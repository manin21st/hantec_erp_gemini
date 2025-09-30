$PBExportHeader$w_pdt_02453.srw
$PBExportComments$����/ġ���� �����Ƿ� ���
forward
global type w_pdt_02453 from window
end type
type cb_delete from commandbutton within w_pdt_02453
end type
type cb_cancel from commandbutton within w_pdt_02453
end type
type cb_save from commandbutton within w_pdt_02453
end type
type st_message_text from statictext within w_pdt_02453
end type
type cb_exit from commandbutton within w_pdt_02453
end type
type sle_message_line from statictext within w_pdt_02453
end type
type gb_3 from groupbox within w_pdt_02453
end type
type gb_1 from groupbox within w_pdt_02453
end type
type dw_list from datawindow within w_pdt_02453
end type
type gb_2 from groupbox within w_pdt_02453
end type
end forward

global type w_pdt_02453 from window
integer x = 5
integer y = 884
integer width = 3657
integer height = 1300
boolean titlebar = true
string title = "����/ġ���� �����Ƿ�"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
cb_delete cb_delete
cb_cancel cb_cancel
cb_save cb_save
st_message_text st_message_text
cb_exit cb_exit
sle_message_line sle_message_line
gb_3 gb_3
gb_1 gb_1
dw_list dw_list
gb_2 gb_2
end type
global w_pdt_02453 w_pdt_02453

type variables
boolean ib_ItemError
char ic_status

String     is_today              //��������
String     is_cnvart             // ��ȯ������
sTring    is_cnvgu             // ��ȯ���뿩��
string     is_kestno            // �����Ƿڹ�ȣ
string     is_estno              // �����Ƿڹ�ȣ
end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_delete ()
public function integer wf_update ()
public function integer wf_item (string sitem, string sspec, long lrow)
public subroutine wf_cal_qty (decimal ad_qty, long al_row)
public subroutine wf_buy_unprc (long arg_row, string arg_itnbr, string arg_opseq)
public function integer wf_initial ()
end prototypes

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. ���� = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sToday, host_damcd, sCheck
dec		{3} dQty, dBalQty, dPrice
long		lRow, lCount

sToday = f_today()

lcount = dw_list.RowCount()

//�ý��۰������� �ʼ����θ� üũ�Ͽ� 'Y'�� ��� �ʼ��� üũ 
SELECT DATANAME  
  INTO :sCheck  
  FROM SYSCNFG  
 WHERE SYSGU = 'Y'  AND  SERIAL = 31  AND  LINENO = '1'    ;

if sqlca.sqlcode <> 0  then sCheck = 'N'

FOR	lRow = 1		TO		lCount

	// ǰ��
	sItem = dw_list.GetitemString(lRow, "itnbr")
	IF IsNull(sItem)	or   trim(sItem) = ''	THEN
		f_message_chk(30,'[ǰ��]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("itnbr")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	// �����
	sCode = dw_list.GetitemString(lRow, "saupj")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[�����]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("saupj")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	// �ŷ�ó
	sCode = dw_list.GetitemString(lRow, "cvcod")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[�ŷ�ó]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("cvcod")
		dw_list.setfocus()
		RETURN -1
	END IF

	//
	dQty = dw_list.getitemdecimal(lrow, "guqty")
	IF IsNull(dQty)  or  dQty = 0		THEN
		f_message_chk(30,'[���ſ䱸����]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("guqty")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	//
	dBalQty = dw_list.getitemdecimal(lrow, "vnqty")
	IF IsNull(dBalQty)  or  dBalQty = 0		THEN
		f_message_chk(30,'[���ֿ�������]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("vnqty")
		dw_list.setfocus()
		RETURN -1
	END IF

   //'Y'�� 	��� �ʼ� üũ
	IF sCheck = 'Y' then 
		sCode = dw_list.GetitemString(lRow, "order_no")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[���ֹ�ȣ]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("order_no")
			dw_list.setfocus()
			RETURN -1
		END IF
   END IF	

	sCode = dw_list.GetitemString(lRow, "rempno")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[�Ƿڴ����]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("rempno")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	//
	sCode = dw_list.GetitemString(lRow, "ipdpt")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[�԰���â��]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("ipdpt")
		dw_list.setfocus()
		RETURN -1
	END IF

	sCode = dw_list.GetitemString(lRow, "yebi1")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[�����ڵ�]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("yebi1")
		dw_list.setfocus()
		RETURN -1
	END IF

	// ��� : �Է°� ���� ��� -> '.' �Է�
	sCode = dw_list.GetitemString(lRow, "pspec")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		dw_list.SetItem(lRow, "pspec", '.')
	END IF


	// �������°� NULL�� ���
	sCode = dw_list.GetitemString(lRow, "itgu")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		dw_list.SetItem(lRow, "itgu", '1')
	END IF
	
	// �Է����ڰ� null�� ���
	sCode = trim(dw_list.GetitemString(lRow, "widat"))
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		dw_list.SetItem(lRow, "widat", sToday)
	END IF	
	
	// �Ƿ����ڰ� null�� ���
	sCode = trim(dw_list.GetitemString(lRow, "rdate"))
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		dw_list.SetItem(lRow, "rdate", sToday)
	END IF		
	
	// �������°� NULL�� ���
	sCode = dw_list.GetitemString(lRow, "suipgu")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		sCode = dw_list.GetitemString(lRow, "itgu")
		if scode = '3' or scode = '4' then
			dw_list.SetItem(lRow, "suipgu", '2')
		else
			dw_list.SetItem(lRow, "suipgu", '1')
		end if
	END IF
	
	// ���Ŵ���ڰ� null�� ���
	sCode = dw_list.GetitemString(lRow, "sempno")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		string sCvcod, sEmpno
		sCvcod = dw_list.GetitemString(lRow, "cvcod")
		
		setnull(sEmpno)
		SELECT A.EMP_ID
		  INTO :sEmpno
		  FROM "VNDMST" A
		 WHERE A.CVCOD = :sCvcod;
		 
		if sqlca.sqlcode <> 0 or isnull(sEmpno) or trim(sEmpno) = '' then	
			Setnull(host_damcd)
			select dataname
			  into :host_damcd
			  from syscnfg
			 where sysgu = 'Y' and serial = '14' and lineno = '1';
			dw_list.SetItem(lRow, "sempno", host_damcd)
		else
			dw_list.SetItem(lRow, "sempno", sempno)			
		end if
	END IF		

NEXT


RETURN 1
end function

public function integer wf_delete ();
string	sGubun
long		lRow, lRowCount
lRowCount = dw_list.RowCount()


FOR  lRow = lRowCount 	TO		1		STEP  -1
		
	sGubun = dw_list.GetItemString(lRow, "blynd")

	IF sGubun <> '1'	THEN
		MessageBox("Ȯ��", "����Ϸ�� �ڷ�� ������ �� �����ϴ�.~r" +	&
								 "LINE : " + string(lRow) )
		RETURN -1
	END IF

	dw_list.DeleteRow(lRow)
	
NEXT

// ����,�����Ƿڿ� �����Ƿڹ�ȣ�� Return
Update kumest Set estno = null
 Where sabu = :gs_sabu And kestno = :is_kestno;
 
if sqlca.sqlcode <> 0 then
	rollback;
	f_message_chk(32, '[�����Ƿ�]')	
	return -1
end if


RETURN 1
end function

public function integer wf_update ();string	sJpno, sDate
long		dSeq

sDate = f_today()

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')

IF dSeq < 1	 or dseq > 9999	THEN	
	f_message_chk(51, '')
   RETURN -1
END IF

COMMIT;


sJpno = sDate + string(dSeq, "0000") + string(1, "000")

dw_list.SetItem(1, "estno", sJpno)

// ����,�����Ƿڿ� �����Ƿڹ�ȣ�� Return
Update kumest Set estno = :sJpno
 Where sabu = :gs_sabu And kestno = :is_kestno;
 
if sqlca.sqlcode <> 0 then
	rollback;
	f_message_chk(32, '[�����Ƿ�]')	
	return -1
end if

MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r�����Ǿ����ϴ�.")

RETURN 1
end function

public function integer wf_item (string sitem, string sspec, long lrow);String sname, sitgu, snull, sispec, spumsr, sAccod, sjijil, sIspec_code
Decimal {3} dJegoqty, dInqty, dOutqty, DbALQTY
Decimal {6} dCnvfat 

Setnull(sNull)

SELECT Ltrim("ITEMAS"."ITDSC")||'.'||Ltrim("ITEMAS"."ISPEC")||'.'||Ltrim("ITEMAS"."ISPEC_CODE")||'.'||Ltrim("ITEMAS"."JIJIL") as itdsc,
		 "ITEMAS"."ITGU", 
		 "ITEMAS"."PUMSR", 
		 "ITEMAS"."CNVFAT" 
  INTO :sName, 
		 :sItgu, :sPumsr, :dCnvfat  
  FROM "ITEMAS"
 WHERE ( "ITEMAS"."ITNBR" = :sItem )	AND
		 ( "ITEMAS"."USEYN" = '0' ) ;                   
 
IF sqlca.sqlcode <> 0		THEN
	f_message_chk(33,'[ǰ��]')
	dw_list.setitem(lRow, "itnbr", sNull)	
	dw_list.SetItem(lRow, "itemas_itdsc", sNull)
	dw_list.SetItem(lRow, "itemas_pumsr", sNull)
	dw_list.SetItem(lRow, "yebi1", sNull)
	dw_list.SetItem(lRow, "itgu",   sNull)
	dw_list.SetItem(lRow, "suipgu", sNull)
	dw_list.setitem(lrow, "cnvfat", 1)
	RETURN 1
END IF

dw_list.SetItem(lRow, "itemas_itdsc", sName)
dw_list.SetItem(lRow, "itemas_pumsr", sPumsr)
if sitgu >= '1' and sitgu <= '6' then
	dw_list.setitem(lrow, "itgu", sitgu)
else
	dw_list.setitem(lrow, "itgu", '1')
end if
if sitgu = '3' or sitgu = '4' then
	dw_list.SetItem(lRow, "suipgu", '2')
else
	dw_list.SetItem(lRow, "suipgu", '1')
end if	

// ��ȯ��� ����
if isnull(dCnvfat) or dCnvfat = 0 then
	dCnvfat = 1
end if

if is_cnvgu = 'Y' then
	dw_list.setitem(lrow, "cnvfat", dcnvfat)
else
	dw_list.setitem(lrow, "cnvfat", 1)
end if

dBalqty = dw_list.getItemdecimal(LROW, "vnqty")

// ���ִ����� ���� ��ü���ַ� ��ȯ(�Ҽ��� 2�ڸ� ������ ���)
if dw_list.getitemstring(LROW, "cnvart") = '/' then
	if dBalqty = 0 then
		dw_list.Setitem(LROW, "cnvqty",	0)	
	Else
		dw_list.Setitem(LROW, "cnvqty",	round(dBalqty / dw_list.getitemdecimal(LROW, "cnvfat"),2))
	end if
else
	dw_list.Setitem(LROW, "cnvqty",	round(dBalqty * dw_list.getitemdecimal(LROW, "cnvfat"),2))
end if

wf_buy_unprc(lrow, sitem, dw_list.getitemstring(lrow, "opseq"))

sAccod = SQLCA.FUN_GET_ITNACC(sitem, '4') ;
dw_list.setitem(lrow, "yebi1", sAccod)
		
return 0
end function

public subroutine wf_cal_qty (decimal ad_qty, long al_row);
IF dw_list.AcceptText() = -1	THEN	RETURN 

string	sItem
dec		{3} dBalQty, dMinqt, dMulqt
dec		{3} dMul


sItem  = dw_list.GetItemString(al_Row, "itnbr")
dBalQty = dw_list.GetItemDecimal(al_Row, "vnqty")

//IF IsNull(sItem) or sItem = ''	THEN	RETURN
	
  SELECT NVL("ITEMAS"."MINQT", 1),    
         NVL("ITEMAS"."MULQT", 1)   
    INTO :dMinqt,   
         :dMulqt  
    FROM "ITEMAS"  
   WHERE "ITEMAS"."ITNBR" = :sItem   ;
	
IF isnull(dMinqt) or DMINQT < 1 THEN dminqt = 1
IF isnull(dMulqt) or DMulQT < 1 THEN dmulqt = 1

IF ad_qty < dMinqt 	THEN
	dBalQty = dMinqt
ELSE

	IF dMulqt =	0	THEN	
		dMul = 1
	ELSE
		dMul = dMulqt
	END IF
	
	dBalQty = dMinqt + ( CEILING( (ad_Qty - dMinqt) / dMul ) * dMulqt)
	
END IF

dw_list.SetItem(al_Row, "vnqty", 	dBalQty)

// ���ִ����� ���� ��ü���ַ� ��ȯ(�Ҽ��� 2�ڸ� ������ ���)
if dw_list.getitemdecimal(al_row, "cnvfat") = 1  then
	dw_list.Setitem(al_row, "cnvqty", dBalqty)
elseif dw_list.getitemstring(al_row, "cnvart") = '/' then
	if dBalqty = 0 then
		dw_list.Setitem(al_row, "cnvqty",	0)	
	Else
		dw_list.Setitem(al_row, "cnvqty",	round(dBalqty / dw_list.getitemdecimal(Al_row, "cnvfat"),2))
	end if
else
	dw_list.Setitem(al_row, "cnvqty",	round(dBalqty * dw_list.getitemdecimal(Al_row, "cnvfat"),2))
end if

end subroutine

public subroutine wf_buy_unprc (long arg_row, string arg_itnbr, string arg_opseq);//String sCvcod, sTuncu ,sCvnas
//Decimal {5} dUnprc
//
//f_buy_unprc(arg_itnbr, arg_opseq, sCvcod, sCvnas, dUnprc, sTuncu)
//
//if isnull(dUnprc) then dUnprc = 0 
//
//dw_list.setitem(arg_row, "cvcod", scvcod)
//dw_list.setitem(arg_row, "vndmst_cvnas2", sCvnas)
//dw_list.setitem(arg_row, "cnvprc", dunprc)
//dw_list.setitem(arg_row, "tuncu", stuncu)
//
//// ���ֿ����ܰ� ��ȯ
//if dw_list.getitemdecimal(arg_row, "cnvfat") = 1 then
//	dw_list.setitem(arg_row, "unprc", dunprc)
//elseif dw_list.getitemstring(arg_row, "cnvart") = '/' then
//	dw_list.setitem(arg_row, "unprc", round(dunprc / dw_list.getitemdecimal(arg_row, "cnvfat"),5))
//else
//	dw_list.setitem(arg_row, "unprc", round(dunprc * dw_list.getitemdecimal(arg_row, "cnvfat"),5))
//end if
end subroutine

public function integer wf_initial ();string scode, sname, sname1, sitnbr, smchno, skumno, syodat, sempno, sdeptcode, sempname, scvcod, scvnas, semp_id
decimal {3} drate, dqty, dprc

// ����/�����Ƿ� �⺻������ �˻�
select a.kumno, a.mchno, a.unqty, a.citnbr, a.yodat, a.estemp, a.unprc, a.wicvcod, b.cvnas2, b.emp_id
  into :skumno, :smchno, :dqty,   :sitnbr,  :syodat, :sempno, :dprc,    :scvcod,   :scvnas, :semp_id
  From kumest a, vndmst b 
 where a.sabu    = :gs_sabu And a.kestno = :is_kestno
   and a.wicvcod = b.cvcod(+) ;
 
if sqlca.sqlcode <> 0 then
	f_message_chk(169, '[���������Ƿ� ��ǥ]')
	return -1
end if

dw_list.setitem(1, "kumno", 		skumno)
dw_list.setitem(1, "mchno", 		smchno)
dw_list.setitem(1, "itnbr", 		sitnbr)
dw_list.setitem(1, "guqty", 		dqty)
dw_list.setitem(1, "vnqty", 		dqty)
dw_list.setitem(1, 'yodat',   	syodat)
dw_list.setitem(1, 'rempno',   	sempno)

dw_list.setitem(1, 'unprc',   	   dprc)
dw_list.setitem(1, 'cvcod',   	   scvcod)
dw_list.setitem(1, 'vndmst_cvnas2', scvnas)
dw_list.SetItem(1, "sempno",        sEmp_id)	

// �Ƿڴ���� �μ��� Setting
select empname, deptcode into :sempname, :sdeptcode
  From p1_master
 where empno = :sempno;
 
dw_list.setitem(1, 'rdptno',   	sdeptcode) 
dw_list.setitem(1, "p1_master_empname",   sempname)


// ���������� Setting
SELECT "KUMMST"."KUMNAME", "KUMMST"."KSPEC", "KUMMST"."KRATE"
 INTO :sname, :sname1, :drate
 FROM "KUMMST"  
WHERE ( "KUMMST"."SABU" =  :gs_sabu) AND  
		( "KUMMST"."KUMNO" = :skumno )   ;
	 
IF sqlca.sqlcode <> 0		THEN
	f_message_chk(33,'[����/ġ���� ��ȣ]')
	RETURN -1
END IF
dw_list.setitem(1, 'kummst_kumname', sName)
dw_list.setitem(1, 'kummst_kspec',   sName1)
dw_list.setitem(1, 'kummst_krate',   drate)

if smchno > '.' then 
	SELECT MCHNAM  
	 INTO :sname
	 FROM MCHMST  
	WHERE SABU  = :gs_sabu AND  
			MCHNO = :smchno    ;
		 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[���� ��ȣ]')
		RETURN -1
	End if
	dw_list.setitem(1, 'mchmst_mchnam', sName)
end if

if wf_item(sitnbr, '.', 1) = 1 then
	return -1
end if

return 1
	 

end function

event open;is_today = f_today()

is_kestno = gs_code
is_estno  = gs_codename

//////////////////////////////////////////////////////////////////////////////////
// ���ִ��� ��뿡 ���� ȭ�� ����
sTring sCnvgu, sCnvart

/* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

/* �����Ƿ� -> ����Ȯ�� �����ڸ� ȯ�漳������ �˻��� */
select dataname
  into :sCnvart
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '4';
If isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '*'
End if
is_cnvart = sCnvart

if sCnvgu = 'Y' then // ���ִ��� ����
	is_cnvgu  = 'Y'
	dw_list.dataobject = 'd_pdt_02453_2'
Else						// ���ִ��� ������
	is_cnvgu  = 'N'	
	dw_list.dataobject = 'd_pdt_02453_1'	
End if

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_list.settransobject(sqlca)

if isnull(is_estno) then  // �����Ƿڹ�ȣ�� �ִ� ��쿡�� ����, null�̸� ���

	ic_status = '1'	// ���
	
	dw_list.insertrow(0)
	
   //	����� ��쿡�� �Ƿ� �ڷḦ Move
	if wf_initial() = -1 then
		close(this)
		return
	end if
	
	cb_save.enabled = true
	cb_delete.enabled = False

Else
	
	ic_status = '2'	// ����
	
	if dw_list.retrieve(gs_sabu, is_estno) < 1 then
		f_message_chk(50, '[�����Ƿ�]')
		close(this)
		return		
	end if
	
	if dw_list.getitemstring(1, "blynd") > '1' then
		messagebox("�����Ƿ�", "������ �����̹Ƿ� ������ �Ұ��մϴ�", information!)
		cb_save.enabled = false
		cb_delete.enabled = false
	else
		cb_save.enabled = true
		cb_delete.enabled = true
	end if
end if

end event

on w_pdt_02453.create
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.st_message_text=create st_message_text
this.cb_exit=create cb_exit
this.sle_message_line=create sle_message_line
this.gb_3=create gb_3
this.gb_1=create gb_1
this.dw_list=create dw_list
this.gb_2=create gb_2
this.Control[]={this.cb_delete,&
this.cb_cancel,&
this.cb_save,&
this.st_message_text,&
this.cb_exit,&
this.sle_message_line,&
this.gb_3,&
this.gb_1,&
this.dw_list,&
this.gb_2}
end on

on w_pdt_02453.destroy
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.st_message_text)
destroy(this.cb_exit)
destroy(this.sle_message_line)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.dw_list)
destroy(this.gb_2)
end on

type cb_delete from commandbutton within w_pdt_02453
integer x = 425
integer y = 932
integer width = 361
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "����(&D)"
end type

event clicked;//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Delete() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
END IF

cb_exit.TriggerEvent("clicked")
	
	

end event

type cb_cancel from commandbutton within w_pdt_02453
boolean visible = false
integer x = 2487
integer y = 2236
integer width = 347
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "���(&C)"
end type

type cb_save from commandbutton within w_pdt_02453
integer x = 64
integer y = 932
integer width = 347
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

event clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. ���� = 0		-> RETURN
//		2. ��ǥä������('A0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq
string sdate

sDate = f_today()

IF	wf_CheckRequiredField() = -1		THEN		
	dw_list.setfocus()
	RETURN
END IF

IF f_msg_update() = -1 	THEN	RETURN
/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_update() = -1 THEN RETURN 

END IF

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	
	COMMIT;

ELSE
	ROLLBACK;
	f_Rollback()
END IF

cb_exit.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type st_message_text from statictext within w_pdt_02453
integer x = 23
integer y = 1088
integer width = 325
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
string text = "�޼���"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_pdt_02453
event key_in pbm_keydown
integer x = 3168
integer y = 932
integer width = 370
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type sle_message_line from statictext within w_pdt_02453
integer x = 352
integer y = 1088
integer width = 3232
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_pdt_02453
integer x = 3127
integer y = 876
integer width = 457
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_pdt_02453
integer x = 23
integer y = 876
integer width = 814
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_pdt_02453
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 55
integer y = 52
integer width = 3497
integer height = 816
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_02453_2"
boolean border = false
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;setnull(gs_code)
setnull(gs_codename)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF this.GetColumnName() = 'cvcod'	THEN
		
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
	
      if gs_code = '' or isnull(gs_code) then return 		
	
		SetItem(this.getrow(),"cvcod",gs_code)

		this.TriggerEvent("itemchanged")
		
	END IF
END IF
end event

event itemchanged;string	sNull
string	sCode,  sName, 	&
			sItem,  sSpec, &
			sEmpno, sDate,	sItdsc, sIspec, sItnbr, sOpseq, sTuncu, sItgu
long		lRow, lReturnRow
dec {5}	dPrice
dec {2}	dQty, dBalQty, djegoqty, dInqty, dOutqty
Integer  iReturn
SetNull(sNull)

lRow  = this.GetRow()	

if this.getcolumnname() = "guqty" 	then

	dQty	= dec(this.GetText())
	
	wf_Cal_Qty(dQty, lRow)
	
// �ŷ�ó
ELSEIF this.GetColumnName() = "cvcod" THEN
	sCode  = this.GetText()								
	if sCode = "" or isnull(sCode) then 
		THIS.SETITEM(LROW, "CVCOD", SNULL)
		THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNULL)
		return 
	end if

	/* �ŷ�ó Ȯ�� */
   SELECT A.CVNAS, A.EMP_ID
     INTO :sName, :sEmpno
     FROM "VNDMST" A
    WHERE A.CVCOD = :sCode
	 	AND A.CVGU IN ('1','2','9'); 
		 
	IF SQLCA.SQLCODE <> 0 THEN
		THIS.SETITEM(LROW, "CVCOD", SNULL)
		THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNULL)
		THIS.SETITEM(LROW, "sempno", SNULL)
		F_MESSAGE_CHK(33, '[�ŷ�ó]')
		RETURN 1
	END IF
	
	THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNAME)
	this.SetItem(lRow, "sempno", sEmpno)	
	
// �Ƿڴ���� 
ELSEIF this.GetColumnName() = "rempno" THEN

	sCode = this.GetText()
	SELECT EMPNAME
	  INTO :sName
	  FROM P1_MASTER
	 WHERE EMPNO = :sCode	AND
	 		 SERVICEKINDCODE <> '3'	;
	IF sqlca.sqlcode = 100 	THEN
		this.triggerevent(RbuttonDown!)
	   return 1
	ELSE
		this.setitem(lRow, 'p1_master_empname', sName)
   END IF
// ���ֹ�ȣ
ELSEIF this.GetColumnName() = "order_no" THEN

	sCode = this.GetText()
	
	IF scode = '' or isnull(scode) then return 

  SELECT "SORDER"."SABU"  
    INTO :sName  
    FROM "SORDER"  
   WHERE ( "SORDER"."SABU" = :gs_sabu ) AND  
         ( "SORDER"."ORDER_NO" = :sCode )   ; 
	 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[���ֹ�ȣ]')
		this.setitem(lRow, "order_no", sNull)	
		RETURN 1
	END IF

// ���ſ䱸�� > ���ֿ����� �̸� ERROR
ELSEIF this.GetColumnName() = "vnqty" THEN

	dBalQty = dec(this.GetText())
	dQty = this.GetItemDecimal(lRow, "guqty")
	IF dQty > dBalQty		THEN
		MessageBox("Ȯ��", "���ֿ������� ���ſ䱸������ Ŀ���մϴ�.")
		RETURN 1
	END IF
	
// ����䱸��
ELSEIF this.GetColumnName() = 'yodat' THEN

	sDate  = TRIM(this.gettext())

	IF sdate = '' or isnull(sdate) then return 

	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "yodat", sNull)
		return 1
	END IF

// �ܰ�
elseif this.getcolumnname() = 'unprc' then
	dprice = dec(this.gettext())
	// ���ֿ����ܰ� ��ȯ
	if dw_list.getitemdecimal(lrow, "cnvfat") = 1   then
		dw_list.setitem(lrow, "cnvprc", dprice)
	elseif dw_list.getitemstring(Lrow, "cnvart") = '/' then
		dw_list.setitem(Lrow, "cnvprc", round(dprice * dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	else
		dw_list.setitem(Lrow, "cnvprc", round(dprice / dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	end if		
ELSEIF this.GetColumnName() = 'kumno' then
	 
	sCode = this.GetText()
	
	if isnull(scode) or scode = '' then 
		this.setitem(lRow, 'kummst_kumname', sNull)
      return 
	end if
	
  SELECT "KUMMST"."KUMNAME"  
    INTO :sname
    FROM "KUMMST"  
   WHERE ( "KUMMST"."SABU" =  :gs_sabu) AND  
         ( "KUMMST"."KUMNO" = :scode )   ;
	 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[����/ġ���� ��ȣ]')
		this.setitem(lRow, 'kumno', sNull)
		this.setitem(lRow, 'kummst_kumname', sNull)
		RETURN 1
	else
		this.setitem(lRow, 'kummst_kumname', sName)
	END IF
ELSEIF this.GetColumnName() = 'mchno' then
	sCode = this.GetText()
	
	if isnull(scode) or scode = '' then 
		this.setitem(lRow, 'mchmst_mchnam', sNull)
      return 
	end if
	
  SELECT MCHNAM  
    INTO :sname
    FROM MCHMST  
   WHERE SABU  = :gs_sabu AND  
         MCHNO = :scode    ;
	 
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[���� ��ȣ]')
		this.setitem(lRow, 'mchno', sNull)
		this.setitem(lRow, 'mchmst_mchnam', sNull)
		RETURN 1
	else
		this.setitem(lRow, 'mchmst_mchnam', sName)
	END IF
	 
END IF


end event

event itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column �� �ƴ� Column ���� Error �߻��� 

IF ib_ItemError = true	THEN	
	ib_ItemError = false		
	RETURN 1
END IF



//	2) Required Column  ���� Error �߻��� 

string	sColumnName
sColumnName = dwo.name + "_t.text"


sle_message_line.text = "  �ʼ��Է��׸� :  " + this.Describe(sColumnName) + "   �Է��ϼ���."

RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

// ǰ��
IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup)
	
	IF gs_code = '' or isnull(gs_code) then return 
	
	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	SetItem(lRow,"itemas_ispec",gs_gubun)
	
	this.TriggerEvent("itemchanged")
// �ŷ�ó
ELSEIF this.GetColumnName() = 'cvcod'	THEN
	sle_message_line.text = '�Ϲ� �ŷ�ó ��ȸ�� F2 KEY �� ��������!'
	
	gs_code 		= getitemstring(lrow, "itnbr")
	gs_codename = getitemstring(lrow, "opseq")

	Open(w_danmst_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(lRow,"cvcod",gs_code)
	SetItem(lRow,"unprc",Dec(gs_codename))
	
	setnull(gs_code)
	setnull(gs_codename)

	this.TriggerEvent("itemchanged")
	
// �Ƿڴ����
elseIF this.GetColumnName() = 'rempno'	THEN

	Open(w_sawon_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(lRow,"rempno",gs_code)
	SetItem(lRow,"p1_master_empname",gs_codename)

// ���ֹ�ȣ
ELSEIF this.GetColumnName() = 'order_no'	THEN

	Open(w_suju_popup)

	IF gs_code = '' or isnull(gs_code) then return 
	
	SetItem(lRow,"order_no",gs_code)

// ����/ġ���� ��ȣ
ELSEIF this.GetColumnName() = 'kumno' then
	 
	 open(w_imt_04630_popup)
	 
	 if gs_code = '' or isnull(gs_code) then return
	 
	 SetItem(lRow, "kumno",gs_code)
	 SetItem(lRow, "kummst_kumname", gs_codename)

ELSEIF this.GetColumnName() = 'mchno' then
	 
	 open(w_mchmst_popup)
	 
	 if gs_code = '' or isnull(gs_code) then return
	  
	 SetItem(lRow, "mchno", gs_code )
	 SetItem(lRow, "mchmst_mchnam", gs_codename)


END IF




end event

event doubleclicked;Long Lrow

Lrow = getrow()

if Lrow <  1 then return

gs_code 		= getitemstring(Lrow, "itnbr")
gs_codename = getitemstring(Lrow, "itemas_itdsc")

if isnull(gs_code) or trim(gs_code) = '' or isnull(gs_codename) or trim(gs_codename) = '' then
	return
end if


open(w_pdt_04000_1)

setnull(gs_code)
setnull(gs_codename)
end event

event getfocus;sle_message_line.text = '��� ���� �������� Doublic Click�� �Ͻʽÿ�'
end event

event rowfocuschanged;sle_message_line.text = '��� ���� �������� Doublic Click�� �Ͻʽÿ�'
end event

type gb_2 from groupbox within w_pdt_02453
integer x = 23
integer width = 3561
integer height = 876
integer taborder = 10
integer textsize = -7
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

