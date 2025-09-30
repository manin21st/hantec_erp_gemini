$PBExportHeader$w_adt_02010.srw
$PBExportComments$작업조건 생성
forward
global type w_adt_02010 from w_inherite
end type
type dw_head from u_key_enter within w_adt_02010
end type
type dw_cond from u_key_enter within w_adt_02010
end type
type dw_rtn from u_key_enter within w_adt_02010
end type
type rr_2 from roundrectangle within w_adt_02010
end type
end forward

global type w_adt_02010 from w_inherite
string title = "작업조건 생성"
dw_head dw_head
dw_cond dw_cond
dw_rtn dw_rtn
rr_2 rr_2
end type
global w_adt_02010 w_adt_02010

type variables
boolean i_chk
end variables

forward prototypes
public function integer wf_mod_table (string arg_code, string arg_gub)
public function integer wf_job_table (string ar_jobcode, string ar_gubun, string ar_sql)
end prototypes

public function integer wf_mod_table (string arg_code, string arg_gub);String sSyntax, sCol, sVar
Long   ix, il_cnt
Int    idigit, idigit2, irtn

Choose Case arg_gub
	Case 'C'	// Table Create
		sSyntax  = "CREATE TABLE " + arg_code + " ( "
		sSyntax += "SILJPNO	VARCHAR2(15) NOT NULL ,"
		sSyntax += "SIDATE	VARCHAR2(8)  NOT NULL ,"
		sSyntax += "WKCTR		VARCHAR2(6)  NULL ,"
		sSyntax += "SDATE		VARCHAR2(8)  NULL ,"
      sSyntax += "STIME		VARCHAR2(4)  NULL ,"
      sSyntax += "EDATE		VARCHAR2(8)  NULL ,"
      sSyntax += "ETIME		VARCHAR2(4)  NULL ,"
      sSyntax += "LOTSNO	VARCHAR2(20) NULL ,"
      sSyntax += "ITNBR		VARCHAR2(20) NULL ,"
//		sSyntax += "ITDSC		VARCHAR2(40) NULL ,"
      sSyntax += "EMPNO		VARCHAR2(10)  NULL ,"
//		sSyntax += "EMPNM		VARCHAR2(10)  NULL ,"

//		If dw_head.GetItemString(1, 'sdate')  = 'Y' Then	sSyntax += "SDATE		VARCHAR2(8) NULL ,"
//		If dw_head.GetItemString(1, 'stime')  = 'Y' Then	sSyntax += "STIME		VARCHAR2(6) NULL ,"
//		If dw_head.GetItemString(1, 'edate')  = 'Y' Then	sSyntax += "EDATE		VARCHAR2(8) NULL ,"
//		If dw_head.GetItemString(1, 'etime')  = 'Y' Then	sSyntax += "ETIME		VARCHAR2(6) NULL ,"
//		If dw_head.GetItemString(1, 'lotsno') = 'Y' Then	sSyntax += "LOTSNO	VARCHAR2(20) NULL ,"
//		If dw_head.GetItemString(1, 'itnbr')  = 'Y' Then	sSyntax += "ITNBR		VARCHAR2(20) NULL ,"
//		If dw_head.GetItemString(1, 'empno')  = 'Y' Then	sSyntax += "EMPNO		VARCHAR2(6)  NULL ,"
		
		// 컬럼정보 생성
		For ix = 1 To dw_insert.RowCount()
			dw_insert.SetItem(ix, 'isnum',dw_insert.GetItemString(ix, 'chk_1'))
			dw_insert.SetItem(ix, 'digit',dw_insert.GetItemNumber(ix, 'chk_2'))
			dw_insert.SetItem(ix, 'digit2',dw_insert.GetItemNumber(ix, 'chk_3'))
			
			sCol		= Upper(dw_insert.GetItemString(ix, 'itemcod'))
			sVar		= dw_insert.GetItemString(ix, 'isnum')
			idigit	= dw_insert.GetItemNumber(ix, 'digit')
			idigit2	= dw_insert.GetItemNumber(ix, 'digit2')
			If sVar = 'V' Then
				sSyntax += sCol + "		VARCHAR2(" +string(idigit) + ")  NULL ,"
			Else
				sSyntax += sCol + "		NUMBER(" +string(idigit) + "," + string(idigit2) + ") DEFAULT 0 ,"
			End If
		Next
		
		sSyntax = Left(sSyntax,len(sSyntax)-1)
		sSyntax += ' )'
		
		If wf_job_table(arg_code, 'C', sSyntax) <> 0 Then REturn -1
		
		// Primary Key 생성
		sSyntax = "ALTER TABLE " + arg_code + " ADD ( PRIMARY KEY (SILJPNO, SIDATE))"
		If wf_job_table(arg_code, 'C', sSyntax) <> 0 Then REturn -1
		
	Case 'D'	// Table Drop				
		sSyntax  = "DROP TABLE " + arg_code 
		
		//테이블 DROP
		If wf_job_table(arg_code, 'D', sSyntax) <> 0 Then REturn -1		
		
	Case 'M' // Table Modify
		sSyntax  = "ALTER TABLE " + arg_code + " ADD ( "		
			
		// 컬럼정보 생성
		For ix = 1 To dw_insert.RowCount()
			If dw_insert.GetItemString(ix, 'gubun') = 'M' Then
				sCol		= Upper(dw_insert.GetItemString(ix, 'itemcod'))
			   sVar		= dw_insert.GetItemString(ix, 'isnum')
			   idigit	= dw_insert.GetItemNumber(ix, 'digit')
			   idigit2	= dw_insert.GetItemNumber(ix, 'digit2')
			   If sVar = 'V' Then
				   sSyntax += sCol + "		VARCHAR2(" +string(idigit) + ")  NULL ,"
			   Else
				   sSyntax += sCol + "		NUMBER(" +string(idigit) + "," + string(idigit2) + ")  DEFAULT 0 ,"
			   End If
			End IF	
		Next
		
		sSyntax = Left(sSyntax,len(sSyntax)-1)
		sSyntax += ' )'
		If wf_job_table(arg_code, 'M', sSyntax) <> 0 Then REturn -1	
	Case 'T' //	Table Modify(컬럼 자리수변경(증가만가능))
		sSyntax  = "ALTER TABLE " + arg_code + " MODIFY  ( "				
		// 컬럼정보 생성
		For ix = 1 To dw_insert.RowCount()
			If dw_insert.GetItemString(ix, 'gubun') = 'T' Then
				sCol		= Upper(dw_insert.GetItemString(ix, 'itemcod'))
			   sVar		= dw_insert.GetItemString(ix, 'isnum')
			   idigit	= dw_insert.GetItemNumber(ix, 'digit')
			   idigit2	= dw_insert.GetItemNumber(ix, 'digit2')
			   If sVar = 'V' Then
				   sSyntax += sCol + "		VARCHAR2(" +string(idigit) + ")  NULL ,"
			   Else
				   sSyntax += sCol + "		NUMBER(" +string(idigit) + "," + string(idigit2) + ")  DEFAULT 0 ,"
			   End If
			End IF	
		Next
		
		sSyntax = Left(sSyntax,len(sSyntax)-1)
		sSyntax += ' )'
		If wf_job_table(arg_code, 'T', sSyntax) <> 0 Then REturn -1	
End Choose
   
Return 0
end function

public function integer wf_job_table (string ar_jobcode, string ar_gubun, string ar_sql);Int irtn
// DECLARE proc1 PROCEDURE FOR FUN_JOB_TABLE  
//         ARG_JOBCODE = ar_jobcode,   
//         ARG_GUBUN = :ar_gubun,   
//         ARG_SQL = :ar_sql  ;

//DECLARE proc1 procedure FOR fun_job_table (:ar_jobcode, :ar_gubun, :ar_sql) USING SQLCA;
//EXECUTE proc1;
//FETCH proc1 INTO :irtn;
//CLOSE proc1;
irtn = SQLCA.fun_job_table (ar_jobcode, ar_gubun, ar_sql)
/* --------------------------------------  */
/* return   >=0  : 조회건수나 정상적일 경우*/
/* return   -1  : table이 존재하지 않을때  */
/* return   -2  : table 생성 실패          */
/* return   -3  : table DROP 실패          */
/* return   -4  : table MODIFY(ADD) 실패   */
/* return   -999: 오류인 경우              */
/* --------------------------------------  */
Choose Case irtn
	Case is >= 0 
		MessageBox('확 인','정상적으로 작업종료되었습니다.!!')
	Case -1
		MessageBox('확 인','테이블이 존재하지 않습니다.!!')
		Messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		return -1
	Case -2
		MessageBox('확 인','테이블 생성 실패하였습니다.!!')
		Messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		return -1
	Case -3
		MessageBox('확 인','테이블 DROP 실패하였습니다.!!')
		Messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		return -1
	Case -4
		MessageBox('확 인','테이블 MODIFY 실패하였습니다.!!')
		Messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		return -1	
	Case Else
		Messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		return -1
End Choose

return 0
end function

on w_adt_02010.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.dw_cond=create dw_cond
this.dw_rtn=create dw_rtn
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.dw_cond
this.Control[iCurrent+3]=this.dw_rtn
this.Control[iCurrent+4]=this.rr_2
end on

on w_adt_02010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.dw_cond)
destroy(this.dw_rtn)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_head.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_rtn.SetTransObject(sqlca)

dw_cond.reset()
dw_head.reset()
dw_insert.reset()

dw_cond.InsertRow(0)
dw_head.InsertRow(0)
dw_rtn.Retrieve('')

i_chk = false   //Create 상태(기존자료 없슴)

end event

type dw_insert from w_inherite`dw_insert within w_adt_02010
integer x = 69
integer y = 544
integer width = 3666
integer height = 1740
string dataobject = "d_adt_02010_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;string sjobcode
long   i, ll_row
dec    ld_new, ld_old

This.Accepttext() 
dw_head.Accepttext()

ll_row = This.GetRow()

IF this.GetColumnName() = 'chk_1'	THEN
	If ( i_chk = True ) and ( This.GetItemString(ll_row,'gubun') = 'R' ) Then
	   This.SetItem(ll_row, 'chk_1', This.GetItemString(ll_row,'isnum'))
		MessageBox('알림','문자항목 수정 불가능합니다.')
		This.SetColumn('chk_1')
		This.Setfocus()
		ib_any_typing = false
	   Return 1
	Else
		This.SetItem(ll_row, 'isnum', This.GetItemString(ll_row,'chk_1'))
   End If	
ElseIF this.GetColumnName() = 'chk_2'	THEN
	ld_new = This.GetItemNumber(ll_row,'chk_2')
	ld_old = This.GetItemNumber(ll_row,'chk_old_2')
	If ( i_chk = True ) and ( This.GetItemString(ll_row,'gubun') = 'R' ) Then
//		if ld_new < ld_old then
//			This.SetItem(ll_row, 'chk_2' ,This.GetItemNumber(ll_row,'digit'))
//			MessageBox('알림','자리수항목 수정 불가능합니다.')
//			This.SetColumn('chk_2')
//			This.Setfocus()
//			ib_any_typing = false
//			Return 1
//		else
			This.SetItem(ll_row,'gubun','T')
//		end if	
	Else
		This.SetItem(ll_row, 'digit',This.GetItemNumber(ll_row,'chk_2'))
   End If
ElseIF this.GetColumnName() = 'chk_3'	THEN
	ld_new = This.GetItemNumber(ll_row,'chk_3')
	ld_old = This.GetItemNumber(ll_row,'chk_old_3')
	If ( i_chk = True ) and ( This.GetItemString(ll_row,'gubun') = 'R' ) Then
//		if ld_new < ld_old then
//			This.SetItem(ll_row, 'chk_3', This.GetItemNumber(ll_row,'digit2'))
//			MessageBox('알림','소수자리수항목 수정 불가능합니다.')
//			This.SetColumn('chk_3')
//			This.Setfocus()
//			ib_any_typing = false
//			Return 1
//		else
			This.SetItem(ll_row,'gubun','T')
//		end if	
   Else
		This.SetItem(ll_row, 'digit2', This.GetItemNumber(ll_row,'chk_3'))
   End If	
END IF

//Create / Modify 구분
sjobcode = Trim(dw_head.GetItemString(1, 'jobcode'))
If Isnull(sjobcode) Or sjobcode = '' Then
	i_chk = false
Else
	i_chk = true
End If

ib_any_typing = true


end event

event dw_insert::clicked;call super::clicked;//if row <=0 then return
//
//this.SelectRow(0,False)
//this.SelectRow(row,True)
//

end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;//if currentrow <=0 then return
//
//this.SelectRow(0,False)
//this.SelectRow(currentrow,True)
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_adt_02010
end type

event p_delrow::clicked;call super::clicked;String sjobcode, swkctr, sgubun
Long   nRow, ll_cnt, ll_row

If dw_head.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sjobcode = Trim(dw_head.GetItemString(1, 'jobcode'))
ll_row   = dw_insert.GetRow()

sgubun   = dw_insert.GetItemString(ll_row,'gubun')

if sgubun = 'R' then //기존 자료
   if i_chk = true then
	   MessageBox('알림','[행삭제 불가] 기존 테이블 컬럼은 삭제할 수 없습니다. ~n 사용유무 값을 설정하세요')
	   return
   end if	
	
	//존재 유무 체크
	ll_cnt = 0
	select count(*) into :ll_cnt
	  from tab
	 where tname = :sjobcode;
	if ll_cnt = 0 then
		MessageBox('알림','[행삭제 불가] 기존 테이블 컬럼은 삭제할 수 없습니다. ~n 사용유무 값을 설정하세요')
		Return 
	end if	
end if	

swkctr = Trim(dw_head.GetItemString(1, 'wkctr'))
if isnull(swkctr) or swkctr = "" then
	f_message_chk(1400,'[작업장코드]')
	dw_head.SetColumn('wkctr')
	dw_head.SetFocus()
	return 		
end if

nRow = dw_insert.DeleteRow(ll_row)
end event

type p_addrow from w_inherite`p_addrow within w_adt_02010
end type

event p_addrow::clicked;call super::clicked;String sjobcode, swkctr
Long   nRow, ll_row

If dw_head.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

swkctr = Trim(dw_head.GetItemString(1, 'wkctr'))
if isnull(swkctr) or swkctr = "" then
	f_message_chk(1400,'[작업장코드]')
	dw_head.SetColumn('wkctr')
	dw_head.SetFocus()
	return 		
end if

ll_row = dw_insert.rowcount()

//Create / Modify 구분
sjobcode = Trim(dw_head.GetItemString(1, 'jobcode'))
If Isnull(sjobcode) Or sjobcode = '' Then
	nRow = dw_insert.InsertRow(ll_row+1)
   dw_insert.SetItem(nRow,'gubun','C') //추가 컬럼 표시
Else
	nRow = dw_insert.InsertRow(ll_row+1)
   dw_insert.SetItem(nRow,'gubun','M') //추가 컬럼 표시
End If


end event

type p_search from w_inherite`p_search within w_adt_02010
boolean visible = false
integer x = 3095
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;call super::clicked;String sjobcode
Long   ll_cnt

sjobcode = dw_head.GetItemString(1, 'jobcode')

// 테이블 생성
If wf_mod_table(sjobcode, 'C') <> 0 Then
	Return
End If
end event

type p_ins from w_inherite`p_ins within w_adt_02010
boolean visible = false
integer x = 3543
integer y = 312
end type

type p_exit from w_inherite`p_exit within w_adt_02010
end type

type p_can from w_inherite`p_can within w_adt_02010
end type

event p_can::clicked;call super::clicked;dw_cond.Reset()
dw_cond.InsertRow(0)

dw_head.Reset()
dw_head.InsertRow(0)

dw_insert.Reset()
i_chk = false
end event

type p_print from w_inherite`p_print within w_adt_02010
boolean visible = false
integer x = 3365
integer y = 316
end type

type p_inq from w_inherite`p_inq within w_adt_02010
integer x = 3401
end type

event p_inq::clicked;call super::clicked;String sJobcode

dw_cond.accepttext() 

sJobcode = dw_cond.GetItemString(1, 'jobcode')

If dw_head.Retrieve(sJobcode) <= 0 Then
	p_can.triggerevent('clicked')
	dw_cond.SetItem(1,'jobcode','')
	dw_cond.SetColumn('jobcode')
	dw_cond.setfocus()
	f_message_chk(50,'')
	Return
Else	
   i_chk = true    //기존 자료 존재(Modify)	
End IF

If dw_insert.Retrieve(sJobcode) <= 0 Then
	p_can.triggerevent('clicked')
	dw_cond.SetItem(1,'jobcode','')
	dw_cond.SetColumn('jobcode')
	dw_cond.setfocus()
	f_message_chk(50,'')
	Return
Else
	i_chk = true    //기존 자료 존재(Modify)
End If

dw_rtn.Retrieve(sjobcode)

end event

type p_del from w_inherite`p_del within w_adt_02010
end type

event p_del::clicked;call super::clicked;String sjobcode, sItem, sWkctr
Long   lrtn, ll_cnt

If dw_head.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sjobcode = Trim(dw_head.GetItemString(1, 'jobcode'))

if isnull(sjobcode) or sjobcode = "" then
	f_message_chk(1400,'[작업조건]')
	dw_head.SetColumn('jobcode')
	dw_head.SetFocus()
	return
end if

if MessageBox('확인', sjobcode + ' 테이블 전체를 삭제하시겠습니까?', &
														question!, YesNo!, 2) = 2 then
	return 2
end if	

//DROP 테이블 존재 유무 체크
ll_cnt = 0
select count(*) into :ll_cnt
  from tab
 where tname = :sjobcode;
if ll_cnt = 0 then
	MessageBox('알림','삭제할(DROP) 테이블이 존재하지 않습니다')
	Return 
end if	

//DROP 테이블 자료 존재 유무 체크
lrtn = SQLCA.fun_job_table (sjobcode, 'S', '')

if lrtn > 0 then
	MessageBox('알림','삭제할(DROP) 테이블에 자료가 존재하여 삭제 할 수 없습니다 ~n  테이블 자료 삭제 후 작업 가능 합니다')
	Return 
end if

//데티터 삭제
Delete From jobcond Where jobcode = :sjobcode;
Delete From jobconh Where jobcode = :sjobcode;

// 테이블 DROP
If i_chk = true Then
   If wf_mod_table(sjobcode, 'D') <> 0 Then
	   Return
	Else
		commit;
	End If	
End If
ib_any_typing = false
p_inq.triggerevent('Clicked')


end event

type p_mod from w_inherite`p_mod within w_adt_02010
end type

event p_mod::clicked;call super::clicked;String sjobcode, sItem, sWkctr
Long   nRow, ix, jx, hx, hy, ll_chk, ll_chk1
Int    imax

If dw_head.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sWkctr = Trim(dw_head.GetItemString(1, 'wkctr'))
if isnull(sWkctr) or sWkctr = "" then
	f_message_chk(1400,'[작업장코드]')
	dw_head.SetColumn('wkctr')
	dw_head.SetFocus()
	return 		
end if

nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	sItem = Trim(dw_insert.GetItemString(ix, 'item'))
	If Isnull(sItem) Or sItem = '' Then
		dw_insert.DeleteRow(ix)
		continue
	End If

	If dw_insert.GetItemNumber(ix,'digit') <= 0 Then
		dw_insert.DeleteRow(ix)
		continue
	End If
Next

sjobcode = Trim(dw_head.GetItemString(1, 'jobcode'))
If Isnull(sjobcode) Or sjobcode = '' Then
	iMax = sqlca.fun_junpyo(gs_sabu, 'JOB', 'Y2')
	Commit;
	IF iMax <= 0 THEN
		ROLLBACK;
		f_message_chk(51,'')
		Return
	END IF
	
	sjobcode = 'JOB' + String(iMax,'0000')
	dw_cond.SetItem(1, 'jobcode', sjobcode)	
	dw_head.SetItem(1, 'jobcode', sjobcode)	
End If

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix, 'isnum' ,dw_insert.GetItemString(ix, 'chk_1'))
	dw_insert.SetItem(ix, 'digit' ,dw_insert.GetItemNumber(ix, 'chk_2'))
	dw_insert.SetItem(ix, 'digit2',dw_insert.GetItemNumber(ix, 'chk_3'))
			
	dw_insert.SetItem(ix, 'jobcode', sjobcode)
	dw_insert.SetItem(ix, 'seq', string(ix,'000'))
	dw_insert.SetItem(ix, 'itemcod', 'item'+ string(ix,'000'))
Next

/* 공정저장 */
String sRoslt

DELETE FROM JOBCONR WHERE JOBCODE =:sjobcode;
COMMIT;
For ix = 1 To dw_rtn.RowCount()
	If dw_rtn.GetItemString(ix, 'chk') ='N' Then continue
	
	sRoslt = dw_rtn.GetItemString(ix, 'reffpf_rfgub')
	INSERT INTO JOBCONR ( JOBCODE, ROSLT ) VALUES ( :sjobcode, :sRoslt);
Next
COMMIT;

If dw_head.Update() <> 1 Then
	MessageBox('HEAD',string(sqlca.sqlcode) + '/' + sqlca.sqlerrtext)
	RollBack;
	return
ElseIf dw_Insert.Update() <> 1 Then
	MessageBox('INSERT',string(sqlca.sqlcode) + '/' + sqlca.sqlerrtext)
	RollBack;
	return
Else	
	If i_chk = false Then  //기존자료 존재 안함(조회내역 없슴)
	   //테이블 생성
      If wf_mod_table(sjobcode, 'C') <> 0 Then
			rollback;
	      Return
      End If
   Else                  //기존자료 존재(조회내역존재)
		//자료추가
		For hx = 1 To dw_insert.RowCount()
			If dw_insert.GetItemString(hx, 'gubun') = 'M' Then
			   ll_chk ++
         End If
		Next
		If ll_chk > 0 Then
		   If wf_mod_table(sjobcode, 'M') <> 0 Then
				rollback;
	         Return
         End If  		   
		End IF
		
		//컬럼증가
		For hy = 1 To dw_insert.RowCount()
			If dw_insert.GetItemString(hy, 'gubun') = 'T' Then
			   ll_chk1 ++
         End If
		Next
		If ll_chk1 > 0 Then
		   If wf_mod_table(sjobcode, 'T') <> 0 Then
				rollback;
	         Return
         End If  		   
		End IF		
	End If	
	Commit;	
End If

ib_any_typing = false
p_inq.triggerevent('Clicked')
end event

type cb_exit from w_inherite`cb_exit within w_adt_02010
end type

type cb_mod from w_inherite`cb_mod within w_adt_02010
end type

type cb_ins from w_inherite`cb_ins within w_adt_02010
end type

type cb_del from w_inherite`cb_del within w_adt_02010
end type

type cb_inq from w_inherite`cb_inq within w_adt_02010
end type

type cb_print from w_inherite`cb_print within w_adt_02010
end type

type st_1 from w_inherite`st_1 within w_adt_02010
end type

type cb_can from w_inherite`cb_can within w_adt_02010
end type

type cb_search from w_inherite`cb_search within w_adt_02010
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_02010
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_02010
end type

type dw_head from u_key_enter within w_adt_02010
integer x = 105
integer y = 224
integer width = 3141
integer height = 280
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_adt_02010_2"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;///////////////////////////////////////////////////////////////////////////
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetColumnName() = "wkctr"	THEN
	
   gs_code = this.GetText()
	open(w_workplace_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "wkctr", 	 gs_Code)
	this.SetItem(1, "wcdsc", 	 gs_Codename)
	RETURN 1
End If
end event

event itemchanged;call super::itemchanged;String sNull, swkctr, get_nm, get_nm2
Dec {2} drate

w_mdi_frame.sle_msg.text = ''
SetNull(sNull)

IF	this.getcolumnname() = "wkctr"	THEN		// 작업장코드 확인
   swkctr = THIS.GetText()
	IF sWkctr = "" OR IsNull(sWkctr) THEN RETURN
	
  SELECT "WRKCTR"."WCDSC"  
    INTO :get_nm  
    FROM "WRKCTR"  
   WHERE "WRKCTR"."WKCTR" = :sWkctr   ;
	If SQLCA.SQLCODE = 0 Then
		SetItem(1, 'wcdsc', get_nm)
	Else
		Return 1
	End If
End If
end event

type dw_cond from u_key_enter within w_adt_02010
integer x = 110
integer y = 92
integer width = 983
integer height = 132
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_adt_02010_4"
boolean border = false
end type

event itemchanged;call super::itemchanged;String sJobCode

Choose case GetColumnName()
	Case 'jobcode'
		p_inq.PostEvent(Clicked!)
End Choose
end event

event rbuttondown;call super::rbuttondown;gs_code     = ''
gs_codename = ''
gs_gubun    = ''

Choose case GetColumnName()
	Case "jobcode"
		SetNull(gs_code)
		open(w_adt_jobconh)
		if isnull(gs_code) or gs_code = "" then return
	
		this.setitem(1, "jobcode", gs_code)		
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_rtn from u_key_enter within w_adt_02010
integer x = 3758
integer y = 524
integer width = 891
integer height = 1756
integer taborder = 120
boolean bringtotop = true
string dataobject = "d_adt_02010_5"
borderstyle borderstyle = stylelowered!
end type

type rr_2 from roundrectangle within w_adt_02010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 520
integer width = 3703
integer height = 1768
integer cornerheight = 40
integer cornerwidth = 55
end type

