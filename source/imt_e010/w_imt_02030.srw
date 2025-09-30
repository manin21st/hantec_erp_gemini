$PBExportHeader$w_imt_02030.srw
$PBExportComments$** 발주확정
forward
global type w_imt_02030 from w_inherite
end type
type dw_1 from datawindow within w_imt_02030
end type
type rb_y from radiobutton within w_imt_02030
end type
type rb_n from radiobutton within w_imt_02030
end type
type cbx_1 from checkbox within w_imt_02030
end type
type dw_print from datawindow within w_imt_02030
end type
type rb_o from radiobutton within w_imt_02030
end type
type st_2 from statictext within w_imt_02030
end type
type sle_bal from singlelineedit within w_imt_02030
end type
type rb_opt from radiobutton within w_imt_02030
end type
type rb_opt2 from radiobutton within w_imt_02030
end type
type dw_update from datawindow within w_imt_02030
end type
type cbx_2 from checkbox within w_imt_02030
end type
type rb_w from radiobutton within w_imt_02030
end type
type p_upgw from uo_picture within w_imt_02030
end type
type pb_1 from u_pb_cal within w_imt_02030
end type
type gb_1 from groupbox within w_imt_02030
end type
type rr_2 from roundrectangle within w_imt_02030
end type
type rr_3 from roundrectangle within w_imt_02030
end type
type rr_4 from roundrectangle within w_imt_02030
end type
end forward

global type w_imt_02030 from w_inherite
integer height = 3772
string title = "발주확정"
dw_1 dw_1
rb_y rb_y
rb_n rb_n
cbx_1 cbx_1
dw_print dw_print
rb_o rb_o
st_2 st_2
sle_bal sle_bal
rb_opt rb_opt
rb_opt2 rb_opt2
dw_update dw_update
cbx_2 cbx_2
rb_w rb_w
p_upgw p_upgw
pb_1 pb_1
gb_1 gb_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_imt_02030 w_imt_02030

type variables
String  ls_gub = 'N',  is_cvcod //자사거래처
String  ls_auto                         //자동채번여부
String  isCnvgu  //발주단위 사용여부
string   is_pspec, is_jijil
String  is_gwgbn

Transaction SQLCA1				// 그룹웨어 접속용
String     isHtmlNo = '00022'	// 그룹웨어 문서번호(발주검토)
end variables

forward prototypes
public subroutine wf_update ()
public subroutine wf_print ()
public function integer wf_insert_estima_web (string arg_estno, string arg_cvcod)
end prototypes

public subroutine wf_update ();int  icount, k 

icount = dw_update.rowcount()

if icount < 1  then return 

FOR k = 1 TO icount
	dw_update.setitem(k, 'pomast_printgu', 'Y')
NEXT

if dw_update.update() = 1 then
	commit ;
else
	rollback ;
end if	

dw_update.reset()
end subroutine

public subroutine wf_print ();int  icount, icount2
String sName

icount = dw_print.rowcount()

if icount < 1  then return 

//// 발주회사 명칭
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '1';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head1.text = sName
//
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '2';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head2.text = sName
//
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '3';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head3.text = sName
//
//SELECT DATANAME into :sName
//  FROM SYSCNFG 
// WHERE SYSGU 	= 'C' 
//	AND SERIAL	= 6
//	AND LINENO	= '4';
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.head4.text = sName
//
//SELECT A.CVNAS2  into :sName
//  FROM VNDMST A, ( SELECT NVL(DATANAME, '000000') AS JASA FROM SYSCNFG 
//						  WHERE SYSGU = 'C' AND SERIAL = 4 AND LINENO	= 1 ) B
// WHERE A.CVCOD = B.JASA ;
//	
//IF isnull(sname) then sname = ''	
//dw_print.object.footer1.text = sName
//
if icount > 0 then 
	// DW_PRINT PRINT START EVENT에서 출력시 출력여부에 Y로 UPDATE
	dw_print.print()
end if
dw_print.reset()
//OpenWithParm(w_print_options, dw_print)
end subroutine

public function integer wf_insert_estima_web (string arg_estno, string arg_cvcod);Integer  iCount
Double   dAmtDr,dAmtCr
String   sKorAmt,sJunGbn

select Count(*)	into :iCount from estima_web 
where estno = :arg_estno 
and   cvcod  = :arg_cvcod ;

if sqlca.sqlcode = 0 and iCount > 0 then
	if MessageBox('확 인','결재 자료가 존재합니다. 변경하시겠습니까?',Question!,YesNo!) = 2 then Return -1
	
	delete from estima_web  
	where estno = :arg_estno 
	and   cvcod  = :arg_cvcod ;
	
	Commit;
end if

insert into estima_web (estno, cvcod, cvnas, empname, itdsc, guqty, quamt, itnbr, status )  
  select substr(estno,1,12), max(cvcod), fun_get_cvnas(max(cvcod)), fun_get_empname( max(rempno) ,'KN'),
 			fun_get_itdsc(max(itnbr)), sum(vnqty), sum(trunc(unprc*vnqty,5)),max(itnbr), 'N'
 From Estima
 where sabu =:gs_sabu
 and   substr(estno,1,12) like :arg_estno
 Group By substr(estno,1,12);
  
if sqlca.sqlcode = 0 then
	Commit;
	Return 1
else
	Rollback;
	Return -1
end if

end function

on w_imt_02030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_y=create rb_y
this.rb_n=create rb_n
this.cbx_1=create cbx_1
this.dw_print=create dw_print
this.rb_o=create rb_o
this.st_2=create st_2
this.sle_bal=create sle_bal
this.rb_opt=create rb_opt
this.rb_opt2=create rb_opt2
this.dw_update=create dw_update
this.cbx_2=create cbx_2
this.rb_w=create rb_w
this.p_upgw=create p_upgw
this.pb_1=create pb_1
this.gb_1=create gb_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_y
this.Control[iCurrent+3]=this.rb_n
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.rb_o
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_bal
this.Control[iCurrent+9]=this.rb_opt
this.Control[iCurrent+10]=this.rb_opt2
this.Control[iCurrent+11]=this.dw_update
this.Control[iCurrent+12]=this.cbx_2
this.Control[iCurrent+13]=this.rb_w
this.Control[iCurrent+14]=this.p_upgw
this.Control[iCurrent+15]=this.pb_1
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.rr_2
this.Control[iCurrent+18]=this.rr_3
this.Control[iCurrent+19]=this.rr_4
end on

on w_imt_02030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_y)
destroy(this.rb_n)
destroy(this.cbx_1)
destroy(this.dw_print)
destroy(this.rb_o)
destroy(this.st_2)
destroy(this.sle_bal)
destroy(this.rb_opt)
destroy(this.rb_opt2)
destroy(this.dw_update)
destroy(this.cbx_2)
destroy(this.rb_w)
destroy(this.p_upgw)
destroy(this.pb_1)
destroy(this.gb_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;PostEvent('ue_open')
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
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

event ue_open;call super::ue_open;/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :isCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
If isNull(isCnvgu) or Trim(isCnvgu) = '' then
	isCnvgu = 'N'
End if

if isCnvgu = 'Y' then // 발주단위 사용시
	dw_insert.dataobject = 'd_imt_02030_0_1'

Else						// 발주단위 사용안함
	dw_insert.dataobject = 'd_imt_02030_0'

End if	

/* 발주번호 자동채번여부를 환경설정에서 검색함 */
select dataname
  into :ls_auto
  from syscnfg
 where sysgu = 'S' and serial = 6 and lineno = '60';
 
If isNull(ls_auto) or Trim(ls_auto) = '' then
	ls_auto = 'Y'
End if

if ls_auto = 'Y' then 
	sle_bal.Visible = false
	st_2.Visible = false
end if

// 전자결재 여동유무(발주검토)
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_gwgbn
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'W' ) AND  
		 ( "SYSCNFG"."SERIAL" = 1 ) AND  
		 ( "SYSCNFG"."LINENO" = '3' )   ;
If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server 접속
	SQLCA1 = Create Transaction
	
	select dataname into	 :ls_dbms     from syscnfg where sysgu = 'W' and serial = '6' and lineno = '1';
	select dataname into	 :ls_database from syscnfg where sysgu = 'W' and serial = '6' and lineno = '2';
	select dataname into	 :ls_id	 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '3';
	select dataname into	 :ls_pwd 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '4';
	select dataname into	 :ls_host 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '5';
	select dataname into	 :ls_port 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '6';
	
	ls_conn_str = "DBMSSOCN,"+ls_host+","+ls_port 
	
	SetNull(ls_reg_cnn)
	RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", ls_host, RegString!, ls_reg_cnn) 
	
	If Trim(Upper(ls_conn_str)) <> Trim(Upper(ls_reg_cnn)) Or &
		( ls_reg_cnn =""  Or isNull(ls_reg_cnn) )  Then
		RegistrySet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", & 
						ls_host, RegString!, ls_conn_str)
	End If
	
	SQLCA1.DBMS = ls_dbms
	SQLCA1.Database = ls_database
	SQLCA1.LogPass = ls_pwd
	SQLCA1.ServerName = ls_host
	SQLCA1.LogId =ls_id
	SQLCA1.AutoCommit = False
	SQLCA1.DBParm = ""
	
	CONNECT USING SQLCA1;
	If sqlca1.sqlcode <> 0 Then
		messagebox(string(sqlca1.sqlcode),sqlca1.sqlerrtext)
		MessageBox('확 인','그룹웨어 연동을 할 수 없습니다.!!')
		is_gwgbn = 'N'
	End If
End If


/*사업장별 담당자선택*/
f_child_saupj(dw_1,'empno','%')

/*사업장별 창고선택*/
f_child_saupj(dw_1,'ipdpt',gs_saupj)


dw_insert.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
dw_update.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1, 'baldate', is_today) //발주일자 기본 셋팅
dw_1.SetFocus()

// 자사 거래처마스터 코드
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_cvcod
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
		 ( "SYSCNFG"."SERIAL" = 4 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' ) AND
		 ( "SYSCNFG"."RFCOD" = :gs_saupj );

if isnull(is_cvcod) then is_cvcod = '000010' 

/*부가사업장 */
f_mod_saupj(dw_1,'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_imt_02030
integer x = 55
integer y = 360
integer width = 4530
integer height = 1952
integer taborder = 20
string dataobject = "d_imt_02030_0"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;/* 입고예정창고가 없는 경우에는 선택할 수 없음 */
if isnull(this.getitemstring(row, "ipnam")) or &
   trim(this.getitemstring(row, "ipnam")) = '' then
	Messagebox("입고예정창고", "입고예정창고가 없는 경우 선택할 수 없읍니다", stopsign!)
	this.setitem(row, "blyn", 'N')
	return 1
end if

end event

event dw_insert::retrieverow;/* 입고예정창고가 없는 경우에는 선택할 수 없음 */
if row < 1 then return 
if isnull(this.getitemstring(row, "ipnam")) or &
   trim(this.getitemstring(row, "ipnam")) = '' then
	this.setitem(row, "blyn", 'N')
end if
end event

type p_delrow from w_inherite`p_delrow within w_imt_02030
integer x = 3461
integer y = 3216
end type

type p_addrow from w_inherite`p_addrow within w_imt_02030
integer x = 3653
integer y = 3224
end type

type p_search from w_inherite`p_search within w_imt_02030
boolean visible = false
integer x = 3977
integer y = 3252
end type

type p_ins from w_inherite`p_ins within w_imt_02030
integer x = 3849
integer y = 2812
end type

type p_exit from w_inherite`p_exit within w_imt_02030
integer x = 4425
integer y = 28
end type

type p_can from w_inherite`p_can within w_imt_02030
integer x = 4251
integer y = 28
end type

event p_can::clicked;call super::clicked;dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.insertrow(0)
dw_1.SetFocus()

dw_insert.setredraw(True)
dw_1.setredraw(True)

ib_any_typing = FALSE

cbx_2.text = "전체해제"	

/*사업장별 담당자선택*/
f_child_saupj(dw_1,'empno',gs_saupj)

/*사업장별 창고선택*/
f_child_saupj(dw_1,'ipdpt',gs_saupj)

f_mod_saupj(dw_1,'saupj')
end event

type p_print from w_inherite`p_print within w_imt_02030
integer x = 3648
integer y = 3380
end type

type p_inq from w_inherite`p_inq within w_imt_02030
integer x = 3904
integer y = 28
end type

event p_inq::clicked;call super::clicked;string 	s_empno, sgubun, scvcod, sestno, sOpt1, &
			sSaupj, sIpdpt, ls_baldate, ls_nextdate
long i

///////////////////////////////////////////////////////////////////////////////////
// 구매검토된 내역중 '의뢰'상태/결재상태가 완료가 아닌 내역을 조회하여 전자결재 상태를 update한다
DataStore ds
Long  ix
String sGwNo, sGwStatus

ds = create datastore
ds.dataobject = 'd_imt_02030_ds'
ds.SetTransObject(sqlca)
ds.Retrieve()
For ix = 1 To ds.RowCount()
	sGwNo  = Trim(ds.GetItemString(ix, 'gwno'))
	
	If is_gwgbn = 'Y' Then
		select approvalstatus into :sGwStatus
		  from eafolder_00022_erp a, approvaldocinfo b
		 where a.macro_field_1 = :sgwno
			and a.reporterid 	 = b.reporterid
			and a.reportnum	 = b.reportnum	using sqlca1 ;
	End If
	
	If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
		// 보류나 반려인 경우 취소로 상태 변경
		If sGwStatus = '2' Or sGwStatus = '5' Then
			UPDATE ESTIMA SET BLYND = '4' , YEBI2 = :sGwStatus WHERE SABU = :gs_sabu AND GWNO = :sGwno;
		Else
			UPDATE ESTIMA SET YEBI2 = :sGwStatus WHERE SABU = :gs_sabu AND GWNO = :sGwno;
		End If
	End If
Next
COMMIT;

///////////////////////////////////////////////////////////////////////////////////

if dw_1.AcceptText() = -1 then return 

SetPointer(HourGlass!)

if rb_y.checked then 
	sgubun = 'Y'
	sOpt1 ='2' //발주지시상태 : 검토
elseIF rb_n.checked then  
	sgubun = 'N'
	sOpt1 ='2' //발주지시상태 : 검토
elseif rb_o.checked then
	sgubun = 'O'
	sOpt1 ='2' //발주지시상태 : 의뢰
elseif rb_w.checked then
	sgubun = 'W'
	sOpt1 ='2' //발주지시상태 : 검토	
end if

s_empno = dw_1.GetItemString(1,'empno')
scvcod  = dw_1.GetItemString(1,'cvcod')
sestno  = dw_1.GetItemString(1,'estno')

sIpdpt  = dw_1.GetItemString(1,'ipdpt')
sSaupj  = dw_1.GetItemString(1,'saupj')

////////////////////////////////////////////////////////////////////////

if isnull(sSaupj) or sSaupj = "" then
	f_message_chk(30,'[사업장]')
	dw_1.Setcolumn('saupj')
	dw_1.SetFocus()
	return
end if	

if isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[발주담당자]')
	dw_1.Setcolumn('empno')
	dw_1.SetFocus()
	return
end if	

if isnull(sIpdpt) or sIpdpt = "" then
	f_message_chk(30,'[입고예정창고]')
	dw_1.Setcolumn('ipdpt')
	dw_1.SetFocus()
	return
end if	

if isnull(scvcod) or scvcod = "" then 
	scvcod = '%'
else	
	scvcod = scvcod + '%'
end if 

if isnull(sestno) or sestno = "" then 
	sestno = '%'
else	
	sestno = sestno + '%'
end if 

////////////////////////////////////////////////////////////////////////////////////////////////////////
if dw_insert.Retrieve(gs_sabu, sestno, s_empno, scvcod, sgubun, sopt1, sIpdpt, sSaupj) <= 0 then 
	if ls_gub = 'N' then 
		f_message_chk(50,'')
	END IF	
	dw_1.Setcolumn('empno')
	dw_1.SetFocus()
end if	

if rb_o.checked then
	
	ls_baldate = dw_1.GetItemString(1, 'baldate')

	If isNull(ls_baldate ) or ls_baldate = '' Then

	Else
		select to_char(trunc(add_months(to_date(:ls_baldate,'YYYYMMDD'),1),'MONTH'),'YYYYMMDD') 
		into :ls_nextdate
		from dual;
		
		FOR i = 1 to dw_insert.rowCount()
			dw_insert.setItem(i, 'yodat', ls_nextdate)
		NEXT
	End If
End If

ib_any_typing = FALSE
cbx_2.text = "전체해제"	

SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_imt_02030
integer x = 3451
integer y = 3360
end type

type p_mod from w_inherite`p_mod within w_imt_02030
integer x = 4078
integer y = 28
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\Erpman\image\발주_up.gif"
end type

event p_mod::clicked;call super::clicked;long i, irtnvalue, lcount
datetime	dtToday
string   s_daytime, sblynd, s_empno, sBaldate, sToday, sDate, ls_estno, ls_status, ls_cvcod

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

ls_estno    = dw_insert.GetItemString(dw_insert.GetRow(),"estno")
ls_cvcod    = dw_insert.GetItemString(dw_insert.GetRow(),"cvcod")

if dw_insert.rowcount() <= 0 then
	return 
end if	

If ls_estno = '' or IsNull(ls_estno) then
	F_MessageChk(50,'[발주의뢰 번호]')
	return
End If

ls_estno = left(ls_estno, 12)

Select distinct status into :ls_status From estima_web
where estno like :ls_estno ||'%';

If sqlca.sqlcode = 0 then
	If ls_status <> 'Y' Then
		if MessageBox('확 인','결재가 승인되지 않았습니다.~r발주를 진행하시겠습니까?',Question!,YesNo!) = 2 then Return -1
	End If
End If

IF dw_insert.update() <= 0 	THEN
	ROLLBACK;
	RETURN
END IF

lcount = dw_insert.rowcount()
FOR i=1 TO lcount
    	sblynd = dw_insert.getitemstring(i, "blyn")
    	if 	sblynd = 'Y' and dw_insert.getitemstring(i, "cvcod") = is_cvcod then 
		 Messagebox("확 인", "발주처가 자사거래처입니다. 거래처를 확인하세요!")
		 dw_insert.ScrollToRow(i)
		 dw_insert.setfocus()
		 return 
 	end if
	sDate    = dw_insert.getitemstring(i, 'yodat')      //납기일자
	IF 	f_datechk(sDate) = -1 THEN
		f_Message_Chk(35, '[납기일자]')
	 	dw_insert.ScrollToRow(i)
		dw_insert.setcolumn('yodat')
		dw_insert.setfocus()
		return 
	End If
	 
NEXT

sDate    = dw_1.getitemstring(1, 'baldate')      //발주일자
if sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if


IF ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF sBaldate = '' or isnull(sBaldate) THEN 
		MessageBox("확 인", "생성할 발주번호를 입력하세요!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = sDate 
END IF

IF Messagebox('확 인','발주 처리 하시겠습니까?',Question!,YesNo!,1)  = 2 THEN return 

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "발주 처리 중....."
// --------------------------------------------- [ 데이타 재입력(납기일자) ]

SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime = String(dtToday,'YYYYMMDD HH:MM:SS')
s_empno   = dw_1.getitemstring(1, 'empno')

FOR i=1 TO lcount
    sblynd = dw_insert.getitemstring(i, "blyn")
    if sblynd = 'Y' then
       dw_insert.setitem(i, "baljutime", s_daytime)
	 end if
NEXT
	
if dw_insert.update() = 1 then
	IF rb_opt.Checked THEN 
		iRtnValue = sqlca.erp000000081(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
   ELSE
		iRtnValue = sqlca.erp000000080(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
	END IF
	
	if irtnvalue = 1 then
		commit ;
		w_mdi_frame.sle_msg.text = "발주처리 되었습니다!!"
		ib_any_typing= FALSE
	else
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(41,'')
		Return				
	END IF
else
	rollback ;
	w_mdi_frame.sle_msg.text = ""
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if

/* 결재조건 UPDATE */
String sPlnApp

sPlnApp = Trim(dw_1.GetItemString(1, 'plnapp'))

UPDATE POMAST SET PLNAPP = :sPlnApp
 WHERE SABU = :gs_sabu
   AND BALJPNO IN ( select distinct baljpno from estima where baljutime = :s_daytime );
COMMIT;

IF cbx_1.Checked Then
   dw_print.retrieve(gs_sabu, s_daytime ) 
   dw_update.retrieve(gs_sabu, s_daytime ) 
	
	wf_print()  //발주서, 외주발주서 출력
	wf_update()  //발주서여부 update 
	
END IF	

ls_gub = 'Y'
p_inq.TriggerEvent(Clicked!)
ls_gub = 'N' 
end event

event p_mod::ue_lbuttondown;PictureName = "C:\Erpman\image\발주_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\Erpman\image\발주_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_imt_02030
integer x = 3209
integer y = 3328
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_imt_02030
integer x = 2505
integer y = 3328
integer taborder = 50
string text = "발주(&S)"
end type

event cb_mod::clicked;call super::clicked;long i, irtnvalue, lcount
datetime	dtToday
string   s_daytime, sblynd, s_empno, sBaldate, sToday, sDate 

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

lcount = dw_insert.rowcount()
FOR i=1 TO lcount
    sblynd = dw_insert.getitemstring(i, "blyn")
    if sblynd = 'Y' and dw_insert.getitemstring(i, "cvcod") = is_cvcod then 
		 Messagebox("확 인", "발주처가 자사거래처입니다. 거래처를 확인하세요!")
		 dw_insert.ScrollToRow(i)
		 dw_insert.setfocus()
		 return 
	 end if
NEXT

sDate    = dw_1.getitemstring(1, 'baldate')      //발주일자
if sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if

IF ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF sBaldate = '' or isnull(sBaldate) THEN 
		MessageBox("확 인", "생성할 발주번호를 입력하세요!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = sDate 
END IF

IF Messagebox('확 인','발주 처리 하시겠습니까?',Question!,YesNo!,1)  = 2 THEN return 

SetPointer(HourGlass!)
sle_msg.text = "발주 처리 중....."

SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime = String(dtToday,'YYYYMMDD HH:MM:SS')
s_empno   = dw_1.getitemstring(1, 'empno')

FOR i=1 TO lcount
    sblynd = dw_insert.getitemstring(i, "blyn")
    if sblynd = 'Y' then
       dw_insert.setitem(i, "baljutime", s_daytime)
	 end if
NEXT
	
if dw_insert.update() = 1 then
	IF rb_opt.Checked THEN 
		iRtnValue = sqlca.erp000000081(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
   ELSE
		iRtnValue = sqlca.erp000000080(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
	END IF
	
	if irtnvalue = 1 then
		commit ;
		sle_msg.text = "발주처리 되었습니다!!"
		ib_any_typing= FALSE
	else
		ROLLBACK;
		sle_msg.text = ""
		f_message_chk(41,'')
		Return				
	END IF
else
	rollback ;
	sle_msg.text = ""
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

IF cbx_1.Checked Then
   dw_print.retrieve(gs_sabu, s_daytime ) 
   dw_update.retrieve(gs_sabu, s_daytime ) 
	
	wf_print()  //발주서, 외주발주서 출력
	wf_update()  //발주서여부 update 
	
END IF	

ls_gub = 'Y'
cb_inq.TriggerEvent(Clicked!)
ls_gub = 'N' 
end event

type cb_ins from w_inherite`cb_ins within w_imt_02030
integer x = 539
integer y = 3204
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_02030
integer x = 960
integer y = 3232
end type

type cb_inq from w_inherite`cb_inq within w_imt_02030
integer x = 46
integer y = 3328
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;string 	s_empno, sgubun, scvcod, sestno, sOpt1, sOpt2,		&
			sSaupj, sIpdpt

if dw_1.AcceptText() = -1 then return 

SetPointer(HourGlass!)

if rb_y.checked then 
	sgubun = 'Y'
	sOpt1 ='1' //발주지시상태 : 의뢰
	sOpt2 ='2' //발주지시상태 : 검토
elseIF rb_n.checked then  
	sgubun = 'N'
	sOpt1 ='2' //발주지시상태 : 검토
	sOpt2 ='2' //발주지시상태 : 검토
else	
	sgubun = 'O'
	sOpt1 ='1' //발주지시상태 : 의뢰
	sOpt2 ='2' //발주지시상태 : 검토
end if

s_empno = dw_1.GetItemString(1,'empno')
scvcod  = dw_1.GetItemString(1,'cvcod')
sestno  = dw_1.GetItemString(1,'estno')

sIpdpt  = dw_1.GetItemString(1,'ipdpt')
sSaupj  = dw_1.GetItemString(1,'saupj')

////////////////////////////////////////////////////////////////////////

if isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[발주담당자]')
	dw_1.Setcolumn('empno')
	dw_1.SetFocus()
	return
end if	

if isnull(sIpdpt) or sIpdpt = "" then
	f_message_chk(30,'[입고예정창고]')
	dw_1.Setcolumn('ipdpt')
	dw_1.SetFocus()
	return
end if	

if isnull(sSaupj) or sSaupj = "" then
	f_message_chk(30,'[사업장]')
	dw_1.Setcolumn('saupj')
	dw_1.SetFocus()
	return
end if	


if isnull(scvcod) or scvcod = "" then 
	scvcod = '%'
else	
	scvcod = scvcod + '%'
end if 

if isnull(sestno) or sestno = "" then 
	sestno = '%'
else	
	sestno = sestno + '%'
end if 

////////////////////////////////////////////////////////////////////////////////////////////////////////
if dw_insert.Retrieve(gs_sabu, sestno, s_empno, scvcod, sgubun, sopt1, sopt2, sIpdpt, sSaupj) <= 0 then 
	if ls_gub = 'N' then 
		f_message_chk(50,'')
	END IF	
	dw_1.Setcolumn('empno')
	dw_1.SetFocus()
end if	
	
ib_any_typing = FALSE
cb_search.text = "전체해제"	

SetPointer(Arrow!)
end event

type cb_print from w_inherite`cb_print within w_imt_02030
integer x = 2757
integer y = 3208
end type

type st_1 from w_inherite`st_1 within w_imt_02030
end type

type cb_can from w_inherite`cb_can within w_imt_02030
integer x = 2857
integer y = 3328
end type

event cb_can::clicked;call super::clicked;dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.insertrow(0)
dw_1.SetFocus()

dw_insert.setredraw(True)
dw_1.setredraw(True)

ib_any_typing = FALSE

cb_search.text = "전체해제"	
end event

type cb_search from w_inherite`cb_search within w_imt_02030
integer x = 398
integer y = 3328
integer width = 375
integer taborder = 40
string text = "전체해제"
end type

event cb_search::clicked;call super::clicked;Long Lrow, lcount

lcount = dw_insert.rowcount()

If this.text = "전체선택" Then
	For Lrow = 1 to lcount
  		 dw_insert.Setitem(Lrow, "blyn", 'Y')
	Next
	
	this.text = "전체해제"	
Else
	For Lrow = 1 to lcount
		 dw_insert.Setitem(Lrow, "blyn", 'N')
	Next
	
	this.text = "전체선택"
End if
end event





type gb_10 from w_inherite`gb_10 within w_imt_02030
integer y = 2808
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_02030
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02030
end type

type dw_1 from datawindow within w_imt_02030
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 72
integer width = 2624
integer height = 236
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02030_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string snull, s_empno, scvcod, get_nm, get_nm2, s_estno, get_aut, s_date
int    ireturn 

setnull(snull)

IF this.GetColumnName() ="empno" THEN
	s_empno = trim(this.GetText())
	
	IF	Isnull(s_empno)  or  s_empno = ''	Then
		dw_insert.reset()
		RETURN 
   END IF

ELSEIF this.GetColumnName() ="cvcod" THEN  
	scvcod = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(1, "cvcod", scvcod)	
	this.setitem(1, "cvnas", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() ="estno" THEN
//	s_estno = trim(this.GetText())
//	
//	IF	Isnull(s_estno)  or  s_estno = ''	Then
//		RETURN
//   END IF
//
//   s_estno = s_estno + '%'
//
//	  SELECT AUTCRT, SEMPNO
//		 INTO :get_aut, :s_empno
//		 FROM ESTIMA
//		WHERE SABU = :gs_sabu AND ESTNO like :s_estno AND ROWNUM = 1 
//	GROUP BY AUTCRT, SEMPNO ;
//
//	IF not (s_empno = '' or isnull(s_empno)) then 
//		dw_1.setitem(1, 'empno', s_empno)
//      IF get_aut = 'Y' then 
//         rb_y.checked = true
//			rb_y.TriggerEvent(Clicked!)
//		ELSEIF get_aut = 'N' then 	
//         rb_n.checked = true
//			rb_n.TriggerEvent(Clicked!)
//		ELSE
//         rb_1.checked = true
//			rb_1.TriggerEvent(Clicked!)
//		END IF
//	END IF
ELSEIF this.GetColumnName() ="baldate" THEN  
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[발주일자]')
		this.SetItem(1,"baldate",is_today)
		this.Setcolumn("baldate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF GetColumnName() = 'saupj' THEN
	s_date = GetText()
	/*사업장별 담당자선택*/
	f_child_saupj(dw_1,'empno','%')
	
	/*사업장별 창고선택*/
	f_child_saupj(dw_1,'ipdpt',s_date)
	
	SetItem(1,'empno',snull)
	SetItem(1,'ipdpt',snull)
	
	// 자사 거래처마스터 코드
	SELECT "SYSCNFG"."DATANAME"  
	  INTO :is_cvcod
	  FROM "SYSCNFG"  
	 WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
			 ( "SYSCNFG"."SERIAL" = 4 ) AND  
			 ( "SYSCNFG"."LINENO" = '1' ) AND
			 ( "SYSCNFG"."RFCOD" = :s_date );
END IF	
end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
ELSEIF this.GetColumnName() = "estno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	
	open(w_estima_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
	
	gs_code = left(gs_code, 12)
	
   this.setitem(1, 'estno', gs_code)
//	THIS.TriggerEvent(ITEMCHANGED!)
END IF	
end event

type rb_y from radiobutton within w_imt_02030
integer x = 2222
integer y = 208
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "자동생성 분"
end type

event clicked;p_inq.triggerevent(clicked!)

end event

type rb_n from radiobutton within w_imt_02030
integer x = 2222
integer y = 80
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "구매의뢰 분"
boolean checked = true
end type

event clicked;p_inq.triggerevent(clicked!)


end event

type cbx_1 from checkbox within w_imt_02030
boolean visible = false
integer x = 3771
integer y = 228
integer width = 407
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "발주서출력"
end type

event clicked;//if this.checked then 
//	dw_print.visible = true
//else	
//	dw_print.visible = false
//end if
end event

type dw_print from datawindow within w_imt_02030
boolean visible = false
integer x = 4027
integer y = 380
integer width = 553
integer height = 252
boolean bringtotop = true
boolean titlebar = true
string title = "발주서"
string dataobject = "d_imt_02030_2"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_o from radiobutton within w_imt_02030
integer x = 2222
integer y = 144
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "연동계획 분"
end type

event clicked;p_inq.triggerevent(clicked!)


end event

type st_2 from statictext within w_imt_02030
integer x = 3035
integer y = 20
integer width = 416
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "생성 발주번호 "
boolean focusrectangle = false
end type

type sle_bal from singlelineedit within w_imt_02030
event ue_key pbm_keydown
integer x = 3461
integer width = 270
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 8
end type

event ue_key;if key = KeyEnter! then
	cb_mod.setfocus()
end if
end event

event modified;//string sBaljpno, sNull
//LonG   lCount
//
//setnull(snull)
//
//sBaljpno = trim(this.text)
//
//  SELECT COUNT(*)
//    INTO :lCount
//    FROM POMAST  
//   WHERE SABU    =    '1'   
//     AND BALJPNO LIKE :sBaljpno||'%' ;
//
//IF lCount > 0 THEN
//	MessageBox("확 인", "등록된 발주번호입니다. 생성할 발주번호를 확인하세요!")
//	this.text = sNull
//	return 1
//END IF	
//
end event

type rb_opt from radiobutton within w_imt_02030
integer x = 2747
integer y = 116
integer width = 768
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "개별(의뢰1건 => 발주1건)"
boolean checked = true
end type

type rb_opt2 from radiobutton within w_imt_02030
integer x = 2747
integer y = 212
integer width = 768
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "집계(의뢰n건 => 발주1건)"
end type

type dw_update from datawindow within w_imt_02030
boolean visible = false
integer x = 1280
integer y = 3232
integer width = 837
integer height = 112
boolean bringtotop = true
boolean titlebar = true
string title = "발주여부 UPDATE"
string dataobject = "d_imt_02030_update"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_2 from checkbox within w_imt_02030
integer x = 4242
integer y = 236
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "전체해제"
end type

event clicked;Long Lrow, lcount

lcount = dw_insert.rowcount()

If this.text = "전체선택" Then
	For Lrow = 1 to lcount
  		 dw_insert.Setitem(Lrow, "blyn", 'Y')
	Next
	
	this.text = "전체해제"	
Else
	For Lrow = 1 to lcount
		 dw_insert.Setitem(Lrow, "blyn", 'N')
	Next
	
	this.text = "전체선택"
End if
end event

type rb_w from radiobutton within w_imt_02030
boolean visible = false
integer x = 2075
integer y = 236
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "주간계획 분"
end type

event clicked;p_inq.triggerevent(clicked!)


end event

type p_upgw from uo_picture within w_imt_02030
boolean visible = false
integer x = 3730
integer y = 28
integer width = 178
integer taborder = 110
boolean bringtotop = true
string picturename = "C:\erpman\image\결재상신_up.gif"
end type

event clicked;////String  sSaupj,sBalDate,sUpmuGu,ls_reportid1, ls_reportid2, ls_junno
//String  ls_estno, ls_cvcod, ls_itnbr, ls_reportid1, ls_reportid2
//
//Long    lJunNo,iCount, ll_count,ll_repno1,ll_repno2, ll_rptcnt1, ll_rptcnt2, ll_row
//
//IF dw_insert.AcceptText() <= -1 Then Return
//
//ll_row = dw_insert.GetRow()
//
//If IsNull(ll_row ) or ll_row = 0 Then
//	ll_row =1
//End If
//
//ls_estno    = dw_insert.GetItemString(ll_row,"estno")
//ls_cvcod    = dw_insert.GetItemString(ll_row,"cvcod")
//ls_itnbr    = dw_insert.GetItemString(ll_row,"itnbr")
//
//If ls_estno = '' or IsNull(ls_estno) then
//	F_MessageChk(50,'[발주의뢰 번호]')
//	return
//End If
//
//ls_estno = left(ls_estno, 12)
//
//// 결재 상신 정보 SELECT를 위한 연결 
//Transaction sqlca1
//sqlca1 = Create Transaction 
//
//// Profile taesunggrp
//SQLCA1.DBMS = "MSS Microsoft SQL Server 6.x"
//SQLCA1.Database = "workcrewnet"
//SQLCA1.LogPass = "taesung"
//SQLCA1.ServerName = "61.34.17.137"
//SQLCA1.LogId = "taesung"
//SQLCA1.AutoCommit = False
//SQLCA1.DBParm = ""
//
//CONNECT USING SQLCA1 ;
//
////그룹웨어 연동구분
//STRING s_gwgbn
//
//select dataname into :s_gwgbn from syscnfg where sysgu = 'W' and serial = 1 and lineno = '1';
//
//w_mdi_frame.sle_msg.text = '결재 상신 중...'
//SetPointer(HourGlass!)
///* 전자결제 상신 */
//IF s_gwgbn = 'Y'  then
//	w_mdi_frame.sle_msg.text = '결재 상신 중...'
//	SetPointer(HourGlass!)
//
//	if Wf_Insert_estima_web(ls_estno,ls_cvcod) = -1 then
//		F_MessageChk(13,'[전자결재 상신 자료]')
//		w_mdi_frame.sle_msg.text = ''
//		SetPointer(Arrow!)
//		Rollback;
//		Return
//	else
//		Commit;
//	end if
//
////결재 상신전 reportNum Max값 조회
////결재 상신전과 상신후 Max값을 조회하여 Max값이 서로 다르면 상신, 같으면 상신 실패.
//	select	a.reporterid, max(a.reportnum)
//	into		:ls_reportid1, :ll_repno1
//	from eafolder_0000000071_erp a
//	where a.macro_field_1 = :ls_estno	//구매의뢰 번호
//	and	a.macro_field_2 = :ls_cvcod	//거래처 코드
//	group by a.reporterid
// 	using sqlca1 ;
//
////등록된 결재가 있는지 조회.
//select count(b.reporterid) into :ll_rptcnt1
//from   eafolder_0000000071_erp a, approvaldocinfo b
//where    a.macro_field_1 = :ls_estno
//	and	a.macro_field_2 = :ls_cvcod
//	and	a.reporterid 	 = b.reporterid
//	and	a.reportnum		 = b.reportnum
//	using sqlca1 ;
//
//	gs_code  = "&ESTNO=" + ls_estno + "&CVCOD=" + ls_cvcod
//	gs_gubun = '0000000081'	//그룹웨어 문서번호
//	SetNull(gs_codename)
//	
//	WINDOW LW_WINDOW
//// response 로 바꿀것....
//	Open(w_groupware_browser)
////	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser',w_mdi_frame, 0, Layered!)
//
////결재 상신 후 reportNum Max값 조회
//select	a.reporterid, max(a.reportnum)
//	into		:ls_reportid2, :ll_repno2
//	from eafolder_0000000071_erp a
//	where a.macro_field_1 = :ls_estno	//구매의뢰 번호
//	and	a.macro_field_2 = :ls_cvcod	//거래처 코드
//	group by a.reporterid
// 	using sqlca1 ;
//
////결재가 등록되었는지 조회.
//select count(b.reporterid) into :ll_rptcnt2
//from   eafolder_0000000071_erp a, approvaldocinfo b
//where    a.macro_field_1 = :ls_estno
//	and	a.macro_field_2 = :ls_cvcod
//	and	a.reporterid 	 = b.reporterid
//	and	a.reportnum		 = b.reportnum
//	using sqlca1 ;
//
//	If ll_repno1 <> ll_repno2 or ll_rptcnt1 <> ll_rptcnt2 Then
//		MessageBox('결재상신','결재가 상신되었습니다.')
//	Else
//		MessageBox('결재상신 실패','결재 상신이 실패하였습니다.')
//	End If
//	
//	w_mdi_frame.sle_msg.text = ''
//	SetPointer(Arrow!)
//END IF
//
//disconnect	using	sqlca1 ;
//destroy	sqlca1
//
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\결재상신_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\결재상신_up.gif"
end event

type pb_1 from u_pb_cal within w_imt_02030
integer x = 1742
integer y = 156
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('baldate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'baldate', gs_code)



end event

type gb_1 from groupbox within w_imt_02030
integer x = 2711
integer y = 60
integer width = 823
integer height = 264
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "발주생성구분"
end type

type rr_2 from roundrectangle within w_imt_02030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 64
integer width = 2638
integer height = 260
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_imt_02030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 352
integer width = 4558
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_imt_02030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4174
integer y = 204
integer width = 439
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

