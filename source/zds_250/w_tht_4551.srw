$PBExportHeader$w_tht_4551.srw
$PBExportComments$�������� �˻� ����
forward
global type w_tht_4551 from w_inherite
end type
type dw_ret from datawindow within w_tht_4551
end type
type p_1 from picture within w_tht_4551
end type
type p_2 from picture within w_tht_4551
end type
type em_date1 from editmask within w_tht_4551
end type
type em_date2 from editmask within w_tht_4551
end type
type r_1 from roundrectangle within w_tht_4551
end type
type r_2 from roundrectangle within w_tht_4551
end type
type dw_list from datawindow within w_tht_4551
end type
type pb_1 from picturebutton within w_tht_4551
end type
type pb_2 from picturebutton within w_tht_4551
end type
type pb_3 from picturebutton within w_tht_4551
end type
type pb_4 from picturebutton within w_tht_4551
end type
end forward

global type w_tht_4551 from w_inherite
integer width = 4695
integer height = 2992
string title = "�������� �˻� ����"
string menuname = ""
boolean minbox = false
dw_ret dw_ret
p_1 p_1
p_2 p_2
em_date1 em_date1
em_date2 em_date2
r_1 r_1
r_2 r_2
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
end type
global w_tht_4551 w_tht_4551

type variables
int			il_win_h[10], il_win_w[10]
DataWindowChild	Dw_Child
end variables

forward prototypes
public function integer wf_get_resize (integer arg_i, window arg_window, datawindow arg_dw, rectangle arg_rr, integer arg_w, integer arg_h, integer arg_x, integer arg_y)
public function integer wf_requiredchk ()
public function integer wf_save ()
public function integer wf_re ()
public function integer wf_load ()
public subroutine wf_selfgbn (string ar_itnbr, string ar_pdtgu, string ar_sidat, string ar_rqcgu)
end prototypes

public function integer wf_get_resize (integer arg_i, window arg_window, datawindow arg_dw, rectangle arg_rr, integer arg_w, integer arg_h, integer arg_x, integer arg_y);//----------------------------------------------------------------------------
// SPEC : WINDOW �������� ���� DATAWINDOW ũ�� ����
//----------------------------------------------------------------------------
// �������� : 2009-03-09  ������ : �̵���
// ���泻�� : �ű�
//----------------------------------------------------------------------------

/*
	FUN_GET_RESIZE( '����', 'WIDONW', 'DATAWINDOW', 'RECTANGLE', 'W', 'H', 'X', 'Y')
   '����'       : �������� DATAWINDOW�� ���� ���� ����
	'DATAWINDOW' : RESIZE�� ������ DATAWINDOW �̸�
	'RECTANGEL'  : DATAWINDOW�� ���� ����Ǿ���� ������ �ڽ� �̸� 
	'W'          : WIDTH �� �����Ұ�� 1  �ƴҰ�� 0
	'H'          : HEIGHT�� �����Ұ�� 1  �ƴҰ�� 0
	'X'          : ��ġx�� �����Ұ��  1 �ƴҰ�� 0
	'Y'			 : ��ġy�� �����Ұ��  1 �ƴҰ�� 0
*/

integer li_win_w, li_win_h, li_dw_w, li_dw_h, li_rr_w, li_rr_h
integer li_win_x, li_win_y, li_dw_x, li_dw_y, li_rr_x, li_rr_y
integer li_win_sum

/*		���� ������ ũ�� ��	*/
li_win_w = arg_window.width
li_win_h = arg_window.height

if li_win_w < 1000 or li_win_h < 1000 then
	return 0
end if

/*		DATAWINDOW ũ�� ��	*/
li_dw_w = arg_dw.width
li_dw_h = arg_dw.height
li_dw_x = arg_dw.x
li_dw_y = arg_dw.y

/* 	�����ιڽ� ũ�� ��	*/
li_rr_w = arg_rr.width
li_rr_h = arg_rr.height
li_rr_x = arg_rr.x
li_rr_y = arg_rr.y

/*		datawindow�� ������ ���� �ش� �迭 ����(width) �� Ȯ��	*/
/*		���� ������� ���簪�� �ο�										*/
if il_win_w[arg_i] = 0 then
	//il_win_w[arg_i] = li_win_w
	il_win_w[arg_i] = 4649
end if

/*		datawindow�� ������ ���� �ش� �迭 ����(height) �� Ȯ��	*/
/*		���� ������� ���簪�� �ο�										*/
if il_win_h[arg_i] = 0 then
	//il_win_h[arg_i] = li_win_h
	il_win_h[arg_i] = 2532
end if

/*		width, height, x, y�� ���� �����Ұ������� ���ο� ���� ���� */
li_win_sum = (li_win_w - il_win_w[arg_i])

if arg_w = 1 and arg_x = 1 then	
	if li_win_sum = 0 then
		
		if li_dw_w < 0 or li_rr_w < 0 or li_dw_x < 0 or li_rr_x < 0 then
			return 1
		end if
		
		arg_dw.width = li_dw_w + 0
		arg_rr.width = li_rr_w + 0
		arg_dw.x = li_dw_x + 0
		arg_rr.x = li_rr_x + 0
	else
		
		if li_dw_w < 0 or li_rr_w < 0 or (li_dw_x + (li_win_sum)) < 0 or (li_rr_x + (li_win_sum)) < 0 then
			return 1
		end if
		
		arg_dw.width = li_dw_w + (0)
		arg_rr.width = li_rr_w + (0)
		arg_dw.x = li_dw_x + (li_win_sum)
		arg_rr.x = li_rr_x + (li_win_sum)
	end if
elseif arg_w = 1 and arg_x = 0 then
		if (li_dw_w + li_win_sum) < 0 or (li_rr_w + li_win_sum) < 0 then
			return 1
		end if
		arg_dw.width = li_dw_w + li_win_sum
		arg_rr.width = li_rr_w + li_win_sum
elseif arg_w = 0 and arg_x = 1 then
		if (li_dw_x + li_win_sum) < 0 or (li_rr_x + li_win_sum) < 0 then
			return 1
		end if
		arg_dw.x = li_dw_x + li_win_sum
		arg_rr.x = li_rr_x + li_win_sum
end if
il_win_w[arg_i] = arg_window.width


li_win_sum = (li_win_h - il_win_h[arg_i])

if arg_h = 1 and arg_y = 1 then	
	if li_win_sum = 0 then
		
		if li_dw_h < 0 or li_rr_h < 0 or li_dw_y < 0 or li_rr_y < 0 then
			return 1
		end if
		
		arg_dw.height = li_dw_h + 0
		arg_rr.height = li_rr_h + 0
		arg_dw.y = li_dw_y + 0
		arg_rr.y = li_rr_y + 0
	else
		
		if li_dw_h < 0 or li_rr_h < 0 or (li_dw_y + (li_win_sum)) < 0 or (li_rr_y + (li_win_sum)) < 0 then
			return 1
		end if
		
		arg_dw.height = li_dw_h + (0)
		arg_rr.height = li_rr_h + (0)
		arg_dw.y = li_dw_y + (li_win_sum)
		arg_rr.y = li_rr_y + (li_win_sum)
	end if
elseif arg_h = 1 and arg_y = 0 then
	
		if (li_dw_h + li_win_sum) < 0 or (li_rr_h + li_win_sum) < 0 then
			return 1
		end if
		
		arg_dw.height = li_dw_h + li_win_sum
		arg_rr.height = li_rr_h + li_win_sum
elseif arg_h = 0 and arg_y = 1 then
	
		if (li_dw_y + li_win_sum) < 0 or (li_rr_y + li_win_sum) < 0 then
			return 1
		end if
	
		arg_dw.y = li_dw_y + li_win_sum
		arg_rr.y = li_rr_y + li_win_sum
end if

il_win_h[arg_i] = arg_window.height

return 1
end function

public function integer wf_requiredchk ();String sItnbr, sSelfGbn, sWkctr, sLotno, sEmpno, sSidat, sSiTim, sGubun, sIsChkVal, sIsChk, sPdtgu
Integer ii, nCount

dw_ret.accepttext( )

sItnbr	=	dw_ret.getitemstring(1, 'itnbr')
sPdtgu	=	dw_ret.getitemstring(1, 'pdtgu')
sWkctr	=	dw_ret.getitemstring(1, 'wkctr')
sEmpno	=	dw_ret.getitemstring(1, 'empno')
sSidat	=	dw_ret.getitemstring(1, 'sidat')
sSiTim	=	dw_ret.getitemstring(1, 'sitim')
sLotno	=	dw_ret.getitemstring(1, 'lotno')

if sItnbr = '' or isnull(sItnbr)	then	
	MessageBox('����', 'ǰ���� �Է� �ϼ���.')
	return -1
End If

if sPdtgu = '' or isnull(sPdtgu)	then	
	MessageBox('����', '�������� �Է� �ϼ���.')
	return -1
End If

if sWkctr = '' or isnull(sWkctr)	then	
	MessageBox('����', '�۾����� �Է� �ϼ���.')
	return -1
End If

if sEmpno = '' or isnull(sEmpno)	then	
	MessageBox('����', '�˻��ڸ� �Է� �ϼ���.')
	return -1
End If

if sSidat = '' or isnull(sSidat)	then	
	MessageBox('����', '�˻����ڸ� �Է� �ϼ���.')
	return -1
End If

if sSiTim = '' or isnull(sSiTim)	then	
	MessageBox('����', '�˻�ð��� �Է� �ϼ���.')
	return -1
End If

if sLotno = '' or isnull(sLotno)	then	
	MessageBox('����', 'LOT NO�� �Է� �ϼ���.')
	return -1
End If

nCount	=	dw_insert.rowcount()

for ii = 1 to nCount
	sGubun = dw_insert.getitemstring(ii, 'gubun')
	sIsChk = dw_insert.getitemstring(ii, 'insp_chk')
	sIsChkVal = dw_insert.getitemstring(ii, 'insp_chkval')
	
	if sIsChk = '' or isnull(sIsChk) then
		messagebox('�˻�����',String(ii)+'�� �˻������� ����ϼ���!')
		return -1
	end if
	
	if sGubun = '2' and (sIsChkVal = '' or isnull(sIsChkVal)) then
		messagebox('������',String(ii)+'�� �������� ����ϼ���!')
		return -1
	end if
next

return 1
end function

public function integer wf_save ();long		nCount,	ii
string	    sGucod, sItnbr, sSelfGbn, sWkctr, sLotno, sEmpno, sSidat, sSiTim, sIsChk, sIsChkVal, sBigo, sJpno, sPordno, sPdtgu
String    sTest1, sTest2, sTest3, sTest4, sTest5, sTest6, sRqcgu

if dw_insert.accepttext( ) = -1 then return -1

dw_ret.accepttext( )

sItnbr	=	dw_ret.getitemstring(1, 'itnbr')
sWkctr	=	dw_ret.getitemstring(1, 'wkctr')
sEmpno	=	dw_ret.getitemstring(1, 'empno')
sSidat	=	dw_ret.getitemstring(1, 'sidat')
sSiTim	=	dw_ret.getitemstring(1, 'sitim')
sSelfGbn	=	dw_ret.getitemstring(1, 'self_gbn')
sLotno	=	dw_ret.getitemstring(1, 'lotno')
sPordno	=	dw_ret.getitemstring(1, 'pordno')		// ���� �۾����ù�ȣ
sRqcgu	=	dw_ret.getitemstring(1, 'rqcgu')	
sSidat	=	dw_ret.getitemstring(1, 'sidat')	
sPdtgu	=	dw_ret.getitemstring(1, 'pdtgu')	

nCount	=	dw_insert.rowcount()

for ii = 1 to nCount
	sGucod = dw_insert.getitemstring(ii, 'rfgub')
	sIsChk = dw_insert.getitemstring(ii, 'insp_chk')
	sIsChkVal = dw_insert.getitemstring(ii, 'insp_chkVal')
	sBigo = dw_insert.getitemstring(ii, 'bigo')
	
	sTest1 = dw_insert.getitemstring(ii, 'test1')
	sTest2 = dw_insert.getitemstring(ii, 'test2')
	sTest3 = dw_insert.getitemstring(ii, 'test3')
	sTest4 = dw_insert.getitemstring(ii, 'test4')
	sTest5 = dw_insert.getitemstring(ii, 'test5')
	sTest6 = dw_insert.getitemstring(ii, 'test6')
	
	SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM(TO_CHAR(SEQ_POPINSPSELF_JPNO.NEXTVAL,'000000'))
	INTO    :sJpno
	FROM  DUAL;
	
	INSERT INTO POP_INSPECTION_SELF (JPNO, WKCTR, ITNBR, GUBUN, GUCOD, INSP_DATE, INSP_TIME, INSP_CHK, INSP_CHKVAL, 
	                                                          INSP_EMP, INSP_BIGO, LOTNO, PORDNO, RQCGU, INSP_TEST1, INSP_TEST2, INSP_TEST3,
															INSP_TEST4, INSP_TEST5, INSP_TEST6, SIDAT, CRT_DATE, CRT_TIME, CRT_USER, PDTGU)
	VALUES(:sJpno, :sWkctr, :sItnbr, :sSelfGbn, :sGucod, TO_CHAR(SYSDATE, 'yyyymmdd'), TO_CHAR(SYSDATE, 'HH24MISS'), :sIsChk, :sIsChkVal,
	             :sEmpno, :sBigo, :sLotno, :sPordno, :sRqcgu, :sTest1, :sTest2, :sTest3,
				 :sTest4, :sTest5, :sTest6, :sSidat, TO_CHAR(SYSDATE, 'yyyymmdd'), TO_CHAR(SYSDATE, 'HH24MISS'), SYS_CONTEXT('USERENV','TERMINAL'), :sPdtgu);
				 
next

commit;

messagebox('���� �Ϸ�', '���������� ���� �Ǿ����ϴ�!!')

return 1
end function

public function integer wf_re ();string	sSidat1, sSidat2, sPdtgu, sJocod, sWkctr, sItnbr, sRqcgu, sChk, sIttyp, sInsdat1, sInsdat2

if dw_ret.accepttext( ) = -1 then return -1
dw_insert.Reset()

sPdtgu	=	dw_ret.getitemstring(1, 'pdtgu')
sWkctr	=	dw_ret.getitemstring(1, 'wkctr')
sItnbr	=	dw_ret.getitemstring(1, 'itnbr')
sSidat1	=	dw_ret.getitemstring(1, 'sidat')			// ��������
sSidat2	=	dw_ret.getitemstring(1, 'sidat')
sInsdat1	=	dw_ret.getitemstring(1, 'insdate')
sInsdat2	=	dw_ret.getitemstring(1, 'insdate')

if sPdtgu = '' or isnull(sPdtgu) then	sPdtgu = '%'
if sWkctr = '' or isnull(sWkctr)	then	sWkctr = '%'
if sItnbr = '' or isnull(sItnbr)	then	sItnbr = '%'

dw_list.retrieve( sSidat1, sSidat2, '%', '%', sPdtgu, '%', sWkctr )

//if sItnbr <> '%' then
	dw_insert.retrieve(sItnbr)
	ib_any_typing = false
//End if

return 1
end function

public function integer wf_load ();//if dw_ret.accepttext( ) = -1 then return -1

String sEmpname, sPdtgu

dw_ret.Reset()
dw_ret.Insertrow(1)
dw_ret.SetFocus()
dw_ret.SetColumn('wkctr')

//dw_ret.setitem(1, 'empno', gs_empno)
//
//SELECT MAX(B.PDTGU), FUN_GET_EMPNO(:gs_empno)
//  INTO :sPdtgu, :sEmpname
//  FROM JODETL A,	WRKCTR	B
// WHERE A.EMPNO	=	:gs_empno
//   AND B.WKCTR	=	A.WKCTR;

//SELECT FUN_GET_EMPNAME(:gs_empno,'KN') 
//INTO :sEmpname
//FROM DUAL;

dw_ret.setitem(1, 'pdtgu', sPdtgu)
//dw_ret.setitem(1, 'empnm', sEmpname)
dw_ret.setitem(1, 'sidat', is_today)
dw_ret.setitem(1, 'insdate', is_today)
dw_ret.setitem(1, 'sitim', left(is_totime,4))
dw_ret.setitem(1, 'lotno', is_today)

//Dw_Child.retrieve( sPdtgu )
//dw_ip.Setitem(1, 'wkctr', '')

return 1
end function

public subroutine wf_selfgbn (string ar_itnbr, string ar_pdtgu, string ar_sidat, string ar_rqcgu);String sGbn

SELECT NVL(MAX(GUBUN),'.')
INTO    :sGbn
FROM POP_INSPECTION_SELF
WHERE ITNBR = :ar_itnbr
AND     PDTGU = :ar_pdtgu
AND     SIDAT = :ar_sidat
AND     RQCGU = :ar_rqcgu;

IF sGbn = '.' or IsNull(sGbn) THEN
	dw_ret.SetItem(1, 'self_gbn', '1')					// �ʹ� ����
ELSEIF sGbn = '1'  THEN
	dw_ret.SetItem(1, 'self_gbn', '2')					// �߹� ����
ELSEIF sGbn = '2'  THEN
	dw_ret.SetItem(1, 'self_gbn', '3')					// ���� ����
ELSEIF sGbn = '3'  THEN
	dw_ret.SetItem(1, 'self_gbn', '3')					// ���� ����
END IF
end subroutine

event open;call super::open;this.SetPosition(TopMost!)
////this.width	=	4685
//this.width	=	5781
//this.height	=	3844//3884
////this.width	=	5685
////this.height	=	4050

This.TriggerEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_ret.SetTransObject(SQLCA)
//dw_ret.InsertRow(0)

dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(SQLCA)

if dw_ret.GetChild("empno", dw_child) = 1 then
	dw_child.settransobject(sqlca)
end if

wf_load()

p_inq.TriggerEvent(Clicked!)
end event

on w_tht_4551.create
int iCurrent
call super::create
this.dw_ret=create dw_ret
this.p_1=create p_1
this.p_2=create p_2
this.em_date1=create em_date1
this.em_date2=create em_date2
this.r_1=create r_1
this.r_2=create r_2
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ret
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.em_date1
this.Control[iCurrent+5]=this.em_date2
this.Control[iCurrent+6]=this.r_1
this.Control[iCurrent+7]=this.r_2
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.pb_3
this.Control[iCurrent+12]=this.pb_4
end on

on w_tht_4551.destroy
call super::destroy
destroy(this.dw_ret)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.em_date1)
destroy(this.em_date2)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
end on

event resize;call super::resize;//-----------------------------------------------------------------
// SPEC : DATAWINDOW RESIZE ó��
//-----------------------------------------------------------------
// �ۼ����� : 2009-03-17  �ۼ��� : �̵���
// �ۼ����� : ���� ũ�⿡ ���� �ش� DATAWINDOW �ڵ� ũ�� ��ȯ
//-----------------------------------------------------------------

//wf_get_resize(1, this, dw_list, r_1, 1, 1, 0, 0)
//wf_get_resize(2, this, dw_insert, r_2, 1,0,0,0)

/*��ư*/
//p_exit.x = newwidth - 400
//p_mod.x = newwidth - 400 - (350 * 1)
//p_del.x = newwidth - 400 - (350 * 2)
//p_ins.x = newwidth - 400 - (350 * 3)
//p_inq.x = newwidth - 400 - (350 * 4)
//
//p_wait.x = newwidth/2 - 740
//p_wait2.x = newwidth/2 - 740

end event

type dw_insert from w_inherite`dw_insert within w_tht_4551
integer x = 23
integer y = 428
integer width = 4626
integer height = 2060
string dataobject = "d_tht_4551_e"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;string	sText,  sText2, sGub, sPdtgu, sWkctr, sInspChk
int		nReturn
decimal     ld_min, ld_max, ld_inspval

ib_any_typing = True

if row < 1 then
	return
end if

if this.GetColumnName( ) = 'insp_chkval' then
	ld_inspval	=	Dec(this.gettext( ))
	
	sGub = GetItemString(row, 'gubun')
	if sGub = '2' then
		ld_min = GetItemDecimal(row, 'spec_min')
		ld_max = GetItemDecimal(row, 'spec_max')
		
		if ld_min <= ld_inspval and ld_inspval <= ld_max then
			SetItem(row, 'insp_chk', 'OK')
		else
			SetItem(row, 'insp_chk', 'NG')
		end if
	end if

elseif	this.GetColumnName( ) = 'test1'  or this.GetColumnName( ) = 'test2'  or this.GetColumnName( ) = 'test3'  or this.GetColumnName( ) = 'test4' or this.GetColumnName( ) = 'test5' or this.GetColumnName( ) = 'test6' then
	
	sText	=	dwo.name
	sGub = GetItemString(row, 'gubun')
	if sGub = '2' then
		gs_gubun	=	'1'
		gs_code	=	this.getitemstring( row, sText)
		open(w_keypad_popup)
		
		if gs_code	=	''	or	isnull(gs_code)	then	return
		
		this.setitem(row, sText, gs_code)
		
		sInspChk = GetItemString(row, 'insp_chk')		//����
		if IsNull(sInspChk) or sInspChk = '' then
			
			this.setitem(row, 'insp_chkval', gs_code)
			
			ld_inspval = dec(gs_code)
			ld_min = GetItemDecimal(row, 'spec_min')
			ld_max = GetItemDecimal(row, 'spec_max')
			
			if ld_min <= ld_inspval and ld_inspval <= ld_max then
				SetItem(row, 'insp_chk', 'OK')
			else
				SetItem(row, 'insp_chk', 'NG')
			end if
		elseif sInspChk = 'OK' then
			this.setitem(row, 'insp_chkval', gs_code)
			
			ld_inspval = dec(gs_code)
			ld_min = GetItemDecimal(row, 'spec_min')
			ld_max = GetItemDecimal(row, 'spec_max')
			
			if ld_min <= ld_inspval and ld_inspval <= ld_max then
				SetItem(row, 'insp_chk', 'OK')
			else
				SetItem(row, 'insp_chk', 'NG')
			end if
		end if
				
	end if
end if

AcceptText()

end event

event dw_insert::clicked;call super::clicked;string	sText, sGub,	sItdsc, sWkctr, sMchno, sJidat, sSidat, sCharge, sWkctr2, sMchno2, smchnam2, sKumno, sInspChk
long		nRow, nCvqty, nCount, ii
decimal     ld_min, ld_max, ld_inspval

sText	=	dwo.name
nRow	=	row
nCount = this.rowcount()

if nRow < 1 then return

if left(sText, 2) = 't_' then
	sText	=	right(sText, len(sText) - 2)
end if

if	sText = 'insp_chkval' then
	sGub = GetItemString(nRow, 'gubun')
	if sGub = '2' then
		gs_gubun	=	'1'
		gs_code	=	this.getitemstring( nRow, sText)
		open(w_keypad_popup)
		
		if gs_code	=	''	or	isnull(gs_code)	then	return
		
		this.setitem(nRow, sText, gs_code)
		
		ld_inspval = dec(gs_code)
		ld_min = GetItemDecimal(nRow, 'spec_min')
		ld_max = GetItemDecimal(nRow, 'spec_max')
		
		if ld_min <= ld_inspval and ld_inspval <= ld_max then
			SetItem(nRow, 'insp_chk', 'OK')
		else
			SetItem(nRow, 'insp_chk', 'NG')
		end if
	end if
		
elseif	sText = 'test1'  or sText = 'test2'  or sText = 'test3'  or sText = 'test4' or sText = 'test5' or sText = 'test6' then
	
	sGub = GetItemString(nRow, 'gubun')
	if sGub = '2' then
		gs_gubun	=	'1'
		gs_code	=	this.getitemstring( nRow, sText)
		open(w_keypad_popup)
		
		if gs_code	=	''	or	isnull(gs_code)	then	return
		
		this.setitem(nRow, sText, gs_code)
		
		sInspChk = GetItemString(nRow, 'insp_chk')		//����
		if IsNull(sInspChk) or sInspChk = '' then
			
			this.setitem(nRow, 'insp_chkval', gs_code)
			
			ld_inspval = dec(gs_code)
			ld_min = GetItemDecimal(nRow, 'spec_min')
			ld_max = GetItemDecimal(nRow, 'spec_max')
			
			if ld_min <= ld_inspval and ld_inspval <= ld_max then
				SetItem(nRow, 'insp_chk', 'OK')
			else
				SetItem(nRow, 'insp_chk', 'NG')
			end if
		elseif sInspChk = 'OK' then
			this.setitem(nRow, 'insp_chkval', gs_code)
			
			ld_inspval = dec(gs_code)
			ld_min = GetItemDecimal(nRow, 'spec_min')
			ld_max = GetItemDecimal(nRow, 'spec_max')
			
			if ld_min <= ld_inspval and ld_inspval <= ld_max then
				SetItem(nRow, 'insp_chk', 'OK')
			else
				SetItem(nRow, 'insp_chk', 'NG')
			end if
		end if
				
	end if
	
end if

SetNull(gs_code)

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_tht_4551
boolean visible = false
integer x = 3753
integer y = 468
integer height = 220
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_tht_4551
boolean visible = false
integer x = 3579
integer y = 468
integer height = 220
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_tht_4551
boolean visible = false
integer x = 3566
integer y = 624
integer height = 220
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_tht_4551
boolean visible = false
integer x = 3749
integer y = 500
boolean enabled = false
end type

event p_ins::clicked;call super::clicked;if dw_list.accepttext( ) = -1 then return

long		nRow, nRow2
string	sItnbr

nRow = dw_list.getrow( )

if nRow < 1 then
	messagebox('ǰ�� ����', '����� ǰ���� �����ϼ���!')
	return
end if

sItnbr = dw_list.getitemstring(nRow, 'itnbr')

nRow2 = dw_insert.insertrow(0)

dw_insert.setitem(nRow2, 'itnbr', sItnbr)

end event

type p_exit from w_inherite`p_exit within w_tht_4551
boolean visible = false
integer x = 5559
integer y = 40
end type

type p_can from w_inherite`p_can within w_tht_4551
boolean visible = false
integer x = 5385
integer y = 40
end type

event p_can::clicked;call super::clicked;dw_ret.reset()
dw_ret.Insertrow(1)

is_today = f_today()
is_totime = left(f_totime(),4)

wf_load()

dw_insert.Reset()

p_inq.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_tht_4551
boolean visible = false
integer x = 3739
integer y = 624
integer height = 220
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_tht_4551
boolean visible = false
integer x = 5038
integer y = 40
end type

event p_inq::clicked;call super::clicked;SetPointer ( HourGlass! )
	wf_re()
SetPointer ( Arrow! )
end event

type p_del from w_inherite`p_del within w_tht_4551
boolean visible = false
integer x = 4608
integer y = 256
end type

event p_del::clicked;call super::clicked;if dw_list.accepttext( ) = -1 then return
if dw_insert.accepttext( ) = -1 then return

long		nRow, nCnt, nCount, ii, nChkcnt
String    sJpno, sPdtgu, sWkctr, sChk, sSidat1, sSidat2

if dw_list.accepttext( ) = -1 then return
if f_msg_delete() = -1 then return

nCount	=	dw_list.rowcount()

nChkcnt = 0
for ii = 1 to nCount
	sChk = dw_list.getitemstring(ii, 'chk')
	
	if sChk = 'Y' then  nChkcnt++
next

if nChkcnt = 0 then
	messagebox('���� ����', '������ �ڷḦ �����ϼ���!')
	return
end if

for ii = 1 to nCount
	sChk = dw_list.getitemstring(ii, 'chk')
	
	if sChk = 'N' then  continue
	
	sJpno = dw_list.GetItemString(ii, 'jpno')
	
	DELETE POP_INSPECTION_SELF
	WHERE JPNO = :sJpno;
	
	if sqlca.sqlcode <> 0 then 
		rollback ;
		messagebox("��������", String(ii)+" üũ �� ������ �����Ͽ����ϴ�")
		return
	end if

next

commit;

sPdtgu	=	dw_ret.getitemstring(1, 'pdtgu')
sWkctr	=	dw_ret.getitemstring(1, 'wkctr')
sSidat1	=	dw_ret.getitemstring(1, 'sidat')		//��������
sSidat2	=	dw_ret.getitemstring(1, 'sidat')

if sPdtgu = '' or isnull(sPdtgu) then	sPdtgu = '%'
if sWkctr = '' or isnull(sWkctr)	then	sWkctr = '%'

dw_list.retrieve( sSidat1, sSidat2, '%', '%', sPdtgu, '%', sWkctr )
end event

type p_mod from w_inherite`p_mod within w_tht_4551
boolean visible = false
integer x = 5211
integer y = 40
end type

event p_mod::clicked;call super::clicked;Integer nCount
nCount	=	dw_insert.rowcount()

If nCount = 0  then return

if f_msg_update() = -1 then return

//p_wait.visible = true
//p_wait2.visible = true

if wf_requiredChk() = -1 then return

if wf_save() = 1 then
	wf_re()
end if

//p_wait.visible = false
//p_wait2.visible = false

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_tht_4551
end type

type cb_mod from w_inherite`cb_mod within w_tht_4551
end type

type cb_ins from w_inherite`cb_ins within w_tht_4551
end type

type cb_del from w_inherite`cb_del within w_tht_4551
end type

type cb_inq from w_inherite`cb_inq within w_tht_4551
end type

type cb_print from w_inherite`cb_print within w_tht_4551
end type

type st_1 from w_inherite`st_1 within w_tht_4551
end type

type cb_can from w_inherite`cb_can within w_tht_4551
end type

type cb_search from w_inherite`cb_search within w_tht_4551
end type







type gb_button1 from w_inherite`gb_button1 within w_tht_4551
end type

type gb_button2 from w_inherite`gb_button2 within w_tht_4551
end type

type dw_ret from datawindow within w_tht_4551
integer x = 37
integer y = 24
integer width = 3301
integer height = 396
integer taborder = 120
string title = "none"
string dataobject = "d_tht_4551_c"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;if row < 1 then
	return
end if

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)
SetNull(gs_codename3)

string sItdsc, ls_wkctr, sPdtgu, sSidat, sRqcgu, sGbn, sSyscnf

if this.GetColumnName( ) = 'itnbr' or  this.GetColumnName( ) = 'itdsc' then
	
	// POPȯ�漳�� : ������������ǰ��(1:����ǰ��,2:�˻����ǰ��)
	SELECT DATANAME 
	INTO     :sSyscnf
	FROM SYSCNFG
      WHERE SYSGU = 'Y' AND SERIAL = 55 AND LINENO = '01';
		
	if sSyscnf = '2' then
	
		gs_code	=	'1'			/*ǰ�񱸺�*/
		open(w_inspitem_popup)
		
	else
		
	end if
	
	if gs_code = '' or isnull(gs_code) then
		return
	end if
	
	this.setitem(1, 'itnbr', gs_code)
	this.setitem(1, 'itdsc', gs_codename)	
	this.setitem(1, 'pdtgu', gs_codename3)	
	
	// ǥ�ذ����� �˻籸���� ���ְ˻� �� �ڷ� �� ��������
	SELECT A.WKCTR 
	INTO    :ls_wkctr
	FROM ROUTNG A
	WHERE A.ITNBR = :gs_code
	AND A.QCGUB = '1'
	AND A.OPSEQ =  (SELECT MAX(OPSEQ) FROM ROUTNG WHERE ITNBR = A.ITNBR)
	GROUP BY A.WKCTR;
			
	SetItem(1,"wkctr", ls_wkctr)
	
	If not isNull(gs_code) or gs_code <> '' then
		sPdtgu = GetItemString(row, 'pdtgu')
		sSidat = GetItemString(row, 'sidat')
		sRqcgu = GetItemString(row, 'rqcgu')
		
		SELECT NVL(MAX(GUBUN),'.')
		INTO    :sGbn
		FROM POP_INSPECTION_SELF
		WHERE ITNBR = :gs_code
		AND     PDTGU = :sPdtgu
		AND     SIDAT = :sSidat
		AND     RQCGU = :sRqcgu;
		
		IF sGbn = '.' or IsNull(sGbn) THEN
			SetItem(1, 'self_gbn', '1')					// �ʹ� ����
		ELSEIF sGbn = '1'  THEN
			SetItem(1, 'self_gbn', '2')					// �߹� ����
		ELSEIF sGbn = '2'  THEN
			SetItem(1, 'self_gbn', '3')					// ���� ����
		ELSEIF sGbn = '3'  THEN
			SetItem(1, 'self_gbn', '3')					// ���� ����
		END IF
		p_inq.TriggerEvent(Clicked!)
	End if
			
end if

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename3)
end event

event itemchanged;String  sNull,sPdtgu, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sjijil, sispeccode
String  sItemCls, sItemGbn, sItemClsName, ls_wkctr, sSidat, sRqcgu, sGbn
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	/* ǰ�� */
//	Case	"itnbr" 
//		sItnbr = Trim(GetText())
//		IF sItnbr ="" OR IsNull(sItnbr) THEN
//			SetItem(nRow,'itdsc',sNull)
//			SetItem(nRow,'itnbr',sNull)
//			Return
//		END IF
//		
//		SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
//				 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
//		  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
//		  FROM "ITEMAS","ITNCT"
//		 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
//				 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
//				 "ITEMAS"."ITNBR" = :sItnbr ;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			PostEvent(RbuttonDown!)
//			Return 2
//		END IF
//		
//		SetItem(nRow,"itdsc", sItdsc)
//		
//		// ǥ�ذ����� �˻籸���� ���ְ˻� �� �ڷ� �� ��������
//		SELECT A.WKCTR 
//		INTO    :ls_wkctr
//		FROM ROUTNG A
//		WHERE A.ITNBR = :sItnbr
//		AND A.QCGUB = '1'
//		AND A.OPSEQ =  (SELECT MAX(OPSEQ) FROM ROUTNG WHERE ITNBR = A.ITNBR)
//		GROUP BY A.WKCTR;
//				
//		SetItem(nRow,"wkctr", ls_wkctr)
//		
//		If not isNull(sItnbr) or sItnbr <> '' then
//			sPdtgu = GetItemString(row, 'pdtgu')
//			sSidat = GetItemString(row, 'sidat')
//			sRqcgu = GetItemString(row, 'rqcgu')
//			
//			SELECT NVL(MAX(GUBUN),'.')
//			INTO    :sGbn
//			FROM POP_INSPECTION_SELF
//			WHERE ITNBR = :sItnbr
//			AND     PDTGU = :sPdtgu
//			AND     SIDAT = :sSidat
//			AND     RQCGU = :sRqcgu;
//			
//			IF sGbn = '.' or IsNull(sGbn) THEN
//				SetItem(1, 'self_gbn', '1')					// �ʹ� ����
//			ELSEIF sGbn = '1'  THEN
//				SetItem(1, 'self_gbn', '2')					// �߹� ����
//			ELSEIF sGbn = '2'  THEN
//				SetItem(1, 'self_gbn', '3')					// ���� ����
//			ELSEIF sGbn = '3'  THEN
//				SetItem(1, 'self_gbn', '3')					// ���� ����
//			END IF
//			p_inq.TriggerEvent(Clicked!)
//		End if
			
	/* ǰ�� */
	Case "itdsc"
		sItdsc = trim(GetText())	
		IF sItdsc ="" OR IsNull(sItdsc) THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			Return
		END IF
		
		/* ǰ������ ǰ��ã�� */
		f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetColumn("itdsc")
			Return 1
		End If	
	Case "wkctr"
		ls_wkctr = trim(GetText())	
		Dw_Child.retrieve( ls_wkctr )
END Choose

//string	sText,  sText2, sGub
//int		nReturn
//
//
//if row < 1 then
//	return
//end if
//
//if this.GetColumnName( ) = 'itnbr' then
//	sText	=	this.gettext( )
//	nReturn	=	f_popup_itnbr('1', sText, sText2)
//	
//	this.setitem(1, 'itnbr', sText)
//	this.setitem(1, 'itdsc', sText2)
//	
//	return nReturn
//	
//	sText = Trim(GetText())
//	
//	IF sItnbr ="" OR IsNull(sItnbr) THEN
//		SetItem(nRow,'itnbr',sNull)
//		SetItem(nRow,'itdsc',sNull)
//		Return
//	END IF
//	
//	SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
//			 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
//	  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
//	  FROM "ITEMAS","ITNCT"
//	 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
//			 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
//			 "ITEMAS"."ITNBR" = :sItnbr ;
//	
//	IF SQLCA.SQLCODE <> 0 THEN
//		PostEvent(RbuttonDown!)
//		Return 2
//	END IF
//	
//	SetItem(nRow,"itdsc", sItdsc)
//	
//elseif this.GetColumnName( ) = 'itdsc' then
//	sText2	=	this.gettext( )
//	nReturn	=	f_popup_itnbr('1', sText, sText2)
//	
//	this.setitem(1, 'itnbr', sText)
//	this.setitem(1, 'itdsc', sText2)
//	
//	return nReturn
//end if

end event

event clicked;string	    sText, sItdsc, sWkctr, sPdtgu, sRqcgu, sSyscnf, sSidat, sGbn, s_cod, sItnbr
long		nRow, nCvqty, nCount, ii

sText	=	dwo.name
nCount = this.rowcount()

if row < 1 then return

if	dwo.name	=	'itnbr'	 then

    SetNull(gs_gubun)
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(gs_codename2)
	SetNull(gs_codename3)	
	
	sWkctr = This.GetItemString(row, 'wkctr')
	if IsNull(sWkctr) or sWkctr = '' then
		MessageBox('Ȯ��','�۾����� ���� �� �ּ���.')
//		this.SetFocus()
			this.SetColumn('wkctr')
		return
	end if		

//	gs_gubun = This.GetItemString(row, 'pdtgu')

	gs_gubun = sWkctr

	// POPȯ�漳�� : ������������ǰ��(1:����ǰ��,2:�˻����ǰ��)
	SELECT DATANAME 
	INTO     :sSyscnf
	FROM SYSCNFG
      WHERE SYSGU = 'Y' AND SERIAL = 55 AND LINENO = '01';
		
	if sSyscnf = '2' then
	
		gs_code	=	'1'			/*ǰ�񱸺�*/
		open(w_inspitem_popup)
		
		if gs_code = '' or isnull(gs_code) then
			return
		end if
		
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)	
		this.setitem(1, 'pdtgu', gs_codename3)
		
		// ǥ�ذ����� �˻籸���� ���ְ˻� �� �ڷ� �� ��������
		// ������ �۾����� ���������� ���� by shjeon 20151207
//		SELECT A.WKCTR 
//		INTO    :sWkctr
//		FROM ROUTNG A
//		WHERE A.ITNBR = :gs_code
//		AND A.QCGUB = '1'
//		AND A.OPSEQ =  (SELECT MAX(OPSEQ) FROM ROUTNG WHERE ITNBR = A.ITNBR)
//		GROUP BY A.WKCTR;
				
//		SetItem(1,"wkctr", sWkctr)
		
		If not isNull(sWkctr) or sWkctr <> '' then
			sPdtgu = GetItemString(row, 'pdtgu')
			sSidat = GetItemString(row, 'sidat')
			sRqcgu = GetItemString(row, 'rqcgu')
			
			wf_selfGbn(gs_code, sPdtgu, sSidat, sRqcgu)		// ������ �ڵ� ����
		End if
		
	else
		
	//	open(w_momast_popup_p)
	
		if gs_code = '' or isnull(gs_code) then
			return
		end if
		
		this.setitem(row, 'itnbr',  gs_code)
		this.setitem(row, 'itdsc',  gs_codename)
	//	this.setitem(row, 'ispec',  gs_codename3)
		this.setitem(row, 'pordno',  gs_codename2)
		
		IF gs_codename2 = 'X' OR isNull(gs_codename2) THEN
			
		ELSE
	//		SELECT PDTGU, DECODE(WKCTR,'.','',WKCTR), RQCGU
	//		INTO    :sPdtgu, :sWkctr, :sRqcgu
	//		FROM MOMAST_JUJO
	//		WHERE PORDNO = :gs_codename2;
			
			this.setitem(row, 'pdtgu',  sPdtgu)	
		//	Dw_Child2.retrieve( sPdtgu )
		//	this.setitem(row, 'wkctr',  sWkctr)
			this.setitem(row, 'rqcgu',  sRqcgu)
		END IF
	
	end if
	
      SetNull(gs_gubun)
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(gs_codename2)
	SetNull(gs_codename3)

	p_inq.TriggerEvent(Clicked!)
			
elseif dwo.name = 'sidat'  then
		
	p_2.TriggerEvent(Clicked!)
	
elseif dwo.name = 'insdat'  then
		
	p_1.TriggerEvent(Clicked!)
	
elseif dwo.name = 'sitim' then
	
	gs_gubun	=	'2'		// �ð��Է�
	gs_code	=	this.getitemstring( row, sText)
	open(w_keypad_popup)
	
	if gs_code	=	''	or	isnull(gs_code)	then	return
	
	this.setitem(row, 'sitim', gs_code)
	
	if "0800" >= gs_code and gs_code <= "1800" then 
		this.setitem(row, 'rqcgu', '1')		//�ְ�
	else
		this.setitem(row, 'rqcgu', '2')		//�߰�
	end if
	
elseif dwo.name = 'lotno' then
	
	gs_gubun	=	'1'	// �����Է�
	gs_code	=	this.getitemstring( row, 'lotno')
	open(w_keypad_popup)
	
	if gs_code	=	''	or	isnull(gs_code)	then	return
	
	this.setitem(row, 'lotno', gs_code)	
	
elseif dwo.name = 'rqcgu'  then
	s_cod = Trim(this.GetText())
	
	sItnbr = GetItemString(row, 'itnbr')
	If not isNull(sItnbr) or sItnbr <> '' then
		sPdtgu = GetItemString(row, 'pdtgu')
		sSidat = GetItemString(row, 'sidat')
		
		wf_selfGbn(sItnbr, sPdtgu, sSidat, s_cod)		// ������ �ڵ� ����
	End if
		
elseif dwo.name = 'wkctr'  then
	SetItem(row, 'itnbr','')
	SetItem(row, 'itdsc','')
	p_inq.TriggerEvent(Clicked!)
end if
end event

type p_1 from picture within w_tht_4551
integer x = 1856
integer y = 280
integer width = 119
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "c:\erpman\image\�޷�.gif"
boolean focusrectangle = false
end type

event clicked;String sDate
gsbom	=	'KOR'
OpenWithParm(w_date_select_p, em_date1)

sDate = trim(em_date1.text)

If IsNull(sDate ) or sDate = '' then
	return
End If

if len(sDate) = 8 then
	dw_ret.object.insdate[1] =  left(em_date1.text,4)+mid(em_date1.text,5,2)+mid(em_date1.text,7,2)
else
	dw_ret.object.insdate[1] =  left(em_date1.text,4)+mid(em_date1.text,6,2)+mid(em_date1.text,9,2)
end if 
end event

type p_2 from picture within w_tht_4551
integer x = 1856
integer y = 176
integer width = 119
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "c:\erpman\image\�޷�.gif"
boolean focusrectangle = false
end type

event clicked;String sDate, sItnbr, sPdtgu, sRqcgu, sSidat
gsbom	=	'KOR'
OpenWithParm(w_date_select_p, em_date2)

sDate = trim(em_date2.text)

If IsNull(sDate ) or sDate = '' then
	return
End If

if len(sDate) = 8 then
	dw_ret.object.sidat[1] =  left(em_date2.text,4)+mid(em_date2.text,5,2)+mid(em_date2.text,7,2)
else
	dw_ret.object.sidat[1] =  left(em_date2.text,4)+mid(em_date2.text,6,2)+mid(em_date2.text,9,2)
end if 

dw_ret.object.insdate[1] =  dw_ret.object.sidat[1]
dw_ret.object.lotno[1] =  dw_ret.object.sidat[1]

sSidat = dw_ret.object.sidat[1]

sItnbr = dw_ret.GetItemString(1, 'itnbr')
If not isNull(sItnbr) or sItnbr <> '' then
	sPdtgu = dw_ret.GetItemString(1, 'pdtgu')
	sRqcgu = dw_ret.GetItemString(1, 'rqcgu')
	
	wf_selfGbn(sItnbr, sPdtgu, sSidat, sRqcgu)		// ������ �ڵ� ����
End if
		
end event

type em_date1 from editmask within w_tht_4551
boolean visible = false
integer x = 4146
integer y = 224
integer width = 402
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

type em_date2 from editmask within w_tht_4551
boolean visible = false
integer x = 4155
integer y = 332
integer width = 402
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

type r_1 from roundrectangle within w_tht_4551
boolean visible = false
integer linethickness = 4
long fillcolor = 16777215
integer x = 3397
integer y = 216
integer width = 329
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type r_2 from roundrectangle within w_tht_4551
boolean visible = false
integer linethickness = 4
long fillcolor = 16777215
integer x = 3749
integer y = 216
integer width = 329
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_tht_4551
integer x = 23
integer y = 2504
integer width = 4626
integer height = 380
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_tht_4551_l"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;if row < 1 then
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(row, true)
this.SetRow(row)
this.SetRedraw(true)

//string	sItnbr
//
//sItnbr = this.getitemstring(row, 'itnbr')
//
//dw_insert.retrieve( sItnbr )
end event

event itemerror;return 1
end event

event retrieveend;If rowcount > 0 Then Event RowFocusChanged(1)
end event

event rowfocuschanged;If currentrow < 1 Then
	dw_insert.reset( )
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
this.SetRedraw(true)


end event

type pb_1 from picturebutton within w_tht_4551
integer x = 3337
integer y = 32
integer width = 325
integer height = 308
integer taborder = 90
integer textsize = -20
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ȸ"
boolean originalsize = true
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type pb_2 from picturebutton within w_tht_4551
integer x = 3662
integer y = 32
integer width = 325
integer height = 308
integer taborder = 100
integer textsize = -20
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����"
boolean originalsize = true
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;p_mod.TriggerEvent(Clicked!)
end event

type pb_3 from picturebutton within w_tht_4551
integer x = 3986
integer y = 32
integer width = 325
integer height = 308
integer taborder = 100
integer textsize = -20
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���"
boolean originalsize = true
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;p_can.TriggerEvent(Clicked!)
end event

type pb_4 from picturebutton within w_tht_4551
integer x = 4311
integer y = 32
integer width = 325
integer height = 308
integer taborder = 110
integer textsize = -20
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ݱ�"
boolean originalsize = true
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

