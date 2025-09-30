$PBExportHeader$w_sm30_3011.srw
$PBExportComments$주간 판매계획 접수
forward
global type w_sm30_3011 from w_inherite
end type
type dw_1 from u_key_enter within w_sm30_3011
end type
type rr_1 from roundrectangle within w_sm30_3011
end type
type p_gen from uo_picture within w_sm30_3011
end type
type hpb_1 from hprogressbar within w_sm30_3011
end type
type pb_1 from u_pb_cal within w_sm30_3011
end type
type dw_excel from datawindow within w_sm30_3011
end type
type p_excel from uo_picture within w_sm30_3011
end type
type cb_1 from commandbutton within w_sm30_3011
end type
type cbx_1 from checkbox within w_sm30_3011
end type
type dw_info from datawindow within w_sm30_3011
end type
type cb_2 from commandbutton within w_sm30_3011
end type
type cb_3 from commandbutton within w_sm30_3011
end type
type rr_2 from roundrectangle within w_sm30_3011
end type
end forward

global type w_sm30_3011 from w_inherite
integer width = 4677
integer height = 2804
string title = "주간 판매계획 접수(NEW)"
dw_1 dw_1
rr_1 rr_1
p_gen p_gen
hpb_1 hpb_1
pb_1 pb_1
dw_excel dw_excel
p_excel p_excel
cb_1 cb_1
cbx_1 cbx_1
dw_info dw_info
cb_2 cb_2
cb_3 cb_3
rr_2 rr_2
end type
global w_sm30_3011 w_sm30_3011

type prototypes

end prototypes

forward prototypes
public function integer wf_danga (integer nrow)
public function integer wf_cnf_chk ()
public function integer wf_find (string ar_saupj, string ar_ymd, string ar_gubun, string ar_cvcod, string ar_plnt, string ar_itnbr)
public subroutine wf_excel_down (datawindow adw_excel)
public function integer wf_init ()
public subroutine wf_info (string arg_fac, string arg_itnbr)
public function integer wf_mobis_as (string as_ymd, string as_saupj)
end prototypes

public function integer wf_danga (integer nrow);String sToday, sCvcod, sItnbr, sSpec
Double dItemPrice, dDcRate
Int    iRtnValue

sToday = f_today()

sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
sSpec  = '.'

iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sToday, sCvcod, sItnbr, sSpec, 'WON','1', dItemPrice, dDcRate)
If IsNull(dItemPrice) Then dItemPrice = 0

dw_insert.SetItem(nRow, 'itm_prc', dItemPrice)

return 1
end function

public function integer wf_cnf_chk ();Long ll_cnt 
String ls_saupj , ls_ymd ,ls_factory , ls_empno
ll_cnt = 0 

If dw_1.AcceptText() < 1 Then Return -1
If dw_1.RowCount() < 1 Then Return -1

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_1.Object.sdate[1])
ls_factory = Trim(dw_1.Object.plant[1])

ls_empno = Trim(dw_1.object.empno[1])
//If ls_empno = '' Or isNull(ls_empno)  Then 
//	MessageBox('확인','담당자를 지정하십시오!!!')
//	Return -1
//End If
//If ls_empno = '' or isNull(ls_empno) then ls_empno = '%' 

ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item_new a
 where a.saupj = :ls_saupj
	and a.yymmdd = :ls_ymd 
	AND cnfirm is not null ;
//	and exists (select 'x' from reffpf x where x.rfcod = '2A' 
//				                              and x.rfgub = a.gate
//													   and nvl(x.rfna5,' ') like :ls_empno )  ;
	
If ll_cnt > 0 Then
	dw_1.Object.confirm[1] = '3'
	p_del.Enabled = False
//	p_mod.Enabled = False
	p_addrow.Enabled = False
	p_delrow.Enabled = False
	
	p_search.Enabled = False
	p_gen.Enabled = False

   p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
//	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_search.PictureName = 'C:\erpman\image\생성_d.gif'
	p_gen.PictureName = 'C:\erpman\image\소요량계산_d.gif'
	
	p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
	
//	return -1
	return 1
Else
	
	dw_1.Object.confirm[1] = '2'
	p_del.Enabled = True
	p_mod.Enabled = True
	p_addrow.Enabled = True
	p_delrow.Enabled = True
	
	p_search.Enabled = True
	p_gen.Enabled = True

	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_search.PictureName = 'C:\erpman\image\생성_up.gif'
	p_gen.PictureName = 'C:\erpman\image\소요량계산_up.gif'
	
	p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
	
	return 1

End iF

Return 1

end function

public function integer wf_find (string ar_saupj, string ar_ymd, string ar_gubun, string ar_cvcod, string ar_plnt, string ar_itnbr);
Long ll_cnt = 0

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item_new
 where saupj = :ar_saupj
	and yymmdd = :ar_ymd 
	and gubun = :ar_gubun
	and cvcod = :ar_cvcod
	and gate = :ar_plnt
	and itnbr = :ar_itnbr ;
	
If ll_cnt > 0 Then
	Return -1
end if
	
	
return 1
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

public function integer wf_init ();Long ll_cnt 
String ls_saupj , ls_ymd ,ls_factory , ls_empno
ll_cnt = 0 

If dw_1.AcceptText() < 1 Then Return -1
If dw_1.RowCount() < 1 Then Return -1

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_1.Object.sdate[1])
ls_factory = Trim(dw_1.Object.plant[1])

ls_empno = Trim(dw_1.object.empno[1])
If ls_empno = '' or isNull(ls_empno) then ls_empno = '%' 

ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item_new a
 where a.saupj = :ls_saupj
	and a.yymmdd = :ls_ymd 
	AND cnfirm is not null
	and exists (select 'x' from reffpf x where x.rfcod = '2A' 
				                              and x.rfgub = a.gate
													   and nvl(x.rfna5,' ') like :ls_empno )  ;
	
If ll_cnt > 0 Then
	dw_1.Object.confirm[1] = '3'
	p_del.Enabled = False
	p_mod.Enabled = False
	p_addrow.Enabled = False
	p_delrow.Enabled = False
	
	p_search.Enabled = False
	p_gen.Enabled = False

   p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_search.PictureName = 'C:\erpman\image\생성_d.gif'
	p_gen.PictureName = 'C:\erpman\image\소요량계산_d.gif'
	
	p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
	
	return -1
Else
	
	dw_1.Object.confirm[1] = '2'
	p_del.Enabled = True
	p_mod.Enabled = True
	p_addrow.Enabled = True
	p_delrow.Enabled = True
	
	p_search.Enabled = True
	p_gen.Enabled = True

	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_search.PictureName = 'C:\erpman\image\생성_up.gif'
	p_gen.PictureName = 'C:\erpman\image\소요량계산_up.gif'
	
	p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
	
	return 1

End iF

Return 1

end function

public subroutine wf_info (string arg_fac, string arg_itnbr);dw_1.AcceptText()

String ls_ym

ls_ym = LEFT(dw_1.GetItemString(1, 'sdate'), 6)
If Trim(ls_ym) = '' Or IsNull(ls_ym) Then
	MessageBox('기준 월 확인!', '기준 월은 필수 입력 사항입니다!', Information!)
	Return
End If

If Trim(arg_fac) = '' OR IsNull(arg_fac) Then
	MessageBox('공장 확인!', '공장은 필수 선택 사항입니다!', Information!)
	Return
End If

//Long   i
//String ls_ymd[], ls_date[]
//
//For i = 1 To 31
//	ls_ymd[i]  = 'D2' + ls_ym + String(i, '00') + arg_fac
////	ls_date[i] = ls_ym + String(i, '00')
//Next

dw_info.SetRedraw(False)
//dw_info.Retrieve(arg_fac, ls_ym, ls_ymd[])
dw_info.Retrieve(arg_fac, ls_ym, arg_itnbr)
dw_info.SetRedraw(True)

//D+5일 계획 표시용
If dw_info.RowCount() > 0 Then
	cb_2.TriggerEvent('Clicked')
End If
end subroutine

public function integer wf_mobis_as (string as_ymd, string as_saupj);String  ls_cvcod
String  ls_emp
/* 거래처 정보 가져오기 */
SELECT RFNA2, RFNA5
  INTO :ls_cvcod, :ls_emp
  FROM REFFPF
 WHERE RFCOD = '2A'
   AND RFGUB = 'MAS' ;

/* 주간판매계획에 모비스 A/S VAN자료만 추가로 생성 */
/* 납기일 기준 미납수량을 집계하여 반영 */
INSERT INTO SM03_WEEKPLAN_ITEM_NEW (
	SAUPJ     , YYMMDD, GUBUN, CVCOD, ITNBR, GATE , PLNT , ITM_PRC   ,
	QTY0      , QTY1  , QTY2 , QTY3 , QTY4 , QTY5 , QTY6 , QTY7      ,
	QTY8      , QTY9  , QTY10, QTY11, JQTY1, JQTY2, JAEGO, SO_WEEKQTY,
	CHULHA_QTY, EMPNO )
SELECT A.SAUPJ,
       :as_ymd,
       'MAS',
       A.MCVCOD,
       SUBSTR(A.PTNO, 1, 5) || '-' || SUBSTR(A.PTNO, 6, LENGTH(A.PTNO)) AS PTNO, /* 품번 */
       '.' AS GATE,
       'MAS' AS PLNT,
       FUN_VNDDAN_DANGA(:as_ymd, SUBSTR(A.PTNO, 1, 5) || '-' || SUBSTR(A.PTNO, 6, LENGTH(A.PTNO)), A.MCVCOD) PRC,
       SUM(DECODE(A.DUE_DATE, :as_ymd, A.DLVAF_INC_QTY, 0)) Q0,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 1 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q1,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 2 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q2,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 3 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q3,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 4 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q4,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 5 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q5,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 6 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q6,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 7 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q7,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 8 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q8,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 9 , 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q9,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 10, 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q10,
       SUM(DECODE(A.DUE_DATE, TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 11, 'YYYYMMDD'), A.DLVAF_INC_QTY, 0)) Q11,
       0 JQTY1, 0 JQTY2, 0 JAEGO, 0 SO_WEEKQTY, 0 CHULHA_QTY, :ls_emp
  FROM VAN_MOBIS_BR A
 WHERE A.SAUPJ    =       :as_saupj
   AND A.DUE_DATE BETWEEN :as_ymd AND TO_CHAR(TO_DATE(:as_ymd, 'YYYYMMDD') + 11, 'YYYYMMDD')
GROUP BY A.SAUPJ,
         A.MCVCOD,
         SUBSTR(A.PTNO, 1, 5) || '-' || SUBSTR(A.PTNO, 6, LENGTH(A.PTNO)),
         FUN_VNDDAN_DANGA(:as_ymd, SUBSTR(A.PTNO, 1, 5) || '-' || SUBSTR(A.PTNO, 6, LENGTH(A.PTNO)), A.MCVCOD) ;

Long    ll_err
String  ls_err
If SQLCA.SQLCODE <> 0 Then
	ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
	ROLLBACK USING SQLCA;
	MessageBox('Mobis A/S Create Error / ' + String(ll_err), ls_err)
	Return -1
End If

COMMIT USING SQLCA;

Return 1
end function

on w_sm30_3011.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.p_gen=create p_gen
this.hpb_1=create hpb_1
this.pb_1=create pb_1
this.dw_excel=create dw_excel
this.p_excel=create p_excel
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.dw_info=create dw_info
this.cb_2=create cb_2
this.cb_3=create cb_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.p_gen
this.Control[iCurrent+4]=this.hpb_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.dw_excel
this.Control[iCurrent+7]=this.p_excel
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.dw_info
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.rr_2
end on

on w_sm30_3011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.p_gen)
destroy(this.hpb_1)
destroy(this.pb_1)
destroy(this.dw_excel)
destroy(this.p_excel)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.dw_info)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)
dw_excel.SetTransObject(SQLCA)

dw_1.InsertRow(0)

//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//   End if
//End If

//20181029 한텍 요청 사항 사업장 강제로 장안으로 디폴트값 지정요청 HYKANG 20181029
// dw_1.SetItem(1, 'saupj', gs_saupj)
dw_1.SetItem(1, 'saupj', '20')
 
dw_1.Object.sdate[1] = is_today

wf_init()

end event

type dw_insert from w_inherite`dw_insert within w_sm30_3011
integer x = 27
integer y = 332
integer width = 4576
integer height = 1392
integer taborder = 140
string dataobject = "d_sm30_3011_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Dec  dmmqty, davg
Long nJucha, ix, nRow
Int  ireturn
String sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, snull, get_nm , ls_plant
String ls_ymd

ls_ymd = dw_1.GetItemString(1, 'sdate')

setnull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

String ls_saupj
String ls_fac
String ls_cvcod
String ls_itnbr

ls_saupj = This.GetItemString(nRow, 'saupj')
ls_cvcod = This.GetItemString(nRow, 'cvcod')
ls_itnbr = This.GetItemString(nRow, 'itnbr')
ls_fac   = This.GetItemString(nRow, 'plnt' )

Double ldb_jqty1
Double ldb_jqty2
Double ldb_prc

Choose Case GetColumnName()
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itemas_itdsc", sitdsc)
		
		SELECT NVL(FUN_GET_STOCK_NAPUM(:ls_saupj, :ls_fac, :sitnbr), 0),
             NVL(FUN_GET_STOCK_MULU2(:ls_cvcod, :ls_fac, :sitnbr), 0),
				 fun_vnddan_danga(:ls_ymd, :sitnbr, :ls_cvcod)
		  INTO :ldb_jqty1, :ldb_jqty2, :ldb_prc
        FROM DUAL;
		
		SetItem(nRow, 'jqty1', ldb_jqty1)
		SetItem(nRow, 'jqty2', ldb_jqty2)
		SetItem(nRow, 'itm_prc', ldb_prc)
		
		RETURN ireturn
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nrow, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS2"  ,fun_get_reffpf_rfgub('1G',:s_cvcod,'1')
		  INTO :get_nm  ,:ls_plant
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;		
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nrow, 'cvnas', get_nm)
			this.setitem(nrow, 'plnt', ls_plant)
		
			SELECT NVL(FUN_GET_STOCK_NAPUM(:ls_saupj, :ls_plant, :ls_itnbr), 0),
					 NVL(FUN_GET_STOCK_MULU2(:s_cvcod , :ls_plant, :ls_itnbr), 0),
					 fun_vnddan_danga(:ls_ymd, :ls_itnbr, :s_cvcod)
			  INTO :ldb_jqty1, :ldb_jqty2, :ldb_prc
			  FROM DUAL;
			
			SetItem(nRow, 'jqty1', ldb_jqty1)
			SetItem(nRow, 'jqty2', ldb_jqty2)
			SetItem(nRow, 'itm_prc', ldb_prc)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
		
	Case 'plnt'
		s_cvcod = this.GetText()
		String  ls_chk
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
		  INTO :ls_chk
		  FROM REFFPF
		 WHERE SABU = :gs_sabu AND RFCOD = '2A' AND RFGUB = :s_cvcod ;
		If ls_chk <> 'Y' Then
			MessageBox('공장코드 확인', '등록된 공장 코드가 아닙니다.')
			Return 1
		End If
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nrow, 'plnt', snull)
			this.setitem(nrow, 'gate', snull)
			return  1
		end if
		
		this.setitem(nrow, 'gate', s_cvcod)
		
		SELECT NVL(FUN_GET_STOCK_NAPUM(:ls_saupj, :s_cvcod, :ls_itnbr), 0),
             NVL(FUN_GET_STOCK_MULU2(:ls_cvcod, :s_cvcod, :ls_itnbr), 0)
		  INTO :ldb_jqty1, :ldb_jqty2
        FROM DUAL;
		
		SetItem(nRow, 'jqty1', ldb_jqty1)
		SetItem(nRow, 'jqty2', ldb_jqty2)
		
End Choose


end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow , i , ll_i = 0
String sItnbr, sNull
String ls_ymd ,ls_saupj

str_code lst_code
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
		
	Case 'cvcod'
		
		gs_gubun = '1'

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(nRow, "cvcod", gs_Code)
		this.TriggerEvent("itemchanged")
		
	/* 2017.06.18 - 한텍, 고객사 공장별 작업사양 조회 선택 */
	Case 'sangyn'
		
		gs_code = Trim(Object.itnbr[nRow])

		Open(w_itmspec_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(nRow, "sangyn", gs_Code)

	Case "itnbr"
		
		ls_saupj = Trim(dw_1.object.saupj[1])
		ls_ymd = Trim(dw_insert.object.yymmdd[nRow])
		
		gs_code = Trim(Object.cvcod[nRow])
		gs_codename =Trim(Object.cvnas[nRow])
		gs_gubun =Trim(Object.plnt[nRow])
		If isNull(gs_code) or gs_code = '' Then 
			Messagebox('확인','거래처를 선택하세요.')
			Return
		End iF
		
		Open(w_sm30_3010_popup2)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then p_addrow.triggerevent("clicked")
			
			
			If wf_find(ls_saupj , ls_ymd , 'HAN' , gs_Code , gs_gubun , lst_code.code[ll_i] ) < 0 Then
				MessageBox('확인','이미 계획에 등록된 품번입니다.')
				continue ;
			end if
			
			this.SetItem(i, "cvcod", gs_Code)
			this.SetItem(i, "cvnas", gs_Codename)
			this.SetItem(i, "plnt", gs_gubun)
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next
	
END Choose


end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)

If row < 1 Then Return

String ls_fac
String ls_itnbr

ls_fac   = This.GetItemString(row, 'plnt')
ls_itnbr = This.GetItemString(row, 'itnbr')

If Trim(ls_fac)   = '' OR IsNull(ls_fac)   Then Return
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then Return

wf_info(ls_fac, ls_itnbr)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

String ls_fac
String ls_itnbr

ls_fac   = This.GetItemString(currentrow, 'plnt')
ls_itnbr = This.GetItemString(currentrow, 'itnbr')

If Trim(ls_fac)   = '' OR IsNull(ls_fac)   Then Return
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then Return

wf_info(ls_fac, ls_itnbr)
end event

type p_delrow from w_inherite`p_delrow within w_sm30_3011
integer x = 3922
integer taborder = 70
end type

event p_delrow::clicked;call super::clicked;Long i , ll_r , ll_cnt=0
String ls_gubun , ls_cvcod ,ls_itnbr
String sYymm, sCust, sSaupj

If dw_1.AcceptText() <> 1 Then Return

sYymm  = Trim(dw_1.GetItemString(1, 'sdate'))
sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))
sCust  = Trim(dw_1.GetItemString(1, 'plant'))

ll_cnt = 0 

If wf_cnf_chk() < 0 Then Return

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 
ll_cnt = 0 

For i = ll_r To 1 Step -1

	
	If dw_insert.IsSelected(i) Then
		
//		ls_gubun = Trim(dw_insert.Object.gubun[i])
//		If ls_gubun = 'CKD' Then
//			MessageBox('확인','CKD 자료는 삭제 수정할 수 없습니다.')
//			Continue ;
//		End if
		
		dw_insert.DeleteRow(i)
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	If dw_insert.Update() < 1 Then
		Rollback;
		MessageBox('저장실패','저장실패')
		Return
	Else
		Commit;
	End iF
End IF


end event

type p_addrow from w_inherite`p_addrow within w_sm30_3011
integer x = 3749
integer taborder = 60
end type

event p_addrow::clicked;String sYymm, sCust, sSaupj, ls_empno
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sYymm  = Trim(dw_1.GetItemString(1, 'sdate'))
sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))
sCust  = Trim(dw_1.GetItemString(1, 'plant'))
ls_empno = Trim(dw_1.Object.empno[1])
If ls_empno = '' Or isNull(ls_empno)  Then 
	MessageBox('확인','담당자를 지정하십시오!!!')
	Return -1
End If

Long ll_cnt
ll_cnt = 0 

If wf_cnf_chk() < 0 Then Return

If scust = 'Y' Then
	MessageBox('확 인','CKD 자료는 추가하실 수 없습니다.!!')
	Return
End If

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[사업장]')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'saupj',  sSaupj)
dw_insert.SetItem(nRow, 'yymmdd', sYymm)
dw_insert.SetItem(nRow, 'gubun',  'HAN')		// 임의 등록
dw_insert.SetItem(nRow, 'empno',  ls_empno)		// 임의 등록

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('cvcod')
dw_insert.SetFocus()

end event

type p_search from w_inherite`p_search within w_sm30_3011
integer x = 3922
integer y = 164
integer taborder = 120
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;String sYymm
Long   nCnt
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

If dw_1.AcceptText() < 1 Then Return


syymm = trim(dw_1.getitemstring(1, 'sdate'))
If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[생성일자]')
	Return
End If
//
//If syymm <> is_today Then
//	messagebox('확인','해당일자가 시스템 현재 일자와 상이합니다. 현재 일자일 경우만 생성 가능합니다.')
//	Return
//End If	
//
/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

/*담당자 확인 - 2006.10.18 by sHInGooN*/
String ls_emp

ls_emp = dw_1.GetItemString(1, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	f_message_chk(1400, '[담당자]')
	dw_1.SetFocus()
	dw_1.SetColumn('empno')
	Return -1
End If

/* 임시 test 처리 */
integer Net
Net = MessageBox('생성 선택', '생성 기준을 선택 하십시오.~r~n~r~n예[Y] : VAN 기준 주/판 생성~r~n아니오[N] : 월간 계획으로 주/판 생성', Question!, YesNoCancel!, 3)
If Net = 1 Then
	If wf_cnf_chk() < 0 Then Return
	gs_code = sYymm
	
	//gs_codename =  trim(dw_1.getitemstring(1, 'empno'))
	gs_codename = ls_emp
	
	gs_codename2 = sSaupj
	
	Open(w_sm30_3011_popup1)
ElseIf Net = 2 Then
	cb_3.TriggerEvent(Clicked!)
End If


end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm30_3011
boolean visible = false
integer x = 4425
integer y = 220
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm30_3011
integer taborder = 110
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm30_3011
integer taborder = 100
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()
dw_1.SetItem(1, 'plant', '.')
end event

type p_print from w_inherite`p_print within w_sm30_3011
boolean visible = false
integer x = 1861
integer y = 80
integer taborder = 130
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sm30_3011
integer x = 3575
end type

event p_inq::clicked;String ls_saupj , ls_factory , ls_ymd , ls_itnbr, ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
String ls_empno
Long i
If dw_1.AcceptText() < 1 Then Return

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_1.Object.sdate[1])
ls_factory = Trim(dw_1.Object.plant[1])

ls_empno = Trim(dw_1.Object.empno[1])

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
If ls_empno = '' Or isNull(ls_empno)  Then 
	MessageBox('확인','담당자를 지정하십시오!!!')
	Return -1
End If
	
//	ls_empno = '%'

ls_itnbr_from = trim(dw_1.getitemstring(1, 'tx_itnbr_f'))
ls_itnbr_to   = trim(dw_1.getitemstring(1, 'tx_itnbr_t'))

IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
IF isNull(ls_itnbr_to) THEN ls_itnbr_to = '' 

// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.	
IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
	SELECT MIN(ITNBR), MAX(ITNBR) 
	INTO   :ls_from, :ls_to
	FROM   ITEMAS ;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('에러','품번마스터를 조회할 수 없습니다.~n전산실에 문의 바랍니다.')
		Return -1
	End If
ELSE
	ls_from = ls_itnbr_from
	ls_to = ls_itnbr_to
END IF 

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If


/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

wf_cnf_chk()

dw_insert.Object.t_d1.Text = String(Right(f_afterday(ls_ymd , 1) , 4) ,'@@/@@')
dw_insert.Object.t_d2.Text = String(Right(f_afterday(ls_ymd , 2) , 4) ,'@@/@@')
dw_insert.Object.t_d3.Text = String(Right(f_afterday(ls_ymd , 3) , 4) ,'@@/@@')
dw_insert.Object.t_d4.Text = String(Right(f_afterday(ls_ymd , 4) , 4) ,'@@/@@')
dw_insert.Object.t_d5.Text = String(Right(f_afterday(ls_ymd , 5) , 4) ,'@@/@@')
dw_insert.Object.t_d6.Text = String(Right(f_afterday(ls_ymd , 6) , 4) ,'@@/@@')
dw_insert.Object.t_d7.Text = String(Right(f_afterday(ls_ymd , 7) , 4) ,'@@/@@')
dw_insert.Object.t_d8.Text = String(Right(f_afterday(ls_ymd , 8) , 4) ,'@@/@@')
dw_insert.Object.t_d9.Text = String(Right(f_afterday(ls_ymd , 9) , 4) ,'@@/@@')
dw_insert.Object.t_d10.Text = String(Right(f_afterday(ls_ymd , 10) , 4) ,'@@/@@')
dw_insert.Object.t_d11.Text = String(Right(f_afterday(ls_ymd , 11) , 4) ,'@@/@@')

for i = 1 To 11
	
	If f_holiday_chk( f_afterday(ls_ymd,i)) = 'Y' Then
		dw_insert.Modify("t_d"+string(i)+".Color = '255'")
		dw_insert.Modify("itm_qty"+string(i)+"_t.Color = '255'")
	Else
		dw_insert.Modify("t_d"+string(i)+".Color = '16777215'")
		dw_insert.Modify("itm_qty"+string(i)+"_t.Color = '16777215'")
		
	End If
	
Next


If dw_insert.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to ,ls_empno) <= 0 Then
	
	f_message_chk(50,'')
	
Else
	
End If

end event

type p_del from w_inherite`p_del within w_sm30_3011
boolean visible = false
integer x = 4247
integer y = 216
integer taborder = 90
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm30_3011
integer x = 4096
integer taborder = 80
end type

event p_mod::clicked;Long ix, nRow
String sCust, sItnbr, sCvcod, sPlnt, sGate 
String ls_new

String sYymm,  sSaupj, ls_empno, ls_conf

String ls_saupj


If dw_1.AcceptText() <> 1 Then Return

sYymm  = Trim(dw_1.GetItemString(1, 'sdate'))
sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))
sCust  = Trim(dw_1.GetItemString(1, 'plant'))
ls_conf = Trim(dw_1.GetItemString(1, 'confirm'))

Long ll_cnt
ll_cnt = 0 

If wf_cnf_chk() < 0 Then Return

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

/* 품목별 계획일 경우 체크 */
scust = Trim(dw_1.GetItemString(1, 'plant'))

If scust = 'CKD' Then
	MessageBox('확 인','CKD 자료는 수정하실 수 없습니다.!!')
	Return
End If

Long    l ; l = 0
String  ls_plnt[]
String  ls_itn[]
dwItemStatus l_sts
nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	sCvcod = Trim(dw_insert.GetItemString(ix, 'cvcod'))
	sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
	sPlnt  = Trim(dw_insert.GetItemString(ix, 'plnt'))
	ls_saupj  = Trim(dw_insert.GetItemString(ix, 'saupj'))
	
	ls_new = Trim(dw_insert.object.is_new[ix])
	
	If IsNull(sCvcod) Or sCvcod = '' Then
		f_message_chk(1400,'[거래처]')
		Return
	End If
	If IsNull(sItnbr) Or sItnbr = '' Then
		f_message_chk(1400,'[품번]')
		Return
	End If
	
	If IsNull(sPlnt) Or sPlnt = '' Then
		f_message_chk(1400,'[공장]')
		Return
	End If
	
	If IsNull(sPlnt) Or sPlnt = '' Then
		f_message_chk(1400,'[공장]')
		Return
	End If
	
	If IsNull(ls_saupj) Or ls_saupj = '' Then
		f_message_chk(1400,'[사업장]')
		Return
	End If
	
	l_sts = dw_insert.GetItemStatus(ix, 0, Primary!)
	Choose Case l_sts
		Case NotModified!
		Case Else
			l++
			ls_plnt[l] = sPlnt
			ls_itn[l]  = sItnbr
	End Choose
	
	If ls_new = 'Y' then
		
		If wf_find( sSaupj , sYymm , 'HAN' , sCvcod ,sPlnt ,sItnbr ) < 1 Then
			MessageBox('확인','중복 등록 된 품번입니다.~r~r~n~n' + sItnbr + ' 품번을 확인 하십시오.')
			dw_insert.ScrollToRow(ix)
			dw_insert.SetFocus()
			Return
		end iF
	end If

Next

If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

/* 확정상태에서 계획을 수정할 경우 문자메세지 전송여부 확인 - by shingoon 2016.07.11 */
/* case(  confirm  when "1"  then "접수"  when "2" then "진행" else "확정") */
If ls_conf = '3' Then

	/* 문자메세지 전송여부 확인 - BY SHINGOON 2016.07.11 */
	String  ls_chk
	SELECT DATANAME INTO :ls_chk FROM SYSCNFG WHERE SYSGU = 'C' AND SERIAL = '92' AND LINENO = 'A2' ;
	If ls_chk = 'Y' Then
		String  ls_sendtel
		SELECT DATANAME INTO :ls_sendtel FROM SYSCNFG WHERE SYSGU = 'C' AND SERIAL = '92' AND LINENO = 'A1' ;
		
		/* 변경 품번별로 메세지 전송 - BY SHINGOON 2016.07.18 */
		Long    ll
		String  ls_emp
		String  ls_name
		String  ls_hpno
		String  ls_err
		Long    ll_err
		For ll = 1 To UpperBound(ls_itn[])
//			INSERT INTO SDK_SMS_SEND (MSG_ID, USER_ID, SUBJECT, SMS_MSG, CALLBACK_URL,
//						NOW_DATE, SEND_DATE, CALLBACK,DEST_INFO,CDR_ID)
//			VALUES ( SDK_SMS_SEQ.NEXTVAL, :gs_empno, '', '['||:sYymm||'] ('||:ls_plnt[ll]||', '||:ls_itn[ll]||') 확정 주간 판매계획이 변경 되었습니다.', '',
//						TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), :ls_sendtel, '테스트^01040467777', :gs_empno) ;
			
			DECLARE l_cur CURSOR FOR
				SELECT A.EMPNO, A.EMPNAME, REPLACE(B.HPHONE, '-', '')
				  FROM P1_MASTER A, P1_ETC B, SDK_SMS_SEND_EMPNO C
				 WHERE A.RETIREDATE    IS NULL
					AND NVL(C.STS, 'N') = 'Y'
					AND A.COMPANYCODE   = B.COMPANYCODE
					AND A.EMPNO         = B.EMPNO
					AND A.EMPNO         = C.EMPNO(+) ;
			
			OPEN l_cur;
			
			FETCH l_cur INTO :ls_emp, :ls_name, :ls_hpno ;
			
			sYymm = LEFT(sYymm, 4) + '년' + MID(sYymm, 5, 2) + '월' + RIGHT(sYymm, 2) + '일'
			
			DO WHILE SQLCA.SQLCODE = 0
				INSERT INTO SDK_SMS_SEND (MSG_ID, USER_ID, SUBJECT, SMS_MSG, CALLBACK_URL,
								NOW_DATE, SEND_DATE, CALLBACK,DEST_INFO,CDR_ID)
					VALUES ( SDK_SMS_SEQ.NEXTVAL, :gs_empno, '', '['||:sYymm||'] ('||:ls_plnt[ll]||', '||:ls_itn[ll]||') 확정 주간 판매계획이 변경 되었습니다.', '',
								TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), :ls_sendtel, :ls_name || '^' || :ls_hpno, :gs_empno) ;
				/* 유저아이디 : 임의 부여 */
				/* 발신번호 : KT에 사용할 발신번호를 요청(KT외주업체 연락하면 처리 가능) */
				/* 보내는 번호 : TEST^01012345678 => 받는사람이름 + ^(구분자) + 연락처 */
				If SQLCA.SQLCODE <> 0 Then
					ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
					ROLLBACK USING SQLCA;
					MessageBox('Send Msg Err [' + String(ll_err) + ']', '문자메세지 전송 중 오류가 발생 했습니다.~r~n' + ls_err)
					Return
				End If
				
				FETCH l_cur INTO :ls_emp, :ls_name, :ls_hpno ;
			LOOP
		Next
		
	End If
End If

COMMIT USING SQLCA;

p_inq.TriggerEvent(Clicked!)
ib_any_typing = false

end event

type cb_exit from w_inherite`cb_exit within w_sm30_3011
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm30_3011
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm30_3011
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm30_3011
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm30_3011
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm30_3011
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm30_3011
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm30_3011
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm30_3011
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm30_3011
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm30_3011
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm30_3011
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm30_3011
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm30_3011
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm30_3011
integer x = 18
integer y = 24
integer width = 3433
integer height = 252
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm30_3011_1"
boolean border = false
end type

event itemchanged;String sDate, sNull, s_cvcod,get_nm, sSaupj, ls_itnbr_t, ls_itnbr_f, ls_value
Long   nCnt

ls_value = Trim(GetText())
SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymmdd'
		sDate = GetText()
		
		
		/* 사업장 체크 */
		sSaupj= Trim(GetItemString(1, 'saupj'))
		If IsNull(sSaupj) Or sSaupj = '' Then
			f_message_chk(1400, '[사업장]')
			SetFocus()
			SetColumn('saupj')
			Return 1
		End If

		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			wf_cnf_chk()
		End If
	Case "tx_itnbr_f"
		ls_itnbr_t = Trim(This.GetItemString(row, 'tx_itnbr_t'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'tx_itnbr_t', ls_value)
	   end if
	Case "tx_itnbr_t"
		ls_itnbr_f = Trim(This.GetItemString(row, 'tx_itnbr_f'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'tx_itnbr_f', ls_value)
	   end if
End Choose
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

//IF this.GetColumnName() = "cvcod" THEN
//	gs_code = this.GetText()
//	IF Gs_code ="" OR IsNull(gs_code) THEN 
//		gs_code =""
//	END IF
//	
////	gs_gubun = '2'
//	Open(w_vndmst_popup)
//	
//	IF isnull(gs_Code)  or  gs_Code = ''	then  
//		this.SetItem(lrow, "cvcod", snull)
//		this.SetItem(lrow, "cvnas", snull)
//   	return
//   ELSE
//		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
//		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
//			f_message_chk(37,'[거래처]') 
//			this.SetItem(lRow, "cvcod", sNull)
//		   this.SetItem(lRow, "cvnas", sNull)
//			RETURN  1
//		END IF
//   END IF	
//
//	this.SetItem(lrow, "cvcod", gs_Code)
//	this.SetItem(lrow, "cvnas", gs_Codename)
//END IF
//
end event

type rr_1 from roundrectangle within w_sm30_3011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 324
integer width = 4599
integer height = 1412
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_gen from uo_picture within w_sm30_3011
integer x = 4096
integer y = 164
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event clicked;call super::clicked;STring ls_gubun ,ls_saupj ,ls_ymd ,ls_itnbr , ls_from ,ls_to
Long i ,ii,iii,ll_rcnt 
Long ll_d1_jqty , ll_newite
Decimal ld_newite
Double ld_jj
Long ll_pqty ,ll_mqty , ll_ctemp  , ll_jq ,ll_contain_qty , ll_jq_last
String ls_empno, ls_factory

If dw_1.AcceptText() < 1 Then Return

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_1.Object.sdate[1])
ls_empno = Trim(dw_1.Object.empno[1])
ls_factory = Trim(dw_1.Object.plant[1])

If ls_empno = '' or isnull(ls_empno) then ls_empno = '%'
If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'

//dw_1.Object.plant[1] = '.'
dw_1.Object.tx_itnbr_f[1] = ''
dw_1.Object.tx_itnbr_t[1] = '' 

Long ll_cnt
ll_cnt = 0 

If wf_cnf_chk() < 0 Then Return

// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.	

SELECT MIN(ITNBR), MAX(ITNBR) 
INTO   :ls_from, :ls_to
FROM   ITEMAS ;

If sqlca.sqlcode <> 0 Then
	MessageBox('에러','품번마스터를 조회할 수 없습니다.~n전산실에 문의 바랍니다.')
	Return -1
End If

dw_insert.AcceptText()
If dw_insert.Update() <> 1 Then
	RollBack;
	Return
Else
	Commit ;
End If

//ls_from = '39182-26860'
//ls_to = '39182-26860'

ll_rcnt = dw_insert.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from , ls_to , ls_empno) 
//messagebox(string(ll_rcnt),ls_from +' ' +ls_to)
If ll_rcnt < 1 Then 
	f_message_chk(50,'')
	Return
End If

If dw_insert.AcceptText() < 1 Then Return

hpb_1.visible = True
hpb_1.maxposition =  100
hpb_1.setstep = 1
hpb_1.position = 0
w_mdi_frame.sle_msg.Text = '납품처 재고 , 재고일수 ,용기당 수량 적용중 ...'
For i =1 To ll_rcnt
	
	ls_gubun = Trim(dw_insert.Object.gubun[i])
	ls_itnbr = Trim(dw_insert.Object.itnbr[i])
	
	If ls_gubun = 'HAN'  Then Continue ;
		
	
	If ls_gubun = 'CKD' or ls_gubun = 'MAS' or ls_gubun = 'MAS1' or ls_gubun = 'EXA' Then 
		dw_insert.Setitem(i, 'itm_qty1', dw_insert.GetItemNumber(i, "qty1") )		
		dw_insert.Setitem(i, 'itm_qty2', dw_insert.GetItemNumber(i, "qty2") )		
		dw_insert.Setitem(i, 'itm_qty3', dw_insert.GetItemNumber(i, "qty3") )		
		dw_insert.Setitem(i, 'itm_qty4', dw_insert.GetItemNumber(i, "qty4") )		
		dw_insert.Setitem(i, 'itm_qty5', dw_insert.GetItemNumber(i, "qty5") )		
		dw_insert.Setitem(i, 'itm_qty6', dw_insert.GetItemNumber(i, "qty6") )		
		dw_insert.Setitem(i, 'itm_qty7', dw_insert.GetItemNumber(i, "qty7") )		
		dw_insert.Setitem(i, 'itm_qty8', dw_insert.GetItemNumber(i, "qty8") )		
		dw_insert.Setitem(i, 'itm_qty9', dw_insert.GetItemNumber(i, "qty9") )		
		dw_insert.Setitem(i, 'itm_qty10', dw_insert.GetItemNumber(i, "qty10") )	
		dw_insert.SetItem(i, 'itm_qty11', dw_insert.GetItemNumber(i, "qty11") )
		Continue;		
	End iF
	
	ll_d1_jqty     = dw_insert.object.d1_jqty[i]
	ld_newite      = dw_insert.object.newite[i]
	ll_newite      = Ceiling(ld_newite)

	ll_pqty = 0
	ll_mqty = 0
	ll_jq = 0
	
	ll_contain_qty = dw_insert.Object.containqty[i]
	if ll_contain_qty <= 0 Then ll_contain_qty = 1
	
	For ii = 1 To 10
		
		Choose Case ll_newite
			Case 0,1
				ll_jq = 0 
			Case 2
				ll_jq = dw_insert.GetItemNumber(i, "qty"+String(ii+1)) 
			
				If ll_newite - ld_newite > 0 Then
					ll_jq = Truncate( ll_jq * (1 - (Double(ll_newite) - ld_newite)) ,0)
				End If
			Case 3
				ll_jq_last = dw_insert.GetItemNumber(i, "qty"+String(ii+2))
				If ll_newite - ld_newite > 0 Then
					ll_jq_last = Truncate( ll_jq_last * (1 - (Double(ll_newite) - ld_newite)) ,0)
				End If
				
				ll_jq = dw_insert.GetItemNumber(i, "qty"+String(ii+1)) + &
						  ll_jq_last
			Case 4
				ll_jq_last = dw_insert.GetItemNumber(i, "qty"+String(ii+3))
				If ll_newite - ld_newite > 0 Then
					ll_jq_last = Truncate( ll_jq_last * (1 - (Double(ll_newite) - ld_newite)) ,0)
				End If
				ll_jq = dw_insert.GetItemNumber(i, "qty"+String(ii+1)) + &
						  dw_insert.GetItemNumber(i, "qty"+String(ii+2)) + &
						  ll_jq_last 
			Case 5
				ll_jq_last = dw_insert.GetItemNumber(i, "qty"+String(ii+4))
				If ll_newite - ld_newite > 0 Then
					ll_jq_last = Truncate( ll_jq_last * (1 - (Double(ll_newite) - ld_newite)) ,0)
				End If
				ll_jq = dw_insert.GetItemNumber(i, "qty"+String(ii+1)) + &
						  dw_insert.GetItemNumber(i, "qty"+String(ii+2)) + &
						  dw_insert.GetItemNumber(i, "qty"+String(ii+3)) + &
						  ll_jq_last 
			Case 6
				ll_jq_last = dw_insert.GetItemNumber(i, "qty"+String(ii+5))
				If ll_newite - ld_newite > 0 Then
					ll_jq_last = Truncate( ll_jq_last * (1 - (Double(ll_newite) - ld_newite)) ,0)
				End If
				
				ll_jq = dw_insert.GetItemNumber(i, "qty"+String(ii+1)) + &
						  dw_insert.GetItemNumber(i, "qty"+String(ii+2)) + &
						  dw_insert.GetItemNumber(i, "qty"+String(ii+3)) + &
						  dw_insert.GetItemNumber(i, "qty"+String(ii+4)) + &
						  ll_jq_last
			Case is > 6
				MessageBox('확인','재고일수가 6 이상은 계산 불가능합니다.')
				Exit
		End Choose
						
		ll_pqty  = dw_insert.GetItemNumber(i, "qty"+String(ii))  
		
		ll_ctemp = ll_mqty + ll_pqty - ll_d1_jqty + ll_jq 
		
		If ll_ctemp > 0 Then
		
			// 용기적입량 적용============================================
			
			if mod(ll_ctemp , ll_contain_qty) = 0 Then
				
			Else
				ll_ctemp = Long(ll_ctemp/ll_contain_qty) * ll_contain_qty + ll_contain_qty
			End iF
			
			//===================================
		Else
			ll_ctemp = 0
		End if
		
		dw_insert.Setitem(i,"itm_qty"+String(ii) , ll_ctemp )
		ll_mqty = ll_mqty + ll_pqty - ll_ctemp
		
		
	Next 

	hpb_1.position = int((i/ll_rcnt)*100)
	
	dw_insert.Setitem(i,"jqty7" , 1 )
	
Next

/* 휴일적용안함 - 2007.03.10 - 송병호 */
//// 생산 월력 적용 ====================================================================
//w_mdi_frame.sle_msg.Text = '생산월력 적용 중  ...'
//Decimal ld_qty , ld_qty_pre
//
//If dw_insert.AcceptText() < 1 Then Return
//
//hpb_1.maxposition =  100
//hpb_1.setstep = 1
//hpb_1.position = 0
//ll_rcnt = dw_insert.RowCount()
//for i = 1 to ll_rcnt
//	for ii = 10 to 1 Step -1
//		If f_holiday_chk( f_afterday(ls_ymd,ii)) = 'Y' Then
//			If ii = 1 Then
//				dw_insert.setitem(i,'itm_qty'+String(ii),0)
//			Else
//				ld_qty     = dw_insert.getitemnumber(i,'itm_qty'+String(ii))
//				ld_qty_pre = dw_insert.getitemnumber(i,'itm_qty'+String(ii - 1))
//			    
//				dw_insert.setitem(i,'itm_qty'+String(ii),0 )
//				dw_insert.setitem(i,'itm_qty'+String(ii - 1),ld_qty_pre + ld_qty)
//			End iF
//		End IF
//	Next
//	hpb_1.position = int((i/ll_rcnt)*100)
//Next
////==============================================================================

hpb_1.visible = false

dw_insert.AcceptText()
If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;
w_mdi_frame.sle_msg.Text = '소요량 계산을 완료 하였습니다.  ...'

MessageBox('확인','소요량 적용을 성공적을 마쳤습니다.')

	
end event

type hpb_1 from hprogressbar within w_sm30_3011
boolean visible = false
integer x = 1819
integer y = 892
integer width = 1262
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type pb_1 from u_pb_cal within w_sm30_3011
integer x = 2117
integer y = 68
integer width = 91
integer height = 80
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', gs_code)

wf_cnf_chk()

end event

type dw_excel from datawindow within w_sm30_3011
boolean visible = false
integer x = 3744
integer y = 476
integer width = 686
integer height = 400
integer taborder = 140
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm30_3011_a_excel"
boolean border = false
boolean livescroll = true
end type

type p_excel from uo_picture within w_sm30_3011
integer x = 3575
integer y = 164
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;If this.Enabled Then wf_excel_down(dw_insert)

//String	ls_quota_no
//integer	li_rc
//string	ls_filepath, ls_filename
//boolean	lb_fileexist
//
//String ls_saupj , ls_factory , ls_ymd , ls_itnbr, ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
//String ls_empno
//Long i
//If dw_1.AcceptText() < 1 Then Return
//
//
//li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
//											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
//IF li_rc = 1 THEN
//	IF lb_fileexist THEN
//		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
//												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
//		IF li_rc = 2 THEN 
//			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
//			RETURN
//		END IF
//	END IF
//	
//	Setpointer(HourGlass!)
//	
//	ls_saupj = Trim(dw_1.Object.saupj[1])
//	ls_ymd = Trim(dw_1.Object.sdate[1])
//	ls_factory = Trim(dw_1.Object.plant[1])
//	ls_empno = Trim(dw_1.Object.empno[1])
//	
//	If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
//	If ls_empno = '' Or isNull(ls_empno)  Then ls_empno = '%'
//	
//	ls_itnbr_from = trim(dw_1.getitemstring(1, 'tx_itnbr_f'))
//	ls_itnbr_to   = trim(dw_1.getitemstring(1, 'tx_itnbr_t'))
//	
//	IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
//	IF isNull(ls_itnbr_to) THEN ls_itnbr_to = '' 
//	
//	// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.	
//	IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
//		SELECT MIN(ITNBR), MAX(ITNBR) 
//		INTO   :ls_from, :ls_to
//		FROM   ITEMAS ;
//		
//		If sqlca.sqlcode <> 0 Then
//			MessageBox('에러','품번마스터를 조회할 수 없습니다.~n전산실에 문의 바랍니다.')
//			Return -1
//		End If
//	ELSE
//		ls_from = ls_itnbr_from
//		ls_to = ls_itnbr_to
//	END IF 
//	
//	If IsNull(ls_ymd) Or ls_ymd = '' Then
//		f_message_chk(1400,'[계획시작일]')
//		Return
//	End If
//	
//	/* 사업장 체크 */
//	ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
//	
//	If dw_excel.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to ,ls_empno) <= 0 Then
//		f_message_chk(50,'')
//		Return
//	End If
//	
// 	If dw_excel.SaveAsAscii(ls_filepath) <> 1 Then
//		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
//		return
//	End If
//
//END IF
//
//w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type cb_1 from commandbutton within w_sm30_3011
integer x = 4274
integer y = 168
integer width = 338
integer height = 140
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "하치장 적용"
end type

event clicked;If wf_cnf_chk() < 0 Then Return

Long ll_cnt
String ls_yymm , ls_saupj ,ls_factory

ls_yymm  = Trim(dw_1.GetItemString(1, 'sdate'))
ls_saupj = Trim(dw_1.GetItemString(1, 'saupj'))
ls_factory = Trim(dw_1.GetItemString(1, 'plant'))

If ls_factory = '' or isNull(ls_factory) or ls_factory = '.' Then ls_factory = '%'

Select count(*) Into :ll_cnt
  from SM03_WEEKPLAN_ITEM_NEW
 Where saupj = :ls_saupj
   and yymmdd = :ls_yymm 
	and plnt like :ls_factory
	and jqty7 = 1 ;
	
If ll_cnt = 0 Then
	MessageBox('확인','소요량 전개 후 하치장 적용이 가능합니다.')
	Return
End IF

/* 하치장 적용하고 난 뒤 추가 발생 했을 경우 하치장 적용이 되지 않음. */
/* 중복발생으로 RETURN됨 by shingoon 2006.11.01 - ??? */
insert into SM03_WEEKPLAN_ITEM_NEW
 select a.saupj       ,
		  a.yymmdd      ,
		  a.gubun       ,
		  a.cvcod       ,
		  a.itnbr       ,
		  a.itm_prc     ,
		  0 as itm_qty1    ,
		  0 as itm_qty2    ,
		  0 as itm_qty3    ,
		  0 as itm_qty4    ,
		  0 as itm_qty5    ,
		  0 as itm_qty6    ,
		  0 as itm_qty7    ,
		  a.cnfirm      ,
		  a.sangyn      ,
		  a.qty1        ,
		  a.qty2        ,
		  a.qty3        ,
		  a.qty4        ,
		  a.qty5        ,
		  a.qty6        ,
		  a.qty7        ,
		  a.packqty     ,
		  a.janqty      ,
		  a.jqty1       ,
		  a.jqty2       ,
		  a.jqty3       ,
		  a.jqty4       ,
		  a.jqty5       ,
		  a.jqty6       ,
		  2 as jqty7       ,
		  a.jaego       ,
		  a.so_weekqty  ,
		  b.vndcod as gate        ,
		  a.plnt        ,
		  a.qty0        ,
		  a.qty8        ,
		  a.qty9        ,
		  a.qty10       ,
		  a.chulha_qty  ,
		  a.empno		 ,
		  a.jqty8       ,
		  a.jqty9       ,
		  a.jqty10      ,
		  0 as itm_qty8    ,
		  0 as itm_qty9    ,
		  0 as itm_qty10   ,
		  0 as itm_qty11   ,
		  0 as qty11    ,
		  0 as jqty11   
  from sm03_weekplan_item_new a , stock_napum_item b
 where a.saupj = :ls_saupj
   and a.yymmdd = :ls_yymm 
	and a.plnt like :ls_factory
   and a.plnt = b.plnt
   and a.itnbr = b.itnbr
   and a.gate <> b.vndcod ;

/* 중복자료 발생 조건 수정 - 2007.03.17 - 송병호 */
//   and a.plnt = b.plnt(+)
//   and a.itnbr = b.itnbr(+)
//   and a.gate <> b.vndcod ;


/*
INSERT INTO SM03_WEEKPLAN_ITEM_NEW
SELECT A.SAUPJ      , A.YYMMDD     , A.GUBUN      , A.CVCOD      , A.ITNBR      , A.ITM_PRC    ,
       0 AS ITM_QTY1, 0 AS ITM_QTY2, 0 AS ITM_QTY3, 0 AS ITM_QTY4, 0 AS ITM_QTY5, 0 AS ITM_QTY6, 0 AS ITM_QTY7   ,
       A.CNFIRM     , A.SANGYN     , A.QTY1       , A.QTY2       , A.QTY3       , A.QTY4       , A.QTY5          ,
       A.QTY6       , A.QTY7       , A.PACKQTY    , A.JANQTY     , A.JQTY1      , A.JQTY2      , A.JQTY3         ,
       A.JQTY4      , A.JQTY5      , A.JQTY6      , 2 AS JQTY7   , A.JAEGO      , A.SO_WEEKQTY , A.VNDCOD AS GATE,
       A.PLNT       , A.QTY0       , A.QTY8       , A.QTY9       , A.QTY10      , A.CHULHA_QTY , A.EMPNO
  FROM (  SELECT A1.*, A2.VNDCOD
            FROM SM03_WEEKPLAN_ITEM_NEW A1,
                 STOCK_NAPUM_ITEM        A2
           WHERE A1.PLNT  =  A2.PLNT(+)
             AND A1.ITNBR =  A2.ITNBR(+)
             AND A1.GATE  <> A2.VNDCOD   ) A
 WHERE A.SAUPJ  =    :ls_saupj
   AND A.YYMMDD =    :ls_yymm
   AND A.PLNT   LIKE :ls_factory
   AND NOT EXISTS (  SELECT 'X'
                      FROM SM03_WEEKPLAN_ITEM_NEW AZ
                     WHERE A.SAUPJ  =  AZ.SAUPJ
                       AND A.YYMMDD =  AZ.YYMMDD
                       AND A.GUBUN  =  AZ.GUBUN
                       AND A.CVCOD  =  AZ.CVCOD
                       AND A.ITNBR  =  AZ.ITNBR
                       AND A.VNDCOD =  AZ.GATE
                       AND A.PLNT   =  AZ.PLNT )   ;
*/

If sqlca.sqlnrows = 0 Then
	MessageBox('확인','적용할 하치장 정보가 없습니다!!!')
	rollback;
	return
else
	commit;
	p_inq.TriggerEvent(Clicked!)
end if
end event

type cbx_1 from checkbox within w_sm30_3011
integer x = 2510
integer y = 76
integer width = 850
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "확정수량 합이 0 이상만 표시"
end type

event clicked;if this.checked then
	dw_insert.setfilter("itm_sum > 0")
else
	dw_insert.setfilter("")
end if
dw_insert.filter()
end event

type dw_info from datawindow within w_sm30_3011
integer x = 27
integer y = 1756
integer width = 4576
integer height = 556
integer taborder = 150
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm30_3011_plan"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_2 from commandbutton within w_sm30_3011
boolean visible = false
integer x = 183
integer y = 2148
integer width = 544
integer height = 80
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
boolean enabled = false
string text = "D+5일 표시용"
end type

event clicked;String ls_ym
String ls_fac
String ls_itn
String ls_doc
Long   ll_d1, ll_d2, ll_d3 , ll_d4 , ll_d5 , ll_d6 , ll_d7
Long   ll_d8, ll_d9, ll_d10, ll_d11, ll_d12, ll_d13, ll_d14

ls_ym  = LEFT(dw_1.GetItemString(1, 'sdate'), 6)
ls_fac = dw_insert.GetItemString(dw_insert.GetRow(), 'plnt')
ls_doc = 'D2' + String(TODAY(), 'yyyymmdd') + ls_fac

Long   i

If ls_ym <> String(TODAY(), 'yyyymm') Then Return

For i = 1 To dw_info.RowCount()
	ls_itn = dw_info.GetItemString(i, 'mitnbr')
	
	If ls_fac = 'HE21' OR ls_fac = 'HV21' OR ls_fac = 'HK21' Then
		  SELECT PLAN_D1TQTY, PLAN_D2TQTY, PLAN_D3TQTY, PLAN_D4TQTY, PLAN_D5QTY , PLAN_D6QTY , PLAN_D7QTY ,
					PLAN_D8QTY , PLAN_D9QTY , PLAN_D10QTY, PLAN_D11QTY, PLAN_D12QTY, PLAN_D13QTY, PLAN_D14QTY
			 INTO :ll_d1, :ll_d2, :ll_d3 , :ll_d4 , :ll_d5 , :ll_d6 , :ll_d7 ,
					:ll_d8, :ll_d9, :ll_d10, :ll_d11, :ll_d12, :ll_d13, :ll_d14
			 FROM VAN_ERPD2
			WHERE SABU    = :gs_sabu
			  AND DOCCODE = :ls_doc
			  AND MITNBR  = :ls_itn  ;
		If SQLCA.SQLCODE <> 0 Then	Continue
		
	Else
		
		  SELECT PLAN_D1TQTY, PLAN_D2TQTY, PLAN_D3TQTY, PLAN_D4TQTY, PLAN_D5QTY , PLAN_D6QTY , PLAN_D7QTY ,
					PLAN_D8QTY , PLAN_D9QTY , PLAN_D10QTY, PLAN_D11QTY, PLAN_D12QTY, PLAN_D13QTY, PLAN_D14QTY
			 INTO :ll_d1, :ll_d2, :ll_d3 , :ll_d4 , :ll_d5 , :ll_d6 , :ll_d7 ,
					:ll_d8, :ll_d9, :ll_d10, :ll_d11, :ll_d12, :ll_d13, :ll_d14
			 FROM VAN_HKCD2
			WHERE SABU    = :gs_sabu
			  AND DOCCODE = :ls_doc
			  AND MITNBR  = :ls_itn  ;
		If SQLCA.SQLCODE <> 0 Then	Continue
	End If
		
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 1) , 'mm') Then
		dw_info.SetItem(i, 'p' + String(RelativeDate(TODAY(), 1) , 'dd'), ll_d1 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 2) , 'mm') Then
		dw_info.SetItem(i, 'p' + String(RelativeDate(TODAY(), 2) , 'dd'), ll_d2 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 3) , 'mm') Then
		dw_info.SetItem(i, 'p' + String(RelativeDate(TODAY(), 3) , 'dd'), ll_d3 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 4) , 'mm') Then
		dw_info.SetItem(i, 'p' + String(RelativeDate(TODAY(), 4) , 'dd'), ll_d4 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 5) , 'mm') Then
		dw_info.SetItem(i, 'p' + String(RelativeDate(TODAY(), 5) , 'dd'), ll_d5 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 6) , 'mm') Then
		dw_info.SetItem(i, 'p' + String(RelativeDate(TODAY(), 6) , 'dd'), ll_d6 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 7) , 'mm') Then
		dw_info.SetItem(i, 'p' + String(RelativeDate(TODAY(), 7) , 'dd'), ll_d7 )
	End If
Next
end event

type cb_3 from commandbutton within w_sm30_3011
boolean visible = false
integer x = 4050
integer y = 1384
integer width = 526
integer height = 140
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "월간 계획 적용"
end type

event clicked;dw_1.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_ymd
ls_ymd = dw_1.GetItemString(row, 'sdate')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('확인', '기준 일자를 입하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('sdate')
	Return
End If

/* 기준일 이후에 오는 첫 번째 월요일인 일자 찾기 */
/* ex) 생성기준일이 수요일(2013.09.25)이면 다음 주 월요일(2013.09.30)일 찾기 - 기준일의 일자와 요일은 상관없음. 그냥 해당일자 다음에 오는 월요일 찾음 */
String  ls_mondate
SELECT TO_CHAR(NEXT_DAY(TO_DATE(:ls_ymd, 'YYYYMMDD'), 2), 'YYYYMMDD') INTO :ls_mondate FROM DUAL;
  
/* 기준일의 전주 일자 받아오기(2013.09.25 -> 2013.09.18) */
String  ls_pdate
SELECT TO_CHAR(TO_DATE(:ls_ymd, 'YYYYMMDD') - 7, 'YYYYMMDD') INTO :ls_pdate FROM DUAL;

String  ls_saupj
ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('확인', '사업장을 선택 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

/* 담당자 확인 */
String ls_emp
ls_emp = dw_1.GetItemString(row, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	f_message_chk(1400, '[담당자]')
	dw_1.SetFocus()
	dw_1.SetColumn('empno')
	Return -1
End If

/* 월간 계획의 마감자료 확인 및 가져오기 */
String  ls_ym
ls_ym = LEFT(ls_ymd, 6)

String  ls_ma
SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
  INTO :ls_ma
  FROM SM01_MONPLAN_DT
 WHERE SAUPJ = :ls_saupj AND YYMM = :ls_ym AND WANDATE IS NOT NULL ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox('Select Err [SM01_MONPLAN_DT] ' + String(SQLCA.SQLDBCODE), SQLCA.SQLERRTEXT)
	Return
End If

If ls_ma <> 'Y' Then
	MessageBox('확인', '[' + LEFT(ls_ym, 4) + '년 ' + RIGHT(ls_ym, 2) + '월] 확정된 월간 계획이 없습니다.')
	Return
End If

/* 해당 일의 월요일이 몇 주차 인지 확인 */
Integer li_jucha
SELECT TRUNC((TO_NUMBER(TO_CHAR(TO_DATE(:ls_mondate, 'YYYYMMDD'), 'DD')) + 7 - TO_NUMBER(TO_CHAR(TO_DATE(:ls_mondate, 'YYYYMMDD'), 'D'))) / 7)
  INTO :li_jucha
  FROM DUAL;
If SQLCA.SQLCODE <> 0 Then
	MessageBox('Select Err [Week Number] ' + String(SQLCA.SQLDBCODE), SQLCA.SQLERRTEXT)
	Return
End If

/* 해당 주(Week)에 자료 생성여부 확인 */
Long    ll_err
String  ls_err
String  ls_dup
SELECT CASE WHEN COUNT('X') < 1 THEN 'N' ELSE 'Y' END
  INTO :ls_dup
  FROM SM03_WEEKPLAN_ITEM_NEW
 WHERE SAUPJ = :ls_saupj AND YYMMDD = :ls_ymd ;
If ls_dup = 'Y' Then
	If MessageBox('자료 존재 확인', '기 생성된 자료가 있습니다.~r~n삭제 후 계속 진행 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return
	
	DELETE FROM SM03_WEEKPLAN_ITEM_NEW
	 WHERE SAUPJ = :ls_saupj AND YYMMDD = :ls_ymd ;
	If SQLCA.SQLCODE = 0 Then
		COMMIT USING SQLCA;
	Else
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('기 자료 삭제 오류 ' + String(ll_err), ls_err)
	End If
End If

SetPointer(HourGlass!)

/* 주간 자료 생성 */
Integer li_cnt
SELECT COUNT('X')
  INTO :li_cnt
  FROM SM01_MONPLAN_DT
 WHERE SAUPJ = :ls_saupj AND YYMM = :ls_ym ;

DECLARE cur_wk CURSOR FOR
	SELECT SAUPJ, YYMM, CVCOD, ITNBR, CARCODE, SPRC, RFCOMMENT, 																			/* 사업장, 계획월, 거래처, 품번, 공장, 월간 생성 시 단가, 자료구분 */
			 DECODE(:li_jucha, '1', S1QTY, '2', S2QTY, '3', S3QTY, '4', S4QTY, '5', S5QTY, '6', S6QTY) WKQTY, 					/* 주차별 수량 */
			 TRUNC(DECODE(:li_jucha, '1', S1QTY, '2', S2QTY, '3', S3QTY, '4', S4QTY, '5', S5QTY, '6', S6QTY) / 5) DQTY, 	/* 1일 당 수량  */
			 MOD(DECODE(:li_jucha, '1', S1QTY, '2', S2QTY, '3', S3QTY, '4', S4QTY, '5', S5QTY, '6', S6QTY), 5) MODQTY, 		/* 주간수량 / 5의 몫 */
			 NVL(FUN_GET_STOCK_NAPUM(SAUPJ, CARCODE, ITNBR), 0) AS JQTY1, 																	/* 납품처 재고 */
			 NVL(FUN_GET_STOCK_MULU2(CVCOD, CARCODE, ITNBR), 0) AS JQTY2, 																	/* 물류처 재고 */
			 FUN_GET_PLNT_SALEQTY(:gs_sabu, :ls_ymd, :ls_ymd, CARCODE, ITNBR) AS CHULHA_QTY, 										/* 출하수량 */
			 NVL(FUN_GET_STOCK_DEPOT_SALE(ITNBR, '.', FUN_GET_REFFPF_RFGUB('AD', RFNA5, '4'), '1', '1', '2'), 0) AS JAEGO, /* 영업재고 */
			 FUN_GET_NEWITS(CARCODE, ITNBR) AS GATE, 																								/* 하치장 */
			 NVL(FUN_GET_D7AVGQTY_HAN(:gs_sabu, :ls_ymd, RFNA5, CARCODE, ITNBR), 0) AS AVGQTY,										/* D-7 평균실적량 */
			 FUN_VNDDAN_DANGA(:ls_ymd, ITNBR, CVCOD) 																								/* 주간 생성 시 단가 */
	  FROM SM01_MONPLAN_DT,
			 ( SELECT RFGUB, RFNA5 FROM REFFPF WHERE RFCOD = 'AD' ) B,
      	 ( SELECT RFGUB, RFCOMMENT FROM REFFPF WHERE RFCOD = '2A' ) C
	 WHERE SAUPJ   = :ls_saupj
		AND YYMM    = :ls_ym
		AND SAUPJ   = B.RFGUB(+)
   	AND CARCODE = C.RFGUB(+) ;
	 
OPEN cur_wk;

Integer i
Integer l
String  ls_sa
String  ls_yymm
String  ls_cvcod
String  ls_itnbr
String  ls_plnt
String  ls_gbn
String  ls_gate
Long    ll_wkqty
Long    ll_dqty
Long    ll_mod
Long    ll_prc
Long    ll_jqty1
Long    ll_jqty2
Long    ll_chul
Long    ll_jg
Long    ll_avg
Long    ll_wprc
Long    ll_upqty[5] = {0, 0, 0, 0, 0}
Long    ll_qty[5]   = {0, 0, 0, 0, 0}
SetNull(ll_err) ; SetNull(ls_err)
For i = 1 To li_cnt
	FETCH cur_wk INTO :ls_sa, :ls_yymm, :ls_cvcod, :ls_itnbr, :ls_plnt, :ll_prc, :ls_gbn, :ll_wkqty, :ll_dqty, :ll_mod, :ll_jqty1, :ll_jqty2, :ll_chul, :ll_jg, :ls_gate, :ll_avg, :ll_wprc ;
		
	/* 주 5일만큼 LOOP 계산 */
	For l = 1 To 5
		/* 나머지 수량은 1일차에 포함 */
		If l = 1 Then
			ll_upqty[l] = ll_dqty + ll_mod
		Else
			ll_upqty[l] = ll_dqty
		End If
	Next
	
	If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then ls_gbn = 'HAN'
	
	/* 전주의 계획 중 수, 목, 금, 토, 일 계획 가져오기 */
	SELECT QTY7, QTY8, QTY9, QTY10, QTY11
	  INTO :ll_qty[1], :ll_qty[2], :ll_qty[3], :ll_qty[4], :ll_qty[5]
	  FROM SM03_WEEKPLAN_ITEM_NEW
	 WHERE SAUPJ  = :ls_sa    AND YYMMDD = :ls_pdate AND GUBUN  = :ls_gbn  AND CVCOD  = :ls_cvcod
		AND ITNBR  = :ls_itnbr AND GATE   = :ls_gate  AND PLNT   = :ls_plnt AND CNFIRM IS NOT NULL;
	If IsNull(ll_qty[1]) Then ll_qty[1] = 0
	If IsNull(ll_qty[2]) Then ll_qty[2] = 0
	If IsNull(ll_qty[3]) Then ll_qty[3] = 0
	If IsNull(ll_qty[4]) Then ll_qty[4] = 0
	If IsNull(ll_qty[5]) Then ll_qty[5] = 0
	
	INSERT INTO SM03_WEEKPLAN_ITEM_NEW (
	SAUPJ     , YYMMDD, GUBUN, CVCOD, ITNBR, GATE , PLNT , ITM_PRC   ,
	QTY0      , QTY1  , QTY2 , QTY3 , QTY4 , QTY5 , QTY6 , QTY7      ,
	QTY8      , QTY9  , QTY10, QTY11, JQTY1, JQTY2, JAEGO, SO_WEEKQTY,
	CHULHA_QTY, EMPNO )
	VALUES (
	:ls_sa      , :ls_ymd     , :ls_gbn   , :ls_cvcod , :ls_itnbr , :ls_gate    , :ls_plnt    , :ll_prc     ,
	:ll_qty[1]  , :ll_qty[2]  , :ll_qty[3], :ll_qty[4], :ll_qty[5], :ll_upqty[1], :ll_upqty[2], :ll_upqty[3],
	:ll_upqty[4], :ll_upqty[5], 0         , 0         , :ll_jqty1 , :ll_jqty2   , :ll_jg      , :ll_avg     ,
	:ll_chul    , :ls_emp     ) ;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		CLOSE cur_wk;
		SetPointer(Arrow!)
		MessageBox('자료 갱신 오류 ' + String(ll_err), ls_err)
		Return
	End If
Next

CLOSE cur_wk;

/* 모비스 A/S는 별도로 VAN자료를 주판에 추가 생성 (황성문대리 요청) - BY SHINGOON 2014.04.17 */
If wf_mobis_as(ls_ymd, ls_saupj) < 1 Then
	SetPointer(Arrow!)
	MessageBox('생성 오류', 'MOBIS A/S 계획 생성 중 오류가 발생 했습니다.')
	Return
End If

SetPointer(Arrow!)
COMMIT USING SQLCA;

MessageBox('생성 확인', '월간 계획이 생성 되었습니다.')
end event

type rr_2 from roundrectangle within w_sm30_3011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 1744
integer width = 4599
integer height = 576
integer cornerheight = 40
integer cornerwidth = 55
end type

