$PBExportHeader$w_sm30_0010.srw
$PBExportComments$년 판매계획 접수
forward
global type w_sm30_0010 from w_inherite
end type
type dw_1 from u_key_enter within w_sm30_0010
end type
type rb_car from radiobutton within w_sm30_0010
end type
type rb_itnbr from radiobutton within w_sm30_0010
end type
type p_1 from uo_picture within w_sm30_0010
end type
type cb_1 from commandbutton within w_sm30_0010
end type
type cb_2 from commandbutton within w_sm30_0010
end type
type cb_3 from commandbutton within w_sm30_0010
end type
type st_txt from statictext within w_sm30_0010
end type
type p_xls from picture within w_sm30_0010
end type
type gb_1 from groupbox within w_sm30_0010
end type
type rr_1 from roundrectangle within w_sm30_0010
end type
end forward

global type w_sm30_0010 from w_inherite
integer height = 2476
string title = "년 판매계획 접수"
dw_1 dw_1
rb_car rb_car
rb_itnbr rb_itnbr
p_1 p_1
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
st_txt st_txt
p_xls p_xls
gb_1 gb_1
rr_1 rr_1
end type
global w_sm30_0010 w_sm30_0010

forward prototypes
public function integer wf_protect (string arg_year, integer arg_chasu)
public function integer wf_danga (integer arg_row)
public subroutine wf_init ()
public subroutine wf_excel_itnbr ()
end prototypes

public function integer wf_protect (string arg_year, integer arg_chasu);String sSaupj
Long   nCnt

sSaupj = Trim(dw_1.GetItemString(1, 'saupj'))

SELECT COUNT(*) INTO :nCnt FROM SM01_YEARPLAN 
 WHERE SABU = :gs_sabu 
	AND SAUPJ = :sSaupj 
	AND YYYY = :arg_year
	AND CHASU = :arg_chasu
	AND CNFIRM IS NOT NULL;
If nCnt > 0 Then
	MessageBox('확 인','년 판매계획이 마감처리 되어있습니다.!!')
	p_search.Enabled = False
	p_print.Enabled = False
	p_mod.Enabled = False
	p_addrow.Enabled = False
	p_delrow.Enabled = False
	p_del.Enabled = False
	p_search.PictureName = 'C:\erpman\image\생성_d.gif'
	p_print.PictureName = 'C:\erpman\image\소요량계산_d.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
Else
	p_search.Enabled = True
	p_print.Enabled = True
	p_mod.Enabled = True
	p_addrow.Enabled = True
	p_delrow.Enabled = True
	p_del.Enabled = True
	p_search.PictureName = 'C:\erpman\image\생성_up.gif'
	p_print.PictureName = 'C:\erpman\image\소요량계산_up.gif'
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
	p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
End If

Return 1
end function

public function integer wf_danga (integer arg_row);String sCvcod, sItnbr, stoday, sGiDate, sSaupj, sYear, sStrmm , ls_curr
Double	 dDanga, nChasu
Long ll_rtn 

If arg_row <= 0 Then Return 1

sToday	= f_today()
sGiDate	= dw_1.GetItemString(1, 'yymm')+'0101'	// 단가기준일자
sCvcod	= Trim(dw_insert.GetItemString(arg_row, 'cvcod'))
sItnbr	= Trim(dw_insert.GetItemString(arg_row, 'itnbr'))

dDanga = SQLCA.fun_erp100000012_1(is_today , sCVCOD ,sITNBR ,'1' ) ;

If IsNull(dDanga) Then dDanga = 0

dw_insert.Setitem(arg_row, 'plan_prc', dDanga)

dw_insert.SetItem(arg_row, 'amt_01', dw_insert.GetItemNumber(arg_row, 'qty_01') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_02', dw_insert.GetItemNumber(arg_row, 'qty_02') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_03', dw_insert.GetItemNumber(arg_row, 'qty_03') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_04', dw_insert.GetItemNumber(arg_row, 'qty_04') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_05', dw_insert.GetItemNumber(arg_row, 'qty_05') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_06', dw_insert.GetItemNumber(arg_row, 'qty_06') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_07', dw_insert.GetItemNumber(arg_row, 'qty_07') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_08', dw_insert.GetItemNumber(arg_row, 'qty_08') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_09', dw_insert.GetItemNumber(arg_row, 'qty_09') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_10', dw_insert.GetItemNumber(arg_row, 'qty_10') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_11', dw_insert.GetItemNumber(arg_row, 'qty_11') * dDanga) 
dw_insert.SetItem(arg_row, 'amt_12', dw_insert.GetItemNumber(arg_row, 'qty_12') * dDanga) 

	
Return 0
end function

public subroutine wf_init ();

If rb_car.Checked Then
	dw_1.object.t_itnbr.Text = "차종"
	dw_insert.DataObject = "d_sm30_0010_a"
	
	//P_search.Visible = True
	//p_1.visible = True
	
	cb_1.BringToTop = True
	
	cb_1.Visible = True
	cb_2.visible = True
	
	cb_3.visible = False

	st_txt.visible = False
	
Else
	dw_1.object.t_itnbr.Text = "품번"
	dw_insert.DataObject = "d_sm30_0010_b"
	
	//P_search.Visible = False
	//p_1.visible = False
	
	cb_3.BringToTop = True
	
	cb_3.x = cb_1.x
	cb_3.y = cb_1.y
	
	cb_1.Visible = False
	cb_2.visible = False
	
	cb_3.visible = True
	
	st_txt.visible = True


End iF

dw_insert.SetTransObject(SQLCA)



	
end subroutine

public subroutine wf_excel_itnbr ();If rb_itnbr.Checked = False Then
	Messagebox('상태확인', '구분 상태가 품번일 경우 가능합니다.')
	Return
End If

If dw_1.AcceptText() = -1 Then Return

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_saupj
String ls_yy
Long   ll_cha

ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('사업장 확인', '사업장은 필수 입력사항 입니다.')
	dw_1.SetColumn('saupj')
	dw_1.SetFocus()
	Return
End If

ls_yy = dw_1.GetItemString(row, 'yymm')
If Trim(ls_yy) = '' OR IsNull(ls_yy) Then
	MessageBox('기준년도 확인', '기준년도는 필수 입력사항 입니다.')
	dw_1.SetColumn('yymm')
	dw_1.SetFocus()
	Return
End If

SELECT MAX(CHASU)
  INTO :ll_cha
  FROM SM01_YEARPLAN
 WHERE YYYY = :ls_yy ;

Long   ll_chasu

ll_chasu = dw_1.GetItemNumber(row, 'chasu')
If ll_cha = ll_chasu Then
	If MessageBox('기존자료 확인', '이미 등록된 차수가 있습니다.~r~n해당 차수를 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then
		Return
	Else
		DELETE FROM SM01_YEARPLAN
		 WHERE YYYY  = :ls_yy
		   AND CHASU = :ll_cha ;
		If SQLCA.SQLCODE = 0 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
			MessageBox('기존자료 삭제오류', '기존자료 삭제 중 오류가 발생했습니다.')
			Return
		End If
		
		If IsNull(ll_cha) OR ll_cha < 1 Then
			ll_cha = 1
		Else
			ll_cha = ll_cha + 1
		End If
	End If
Else
	If IsNull(ll_cha) OR ll_cha < 1 Then
		ll_cha = 1
	Else
		ll_cha = ll_cha + 1
	End If
End If

Long   ll_value
String ls_docname
String ls_named

ll_value = GetFileOpenName('품목별 년간판매계획 데이터 가져오기', ls_docname, ls_named, "XLS", "XLS Files (*.XLS),*.XLS,")
If ll_value <> 1 Then Return

dw_insert.Reset()

Setpointer(Hourglass!)

uo_xlobject uo_xl

//UserObject 생성
uo_xl = create uo_xlobject
		
//엑셀과 연결
uo_xl.uf_excel_connect(ls_docname, False , 3)

uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting (행)
Long   ll_xl_row
Long   ll_cnt

ll_xl_row  = 5  //엑셀의 5번째 행부터 시작
ll_cnt     = 0

Long   i
Long   ll_prc
Long   ll_qty01, ll_qty02, ll_qty03, ll_qty04, ll_qty05, ll_qty06
Long   ll_qty07, ll_qty08, ll_qty09, ll_qty10, ll_qty11, ll_qty12
Double ldb_amt01, ldb_amt02, ldb_amt03, ldb_amt04, ldb_amt05, ldb_amt06
Double ldb_amt07, ldb_amt08, ldb_amt09, ldb_amt10, ldb_amt11, ldb_amt12
String ls_year
String ls_factory
String ls_itnbr
String ls_cvcod
String ls_itdsc
String ls_err
String ls_chk
String ls_subt

Do While(True)
	
	//사용자 ID(A,1)
	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	For i = 1 To 50
		uo_xl.uf_set_format(ll_xl_row, i, '@' + space(50))		
	Next
	
	/* SM01_YEARPLAN 입력 COLUMN
	   SABU, YYYY, CVCOD, ITNBR, 
	   QTY_01, AMT_01, QTY_02, AMT_02, QTY_03, AMT_03, QTY_04, AMT_04, QTY_05, AMT_05, QTY_06, AMT_06,
	   QTY_07, AMT_07, QTY_08, AMT_08, QTY_09, AMT_09, QTY_10, AMT_10, QTY_11, AMT_11, QTY_12, AMT_12,
		CNFIRM, GUBUN, ITDSC, SAUPJ, PLAN_PRC, CRTGB, CHASU, STRMM, PLNT, BRATE */
	/* EXCEL FORMAT
	   년도, 공장, 품번, 단가, 계획수량(1월~12월) 순으로 접수 */
	ls_year    = ls_yy //양식 변경으로 해당 자료 없음 - by shingoon 2013.10.17 //Trim(uo_xl.uf_gettext(ll_xl_row, 1 ))        //년도	
	ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row, 2 ))        //공장
	ls_itnbr   = Trim(uo_xl.uf_gettext(ll_xl_row, 3 ))        //품번
	ll_prc     = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 7 )))  //단가
	ll_qty01   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 9 )))  //01월계획수량
	ll_qty02   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 10)))  //02월계획수량
	ll_qty03   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 11)))  //03월계획수량
	ll_qty04   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 12)))  //04월계획수량
	ll_qty05   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 13)))  //05월계획수량
	ll_qty06   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 14)))  //06월계획수량
	ll_qty07   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 15)))  //07월계획수량
	ll_qty08   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 16)))  //08월계획수량
	ll_qty09   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 17)))  //09월계획수량
	ll_qty10   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 18)))  //10월계획수량
	ll_qty11   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 19)))  //11월계획수량
	ll_qty12   = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 20)))  //12월계획수량
	
	ldb_amt01  = ll_qty01 * ll_prc                      		 //01월계획금액
	ldb_amt02  = ll_qty02 * ll_prc                      		 //02월계획금액
	ldb_amt03  = ll_qty03 * ll_prc                      		 //03월계획금액
	ldb_amt04  = ll_qty04 * ll_prc                      		 //04월계획금액
	ldb_amt05  = ll_qty05 * ll_prc                      		 //05월계획금액
	ldb_amt06  = ll_qty06 * ll_prc                      		 //06월계획금액
	ldb_amt07  = ll_qty07 * ll_prc                      		 //07월계획금액
	ldb_amt08  = ll_qty08 * ll_prc                      		 //08월계획금액
	ldb_amt09  = ll_qty09 * ll_prc                      		 //09월계획금액
	ldb_amt10  = ll_qty10 * ll_prc                      		 //10월계획금액
	ldb_amt11  = ll_qty11 * ll_prc                      		 //11월계획금액
	ldb_amt12  = ll_qty12 * ll_prc                      		 //12월계획금액
	
	If (Trim(ls_factory) = '' OR IsNull(ls_factory)) AND &
		(Trim(ls_itnbr)   = '' OR IsNull(ls_itnbr))   Then Exit ;
	
	If ls_yy <> ls_year Then
		MessageBox('년도 확인', '지정한 기준년도와 Excel File의 기준년도가 다릅니다.~r~r~n~n' + &
		                        'Excel File의 ' + String(ll_xl_row) + '번째 행')
		Return
	End If
	
	SetNull(ls_cvcod)
	SELECT RFNA2
     INTO :ls_cvcod
     FROM REFFPF
    WHERE RFCOD = '2A'
      AND RFGUB = :ls_factory ;
	If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
		/* 공장코드가 아닐 경우 거래처로 검색 - by shingoon 2013.10.17 */
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
		  INTO :ls_chk
		  FROM VNDMST
		 WHERE CVCOD = :ls_factory ;
		If ls_chk = 'Y' Then
			ls_cvcod   = ls_factory
			ls_factory = '.'
		Else
			/* 선택 행이 소계항목일 경우 - by shingoon 2013.10.18 */
			SetNull(ls_subt)
			SELECT 'Y' INTO :ls_subt FROM DUAL WHERE :ls_factory LIKE '%소계%';
			If ls_subt = 'Y' Then
				ll_xl_row ++
				Continue
			End If

			MessageBox('공장확인', '등록된 공장코드가 아닙니다.~r~r~n~n' + 'Excel File의 ' + String(ll_xl_row) + '번째 행')
			Return
		End If
	End If
	
	SELECT ITDSC
	  INTO :ls_itdsc
	  FROM ITEMAS
	 WHERE ITNBR = :ls_itnbr ;
	If Trim(ls_itdsc) = '' OR IsNull(ls_itdsc) Then
		MessageBox('품번확인', '등록된 품번이 아닙니다.~r~r~n~n' + 'Excel File의 ' + String(ll_xl_row) + '번째 행')
		Return
	End If
	
	INSERT INTO SM01_YEARPLAN (
		SABU     , YYYY      , CVCOD    , ITNBR     , 
	   QTY_01   , AMT_01    , QTY_02   , AMT_02    , QTY_03   , AMT_03    , QTY_04   , AMT_04    ,
		QTY_05   , AMT_05    , QTY_06   , AMT_06    , QTY_07   , AMT_07    , QTY_08   , AMT_08    ,
		QTY_09   , AMT_09    , QTY_10   , AMT_10    , QTY_11   , AMT_11    , QTY_12   , AMT_12    ,
		CNFIRM   , GUBUN     , ITDSC    , SAUPJ     , PLAN_PRC , CRTGB     , CHASU    , STRMM     , PLNT       , BRATE )
	VALUES (
		:gs_sabu , :ls_year  , :ls_cvcod, :ls_itnbr ,
		:ll_qty01, :ldb_amt01, :ll_qty02, :ldb_amt02, :ll_qty03, :ldb_amt03, :ll_qty04, :ldb_amt04,
		:ll_qty05, :ldb_amt05, :ll_qty06, :ldb_amt06, :ll_qty07, :ldb_amt07, :ll_qty08, :ldb_amt08,
		:ll_qty09, :ldb_amt09, :ll_qty10, :ldb_amt10, :ll_qty11, :ldb_amt11, :ll_qty12, :ldb_amt12,
		NULL     , '2'       , :ls_itdsc, :ls_saupj , :ll_prc  , NULL      , :ll_cha  , NULL      , :ls_factory, 0     ) ;
	If SQLCA.SQLCODE <> 0 Then
		ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('File Upload Fail [' + String(ll_xl_row) + ']', '자료 추가작업 중 오류가 발생하여 자료 Upload에 실패 했습니다.~r~r~n~n' + ls_err)
		Return
	End If
		
	ll_xl_row ++
	
Loop

uo_xl.uf_excel_Disconnect()
// 엑셀 IMPORT  END ***************************************************************

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('File Upload Fail', '자료 추가작업 중 오류가 발생하여 자료 Upload에 실패 했습니다.~r~r~n~n' + ls_err)
	Return
End If

w_mdi_frame.sle_msg.text = String(ll_xl_row - 2) + '건의 년간계획 DATA IMPORT 를 완료하였습니다.'
MessageBox('확인', String(ll_xl_row - 2) + '건의 년간계획 DATA IMPORT 를 완료하였습니다.')

end subroutine

on w_sm30_0010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_car=create rb_car
this.rb_itnbr=create rb_itnbr
this.p_1=create p_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.st_txt=create st_txt
this.p_xls=create p_xls
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_car
this.Control[iCurrent+3]=this.rb_itnbr
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.st_txt
this.Control[iCurrent+9]=this.p_xls
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.rr_1
end on

on w_sm30_0010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_car)
destroy(this.rb_itnbr)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.st_txt)
destroy(this.p_xls)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

Long ll_chasu


Select Max(chasu) Into :ll_chasu 
  from SM01_YEARPLAN
Where saupj   = :gs_code
  and YYYY = trim(to_char(to_number(substr(:is_today,1,4))+1 ,'0000'))
  and gubun = '1';
  
If isNull(ll_chasu) Then ll_chasu = 1
  
dw_1.Object.yymm[1] = String( Long ( Left(is_today,4)) + 1 ,'0000')
dw_1.Object.chasu[1] = ll_chasu


dw_1.SetColumn("cvcod")

//rb_car.Checked = True
//
//rb_car.PostEvent(Clicked!)
//
end event

type dw_insert from w_inherite`dw_insert within w_sm30_0010
integer x = 27
integer y = 280
integer width = 4558
integer height = 2000
integer taborder = 130
string dataobject = "d_sm30_0010_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Dec 	 dQty, dAmt, dPrc, nChasu
Long   nRow
String sCol, sItnbr, sItdsc, siSpec, sjijil, sispec_code,s_cvcod, snull, get_nm, syear, sstrmm, ssaupj
Int    ireturn

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

sCol = GetColumnName()
Choose Case LEFT(sCol,3)
	Case 'cvc'
		
			sItnbr = trim(this.GetText())
			
			Select cvnas Into :sitdsc
			  from vndmst
			 where cvcod = :sItnbr ;
		   
			If sqlca.sqlcode <> 0 Then
		
				setitem(nrow, "cvcod", sNull)	
				setitem(nrow, "cvnas", sNull)	
				Return 1
			else
				setitem(nrow, "cvnas", sitdsc)	
			End if
		
		RETURN ireturn
	
		
	Case 'qty'
		dQty = Dec(GetText())
		If IsNull(dQty) Then dQty = 0
		
		dPrc = GetItemNumber(nRow, 'plan_prc')
		
		dAmt = Round(dQty * dPrc,0)
		
		SetItem(nRow, 'amt_'+Right(sCol,2), dAmt)
	Case 'itn'
		
		If rb_itnbr.checked  Then
			sItnbr = trim(this.GetText())
		
			ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
			setitem(nrow, "itnbr", sitnbr)	
			setitem(nrow, "itdsc", sitdsc)	
			
			Post wf_danga(nrow)
		else
			sItnbr = trim(this.GetText())
			
			Select carname Into :sitdsc
			  from carhead
			 where carcode = :sItnbr ;
		   
			If sqlca.sqlcode <> 0 Then
		
				setitem(nrow, "itnbr", sNull)	
				setitem(nrow, "itdsc", sNull)	
				Return 1
			else
				setitem(nrow, "itdsc", sitdsc)	
			End if
				
		end if
		
		RETURN ireturn
	
End Choose

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow , i , ll_i = 0
String sItnbr, sNull
str_code lst_code
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

sle_msg.text = ''

nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		
		If rb_itnbr.Checked Then

			gs_code = Trim(dw_1.Object.cvcod[1])
			gs_codename =Trim(dw_1.Object.cvnas[1])
			
			Open(w_sal_02000_vnddan)
	
			lst_code = Message.PowerObjectParm
			IF isValid(lst_code) = False Then Return 
			If UpperBound(lst_code.code) < 1 Then Return 
			
			For i = row To UpperBound(lst_code.code) + row - 1
				ll_i++
				if i > row then p_addrow.triggerevent("clicked")
				this.SetItem(i,"itnbr",lst_code.code[ll_i])
				this.TriggerEvent("itemchanged")
				
			Next
		End if
		
	Case 'cvcod'
		
	   gs_codename = '현대'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(nRow, "cvcod", gs_Code)
		SetItem(nRow, "cvnas", gs_Codename)
	
END Choose
end event

event dw_insert::clicked;call super::clicked;
f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm30_0010
integer x = 3922
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;Long i , ll_r , ll_cnt=0 , ll_i=0 ,ll_chasu
String ls_new , ls_cvcod ,ls_year ,ls_itnbr


If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 
ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return

For i = ll_r To 1 Step -1
	
	If dw_insert.IsSelected(i) Then
		ls_new = Trim(dw_insert.Object.is_new[i])
		If ls_new <> 'Y' Then
			
			ls_cvcod = Trim(dw_insert.Object.cvcod[i])
			ls_year  = Trim(dw_insert.Object.yyyy[i])
			ls_itnbr = Trim(dw_insert.Object.itnbr[i])
			ll_chasu = dw_insert.Object.chasu[i]
			
			Delete From SM01_YEARPLAN 
			      WHERE SABU = :gs_sabu 
					  AND YYYY = :ls_year 
					  AND CVCOD = :ls_cvcod 
					  AND ITNBR = :ls_itnbr
					  AND CHASU = :ll_chasu ;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox('',sqlca.sqlerrText )
				Rollback;
				Return
			End IF
		
		End If
		dw_insert.DeleteRow(i)
		ll_cnt++
		
	End If
Next

Commit ;

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text = String(ll_cnt) + "건이 삭제 되었습니다."



end event

type p_addrow from w_inherite`p_addrow within w_sm30_0010
integer x = 3749
integer taborder = 50
end type

event p_addrow::clicked;String sYymm, sCust, sSaupj, sStrmm , ls_cvcod ,ls_gubun
Long	 nRow, dMax, nChasu

String ls_cvnas

If dw_1.AcceptText() <> 1 Then Return

sYymm = Trim(dw_1.GetItemString(1, 'yymm'))
ls_cvcod = Trim(dw_1.GetItemString(1, 'cvcod'))
ls_cvnas = Trim(dw_1.GetItemString(1, 'cvnas'))

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	Return
End If

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

nChasu = dw_1.getitemNumber(1, 'chasu')

If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

If IsNull(ls_cvcod ) Or ls_cvcod = '' Then
	f_message_chk(1400,'[거래처]')
	Return
End If

//SELECT MAX(STRMM) INTO :sStrmm FROM SM01_YEARPLAN 
// WHERE SABU = :gs_sabu 
//	AND SAUPJ = :sSaupj 
//	AND YYYY = :sYymm
//	AND CHASU = :nChasu;
//If IsNull(sStrmm) Or sStrmm = '' Then
//	MessageBox('확인','계획시작월이 지정되지 않았습니다.!!')
//	Return
//End If

If rb_car.Checked Then
	ls_gubun = '1'
Else
	ls_gubun = '2'
End if

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'sabu',  gs_sabu)
dw_insert.SetItem(nRow, 'yyyy',  sYymm)
dw_insert.SetItem(nRow, 'cvcod', ls_cvcod)
dw_insert.SetItem(nRow, 'cvnas', ls_cvnas)
dw_insert.SetItem(nRow, 'gubun', ls_gubun)
dw_insert.SetItem(nRow, 'saupj', sSaupj)
dw_insert.SetItem(nRow, 'chasu', nChasu)
dw_insert.SetItem(nRow, 'strmm', sStrmm)

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()
end event

type p_search from w_inherite`p_search within w_sm30_0010
boolean visible = false
integer x = 3433
integer y = 156
integer taborder = 110
boolean enabled = false
string picturename = "C:\erpman\image\from_excel.gif"
end type

event p_search::ue_lbuttondown;//PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;//PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;//String sYear, sCust, sCvcod, sToday , ls_saupj ,ls_factory , ls_carcode , ls_crtgbn 
//String ls_carname
//string ls_pre_fac , ls_pre_car , ls_pre_crt
//Long   ll_cnt=0 ,  ll_chasu 
//Long   ll_sqty
//If dw_1.AcceptText() <> 1 Then Return
//
//sYear = trim(dw_1.getitemstring(1, 'yymm'))
//sCust = trim(dw_1.getitemstring(1, 'cust'))
//sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
//ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
//
//ll_chasu = dw_1.object.chasu[1]
//
//If IsNull(sYear) Or sYear = '' Then
//	f_message_chk(1400,'[계획년도]')
//	Return
//End If
//
//If IsNull(ll_chasu) Or ll_chasu <= 0 Then
//	f_message_chk(1400,'[차수]')
//	Return
//End If
//
//SELECT COUNT(*) INTO :ll_cnt
//  FROM SM01_YEARPLAN
// WHERE SUBSTR(GUBUN,1,1) = '1' 
//   AND SAUPJ = :ls_saupj
//	AND YYYY = :sYear 
//	AND CHASU = :ll_chasu
//	;
//
//If ll_cnt > 0 Then
//	MessageBox('확인','해당 년도에는 이미 차종계획 데이타가 존재합니다. 다른차수로 계획을 생성하세요. ')
//	dw_1.SetFocus()
//	dw_1.SetColumn("chasu")
//	Return
//End if 
//
//gs_code = sYear
//w_mdi_frame.sle_msg.text =""
//
//If rb_itnbr.checked Then
//	MessageBox('확인','차종 Checked 상태일때만 엑셀 파일 Import 가 가능합니다. ')
//	Return
//End if
//
//// 엘셀 IMPORT ***************************************************************
//uo_xlobject uo_xl
//string ls_docname, ls_named ,ls_line 
//Long   ll_FileNum ,ll_value
//String ls_gubun , ls_col ,ls_line_t , ls_data[]
//Long   ll_xl_row , ll_r , i 
//
//If dw_1.AcceptText() = -1 Then Return
//
//ls_gubun = '1'
//
//
//ll_value = GetFileOpenName("차종별 년간계획 데이타 가져오기", ls_docname, ls_named, & 
//             "XLS", "XLS Files (*.XLS),*.XLS,")
//
//If ll_value <> 1 Then Return
//
//dw_insert.Reset()
//
//Setpointer(Hourglass!)
//
////===========================================================================================
////UserObject 생성
//uo_xl = create uo_xlobject
//		
////엑셀과 연결
//uo_xl.uf_excel_connect(ls_docname, false , 3)
//
//uo_xl.uf_selectsheet(1)
//
//If sYear <> Left(Trim(uo_xl.uf_gettext(1,2)),4) Then
//	MessageBox('확인','등록하신 기준년월이 파일의 년월과 일치하지 않습니다. 확인 후 등록하세요')
//	uo_xl.uf_excel_Disconnect()
//	Return
//End If
//
////dw_insert.object.t_mm.text = String(sYear,'@@@@')+'년도'
//
////Data 시작 Row Setting (행)
//// Excel 에서 A: 1 , B :2 로 시작 
//
//ll_xl_row = 4
//ll_cnt = 0 
//ls_factory = ' '
//Do While(True)
//	
//	//사용자 ID(A,1)
//	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
//	For i =1 To 30
//		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
//		
//	Next
//	
//	ls_factory = trim(uo_xl.uf_gettext(ll_xl_row,2))
//	ls_carcode = trim(uo_xl.uf_gettext(ll_xl_row,3))
//	ls_crtgbn  = trim(uo_xl.uf_gettext(ll_xl_row,4))
//	
//	If ( ls_factory = '' or isNull(ls_factory) ) and &
//	   ( ls_carcode = '' or isNull(ls_carcode) ) and &
//		( ls_crtgbn = '' or isNull(ls_crtgbn) ) Then Exit ;
//
//	If Right(ls_factory,2) = '계' Then 
//		ll_xl_row ++
//		Continue ;
//	End if
//	
//	If ls_factory = '' or isNull(ls_factory) Then
//		ls_factory = ls_pre_fac 
//	End if
//	
//	ll_cnt = 0
//	
//	Select Count(*) Into :ll_cnt
//	  From reffpf
//	 Where rfcod = '1G'
//	   and rfgub = substr(:ls_factory,1,1) ;
//	
//	If ll_cnt <= 0 Then
//	
//		Choose Case Trim(Left(ls_factory,4))
//			Case '아산'
//				ls_factory = '7'
//				ls_saupj = '20'
//			Case 'CKD' , 'Y'
//				ls_factory = 'Y'
//			Case Else
//				ls_factory = '.'
//		End Choose
//	Else
//		ls_factory = Left(ls_factory,1)
//		ls_saupj = '10'
//	End If
//	
//	If ls_factory = '.' Then 
//		ls_pre_fac = ls_factory
//		ll_xl_row ++
//		Continue ;
//	End if
//	
//	If  ls_factory = 'Y' Then
//		If Right(ls_carcode,2) <> '계' Then
//			ls_pre_fac = ls_factory
//			ls_pre_car = ls_carcode
//			ll_xl_row ++
//			Continue ;
//		End if
//	Else
//		If Right(ls_carcode,2) = '계'  Then
//			ls_pre_fac = ls_factory
//			ls_pre_car = ls_carcode
//			ll_xl_row ++
//			Continue ;
//		End if
//	End if
//	
//	If Right(ls_crtgbn,2) = '계' Then 
//		ls_pre_fac = ls_factory
//		ls_pre_car = ls_carcode
//		ll_xl_row ++
//		Continue ;
//	End if
//
//	
//	If ls_carcode = '' or isNull(ls_carcode) Then
//		ls_carcode = ls_pre_car
//	End if
//	
//	If ls_crtgbn = '' or isNull(ls_crtgbn) Then
//		ls_crtgbn = '10'
//	Else
//		If ls_crtgbn = '내수' Then 
//			ls_crtgbn = '11'
//		ElseIf  ls_crtgbn = '수출' Then 
//			ls_crtgbn = '12'
//		Else
//			ls_crtgbn = '10'
//		End if
//	End if
//
//
//	ll_r = dw_insert.InsertRow(0) 
//	ll_cnt++
//	
//	dw_insert.Scrolltorow(ll_r)
//
//	dw_insert.object.saupj[ll_r] =  ls_saupj
//	dw_insert.object.yyyy[ll_r] =   sYear  
//	dw_insert.object.chasu[ll_r] =    ll_chasu
//	dw_insert.object.cvcod[ll_r] =    ls_factory
//	If ls_factory = 'Y' Then
//		dw_insert.object.itnbr[ll_r] =    'AL'
//		dw_insert.object.itdsc[ll_r] =    'ALL'
//	Else 
//		dw_insert.object.itnbr[ll_r] =    ls_carcode
//	
//		SELECT FUN_GET_REFFPF('01',:ls_carcode) Into :ls_carname FROM DUAL ;
//	
//		If sqlca.sqlcode <> 0 Then ls_carname = '미정'
//	
//		dw_insert.object.itdsc[ll_r] =    ls_carname
//	End if
//	
//	dw_insert.object.gubun[ll_r] =   ls_crtgbn
//	
//	For i = 1 To 12
//		dw_insert.Setitem(ll_r , "qty_"+string(i,'00') , Long(uo_xl.uf_gettext(ll_xl_row,7+i)) )
//	Next
//		
//	ls_pre_fac = ls_factory
//	ls_pre_car = ls_carcode
//	
//	ll_xl_row ++
//	
//Loop
//uo_xl.uf_excel_Disconnect()
//
//
//// 엘셀 IMPORT  END ***************************************************************
//
//dw_insert.AcceptText()
//
////If dw_insert.Update() < 1 Then
////	Rollback;
////	MessageBox('확인','저장실패')
////	Return
////Else
////	Commit;
////End If
//
//w_mdi_frame.sle_msg.text =String(ll_r)+'건의 년간계획 DATA IMPORT 를 완료하였습니다.'
//MessageBox('확인',String(ll_r)+'건의 년간계획 DATA IMPORT 를 완료하였습니다.')
//
//Return
end event

type p_ins from w_inherite`p_ins within w_sm30_0010
boolean visible = false
integer x = 4064
integer y = 196
integer taborder = 30
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm30_0010
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_sm30_0010
integer taborder = 90
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sm30_0010
boolean visible = false
integer x = 3845
integer y = 204
integer taborder = 120
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sm30_0010
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2
String scvcod
Long   nCnt, ix, nrow, nChasu
String sSaupj , ls_itnbr

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sYear = trim(dw_1.getitemstring(1, 'yymm'))
nChasu = dw_1.getitemNumber(1, 'chasu')
scvcod = trim(dw_1.getitemstring(1, 'cvcod'))

ls_itnbr = Trim(dw_1.Object.itnbr[1])

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))


If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If


If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

If IsNull(scvcod) Or scvcod = '.' or scvcod = '' Then scvcod = '%'
	
If IsNull(ls_itnbr) Or ls_itnbr = '' Then 
	ls_itnbr = '%'
else
	ls_itnbr = ls_itnbr + '%'
end if
	
If dw_insert.Retrieve(gs_sabu, sSaupj, sYear, nChasu, scvcod+'%',  ls_itnbr) <= 0 Then
	f_message_chk(50,'')
End If

end event

type p_del from w_inherite`p_del within w_sm30_0010
boolean visible = false
integer x = 3648
integer y = 200
integer taborder = 80
boolean enabled = false
end type

event p_del::clicked;Long nRow, ix
String sCust, sCvcod, sItnbr, sItdsc, tx_name, sCargbn1, sCargbn2, sYear
String sSaupj

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

scust = Trim(dw_1.GetItemString(1, 'cust'))
sYear = Trim(dw_1.GetItemString(1, 'yymm'))
tx_name = Trim(dw_1.Describe("Evaluate('LookUpDisplay(cust) ', 1)"))
sCargbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCargbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

IF MessageBox("확인", '고객구분 ' + tx_name + ' 의 자료를 삭제합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

dw_insert.RowsMove(1, dw_insert.RowCount(), Primary!, dw_insert, 1, Delete!)

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

// 차종별 계획인 경우
If dw_insert.DataObject = 'd_sm00_00010_2' Then
/* 기존자료 삭제 - 차종,기종 */
	DELETE FROM "SM01_YEARPLAN"
		WHERE SABU = :gs_sabu 
		  AND YYYY = :sYear
		  AND GUBUN = :sCargbn1||:sCargbn2
		  AND SAUPJ = :sSaupj;
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		RollBack;
		Return
	End If
End If

Commit;

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sm30_0010
integer x = 4096
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;Long ix, nRow , ll_chasu ,ll_cnt = 0 , ll_f
String sCust, sItnbr, sItdsc, sCvcod, ls_gubun, ls_fac
String ls_saupj , ls_yyyy 

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

If rb_car.Checked Then
	ls_gubun = '1'
Else
	ls_gubun = '2' 
End if

nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1

	sCvcod = Trim(dw_insert.GetItemString(ix, 'cvcod'))
	sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
	sItdsc = Trim(dw_insert.GetItemString(ix, 'itdsc'))
	
	If IsNull(sItnbr) Or sItnbr = '' Then
		dw_insert.DeleteRow(ix)
		continue
	
	End If
	
	If IsNull(sItdsc) Or sItdsc = '' Then
		dw_insert.object.itdsc[ix] = '.'
	End If

Next

For ix = nRow To 1 Step -1

	sCvcod = Trim(dw_insert.GetItemString(ix, 'cvcod'))
	sItnbr = Trim(dw_insert.GetItemString(ix, 'itnbr'))
	ls_fac = Trim(dw_insert.GetItemString(ix, 'plnt' ))
	
	If ix > 2 Then 
	
		ll_f = dw_insert.Find("cvcod='"+sCvcod+"' and itnbr='"+sItnbr+"' and plnt = '"+ls_fac+"'", 1 , ix - 1 )
		
		If ll_f > 0 Then
			MessageBox('확인','중복된 거래처 , 품번이 존해합니다.')
			dw_insert.ScrollToRow(ix)
			Return
		End if
	End If

Next
	
ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yyyy = Trim(dw_1.Object.yymm[1])
ll_chasu = dw_1.Object.chasu[1]

ll_cnt = 0  

Select Count(*) into :ll_cnt
  From SM01_YEARPLAN
  WHERE SAUPJ = :ls_saupj
	 AND YYYY = :ls_yyyy 
	 AND CHASU = :ll_chasu 
	 AND CNFIRM IS NOT NULL ;
	 
If ll_cnt > 0 Then
	MessageBox('확인','해당 계획연도의 해당 차수에는 이미 확정된 년간판매계획이 존재합니다.' + &
					 '~n~r~n~r저장 불가능 합니다.') 
	Return

End iF
	
If dw_insert.RowCount() > 0 Then
	
	If dw_insert.Update() <> 1 Then
		MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If
	
	UPDATE sm01_yearplan SET AMT_01 =  ROUND(QTY_01*PLAN_PRC , 0 ), 
							 AMT_02 =  ROUND(QTY_02*PLAN_PRC , 0 ), 
							 AMT_03 =  ROUND(QTY_03*PLAN_PRC , 0 ), 
							 AMT_04 =  ROUND(QTY_04*PLAN_PRC , 0 ), 
							 AMT_05 =  ROUND(QTY_05*PLAN_PRC , 0 ), 
							 AMT_06 =  ROUND(QTY_06*PLAN_PRC , 0 ),
							 AMT_07 =  ROUND(QTY_07*PLAN_PRC , 0 ), 
							 AMT_08 =  ROUND(QTY_08*PLAN_PRC , 0 ), 
							 AMT_09 =  ROUND(QTY_09*PLAN_PRC , 0 ), 
							 AMT_10 =  ROUND(QTY_10*PLAN_PRC , 0 ), 
							 AMT_11 =  ROUND(QTY_11*PLAN_PRC , 0 ), 
							 AMT_12 =  ROUND(QTY_12*PLAN_PRC , 0 ) 
	WHERE YYYY = :ls_yyyy
	  AND CHASU = :ll_chasu
	  AND substr(GUBUN ,1,1) = :ls_gubun
	  AND SAUPJ = :ls_saupj ;
  
	If sqlca.sqlcode <> 0 Then
		MessageBox('확인2',sqlca.sqlerrText)
		Rollback ;
		Return
	End if 

	COMMIT;
	
	MessageBox('확 인','저장하였습니다')
Else
	MessageBox('확 인','저장할 자료가 없습니다.!!')
End If

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_sm30_0010
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm30_0010
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm30_0010
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm30_0010
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm30_0010
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm30_0010
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm30_0010
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm30_0010
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm30_0010
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm30_0010
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm30_0010
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm30_0010
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm30_0010
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm30_0010
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm30_0010
integer x = 18
integer y = 16
integer width = 2135
integer height = 244
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sm30_0010_1"
boolean border = false
end type

event itemchanged;String s_cvcod, snull, get_nm, sItem, sCust,sDate
Long   nCnt, nChasu
String sSaupj

SetNull(sNull)


Choose Case GetColumnName()
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	
	Case 'itnbr'
		sItem = GetText()
	/* 계획년도 */
	Case 'yymm'
		sDate = Left(GetText(),6)
		
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			// 해당년도의 최종차수 계산
			SELECT MAX(CHASU) INTO :nChasu FROM SM01_YEARPLAN 
			 WHERE SABU = :gs_sabu 
			   AND SAUPJ = :sSaupj 
				AND YYYY = :sDate;
			If IsNull(nChasu) Then nChasu = 1
			SetItem(1, 'chasu', nChasu)
			
			Post wf_protect(sDate, nChasu)
		End If
	/* 계획차수 */
	Case 'chasu'
		nChasu = Dec(GetText())
		If nChasu <= 0 Then Return
		
		sDate = GetitemString(1, 'yymm')
		
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			Post wf_protect(sDate, nChasu)
		End If
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
	   gs_codename = '현대'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

type rb_car from radiobutton within w_sm30_0010
boolean visible = false
integer x = 2199
integer y = 56
integer width = 274
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
boolean enabled = false
string text = "차종"
end type

event clicked;wf_init()
end event

type rb_itnbr from radiobutton within w_sm30_0010
boolean visible = false
integer x = 2199
integer y = 164
integer width = 274
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
boolean enabled = false
string text = "품번"
boolean checked = true
end type

event clicked;wf_init()
end event

type p_1 from uo_picture within w_sm30_0010
boolean visible = false
integer x = 3799
integer y = 148
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
end type

type cb_1 from commandbutton within w_sm30_0010
boolean visible = false
integer x = 2514
integer y = 28
integer width = 603
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "전년도 차종계획 생성"
end type

event clicked;
String ls_saupj , ls_yyyy 
Long   ll_chasu 
Long   ll_cnt

If dw_1.AcceptText() <> 1 Then Return

ls_yyyy = trim(dw_1.getitemstring(1, 'yymm'))
ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ll_chasu = dw_1.object.chasu[1]

If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

If IsNull(ls_yyyy) Or ls_yyyy = '' Then
	f_message_chk(1400,'[계획년도]')
	dw_1.SetFocus()
	dw_1.SetColumn('yymm')
	Return
End If


If IsNull(ll_chasu) Or ll_chasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	dw_1.SetFocus()
	dw_1.SetColumn('chasu')
	Return
End If

ll_cnt = 0
Select Count(*) Into :ll_cnt 
  from SM01_YEARPLAN
 Where saupj   = :ls_saupj
   and YYYY = :ls_yyyy
   and chasu = :ll_chasu 
   and cnfirm is not null ;
	
If ll_cnt > 0 Then
	MessageBox('확인','이미 확정된 계획입니다.  생성불가합니다.')
	Return
End If

ll_cnt = 0
Select Count(*) Into :ll_cnt 
  from SM01_YEARPLAN
 Where saupj   = :ls_saupj
   and YYYY = :ls_yyyy
   and chasu = :ll_chasu 
	and gubun = '1';
	
If ll_cnt > 0 Then
	If MessageBox('확인','삭제 후 재성성 하시겠습니까?' ,Exclamation!, OKCancel!, 2) = 2 Then Return
End If

pointer oldpointer

oldpointer = SetPointer(HourGlass!)
		  
Delete from SM01_YEARPLAN
      Where saupj   = :ls_saupj
		  and YYYY = :ls_yyyy
		  and chasu = :ll_chasu  ;
		  
If sqlca.sqlcode <> 0 Then
	MessageBox('확인','삭제실패')
	Rollback;
   Return
End If 

insert into sm01_yearplan(	sabu    ,
									yyyy    ,
									cvcod   ,
									itnbr   ,
									gubun   ,
									itdsc   ,
									saupj   ,
									chasu   ,
									plnt    ,
									qty_01  ,
									qty_02  ,
									qty_03  ,
									qty_04  ,
									qty_05  ,
									qty_06  ,
									qty_07  ,
									qty_08  ,
									qty_09  ,
									qty_10  ,
									qty_11  ,
									qty_12  ,
									cnfirm  ,
									plan_prc,
									crtgb   ,
									strmm   ,
									brate )
     select '1' as sabu    ,
				x1.yyyy    ,
				x1.cvcod   ,
				x1.carcode as itnbr   ,
				x1.gubun   ,
				x1.carname as itdsc   ,
				x1.saupj   ,
				:ll_chasu as chasu   ,
				'.' as plnt    ,
				x1.qty_01  ,
				x1.qty_02  ,
				x1.qty_03  ,
				x1.qty_04  ,
				x1.qty_05  ,
				x1.qty_06  ,
				x1.qty_07  ,
				x1.qty_08  ,
				x1.qty_09  ,
				x1.qty_10  ,
				x1.qty_11  ,
				x1.qty_12  ,
				null as cnfirm  ,
				0   as plan_prc ,
				'1' as crtgb   ,
				'.' as strmm  ,
				1  /* x2.brate */
      from  ( select a.saupj  as saupj ,
							:ls_yyyy as yyyy ,
							b.cvcod    as cvcod ,
							b.carcode  as carcode ,
							'1'        as gubun ,
							b.carname  as carname ,
							sum(decode(substr(a.yymm,-2,2) , '01',a.mmqty , 0 )) as qty_01 ,
							sum(decode(substr(a.yymm,-2,2) , '02',a.mmqty , 0 )) as qty_02 ,
							sum(decode(substr(a.yymm,-2,2) , '03',a.mmqty , 0 )) as qty_03 ,
							sum(decode(substr(a.yymm,-2,2) , '04',a.mmqty , 0 )) as qty_04 ,
							sum(decode(substr(a.yymm,-2,2) , '05',a.mmqty , 0 )) as qty_05 ,
							sum(decode(substr(a.yymm,-2,2) , '06',a.mmqty , 0 )) as qty_06 ,
							sum(decode(substr(a.yymm,-2,2) , '07',a.mmqty , 0 )) as qty_07 ,
							sum(decode(substr(a.yymm,-2,2) , '08',a.mmqty , 0 )) as qty_08 ,
							sum(decode(substr(a.yymm,-2,2) , '09',a.mmqty , 0 )) as qty_09 ,
							sum(decode(substr(a.yymm,-2,2) , '10',a.mmqty , 0 )) as qty_10 ,
							sum(decode(substr(a.yymm,-2,2) , '11',a.mmqty , 0 )) as qty_11 ,
							sum(decode(substr(a.yymm,-2,2) , '12',a.mmqty , 0 )) as qty_12 
					  from sm01_monplan_car a , carhead b 
					 where a.carcode = b.ycarcode
						and a.saupj = :ls_saupj
						and a.yymm like  trim(to_char(to_number(:ls_yyyy) - 1 ,'0000'))||'%'
					  group by a.saupj ,
								 trim(to_char(to_number(:ls_yyyy) - 1 ,'0000')) ,
								 b.cvcod   ,
								 b.carcode ,
								 b.carname   ) x1  ; /*,
				    ( select x.carcode as carcode,
							    decode(x.sqty,0,0, trunc(y.mqty / x.sqty,2)) as brate
						  from ( select a1.carcode                 as carcode,
									       sum(a1.sumqty * b1.usage ) as sqty 
								    from (select s15 as carcode,
										           nvl(sum(mmqty),0)  AS sumqty
										      from sm01_monplan_car 
										     WHERE SAUPJ = :ls_saupj
										       AND YYMM  LIKE trim(to_char(to_number(:ls_yyyy) - 1 ,'0000'))||'%'
										     group by s15 
											  ) a1 ,
										   (select carcode , itnbr , max(usage) as usage from carbom b1 group by carcode , itnbr ) b1 
								   where a1.carcode = b1.carcode
								  group by a1.carcode
								  ) x ,
							    ( select carcode , sum(mmqty) as mqty
								     from sm01_monplan_dt 
								    where carcode <> '.'
								  group by carcode ) y
						  where x.carcode = y.carcode 
				 ) x2 
       where x1.carcode = x2.carcode(+)  ; */
		 
If sqlca.sqlnrows = 0 Then
	MessageBox('확인','생성할 전년도 월계획이 없습니다.')
	Rollback;
   Return
End If 
		 
Commit;

SetPointer(oldpointer)

w_mdi_frame.sle_msg.text =String(sqlca.sqlnrows) + " 건 데이타를 생성 하였습니다."

rb_car.Checked = True

wf_init()

p_inq.TriggerEvent(Clicked!)

MessageBox('확인', '생성 완료 하였습니다.')


end event

type cb_2 from commandbutton within w_sm30_0010
boolean visible = false
integer x = 2514
integer y = 132
integer width = 603
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "차종 BOM 적용"
end type

event clicked;String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2
String scvcod
Long   nCnt, ix, nrow, nChasu , ll_rcnt , ll_cnt , i
String sSaupj , ls_itnbr ,ls_itdsc
String ls_factory , ls_carcode  ,ls_saupj


If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sYear = trim(dw_1.getitemstring(1, 'yymm'))
nChasu = dw_1.getitemNumber(1, 'chasu')
scvcod = trim(dw_1.getitemstring(1, 'cvcod'))

ls_itnbr = Trim(dw_1.Object.itnbr[1])

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))


If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

ll_cnt = 0
Select Count(*) Into :ll_cnt 
  from SM01_YEARPLAN
 Where saupj   = :sSaupj
   and YYYY = :sYear
   and chasu = :nChasu 
   and cnfirm is not null ;
	
If ll_cnt > 0 Then
	MessageBox('확인','이미 확정된 계획입니다.  생성불가합니다.')
	Return
End If

ll_cnt = 0
Select Count(*) Into :ll_cnt 
  from SM01_YEARPLAN
 Where saupj   = :sSaupj
   and YYYY = :sYear
   and chasu = :nChasu 
	and gubun = '2';
	
If ll_cnt > 0 Then
	If MessageBox('확인','삭제 후 재성성 하시겠습니까?' ,Exclamation!, OKCancel!, 2) = 2 Then Return
End If

pointer oldpointer 

oldpointer = SetPointer(HourGlass!)


SetPointer(oldpointer)
		  
Delete from SM01_YEARPLAN
		Where saupj   = :sSaupj
		  and YYYY = :sYear
		  and chasu = :nChasu 
		  and gubun = '2' ;
		  
dw_insert.SetRedraw(False)


w_mdi_frame.sle_msg.text ="차종 BOM 을 적요하고 있습니다......"

// 차종 BOM 전개 ================================================================================
		
insert into sm01_yearplan ( sabu , yyyy , cvcod , itnbr , itdsc ,plan_prc ,
									 qty_01 , qty_02 , qty_03, qty_04 , qty_05 , qty_06  ,
									 qty_07 , qty_08 , qty_09, qty_10 , qty_11 , qty_12  ,
									 saupj, gubun , chasu ,plnt ,brate )
							select a.sabu , 
									 a.yyyy , 
									 a.cvcod , 
									 b.itnbr , 
									 trim(fun_get_itdsc(b.itnbr)) as itdsc ,
									 fun_erp100000012_1(to_char(sysdate,'YYYYMMDD') ,a.cvcod ,
														b.itnbr ,'1') as plan_prc ,
									 sum(ROUND(a.qty_01 * b.usage ,0)) as qty_01 , 
									 sum(ROUND(a.qty_02 * b.usage ,0)) as qty_02 , 
									 sum(ROUND(a.qty_03 * b.usage ,0)) as qty_03 , 
									 sum(ROUND(a.qty_04 * b.usage ,0)) as qty_04 , 
									 sum(ROUND(a.qty_05 * b.usage ,0)) as qty_05 , 
									 sum(ROUND(a.qty_06 * b.usage ,0)) as qty_06 , 
									 sum(ROUND(a.qty_07 * b.usage ,0)) as qty_07 , 
									 sum(ROUND(a.qty_08 * b.usage ,0)) as qty_08 , 
									 sum(ROUND(a.qty_09 * b.usage ,0)) as qty_09 , 
									 sum(ROUND(a.qty_10 * b.usage ,0)) as qty_10 , 
									 sum(ROUND(a.qty_11 * b.usage ,0)) as qty_11 , 
									 sum(ROUND(a.qty_12 * b.usage ,0)) as qty_12 ,
									 a.saupj ,
									 '2' gubun ,
									 a.chasu as chasu ,
									 '.' ,
									 1
								from sm01_yearplan a , 
									(select  carcode , itnbr ,max(usage) as usage 
										from carbom
									group by carcode  , itnbr  ) b 
							where a.itnbr = b.carcode 
							  and a.yyyy = :syear
							  and a.chasu = :nchasu
							  and substr(a.gubun,1,1) = '1'
							  and a.saupj = :ssaupj
							group by a.sabu , a.yyyy , a.cvcod , b.itnbr , a.saupj  ,a.chasu ;
								
If sqlca.sqlcode <> 0 Then
	MessageBox('확인1',sqlca.sqlerrText)
	Rollback;
	Return
End if 

w_mdi_frame.sle_msg.text ="계획비율을 계산하고 있습니다......."


// 계획비율 산정 (전년도 기준 ) ==================================================================
//// 임시 - 2006년도만 할 것 
//update sm01_yearplan x 
//   set x.brate = (select trunc( decode(sum(y.sumqty) ,0 , 0 , sum(y.silqty) / sum(y.sumqty) ) ,4)
//						  from (select substr(a.ipdate , 1 , 4) as yyyy ,
//						               a.mcvcod                 as cvcod ,
//										   b.itnbr as itnbr,
//										   sum(a.ipqty) as silqty ,
//										   0 as sumqty
//								    from van_hkcd1_conv a , itemas b
//								   where a.itnbr = replace(b.itnbr , '-','')
//									  and substr(a.ipdate , 1 , 4) = trim(to_char(to_number(:sYear) - 1 ))
//								group by substr(a.ipdate , 1 , 4) , a.mcvcod , b.itnbr
//								union all
//								  select substr(a.yymm , 1 , 4) as yyyy ,
//								         a.cvcod                as cvcod ,
//										   a.itnbr as itnbr,
//										   0 as silqty ,
//										   sum(a.mmqty) as sumqty
//								    from sm01_monplan_dt a
//								   where substr(a.yymm , 1 , 4) = trim(to_char(to_number(:sYear) - 1 ))
//								group by substr(a.yymm , 1 , 4) , a.cvcod , a.itnbr 
//								) y
//						  where y.itnbr = x.itnbr
//						    and y.cvcod = x.cvcod
//							 and trim(to_char(to_number(y.yyyy) + 1 ))= x.yyyy
//					   )
//where x.gubun = '2'
//  and x.saupj = :ssaupj
//  and x.yyyy = :sYear
//  and x.chasu = :nChasu ; 
  
  
// 2007년도 부터 적용  
update sm01_yearplan x 
   set x.brate = (select trunc( decode(sum(y.sumqty) ,0 , 0 , sum(y.silqty) / sum(y.sumqty) ) ,4)
						  from (select substr(a.ipdate , 1 , 4) as yyyy ,
						               a.mcvcod                 as cvcod ,
										   b.itnbr as itnbr,
										   sum(a.ipqty) as silqty ,
										   0 as sumqty
								    from van_hkcd1 a , itemas b
								   where a.itnbr = replace(b.itnbr , '-','')
									  and substr(a.ipdate , 1 , 4) = trim(to_char(to_number(:sYear) - 1 ))
								group by substr(a.ipdate , 1 , 4) , a.mcvcod , b.itnbr
								union all
								  select substr(a.yymm , 1 , 4) as yyyy ,
								         a.cvcod                as cvcod ,
										   a.itnbr as itnbr,
										   0 as silqty ,
										   sum(a.mmqty) as sumqty
								    from sm01_monplan_dt a
								   where substr(a.yymm , 1 , 4) = trim(to_char(to_number(:sYear) - 1 ))
								group by substr(a.yymm , 1 , 4) , a.cvcod , a.itnbr 
								) y
						  where y.itnbr = x.itnbr
						    and y.cvcod = x.cvcod
							 and trim(to_char(to_number(y.yyyy) + 1 ))= x.yyyy
					   )
where x.gubun = '2'
  and x.saupj = :ssaupj
  and x.yyyy = :sYear
  and x.chasu = :nChasu ; 
  
If sqlca.sqlcode <> 0 Then
	MessageBox('확인1',sqlca.sqlerrText)
	Rollback;
	Return
End if 

commit;

SetPointer(oldpointer)

w_mdi_frame.sle_msg.text =String(sqlca.sqlnrows) + " 건 데이타를 생성 하였습니다."

rb_itnbr.Checked = True

wf_init()

p_inq.TriggerEvent(Clicked!)

MessageBox('확인', '생성 완료 하였습니다.')
end event

type cb_3 from commandbutton within w_sm30_0010
integer x = 2336
integer y = 160
integer width = 603
integer height = 108
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "계획비율 적용"
end type

event clicked;String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2
String scvcod
Long   nCnt, ix, nrow, nChasu , ll_rcnt , ll_cnt , i
String sSaupj , ls_itnbr ,ls_itdsc
String ls_factory , ls_carcode  ,ls_saupj


If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sYear = trim(dw_1.getitemstring(1, 'yymm'))
nChasu = dw_1.getitemNumber(1, 'chasu')
scvcod = trim(dw_1.getitemstring(1, 'cvcod'))

ls_itnbr = Trim(dw_1.Object.itnbr[1])

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))


If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return
End If

If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

ll_cnt = 0
Select Count(*) Into :ll_cnt 
  from SM01_YEARPLAN
 Where saupj   = :sSaupj
   and YYYY = :sYear
   and chasu = :nChasu 
   and cnfirm is not null ;
	
If ll_cnt > 0 Then
	MessageBox('확인','이미 확정된 계획입니다.  생성불가합니다.')
	Return
End If

ll_cnt = 0
Select Count(*) Into :ll_cnt 
  from SM01_YEARPLAN
 Where saupj   = :sSaupj
   and YYYY = :sYear
   and chasu = :nChasu 
	and gubun = '2';
	
If ll_cnt = 0 Then
	MessageBox('확인','차종 BOM 적용 후 계획비율 적용가능합니다.') 
	Return
End If

dw_insert.SetRedraw(False)

pointer oldpointer 

oldpointer = SetPointer(HourGlass!)

  
// 계획비율 계산 =====================================================================


UPDATE sm01_yearplan SET QTY_01 =  ROUND(QTY_01 * BRATE , 0 ), 
                         QTY_02 =  ROUND(QTY_02 * BRATE , 0 ), 
								 QTY_03 =  ROUND(QTY_03 * BRATE , 0 ), 
								 QTY_04 =  ROUND(QTY_04 * BRATE , 0 ), 
								 QTY_05 =  ROUND(QTY_05 * BRATE , 0 ), 
								 QTY_06 =  ROUND(QTY_06 * BRATE , 0 ),
			                QTY_07 =  ROUND(QTY_07 * BRATE , 0 ), 
								 QTY_08 =  ROUND(QTY_08 * BRATE , 0 ), 
								 QTY_09 =  ROUND(QTY_09 * BRATE , 0 ), 
								 QTY_10 =  ROUND(QTY_10 * BRATE , 0 ), 
								 QTY_11 =  ROUND(QTY_11 * BRATE , 0 ), 
								 QTY_12 =  ROUND(QTY_12 * BRATE , 0 ),
                         AMT_01 =  ROUND(QTY_01 * BRATE * PLAN_PRC , 0 ), 
                         AMT_02 =  ROUND(QTY_02 * BRATE * PLAN_PRC , 0 ), 
								 AMT_03 =  ROUND(QTY_03 * BRATE * PLAN_PRC , 0 ), 
								 AMT_04 =  ROUND(QTY_04 * BRATE * PLAN_PRC , 0 ), 
								 AMT_05 =  ROUND(QTY_05 * BRATE * PLAN_PRC , 0 ), 
								 AMT_06 =  ROUND(QTY_06 * BRATE * PLAN_PRC , 0 ),
			                AMT_07 =  ROUND(QTY_07 * BRATE * PLAN_PRC , 0 ), 
								 AMT_08 =  ROUND(QTY_08 * BRATE * PLAN_PRC , 0 ), 
								 AMT_09 =  ROUND(QTY_09 * BRATE * PLAN_PRC , 0 ), 
								 AMT_10 =  ROUND(QTY_10 * BRATE * PLAN_PRC , 0 ), 
								 AMT_11 =  ROUND(QTY_11 * BRATE * PLAN_PRC , 0 ), 
								 AMT_12 =  ROUND(QTY_12 * BRATE * PLAN_PRC , 0 ) 
	WHERE YYYY = :sYear
	  AND CHASU = :nchasu
	  AND GUBUN = '2'
	  AND SAUPJ = :sSaupj ;
	  
If sqlca.sqlcode <> 0 Then
	MessageBox('확인2',sqlca.sqlerrText)
	Rollback ;
	Return
End if 

Commit ;

w_mdi_frame.sle_msg.text =String(sqlca.sqlnrows) + " 건 데이타를 생성 하였습니다."

SetPointer(oldpointer)

rb_itnbr.Checked = True

wf_init()

p_inq.TriggerEvent(Clicked!)

MessageBox('확인', '계획비율 적용완료 하였습니다.')
end event

type st_txt from statictext within w_sm30_0010
integer x = 2962
integer y = 212
integer width = 1637
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* 계획비율은 소수점으로 입력하세요.( 예 90 % -> 0.9 )"
boolean focusrectangle = false
end type

type p_xls from picture within w_sm30_0010
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3145
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\from_excel.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;//PictureName = "C:\erpman\image\button_dn.gif"
end event

event ue_lbuttonup;//PictureName = "C:\erpman\image\button_up.gif"
end event

event clicked;wf_excel_itnbr()
end event

type gb_1 from groupbox within w_sm30_0010
boolean visible = false
integer x = 2158
integer width = 334
integer height = 248
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
end type

type rr_1 from roundrectangle within w_sm30_0010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 276
integer width = 4585
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

