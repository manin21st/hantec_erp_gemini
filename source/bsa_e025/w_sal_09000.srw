$PBExportHeader$w_sal_09000.srw
forward
global type w_sal_09000 from w_standard_print
end type
type mle_1 from multilineedit within w_sal_09000
end type
type dw_opt from u_key_enter within w_sal_09000
end type
type gb_1 from groupbox within w_sal_09000
end type
end forward

global type w_sal_09000 from w_standard_print
string title = "조건검색(영업)"
mle_1 mle_1
dw_opt dw_opt
gb_1 gb_1
end type
global w_sal_09000 w_sal_09000

type variables
integer   li_last_x
Boolean   ib_ret=False
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_create_report (string arg_code)
public function string wf_get_sql ()
public function integer wf_set_report_column (string ar_col, integer ar_tab, integer ar_width, string ar_format)
public function integer wf_set_report_text (string ar_col, string ar_text, string ar_x, string ar_y, string ar_h, string ar_w)
public function string wf_get_syntax ()
end prototypes

public function integer wf_retrieve ();//String sJobcode, sSidat, sSetSql, sPlctbl
//
//If dw_cond.AcceptText() <> 1 Then Return
//

//x 좌표 값 초기화
li_last_x = 0
dw_list.reset()

//sJobcode = Trim(dw_cond.GetItemString(1, 'jobcode'))
//sSidat   = Trim(dw_cond.GetItemString(1, 'sidate'))
//
//If IsNull(sJobcode) Or sJobcode = '' Then
//	f_message_chk(1400,'[작업조건]')
//	dw_cond.SetFocus()
//	dw_cond.SetColumn('jobcode')
//	Return
//End If
//
//If IsNull(sSidat) Or sSidat = '' Then
//	f_message_chk(1400,'[등록일자]')
//	dw_cond.SetFocus()
//	dw_cond.SetColumn('sidate')
//	Return
//End If
//
//dw_insert.SetRedraw(False)
//
// 신규인 경우 레포트 양식을 생성한다.
If ib_ret = False Then
//	// 테이블내역 조회
//	If ds_jobconh.Retrieve(sJobcode) <= 0 Then
//		MessageBox('확 인','작업조건 내역을 확인할 수 없습니다.!!')
//		dw_insert.SetRedraw(True)
//		Return
//	End If
//	
//	If ds_jobcond.Retrieve(sJobcode) <= 0 Then
//		MessageBox('확 인','작업조건 상세내역을 확인할 수 없습니다.!!')
//		dw_insert.SetRedraw(True)
//		Return
//	End If
//
//	sPlctbl = Trim(ds_jobconh.GetItemString(1, 'plctbl'))
//	If IsNull(sPlctbl) Or sPlctbl = '' then
//		cb_plc.Visible = False
//	Else
//		cb_plc.Visible = True
//	End If
//	dw_cond.SetItem(1, 'plctbl', splctbl)
//	
	wf_create_report('1')
	
	ib_ret = True
Else
//	// 기존에 조회된 경우에는 등록일자만 수정한다.
//	sSetSql = sOrginalSql + " WHERE A.SIDATE = " + sSidat
//	dw_insert.SetSQLSelect(sSetSql)
	dw_list.Retrieve()
End If


//// 정렬
//dw_insert.setsort("A.SDATE, A.STIME A, A.LOTSNO A")
//dw_insert.sort()
//dw_insert.SetRedraw(True)

Return 1
end function

public function integer wf_create_report (string arg_code);string error_syntaxfromSQL, error_create, serr, sCol, sColText, sText, sIsnum
Int    i, j, itab = 0, li_x = 0, li_unit_per_char = 30 , ix, dlen
Long   lx, ly, lw, lh, lxpos, lDigit, l_dx, l_dw, li_w, lnam
string new_sql, new_syntax, sFormat, smsg, presentation_str
integer li_FileNum

// 조회할 테이블내역에 대한 sql문장을 구한다
//new_sql = wf_get_sql()
//presentation_str = "Style(Type=tabular)" 
//new_syntax = SQLCA.SyntaxFromSQL(new_sql, presentation_str, error_syntaxfromSQL)
//new_syntax = f_replace(new_syntax, 'imhist_', '')
//new_syntax = f_replace(new_syntax, 'itemas_', '')
//new_syntax = f_replace(new_syntax, 'iomatrix_', '')

// Syntax를 직접생성함
new_syntax = wf_get_syntax()

//messagebox('', new_syntax)

// Group #1 생성
//new_syntax += " group(level=1 header.height=0 trailer.height=76 by=('c5') header.color='536870912' trailer.color='536870912' )"

IF Len(error_syntaxfromSQL) > 0 THEN
   MessageBox('error',error_syntaxfromSQL)
ELSE
  // Generate new DataWindow
  dw_list.Create(new_syntax, error_create)
  IF Len(error_create) > 0 THEN
		MessageBox('error1',error_create)
  END IF
END IF

// text 저장<==테스트용으로 사용함
li_FileNum = FileOpen("C:\dw.txt",StreamMode!, Write!, Shared!, Replace!)
FileWrite(li_FileNum, new_syntax)
FileClose(li_FileNum)

// DataWindow backgroud
//dw_list.Modify("DataWindow.Color='32106727'")

// Header 높이 조정
dw_list.Modify("DataWindow.Header.Height='400'")
dw_list.Modify("DataWindow.Summary.Height='156'")

For ix = 1 To dw_ip.RowCount()
	If dw_ip.GetItemString(ix, 'chk') = 'Y'  Then 
		itab = 0	// tab order
		
		// 컬럼명
		sCol = 'c'+string(ix)
		sColText = dw_ip.GetItemString(ix, 'dw_cnam')
		sFormat  = dw_ip.GetItemString(ix, 'dw_format')
		dLen     = dw_ip.GetItemNumber(ix, 'dw_len')
		
		// 컬럼속성 변경(컬럼명, TabOrder, 길이, 포맷
		wf_set_report_column(sCol, itab, dlen, sFormat)
		
		li_x = Long(dw_list.Describe(sCol + ".x")) 
		li_w = Long(dw_list.Describe(sCol + ".width"))

		//헤더(text) 변경
		wf_set_report_text(sCol, sColText, string(li_x), '320', '192', string(li_w))
		
		// 집게항목인 경우 총합을 표시
		If dw_ip.GetItemString(ix, 'grp') = 'Y'  Then 
			smsg = dw_list.Modify("create compute(band=summary alignment='1' expression='sum(" +scol + ")' border='0' color='33554432' " + &
										 "x='" + string(li_x) + "' y='8' height='68' width='" + string(li_w) + "' name=" + 'compute_'+scol + " visible='1' " + &
										 " font.face='굴림체' font.height='-9' font.weight='400'  font.family='1' font.pitch='1' " + &
										 " font.charset='129' background.mode='1' background.color='536870912'" + &
										 " format='"+sformat+"' " + &
										 " )")
			//messagebox(scol, smsg)
		End If
	End If
Next

// 타이틀 라인
dw_list.Modify("create line(band=header x1='0' y1='304' x2='" + string(li_x + li_w - 7) + "' y2='304'  name=l_1 visible='1' pen.style='0' pen.width='9' pen.color='0'  background.mode='2' background.color='16777215' )")
dw_list.Modify("create line(band=header x1='0' y1='392' x2='" + string(li_x + li_w - 7) + "' y2='392'  name=l_2 visible='1' pen.style='0' pen.width='9' pen.color='0'  background.mode='2' background.color='16777215' )")

// 총계에대한 라인
dw_list.Modify("create line(band=summary x1='0' y1='4' x2='" + string(li_x + li_w - 7) + "' y2='4'  name=l_1 visible='1' pen.style='0' pen.width='9' pen.color='0'  background.mode='2' background.color='16777215' )")
dw_list.Modify("create line(band=summary x1='0' y1='132' x2='" + string(li_x + li_w - 7) + "' y2='132'  name=l_2 visible='1' pen.style='0' pen.width='9' pen.color='0'  background.mode='2' background.color='16777215' )")

//messagebox('', smsg)
//messagebox(dw_list.GetItemstring(2, 'c2'), dw_list.Describe("c2.x"))

////DISPLAY 안함(UPDATE Key정보)
//dw_list.Modify("dummy.visible='0'")
//dw_list.Modify("dummy_t.visible='0'")

// 출력속성 변경 //<0 - default, 1 - Landscape, 2 - Portrait>
dw_list.Object.DataWindow.Print.Orientation= dw_opt.GetItemString(1, 'orgin')

// 용지 사이즈
dw_list.Object.DataWindow.Print.Paper.Size='9'	  //a4

//blob(string(dw_list.object))
//Messagebox('', dw_list.describe('datawindow.syntax'))

// text 저장<==테스트용으로 사용함
//li_FileNum = FileOpen("C:\dw.txt",StreamMode!, Write!, Shared!, Replace!)
//FileWrite(li_FileNum, dw_list.describe('datawindow.syntax'))
//FileClose(li_FileNum)

//////////////////////////////
dw_list.SetTransObject(SQLCA)

dw_list.Retrieve()
dw_print.ShareData(dw_list)

Return 0
end function

public function string wf_get_sql ();String sGetSql, sJobcode, sItemCod, sSidate, sGrpCol, sAllSql
Long   ix, igrpcnt

sAllSql = "SELECT "
sGetSql = "SELECT "

// 선택컬럼 지정
//sGetSql += " 0 AS DUMMY "
For ix = 1 To dw_ip.RowCount()
	If dw_ip.GetItemString(ix, 'chk') = 'Y' Then 
		If dw_ip.GetItemString(ix, 'grp') = 'Y' Then
			sGetSql += ('SUM(' + dw_ip.GetItemString(ix, 'dw_cols') +') AS C' +string(ix) +', ')
			sAllSql += ( 'C' +string(ix) + ', ')
			
			igrpcnt++
		Else
			sGetSql += ( dw_ip.GetItemString(ix, 'dw_cols') +' AS C' +string(ix) + ', ' )
			sAllSql += ( 'C' +string(ix) + ', ')
			
			sGrpCol += ( dw_ip.GetItemString(ix, 'dw_cols') + ' ,')
		End If
	End If
Next

// Key Column 및 조회조건을 등록일자로 설정
sAllSql = Left(sAllSql, Len(sAllSql)-2)
sGetSql = Left(sGetSql, Len(sGetSql)-2)

// 기본 조건절
sGetSql += " FROM IMHIST A, IOMATRIX B, ITEMAS I "
sGetSql += " WHERE A.SABU = '" + gs_sabu +"'"
sGetSql += "   AND A.IOGBN = B.IOGBN AND B.SALEGU = 'Y'"
sGetSql += "   AND A.ITNBR = I.ITNBR "

// 그룹함수가 있는경우
If igrpcnt > 0 And sGrpCol > '' Then
	sGetSql =  sGetSql + ' GROUP BY ' + Left(sGrpCol, Len(sGrpCol)-1)
End If

// 조건절을 제외한 sql문장을 별도저장 .. 나중에 일자만 변경될 경우를 위해서 저장한다.
//sOrginalSql = sGetSql

sAllSql = sAllSql + ' FROM ( ' +sGetSql + ' )'

//MessageBox('',sAllSql)

//sgetsql = "SELECT EMPNO, EMPNAME FROM P1_MASTER "
mle_1.text = sAllSql

Return sAllSql
end function

public function integer wf_set_report_column (string ar_col, integer ar_tab, integer ar_width, string ar_format);//Integer	li_unit_per_char = 210	// unit : 1/ 1000 Cm
Integer	li_unit_per_char = 30   
Integer  iLen
String   sColtype, sLen

//dw_list.Modify(ar_col + ".update='no'") 								// 컬럼의 UPDATE
//dw_list.Modify(ar_col + ".background.color='16777215'") 			// 컬럼의 back color
//dw_list.Modify(ar_col + ".color='33554432'") 							// 컬럼의 color
//dw_list.Modify(ar_col + ".background.mode='0'") 						// 컬럼의 back MODE
//dw_list.Modify(ar_col + ".TabSequence='" +string(ar_tab) + "'") // tab Order

dw_list.Modify(ar_col + ".x=" + String(li_last_x))

dw_list.Modify(ar_col + '.font.face="굴림체"')
dw_list.Modify(ar_col + '.font.height="-9"')
dw_list.Modify(ar_col + '.font.weight="400"')
dw_list.Modify(ar_col + '.font.family="1"')
dw_list.Modify(ar_col + '.font.pitch="1"')
dw_list.Modify(ar_col + '.font.charset="129"')
dw_list.Modify(ar_col + '.border="0"')

If ar_format > '' Then
	dw_list.Modify(ar_col + ".Format='" + ar_format + "'")
End If

if ar_width > 0 then
   dw_list.Modify(ar_col + ".Width =" + String(li_unit_per_char * (ar_width)))
	dw_list.Modify(ar_col + ".Height =" + String(72))
end if

li_last_x = (li_last_x + (li_unit_per_char * ar_width)) + 7 //컬럼사이 공백 = 7으로설정

Return 0


end function

public function integer wf_set_report_text (string ar_col, string ar_text, string ar_x, string ar_y, string ar_h, string ar_w);String sMsg

sMsg = dw_list.Modify(ar_col + "_t.text='" + ar_text + "'")	 		// Column Text 조정
//sMsg = dw_list.Modify(ar_col + "_t.background.color='28144969'")	// Column Text 조정
//sMsg = dw_list.Modify(ar_col + "_t.background.mode='2'")
//sMsg = dw_list.Modify(ar_col + "_t.color='16777215'")

sMsg = dw_list.Modify(ar_col + '_t.font.face="굴림체"')
sMsg = dw_list.Modify(ar_col + '_t.font.height="-9"')
sMsg = dw_list.Modify(ar_col + '_t.font.weight="400"')
sMsg = dw_list.Modify(ar_col + '_t.font.family="1"')
sMsg = dw_list.Modify(ar_col + '_t.font.pitch="1"')
sMsg = dw_list.Modify(ar_col + '_t.font.charset="129"')


dw_list.Modify(ar_col + "_t.x='" + ar_x + "'")  		// Column x좌표에 따라 Text 위치 조정
dw_list.Modify(ar_col + "_t.width='" +ar_w + "'")   // Column width에 따라 Text 위치 조정

If ar_y > '0' Then 	
	dw_list.Modify(ar_col + "_t.y='" + ar_y + "'")  		// Column Text 위치 조정
End If

If ar_h > '0' Then 
	dw_list.Modify(ar_col + "_t.height='" +ar_h + "'")
End If

return 0


end function

public function string wf_get_syntax ();String sGetSql, sJobcode, sItemCod, sSidate, sGrpCol, sAllSql, sCol
Long   ix, igrpcnt

sAllSql = "SELECT "
sGetSql = "SELECT "

// 선택컬럼 지정
//sGetSql += " 0 AS DUMMY "
For ix = 1 To dw_ip.RowCount()
	If dw_ip.GetItemString(ix, 'chk') = 'Y' Then 
		If dw_ip.GetItemString(ix, 'grp') = 'Y' Then
			sGetSql += ('SUM(' + dw_ip.GetItemString(ix, 'dw_cols') +') AS C' +string(ix) +', ')
			sAllSql += ( 'C' +string(ix) + ', ')
			
			igrpcnt++
		Else
			sGetSql += ( dw_ip.GetItemString(ix, 'dw_cols') +' AS C' +string(ix) + ', ' )
			sAllSql += ( 'C' +string(ix) + ', ')
			
			sGrpCol += ( dw_ip.GetItemString(ix, 'dw_cols') + ' ,')
		End If
	End If
Next

// Key Column 및 조회조건을 등록일자로 설정
sAllSql = Left(sAllSql, Len(sAllSql)-2)
sGetSql = Left(sGetSql, Len(sGetSql)-2)

// 기본 조건절
sGetSql += " FROM IMHIST A, IOMATRIX B, ITEMAS I "
sGetSql += " WHERE A.SABU = '" + gs_sabu +"'"
sGetSql += "   AND A.IOGBN = B.IOGBN AND B.SALEGU = 'Y'"
sGetSql += "   AND A.ITNBR = I.ITNBR "

// 그룹함수가 있는경우
If igrpcnt > 0 And sGrpCol > '' Then
	sGetSql =  sGetSql + ' GROUP BY ' + Left(sGrpCol, Len(sGrpCol)-1)
End If

// 조건절을 제외한 sql문장을 별도저장 .. 나중에 일자만 변경될 경우를 위해서 저장한다.
//sOrginalSql = sGetSql

sAllSql = sAllSql + ' FROM ( ' +sGetSql + ' )'

///////////////////////////////////////////////////////
// DataWindow Syntax 생성 /////////////////////////////
///////////////////////////////////////////////////////
String sdw_table_column, sdw_Column, sdw_Text, sSyntax, sdw_ctype, sAlig
Int    iid, iix=5

For ix = 1 To dw_ip.RowCount()
	If dw_ip.GetItemString(ix, 'chk') = 'Y' Then
		sCol = 'c' + string(ix)	// 컬럼명
		iid++							// 컬럼ID
		sdw_ctype = dw_ip.GetItemString(ix, 'dw_ctype')	// Type
		If left(sdw_ctype,4) = 'numb' then
			sAlig = '1'	// 숫자-RIGHT
		Else
			sAlig = '0'	// 문자- left
		End If
		
		sdw_table_column += ( "column=(type=" + sdw_ctype + " updatewhereclause = yes name=" + sCol + " dbname='" + sCol + "')" +"~r~n")
		sdw_Column		  += ( "column(band=detail id=" + string(iid) + " x='" +string(iix) + "' y='4' height='64' width='297' alignment='" +sAlig + "' font.face='MS Sans Serif' font.height='-8' font.weight='400' font.charset='0' font.pitch='2' font.family='2' font.underline='0' font.italic='0' font.strikethrough='0' border='0' color='0' background.mode='1' background.color='0'  edit.autoselect=yes edit.autohscroll=yes edit.autovscroll=no edit.focusrectangle=yes )" +'~r~n')
		sdw_Text			  += ( "text(band=header text='" +scol +       "' x='" +string(iix) + "' y='4' height='52' width='297' font.face='MS Sans Serif' font.height='-8' font.weight='400' font.charset='0' font.pitch='2' font.family='2' font.underline='0' font.italic='0' font.strikethrough='0' border='0' color='0' background.mode='1' background.color='0' alignment='2'  name="+ scol+"_t" + " )" +'~r~n')
		
		iix = iix + 300
	End If
Next

sSyntax = "release 8;" + "~r~n"
sSyntax = sSyntax + ( "datawindow(units=0 timer_interval=0 color=1073741824 processing=0 print.margin.bottom=96 print.margin.left=110 print.margin.right=110 print.margin.top=96 print.preview.buttons=no )" ) + "~r~n"
sSyntax = sSyntax + ( "table( ") + "~r~n"
sSyntax = sSyntax + ( sdw_table_column ) + "~r~n"
sSyntax = sSyntax + ( 'retrieve="' + sAllSql + '"' ) + "~r~n"
// ARgument 설정
//sSyntax = sSyntax + ( "arguments=(('arg_yymm', string))" ) + "~r~n"
sSyntax = sSyntax + ( " )" ) + "~r~n"

sSyntax = sSyntax + ("header(height=60)" ) + "~r~n"
sSyntax = sSyntax + ("detail(height=72)" ) + "~r~n"
sSyntax = sSyntax + ( sdw_Column ) + "~r~n"
sSyntax = sSyntax + ( sdw_Text ) + "~r~n"
sSyntax = sSyntax + ("htmltable(border='0' cellpadding='1' cellspacing='1' generatecss='no' nowrap='no')" )

///////////////////////////////////////////////////////

mle_1.text = sSyntax

Return sSyntax
end function

on w_sal_09000.create
int iCurrent
call super::create
this.mle_1=create mle_1
this.dw_opt=create dw_opt
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
this.Control[iCurrent+2]=this.dw_opt
this.Control[iCurrent+3]=this.gb_1
end on

on w_sal_09000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mle_1)
destroy(this.dw_opt)
destroy(this.gb_1)
end on

event ue_open;call super::ue_open;dw_ip.SetTransObject(SQLCA)
dw_ip.Retrieve()

dw_opt.InsertRow(0)
end event

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

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

//dw_ip.SetTransObject(SQLCA)
//dw_ip.Reset()
//dw_ip.InsertRow(0)
//
//dw_list.settransobject(sqlca)
//dw_print.settransobject(sqlca)
//
//IF is_upmu = 'A' THEN //회계인 경우
//   int iRtnVal 
//
//	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
//		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
//			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
//			
//			dw_ip.Modify("saupj.protect = 1")
//		ELSE
//			dw_ip.Modify("saupj.protect = 0")
//		END IF
//	ELSE
//		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
//			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
//		ELSE
//			iRtnVal = F_Authority_Chk(Gs_Dept)
//		END IF
//		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
//			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
//			
//			dw_ip.Modify("saupj.protect = 1")
//		ELSE
//			dw_ip.Modify("saupj.protect = 0")
//		END IF	
//	END IF
//END IF
//dw_print.object.datawindow.print.preview = "yes"	
//
//dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_09000
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	
end event

type p_exit from w_standard_print`p_exit within w_sal_09000
end type

type p_print from w_standard_print`p_print within w_sal_09000
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_09000
end type







type st_10 from w_standard_print`st_10 within w_sal_09000
end type



type dw_print from w_standard_print`dw_print within w_sal_09000
end type

type dw_ip from w_standard_print`dw_ip within w_sal_09000
integer x = 46
integer y = 280
integer width = 1024
integer height = 1332
string dataobject = "d_sal_09000_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_ip::itemchanged;call super::itemchanged;ib_ret = False
end event

type dw_list from w_standard_print`dw_list within w_sal_09000
integer x = 1083
integer y = 280
integer width = 3543
integer height = 1972
borderstyle borderstyle = stylelowered!
end type

type mle_1 from multilineedit within w_sal_09000
integer x = 46
integer y = 56
integer width = 3813
integer height = 156
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
boolean border = false
boolean autohscroll = true
boolean autovscroll = true
end type

type dw_opt from u_key_enter within w_sal_09000
integer x = 73
integer y = 1700
integer width = 955
integer height = 528
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_09000_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;String sData

Choose Case GetColumnName()
	Case 'orgin'
		sData = GetText()
		
		dw_list.Object.DataWindow.Print.Orientation=sData
End Choose
end event

type gb_1 from groupbox within w_sal_09000
integer x = 50
integer y = 1640
integer width = 1010
integer height = 604
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "양식"
end type

