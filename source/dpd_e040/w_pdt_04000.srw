$PBExportHeader$w_pdt_04000.srw
$PBExportComments$�����Ƿڵ��
forward
global type w_pdt_04000 from window
end type
type pb_2 from u_pb_cal within w_pdt_04000
end type
type pb_1 from u_pb_cal within w_pdt_04000
end type
type cb_2 from commandbutton within w_pdt_04000
end type
type cb_1 from commandbutton within w_pdt_04000
end type
type p_all from picture within w_pdt_04000
end type
type dw_hidden from datawindow within w_pdt_04000
end type
type p_exit from uo_picture within w_pdt_04000
end type
type p_can from uo_picture within w_pdt_04000
end type
type p_del from uo_picture within w_pdt_04000
end type
type p_mod from uo_picture within w_pdt_04000
end type
type p_delrow from uo_picture within w_pdt_04000
end type
type p_addrow from uo_picture within w_pdt_04000
end type
type p_inq from uo_picture within w_pdt_04000
end type
type cb_delete from commandbutton within w_pdt_04000
end type
type cb_cancel from commandbutton within w_pdt_04000
end type
type cb_del from commandbutton within w_pdt_04000
end type
type cb_insert from commandbutton within w_pdt_04000
end type
type rb_delete from radiobutton within w_pdt_04000
end type
type rb_insert from radiobutton within w_pdt_04000
end type
type dw_detail from datawindow within w_pdt_04000
end type
type cb_save from commandbutton within w_pdt_04000
end type
type cb_exit from commandbutton within w_pdt_04000
end type
type cb_retrieve from commandbutton within w_pdt_04000
end type
type rr_3 from roundrectangle within w_pdt_04000
end type
type rr_1 from roundrectangle within w_pdt_04000
end type
type rr_2 from roundrectangle within w_pdt_04000
end type
type dw_list from datawindow within w_pdt_04000
end type
end forward

global type w_pdt_04000 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "�����Ƿڵ��"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_2 pb_2
pb_1 pb_1
cb_2 cb_2
cb_1 cb_1
p_all p_all
dw_hidden dw_hidden
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_delrow p_delrow
p_addrow p_addrow
p_inq p_inq
cb_delete cb_delete
cb_cancel cb_cancel
cb_del cb_del
cb_insert cb_insert
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
rr_3 rr_3
rr_1 rr_1
rr_2 rr_2
dw_list dw_list
end type
global w_pdt_04000 w_pdt_04000

type variables
Boolean ib_any_typing     
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����
String     is_cnvart             // ��ȯ������
sTring     is_cnvgu             // ��ȯ���뿩��
String     is_empno            //���Ŵ����
String     is_outemp            //���ִ����
String     is_gwgbn            // �׷���� ��������

Transaction SQLCA1				// �׷���� ���ӿ�
String     isHtmlNo = '00021'	// �׷���� ������ȣ
end variables

forward prototypes
public subroutine wf_cal_qty (decimal ad_qty, long al_row)
public function integer wf_checkrequiredfield ()
public function integer wf_warndataloss (string as_titletext)
public function integer wf_update ()
public function integer wf_initial ()
public function integer wf_delete ()
public subroutine wf_buy_unprc (long arg_row, string arg_itnbr, string arg_pspec, string arg_opseq)
public function integer wf_item (string sitem, string sspec, long lrow)
public function integer wf_create_gwdoc ()
end prototypes

public subroutine wf_cal_qty (decimal ad_qty, long al_row);
IF dw_list.AcceptText() = -1	THEN	RETURN 

string	sItem
dec{3}	dBalQty, dMinqt, dMulqt, dMul


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
		dw_list.Setitem(al_row, "cnvqty",	round(dBalqty / dw_list.getitemdecimal(Al_row, "cnvfat"),3))
	end if
else
	dw_list.Setitem(al_row, "cnvqty",	round(dBalqty * dw_list.getitemdecimal(Al_row, "cnvfat"),3))
end if




end subroutine

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. ���� = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sItem, sCode, sToday, host_damcd, sCheck, soutemp, sIpdpt, sJuprod, sIttyp
dec{3}	dQty, dBalQty
DEC{2}   dPrice
long		lRow, lCount

sToday = f_today()

lcount = dw_list.RowCount()

//�ý��۰������� �ʼ����θ� üũ�Ͽ� 'Y'�� ��� �ʼ��� üũ 
SELECT DATANAME  
  INTO :sCheck  
  FROM SYSCNFG  
 WHERE SYSGU = 'Y'  AND  SERIAL = 31  AND  LINENO = '1'    ;

if sqlca.sqlcode <> 0  then sCheck = 'N'

// �԰���â�� MRO�� ��� �Ƿڱ����� MRO�� �����Ѵ�
sIpdpt = dw_detail.GetItemString(1, 'ipdpt')
SELECT JUPROD INTO :sJuprod FROM VNDMST WHERE CVCOD = :sIpdpt;
If sJuprod = 'Z' Then
	dw_detail.SetItem(1, 'gubun', '9')
End If
	
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

//	IF dQty > dBalQty		THEN
//		MessageBox("Ȯ��", "���ֿ������� ���ſ䱸������ Ů�ϴ�.")
//		dw_list.ScrollToRow(lrow)
//		dw_list.Setcolumn("vnqty")
//		dw_list.setfocus()
//		RETURN -1
//	END IF
	
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

	// ����ǰ �Ҹ�ǰ�� ��� �뵵 �ʼ� �Է�
	sIttyp = dw_list.GetitemString(lRow, "itemas_ittyp")
	
	If sIttyp > '4' Then 
		sCode = dw_list.GetitemString(lRow, "yongdo")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			f_message_chk(30,'[�뵵]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("yongdo")
			dw_list.setfocus()
			RETURN -1
		END IF
	End If
	
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
		setnull(soutEmp)		
		SELECT A.EMP_ID, A.OUTORDER_EMP
		  INTO :sEmpno, :soutemp
		  FROM "VNDMST" A
		 WHERE A.CVCOD = :sCvcod;
		 
		if dw_detail.getitemstring(1, "gubun") = '3' then
			if soutEmp = '' or isnull(soutEmp) then soutEmp = is_outemp //���ִ���ڰ� ���� �� �⺻���ִ��
			dw_list.SetItem(lRow, "sempno", soutEmp)									
		Else
			if sEmpno = '' or isnull(sEmpno) then sEmpno = is_empno //���Ŵ���ڰ� ���� �� �⺻���Ŵ��
			dw_list.SetItem(lRow, "sempno", sEmpno)					
		End if		
		
	END IF		


	/////////////////////////////////////////////////////////////////////////
	//	1. ������ -> ���߰��� data�� �Ƿڹ�ȣ : �������� + 1 ->SETITEM
	// 2. ��ǥ��ȣ�� NULL �ΰ͸� �������� + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_list.GetitemString(lRow, "estno")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_list.SetItem(lRow, "estno", is_Last_Jpno)
		END IF
	END IF

NEXT


RETURN 1
end function

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : ����, ��Ͻ� ȣ���
		    dw_detail �� typing(datawindow) ������� �˻�

		 2. ��������� ��� ��������� ������� ������ ���                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : ��������� �������� �ʰ� ��� ������ ���.
			* -1 : ������ �ߴ��� ���.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)�� typing ����Ȯ��

	Beep(1)
	IF MessageBox("Ȯ�� : " + as_titletext , &
		 "�������� ���� ���� �ֽ��ϴ�. ~r��������� �����Ͻðڽ��ϱ�", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) �� ��������� ���ų� no�� ���
														// ��������� �������� �ʰ� ������� 

end function

public function integer wf_update ();string	sJpno, sDate
long		lRow, dSeq

if dw_detail.AcceptText() = -1 then return -1

sDate = trim(dw_detail.GetItemString(1, "sdate"))

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')

IF dSeq < 1	 or dseq > 9999	THEN	
	ROLLBACK ;
	f_message_chk(51, '')
   RETURN -1
END IF

COMMIT;

sJpno = sDate + string(dSeq, "0000")

FOR	lRow = 1		TO		dw_list.RowCount()
	dw_list.SetItem(lRow, "estno", sJpno + string(lRow, "000"))
NEXT

MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r�����Ǿ����ϴ�.")

RETURN 1
end function

public function integer wf_initial ();string sempno, sempnm, sDept, sname, ls_next_day

dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()

//cb_save.enabled = false
p_del.enabled = false
p_del.picturename = "C:\erpman\image\����_d.gif"
dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// ��Ͻ�
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("sDATE", 10)
	dw_detail.settaborder("saupj", 20)
	dw_detail.settaborder("GUBUN", 30)
	dw_detail.settaborder("EDATE", 40)
//	dw_detail.settaborder("DEPT",  50)
	dw_detail.settaborder("empno",  60)
	dw_detail.settaborder("ipdpt",  80)
	
	dw_detail.SetItem(1, "sdate", is_Date)
	//����䱸���� 7�� ����
   select to_char(to_date(sysdate)+7,'yyyymmdd') into :ls_next_day
	  from dual;
	dw_detail.SetItem(1, "edate", ls_next_day)
	
	dw_detail.setcolumn("gubun")

	p_inq.enabled = false
	p_inq.picturename = "C:\erpman\image\��ȸ_d.gif"
	p_all.enabled = True
	p_all.picturename = "C:\erpman\image\�ϰ�����_up.gif"
	w_mdi_frame.sle_msg.text = "���"

	select a.empno, a.empname, a.deptcode, b.deptname into :sempno, :sempnm, :sDept, :sname from p1_master a, p0_dept b
	 where a.empno = :gs_empno and a.deptcode = b.deptcode;
	If SQLCA.SQLCODE = 0 THEN
		dw_detail.setitem(1, "empno", sEmpno)
		dw_detail.setitem(1, "empnm", sEmpnm)
		dw_detail.setitem(1, "dept", sDept)
		dw_detail.setitem(1, "deptname", sName)
	End If
ELSE
	dw_detail.settaborder("jpno",  10)
	dw_detail.settaborder("sDATE", 0)
	dw_detail.settaborder("EDATE", 0)
	dw_detail.settaborder("saupj", 0)
	dw_detail.settaborder("DEPT",  0)
	dw_detail.settaborder("empno",  0)
	dw_detail.settaborder("GUBUN", 0)
	dw_detail.settaborder("ipdpt",  0)
	
	dw_detail.setcolumn("JPNO")

	p_inq.enabled = true
	p_inq.picturename = "C:\erpman\image\��ȸ_up.gif"
	p_all.enabled = False
	p_all.picturename = "C:\erpman\image\�ϰ�����_d.gif"
	w_mdi_frame.sle_msg.text = "����"
	
END IF

p_addrow.enabled = true
p_addrow.picturename = "C:\erpman\image\���߰�_up.gif"
p_delrow.enabled = true
p_delrow.picturename = "C:\erpman\image\�����_up.gif"
p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\����_up.gif"
p_del.enabled = true
p_del.picturename = "C:\erpman\image\����_up.gif"
		
dw_detail.setfocus()
dw_detail.setredraw(true)

// �ΰ��� ����� ����
f_mod_saupj(dw_detail, 'saupj')

//�԰�â�� 
f_child_saupj(dw_detail, 'ipdpt', gs_saupj )

return  1

end function

public function integer wf_delete ();
string	sGubun
long		lRow, lRowCount
lRowCount = dw_list.RowCount()


FOR  lRow = lRowCount 	TO		1		STEP  -1
		
	sGubun = dw_list.GetItemString(lRow, "blynd")

	IF sGubun = '2' or sGubun = '3'	THEN
		MessageBox("Ȯ��", "����Ϸ�� �ڷ�� ������ �� �����ϴ�.~r" +	&
								 "LINE : " + string(lRow) )
		RETURN -1
	END IF

	dw_list.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public subroutine wf_buy_unprc (long arg_row, string arg_itnbr, string arg_pspec, string arg_opseq);String sCvcod, sTuncu ,sCvnas
Decimal {5} dUnprc

f_buy_unprc(arg_itnbr, arg_pspec, arg_opseq, sCvcod, sCvnas, dUnprc, sTuncu)

if isnull(dUnprc) then dUnprc = 0 

dw_list.setitem(arg_row, "cvcod", scvcod)
dw_list.setitem(arg_row, "vndmst_cvnas2", sCvnas)
dw_list.setitem(arg_row, "cnvprc", dunprc)
dw_list.setitem(arg_row, "tuncu", stuncu)

// ���ֿ����ܰ� ��ȯ
if 	dw_list.getitemdecimal(arg_row, "cnvfat") = 1 then
	dw_list.setitem(arg_row, "unprc", dunprc)
elseif dw_list.getitemstring(arg_row, "cnvart") = '/' then
	dw_list.setitem(arg_row, "unprc", round(dunprc / dw_list.getitemdecimal(arg_row, "cnvfat"),5))
else
	dw_list.setitem(arg_row, "unprc", round(dunprc * dw_list.getitemdecimal(arg_row, "cnvfat"),5))
end if
end subroutine

public function integer wf_item (string sitem, string sspec, long lrow);String sname, sitgu, snull, sispec, spumsr, sAccod, sjijil, sIspec_code, sMaker, sEstgu, sJejo, ssht, sIttyp
Decimal {3} dJegoqty, dInqty, dOutqty, DbALQTY
Decimal {6} dCnvfat

Setnull(sNull)

SELECT "ITEMAS"."ITDSC",
		 "ITEMAS"."ISPEC",
		 "ITEMAS"."JIJIL",
		 "ITEMAS"."ISPEC_CODE",
		 "ITEMAS"."ITGU",
		 "ITEMAS"."PUMSR",
		 "ITEMAS"."CNVFAT",
		 "ITEMAS"."JEJOS",
		 fun_get_itmsht(:gs_saupj, "ITEMAS"."ITNBR"),
 		 "ITEMAS"."ITTYP"
  INTO :sName,
		 :sIspec,
		 :sjijil,
		 :sIspec_code,
		 :sItgu, :sPumsr, :dCnvfat, :sJejo, :ssht, :sIttyp
  FROM "ITEMAS"
 WHERE ( "ITEMAS"."ITNBR" = :sItem ) AND
		 ( "ITEMAS"."USEYN" = '0' );

IF sqlca.sqlcode <> 0 THEN
	f_message_chk(33,'[ǰ��]')
	dw_list.setitem(lRow, "itnbr", sNull)
	dw_list.SetItem(lRow, "itemas_itdsc", sNull)
	dw_list.SetItem(lRow, "itemas_ispec", sNull)
	dw_list.SetItem(lRow, "itemas_jijil", sNull)
	dw_list.SetItem(lRow, "itemas_ispec_code", sNull)
	dw_list.SetItem(lRow, "itemas_pumsr", sNull)
	dw_list.SetItem(lRow, "yebi1", sNull)
	dw_list.SetItem(lRow, "itgu",   sNull)
	dw_list.SetItem(lRow, "suipgu", sNull)
	dw_list.setitem(lrow, "stock_view_jego", 0)
	dw_list.setitem(lrow, "inqty", 0)
	dw_list.setitem(lrow, "outqty", 0)
	dw_list.setitem(lrow, "cnvfat", 1)
	dw_list.SetItem(lRow, "shpjpno", sNull)
	dw_list.SetItem(lRow, "itm_shtnm", sNull)
	dw_list.SetItem(lRow, "itemas_ittyp", sNull)
	RETURN 1
END IF

dw_list.SetItem(lRow, "itemas_itdsc", sName)
dw_list.SetItem(lRow, "itemas_ispec", sIspec)
dw_list.SetItem(lRow, "itemas_jijil", sjijil)
dw_list.SetItem(lRow, "itemas_ispec_code", sIspec_code)
dw_list.SetItem(lRow, "itemas_pumsr", sPumsr)
dw_list.SetItem(lRow, "itemas_ittyp", sIttyp)

dw_list.SetItem(lRow, "itm_shtnm", sSht)

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
		dw_list.Setitem(LROW, "cnvqty",	round(dBalqty / dw_list.getitemdecimal(LROW, "cnvfat"),3))
	end if
else
	dw_list.Setitem(LROW, "cnvqty",	round(dBalqty * dw_list.getitemdecimal(LROW, "cnvfat"),3))
end if

/* ������� */
SELECT A.JEGO_QTY AS JEGO,  
		 ( A.JISI_QTY + A.PROD_QTY + A.BALJU_QTY + A.POB_QC_QTY + A.INS_QTY
		 + A.GI_QC_QTY + A.GITA_IN_QTY ) AS INQTY, 
		 ( A.HOLD_QTY + A.ORDER_QTY + A.MFGCNF_QTY ) AS OUTQTY
  INTO :dJegoqty, :dInqty, :dOutqty
  FROM "STOCK_VIEW" A
 WHERE A.ITNBR = :SITEM
   AND A.PSPEC = :SSPEC;

dw_list.setitem(lrow, "stock_view_jego", dJegoqty)
dw_list.setitem(lrow, "inqty", dInqty)
dw_list.setitem(lrow, "outqty", dOutqty)

// �ܰ��� ��纰 �ܰ��� �ƴ� MAKER�� �ܰ��� �����´�
sMaker = Trim(dw_list.GetItemString(lrow, 'shpjpno'))
If IsNull(sMaker) Or sMaker = '' Then sMaker = '.'

wf_buy_unprc(lrow, sitem, sMaker, dw_list.getitemstring(lrow, "opseq"))
//wf_buy_unprc(lrow, sitem, sspec, dw_list.getitemstring(lrow, "opseq"))

sEstgu = dw_detail.GetItemString(1, 'gubun')
// ������ ��� �Ӱ�������
If sItgu = '6' Then
	SELECT fun_get_itnacc(:sitem, '5') INTO :sAccod FROM DUAL;
	dw_list.setitem(lrow, "estgu", '3')
Else
	SELECT fun_get_itnacc(:sitem, '4') INTO :sAccod FROM DUAL;
	dw_list.setitem(lrow, "estgu", sEstgu)
End If

dw_list.setitem(lrow, "yebi1", sAccod)
		
return 0
end function

public function integer wf_create_gwdoc ();String sEstNo, sDate
string smsg, scall, sHeader, sDetail, sFooter, sRepeat, sDetRow, sValue
integer li_FileNum, nspos, nepos, ix, nPos, i, ll_repno1,ll_rptcnt1, ll_repno2,ll_rptcnt2, ll_html
string ls_Emp_Input, sGwNo, ls_reportid1, ls_reportid2, sGwStatus
long ll_FLength, dgwSeq, lRow

// HTML ������ �о���δ�
ll_FLength = FileLength("EAFolder_00021.html")
li_FileNum = FileOpen("EAFolder_00021.html", StreamMode!)

IF ll_FLength < 32767 THEN
        FileRead(li_FileNum, scall)
END IF
FileClose(li_FileNum)
If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('Ȯ ��','HTML ������ �������� �ʽ��ϴ�.!!')
	Return -1
End If

// �׷���� ���� ��ȣ 
sGwNo =  dw_list.GetItemString(1, 'shpjpno')

// �׷���� ������ ������ȣ ä��...�ʿ��� ��� ��
If IsNull(sGwNo) Or Trim(sGwNo) = '' Then
	sDate = f_today()
	sDate = dw_detail.GetItemString(1, 'sdate')
	dgwSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'GW')
	IF dgwSeq < 1	 or dgwSeq > 9999	THEN	
		ROLLBACK ;
		f_message_chk(51, '[���ڰ���]')
		RETURN -1
	END IF
	
	COMMIT;
	
	sGWno = sDate + string(dGWSeq, "0000")
End If

If IsNull(sGwNo) Or sGwNo = '' Then Return 0

// �ݺ����� ã�´�
nsPos = Pos(scall, '(__LOOP_START__)')
nePos = Pos(scall, '(__LOOP_END__)')
If nsPos > 0 And nePos > 0 Then
	sHeader = Left(sCall, nsPos -1)
	sRepeat = Mid(sCall, nsPos + 17, nePos - (nsPos + 17))
	sFooter = Mid(sCall, nePos + 14)

	// Detail�� ���ؼ� �ݺ��ؼ� ���� setting�Ѵ�
	ix = 1
	do 
		nPos = Pos(sRepeat, '(_ROW_)')  
		If nPos > 0 Then sDetRow = Replace(sRepeat, nPos, 7, string(ix))	
		
		nPos = Pos(sDetRow, '(_IDTSC_)')
		sValue = dw_list.GetItemString(ix,'itemas_itdsc')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_ISPEC_)')
		sValue = dw_list.GetItemString(ix,'itemas_ispec')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue )
		
		nPos = Pos(sDetRow, '(_UNMSR_)')
		sValue = dw_list.GetItemString(ix,'itemas_pumsr')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)
		
		nPos = Pos(sDetRow, '(_QTY_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, String(dw_list.GetItemNumber(ix,'guqty'),'#,##0.00'))
		
		nPos = Pos(sDetRow, '(_PRC_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, '0')
		
		nPos = Pos(sDetRow, '(_AMT_)')  
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 7, '0')
		
		nPos = Pos(sDetRow, '(_ITNBR_)')
		sValue = dw_list.GetItemString(ix,'itnbr')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 9, sValue)

		nPos = Pos(sDetRow, '(_BIGO_)')
		sValue = dw_list.GetItemString(ix,'yongdo')
		If IsnUll(sValue) Then sValue = ''
		If nPos > 0 Then sDetRow = Replace(sDetRow, nPos, 8, sValue)
		
		sDetail = sDetail + sDetRow
		ix = ix + 1
	loop while (ix <= dw_list.RowCount() )

	nPos = Pos(sFooter, '(_RMK_)')
	sValue = Trim(dw_detail.GetItemString(1,'estrmk'))
	If IsnUll(sValue) Then sValue = ''
	If nPos > 0 Then sFooter = Replace(sFooter, nPos, 7, sValue)
	
	sCall = sHeader + sDetail + sFooter
End If

// Detail�� ��ũ�� ������ ġȯ�Ѵ�
nPos = Pos(sCall, '(_SDATE_)')
sValue = Trim(dw_detail.GetItemString(1,'sdate'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)
		
nPos = Pos(sCall, '(_ESTNO_)')
sValue = sEstNo
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_DEPT_NAME_)')
sValue = Trim(dw_detail.GetItemString(1,'deptname'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 13, sValue)

nPos = Pos(sCall, '(_YODAT_)')
sValue = Trim(dw_list.GetItemString(1,'yodat'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_DEPOT_)')
sValue = dw_detail.Describe("evaluate('lookupdisplay(ipdpt)'," + string(1) + ")")
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 9, sValue)

nPos = Pos(sCall, '(_YONG_)')
sValue = Trim(dw_detail.GetItemString(1,'yongdo'))
If IsnUll(sValue) Then sValue = ''
If nPos > 0 Then sCall = Replace(sCall, nPos, 8, sValue)

///////////////////////////////////////////////

If IsNull(sCall) oR Trim(sCall) = '' Then
	MessageBox('Ȯ ��','HTML ������ �������� �ʾҽ��ϴ�.!!')
	Return -1
End If

//EAERPHTML�� ��ϵǾ����� Ȯ��
select count(cscode) into :ll_html from eaerphtml
 where CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS > '0' USING SQLCA1;

If ll_html = 0 Then
	// ���� �̻�� ������ ������ ����
	DELETE FROM EAERPHTML WHERE CSCODE = 'BDS' AND KEY1 = :sGwno AND GWDOCGUBUN = :isHtmlNo AND STATUS IS NULL USING SQLCA1;
	
	// �׷���� EAERPHTML TABLE�� ��ȳ����� INSERT�Ѵ�
	INSERT INTO EAERPHTML
			  ( CSCODE, KEY1,  ERPEMPCODE, GWDOCGUBUN, SENDINGGUBUN, HTMLCONTENT, STATUS)
	 VALUES ( 'BDS',  :sGWno, Lower(:gs_userid),:isHtmlNo,    '1',   :sCall, '0') using sqlca1;
	If sqlca1.sqlcode <> 0 Then
		MESSAGEBOX(STRING(SQLCA1.SQLCODE), SQLCA1.SQLERRTEXT)
		RollBack USING SQLCA1;
		Return -1
	End If
	
	COMMIT USING SQLCA1;
Else
	MessageBox('Ȯ��','���ŵ� �����Դϴ�.!!')
	Return 0
End If

// ��ȼ� ���
gs_code  = "key1="+sGwNo			// Key Group
gs_gubun = isHtmlNo					//�׷���� ������ȣ
SetNull(gs_codename)		 			//�����Է¹���(erptitle)
Open(w_groupware_browser)

//EAERPHTML�� ��ŵǾ����� Ȯ��
SetNull(sGwStatus)
select approvalstatus into :sGwStatus
  from eafolder_00021_erp a, approvaldocinfo b
 where a.macro_field_1 = :sgwno
	and a.reporterid 	 = b.reporterid
	and a.reportnum	 = b.reportnum	using sqlca1 ;

If Not IsNull(sGwStatus) Or Trim(sGwNo) = '' Then
	MessageBox('������','���簡 ��ŵǾ����ϴ�.')
Else
	MessageBox('������','���簡 ��ŵ��� �ʾҽ��ϴ�.')
	Return -1
End If

// �׷���� ������ȣ�� �����Ƿ� ���̺� �����Ѵ�
For ix = 1 To dw_list.RowCount()
	dw_list.SetItem(ix, 'shpjpno', sGwno)
Next

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)

Return 1
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
///////////////////////////////////////////////////////////////////////////////////
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
	dw_list.dataobject = 'd_pdt_04002'
Else						// ���ִ��� ������
	is_cnvgu  = 'N'	
	dw_list.dataobject = 'd_pdt_04000'	
End if

//�ŷ�ó�� ���Ŵ���ڰ� ���� ��쿡 ���Ŵ����
select dataname
  into :is_empno
  from syscnfg
 where sysgu = 'Y' and serial = 14 and lineno = '1';
 
//�ŷ�ó�� ���ִ���ڰ� ���� ��쿡 ���ִ����
select dataname
  into :is_outemp
  from syscnfg
 where sysgu = 'Y' and serial = 14 and lineno = '2'; 


//�׷���� ��������
Select dataname into :is_gwgbn
  from syscnfg
 where sysgu = 'W' and
       serial = 1 and
		 lineno = '2';
If is_gwgbn = 'Y' Then
	String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
	
	// MsSql Server ����
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
		MessageBox('Ȯ ��','�׷���� ������ �� �� �����ϴ�.!!')
		is_gwgbn = 'N'
	End If
End If

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")

//�԰�â�� 
f_child_saupj(dw_detail, 'ipdpt','%' )
end event

on w_pdt_04000.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_2=create pb_2
this.pb_1=create pb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_all=create p_all
this.dw_hidden=create dw_hidden
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.p_inq=create p_inq
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.cb_del=create cb_del
this.cb_insert=create cb_insert
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.rr_3=create rr_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_list=create dw_list
this.Control[]={this.pb_2,&
this.pb_1,&
this.cb_2,&
this.cb_1,&
this.p_all,&
this.dw_hidden,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_delrow,&
this.p_addrow,&
this.p_inq,&
this.cb_delete,&
this.cb_cancel,&
this.cb_del,&
this.cb_insert,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.rr_3,&
this.rr_1,&
this.rr_2,&
this.dw_list}
end on

on w_pdt_04000.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_all)
destroy(this.dw_hidden)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.p_inq)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.cb_del)
destroy(this.cb_insert)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.rr_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_list)
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

// �׷���� �������� ����
If is_gwgbn = 'Y' Then
	disconnect	using	sqlca1 ;
	destroy	sqlca1
End If

end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type pb_2 from u_pb_cal within w_pdt_04000
integer x = 699
integer y = 284
integer taborder = 110
end type

event clicked;call super::clicked;string ls_next_day, ls_reqdat

if dw_detail.accepttext() = -1 then return -1
//�ش� �÷� ����
dw_detail.SetColumn('edate')
IF IsNull(gs_code) THEN Return
If dw_detail.Object.edate.protect = '1' Or dw_detail.Object.edate.TabSequence = '0'  Then Return

If ic_status = '1' then
  //����䱸���� 7�� ����
  select to_char(to_date(sysdate)+7,'yyyymmdd') into :ls_next_day  from dual;
  if gs_code < ls_next_day then
	  messagebox('�˸�','����䱸���� �������ڿ��� 7������ ��¥�� ���� �����մϴ�')
	  return 1
  end if
else  
	ls_reqdat = dw_detail.getitemstring(1,'sdate')
	select to_char(to_date(:ls_reqdat)+7,'yyyymmdd') into :ls_next_day  from dual;
	if gs_code < ls_next_day then
	  messagebox('�˸�','����䱸���� �Ƿ����ڿ��� 7������ ��¥�� ���� �����մϴ�')
	  return 1
  end if
end if	
	  
dw_detail.SetItem(1, 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_pdt_04000
integer x = 699
integer y = 196
integer taborder = 20
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
If dw_detail.Object.sdate.protect = '1' Or dw_detail.Object.sdate.TabSequence = '0'  Then Return

dw_detail.SetItem(1, 'sdate', gs_code)
end event

type cb_2 from commandbutton within w_pdt_04000
integer x = 37
integer y = 88
integer width = 521
integer height = 84
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "ǰ���̵�Ͻ� �Ƿ�"
end type

event clicked;//If gs_saupj = '10' Then
//	gs_gubun = '�豤��'
//Else
//	gs_gubun = '�ں���'
//End If
gs_code = 'ǰ�� ����� �Ƿ��մϴ�'
gs_codename = 'ǰ��� :~r~n~r~n�԰� :~r~n~r~n��� :'
gs_gubun = 'w_pdt_04000'
Open(w_mail_insert)
end event

type cb_1 from commandbutton within w_pdt_04000
integer x = 3881
integer y = 264
integer width = 402
integer height = 84
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����ϰ�����"
end type

event clicked;String sBlynd, sNull
Long	 ix, nCnt

If MessageBox('Ȯ ��','��һ��¸� �Ƿڻ��·� �ϰ� �����մϴ�.~n~r����Ͻðڽ��ϱ�?', Information!, YesNo!) = 2 Then Return

SetNull(sNull)

For ix = 1 To dw_list.RowCount()
	sBlynd = dw_list.GetItemString(ix, 'blynd')
	If sBlynd = '4' Then
		dw_list.SetItem(ix, 'blynd','1')
		dw_list.SetItem(ix, 'shpjpno', sNull)		// ���ڰ��� ���¸� �̻�Ż��·� �����Ѵ�
		dw_list.SetItem(ix, 'gubun','0')
		dw_list.SetItem(ix, 'yebi2','0')
		dw_list.SetItem(ix, 'gwno', sNull)		// ���ڰ��� ���¸� �̻�Ż��·� �����Ѵ�
		ncnt = nCnt + 1
	End If
Next

If nCnt > 0 Then
	p_addrow.enabled = true
	p_addrow.picturename = "C:\erpman\image\���߰�_up.gif"
	p_delrow.enabled = true
	p_delrow.picturename = "C:\erpman\image\�����_up.gif"
	p_mod.enabled = true
	p_mod.picturename = "C:\erpman\image\����_up.gif"
	p_del.enabled = true
	p_del.picturename = "C:\erpman\image\����_up.gif"
End If
end event

type p_all from picture within w_pdt_04000
integer x = 3168
integer y = 16
integer width = 178
integer height = 144
string picturename = "C:\erpman\image\�ϰ�����_up.gif"
boolean focusrectangle = false
end type

event clicked;w_mdi_frame.sle_msg.text =""

IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_list) = -1	then	return

//////////////////////////////////////////////////////////
string	sStartDate, sEndDate, sDept, sGubun, saupj,	&
			sIpdpt, sEmpno, sopt, sItem
long		lRow, k

sStartDate = trim(dw_detail.GetItemString(1, "sdate"))
sEndDate = trim(dw_detail.GetItemString(1, "edate"))
saupj    = dw_detail.GetItemString(1, "saupj")
sDept 	= dw_detail.GetItemString(1, "dept")
sGubun 	= dw_detail.GetItemString(1, "gubun")

sEmpno 	= dw_detail.GetItemString(1, "empno")
sIpdpt 	= dw_detail.GetItemString(1, "ipdpt")

////////////////////////////////////////////////////////////
// �Ƿ�����
IF isnull(sstartDate) or sstartDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

// �����
IF isnull(saupj) or saupj = "" 	THEN
	f_message_chk(30,'[�����]')
	dw_detail.SetColumn("saupj")
	dw_detail.SetFocus()
	RETURN
END IF

// �Ƿڱ���
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[�Ƿڱ���]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF

// ����䱸��
IF isnull(sEndDate) or sEndDate = "" 	THEN
	f_message_chk(30,'[����䱸��]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

// �԰�â��
IF isnull(sIpdpt) or sIpdpt = "" 	THEN
	f_message_chk(30,'[�԰�â��]')
	dw_detail.SetColumn("ipdpt")
	dw_detail.SetFocus()
	RETURN
END IF

// �Ƿ���
IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[�Ƿڴ����]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF

if ic_status = '1' and  dw_list.rowcount() = 1 then 
	dw_detail.settaborder("sDATE", 0)
end if

//////////////////////////////////////////////////////////////////////////////////////////////
SetNull(gs_code)
gs_gubun = '3'
open(w_itmbuy_popup5)
if Isnull(gs_code) or Trim(gs_code) = "" then return

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if sopt  = 'Y' then 
		lRow  = dw_list.insertrow(0)

		// �׷���� ���� ��ȸ�� ���� �����ڵ� ����
		if is_gwgbn = 'Y' then
			dw_list.SetItem(lRow, "blynd",  '1')
			dw_list.SetItem(lRow, "gubun",  '0')
		else
			dw_list.SetItem(lRow, "blynd",  '1')
			dw_list.SetItem(lRow, "gubun",  '4')	// ���ڰ��� �̿����� ����� �����Ѵ�
		end if

		dw_list.SetItem(lRow, "saupj", saupj)
		dw_list.SetItem(lRow, "rdate", sStartDate)
		dw_list.SetItem(lRow, "yodat", sEndDate)
		dw_list.SetItem(lRow, "rdptno", sDept)
		dw_list.SetItem(lRow, "estgu", sGubun)
		dw_list.SetItem(lRow, "rempno", dw_detail.GetItemString(1, "empno"))
		dw_list.SetItem(lRow, "p1_master_empname", dw_detail.GetItemString(1, "empnm"))
		
		dw_list.SetItem(lRow, "ipdpt", sIpdpt)
		
		// �����ڿ� ���� �ڷ� ����
		if is_cnvgu = 'Y' then
			dw_list.SetItem(lRow, "cnvart", is_cnvart)
		else
			dw_list.SetItem(lRow, "cnvart", '*')
		end if

		sItem = dw_hidden.GetItemString(k, 'itnbr')
		dw_list.SetItem(lRow, "itnbr", sItem)
		wf_item(sitem, '.', lrow)
	
	end if	
NEXT

dw_list.ScrollToRow(1)
dw_list.SetColumn("guqty")
dw_list.SetFocus()

dw_hidden.reset()
end event

type dw_hidden from datawindow within w_pdt_04000
boolean visible = false
integer x = 1248
integer y = 28
integer width = 1298
integer height = 136
integer taborder = 90
string title = "none"
string dataobject = "d_itmbuy_popup5"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_exit from uo_picture within w_pdt_04000
integer x = 4416
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("����") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_can from uo_picture within w_pdt_04000
integer x = 4242
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""


rb_insert.checked = true


ic_status = '1'	// ���

wf_Initial()
//
//p_addrow.picturename = "C:\erpman\image\���߰�_up.gif"
//p_addrow.TriggerEvent("clicked")
//
//
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

type p_del from uo_picture within w_pdt_04000
integer x = 4069
integer y = 16
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

//////////////////////////////////////////////////////////////////
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

p_can.TriggerEvent("clicked")
	
	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_mod from uo_picture within w_pdt_04000
integer x = 3895
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. ���� = 0		-> RETURN
//		2. ��ǥä������('A0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq, nCnt
string sdate, sEstno, sGyel, sBigo, syongdo

sDate = trim(dw_detail.GetItemString(1, "sdate"))

// �Ƿ�����
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

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

// �������� ����
If dw_list.RowCount() > 0 Then
	sEstno =  Left(dw_list.GetItemString(1, 'estno'),12)
	sGyel  =  Trim(dw_detail.GetItemString(1, 'gyel'))
   sBigo  =  Trim(dw_detail.GetItemString(1, 'estrmk'))
	syongdo = Trim(dw_detail.GetItemString(1, 'yongdo'))
	
	SELECT COUNT(*) INTO :nCnt FROM ESTIMA_EAXMI WHERE SABU = :gs_sabu AND ESTNO = :sEstno;
	If nCnt > 0 Then
		UPDATE ESTIMA_EAXMI SET GYEL = :sGyel, ESTRMK = :sBigo, YONGDO = :sYongdo WHERE SABU = :gs_sabu AND ESTNO = :sEstno;
	Else
		INSERT INTO ESTIMA_EAXMI ( SABU, ESTNO, GYEL, ESTRMK, YONGDO ) VALUES ( :gs_sabu, :sEstno, :sGyel, :sBigo, :sYongdo);
	End If
	
//	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	If sqlca.sqlcode = 0 Then
		COMMIT;
	Else
		f_Rollback()
		return
	End If
End If

// �����Ƿ� ������
IF is_gwgbn = 'Y' then
	wf_create_gwdoc()
End If
	
////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	return
END IF

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_delrow from uo_picture within w_pdt_04000
integer x = 3721
integer y = 16
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
////////////////////////////////////////////////////////
string	sGubun, sGwgbn

sGubun = dw_list.GetItemString(lRow, "blynd")
sGwgbn = dw_list.GetItemString(lRow, "gubun")	// ���ڰ��� ����

If is_gwgbn = 'Y' Then
	IF sGwgbn = '4'	THEN
		MessageBox("Ȯ��", "������ε� �ڷ�� ������ �� �����ϴ�.")
		RETURN 
	END IF
	
	IF sGubun <> '1' THEN
		MessageBox("Ȯ��", "����Ϸ�� �ڷ�� ������ �� �����ϴ�.")
		RETURN 
	END IF
Else
	IF sGubun <> '1'	THEN
		MessageBox("Ȯ��", "����Ϸ�� �ڷ�� ������ �� �����ϴ�.")
		RETURN 
	END IF
End If


dw_list.DeleteRow(lRow)

if ic_status = '1' and  dw_list.rowcount() < 1 then 
	dw_detail.settaborder("sDATE", 10)
end if

///////////////////////////////////////////////////////
//IF dw_list.Update() > 0		THEN
//	COMMIT;
//ELSE
//	f_Rollback()
//	ROLLBACK;
//END IF
///////////////////////////////////////////////////////


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

type p_addrow from uo_picture within w_pdt_04000
integer x = 3547
integer y = 16
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\���߰�_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_list) = -1	then	return

//////////////////////////////////////////////////////////
string	sStartDate, sEndDate, sDept, sGubun, saupj,	&
			sIpdpt, sEmpno
long		lRow

sStartDate = trim(dw_detail.GetItemString(1, "sdate"))
sEndDate = trim(dw_detail.GetItemString(1, "edate"))
saupj    = dw_detail.GetItemString(1, "saupj")
sDept 	= dw_detail.GetItemString(1, "dept")
sGubun 	= dw_detail.GetItemString(1, "gubun")

sEmpno 	= dw_detail.GetItemString(1, "empno")
sIpdpt 	= dw_detail.GetItemString(1, "ipdpt")

////////////////////////////////////////////////////////////
// �Ƿ�����
IF isnull(sstartDate) or sstartDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN
END IF

// �����
IF isnull(saupj) or saupj = "" 	THEN
	f_message_chk(30,'[�����]')
	dw_detail.SetColumn("saupj")
	dw_detail.SetFocus()
	RETURN
END IF

// �Ƿڱ���
IF isnull(sGubun) or sGubun = "" 	THEN
	f_message_chk(30,'[�Ƿڱ���]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF

// ����䱸��
IF isnull(sEndDate) or sEndDate = "" 	THEN
	f_message_chk(30,'[����䱸��]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN
END IF

// �԰�â��
IF isnull(sIpdpt) or sIpdpt = "" 	THEN
	f_message_chk(30,'[�԰�â��]')
	dw_detail.SetColumn("ipdpt")
	dw_detail.SetFocus()
	RETURN
END IF

// �Ƿ���
IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[�Ƿڴ����]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN
END IF

//// �Ƿںμ�
//IF isnull(sDept) or sDept = "" 	THEN
//	f_message_chk(30,'[�Ƿںμ�]')
//	dw_detail.SetColumn("dept")
//	dw_detail.SetFocus()
//	RETURN
//END IF

//////////////////////////////////////////////////////////////////////////////////////////////
lRow = dw_list.InsertRow(0)

if ic_status = '1' and  dw_list.rowcount() = 1 then 
	dw_detail.settaborder("sDATE", 0)
end if


// �׷���� ���� ��ȸ�� ���� �����ڵ� ����
if is_gwgbn = 'Y' then
	dw_list.SetItem(lRow, "blynd",  '1')
	dw_list.SetItem(lRow, "gubun",  '0')
else
	dw_list.SetItem(lRow, "blynd",  '1')
	dw_list.SetItem(lRow, "gubun",  '4')	// ���ڰ��� �̿����� ����� �����Ѵ�
end if

dw_list.SetItem(lRow, "saupj", saupj)
dw_list.SetItem(lRow, "rdate", sStartDate)
dw_list.SetItem(lRow, "yodat", sEndDate)
dw_list.SetItem(lRow, "rdptno", sDept)
dw_list.SetItem(lRow, "estgu", sGubun)
dw_list.SetItem(lRow, "rempno", dw_detail.GetItemString(1, "empno"))
dw_list.SetItem(lRow, "p1_master_empname", dw_detail.GetItemString(1, "empnm"))

dw_list.SetItem(lRow, "ipdpt", sIpdpt)

/////////////////////////////////////////////////////////////////////////////////////////////////
// �����ڿ� ���� �ڷ� ����
if is_cnvgu = 'Y' then
	dw_list.SetItem(lRow, "cnvart", is_cnvart)
else
	dw_list.SetItem(lRow, "cnvart", '*')
end if

dw_list.ScrollToRow(lRow)
dw_list.SetColumn("itnbr")
dw_list.SetFocus()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���߰�_up.gif"
end event

type p_inq from uo_picture within w_pdt_04000
integer x = 3369
integer y = 16
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event clicked;call super::clicked;string  	sJpno,		&
			sDate,		&
			sNull, sGwNo
string   sGwStatus

w_mdi_frame.sle_msg.text =""

if dw_detail.Accepttext() = -1	then 	return

SetNull(sNull)

sJpno   	= trim(dw_detail.getitemstring(1, "jpno"))

IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30,'[�Ƿڹ�ȣ]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	RETURN
END IF
//////////////////////////////////////////////////////////////////////////
// �׷���� ������ȣ ��ȸ
sGwNo = dw_detail.GetItemString(1, 'gwno')

//EAERPHTML�� ��ŵǾ����� Ȯ��
If Not IsNull(sGwNo) Then
	select approvalstatus into :sGwStatus
	  from eafolder_00021_erp a, approvaldocinfo b
	 where a.macro_field_1 = :sgwno
		and a.reporterid 	 = b.reporterid
		and a.reportnum	 = b.reportnum	using sqlca1 ;

	// ������°��� ���� ������ �����Ƿڿ� �����Ѵ�
	If Not IsNull(sGwStatus) Then
		// ������ �ݷ��� ��� '���'�� �����Ѵ�
		If sGwStatus = '2' Or sGwStatus = '5' Then
			UPDATE ESTIMA SET BLYND = '4', GUBUN = :sGwStatus WHERE SABU = :gs_sabu AND ESTNO LIKE :sJpno||'%';
		Else
			UPDATE ESTIMA SET GUBUN = :sGwStatus WHERE SABU = :gs_sabu AND ESTNO LIKE :sJpno||'%';
		End If
		COMMIT;
	End If
	
	dw_detail.SetItem(1,'smsg', sGwStatus)
End If

//////////////////////////////////////////////////////////////////////////
sJpno = sJpno + '%'
IF	dw_list.Retrieve(gs_sabu, sjpno) <	1		THEN
	f_message_chk(50, '[�����Ƿ�]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	return
end if

string sbigo, syongdo

SELECT ESTRMK, YONGDO INTO :sBigo, :syongdo 
 FROM ESTIMA_EAXMI 
 WHERE SABU = :gs_sabu AND ESTNO LIKE :sjpno;

dw_detail.SetItem(1, 'estrmk', sbigo)
dw_detail.SetItem(1, 'yongdo', syongdo)

//////////////////////////////////////////////////////////////////////////
// �����Ƿڹ�ȣ
is_Last_Jpno = dw_list.GetItemString(dw_list.RowCount(), "estno")

//dw_detail.enabled = false

//EAERPHTML�� ��ŵǾ����� Ȯ��
If Not IsNull(sGwNo) Then
	If sGwStatus >= '0'  Then // ������	
		p_addrow.enabled = false
		p_addrow.picturename = "C:\erpman\image\���߰�_d.gif"
		p_delrow.enabled = false
		p_delrow.picturename = "C:\erpman\image\�����_d.gif"
		p_mod.enabled = false
		p_mod.picturename = "C:\erpman\image\����_d.gif"
		p_del.enabled = false
		p_del.picturename = "C:\erpman\image\����_d.gif"
	End If
Else
	p_del.enabled = true
	p_del.picturename = "C:\erpman\image\����_up.gif"
End If

dw_list.SetColumn("itnbr")
dw_list.SetFocus()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

type cb_delete from commandbutton within w_pdt_04000
integer x = 955
integer y = 3232
integer width = 361
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "����(&D)"
end type

type cb_cancel from commandbutton within w_pdt_04000
integer x = 2770
integer y = 3232
integer width = 347
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

type cb_del from commandbutton within w_pdt_04000
integer x = 2053
integer y = 3232
integer width = 393
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����(&L)"
end type

type cb_insert from commandbutton within w_pdt_04000
integer x = 1637
integer y = 3232
integer width = 393
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���߰�(&A)"
end type

type rb_delete from radiobutton within w_pdt_04000
integer x = 4361
integer y = 272
integer width = 215
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "����"
end type

event clicked;
ic_status = '2'


wf_Initial()
end event

type rb_insert from radiobutton within w_pdt_04000
integer x = 4361
integer y = 204
integer width = 215
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "���"
boolean checked = true
end type

event clicked;
ic_status = '1'	// ���

wf_Initial()
end event

type dw_detail from datawindow within w_pdt_04000
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 200
integer width = 4256
integer height = 396
integer taborder = 10
string dataobject = "d_pdt_04001"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Choose Case GetColumnName() 
	Case "estrmk"
		return 0
	Case Else
      Send(Handle(this),256,9,0)
      Return 1
End Choose
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sDate,  sDate2, sDept, sName, 	&
			sGubun, sNull, sname2, sPordno, sempno, sempnm, ssaupj, sGwNo, sJuprod, ls_next_day, ls_reqdat
int      ireturn 

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[�Ƿ�����]')
		this.setitem(1, "sdate", is_date)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'edate' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[����䱸��]')
		this.setitem(1, "edate", is_date)
		return 1
	Else
		If ic_status = '1' then
		  //����䱸���� 7�� ����
		  select to_char(to_date(sysdate)+7,'yyyymmdd') into :ls_next_day  from dual;
		  if sDate < ls_next_day then
			  messagebox('�˸�','����䱸���� �������ڿ��� 7������ ��¥�� ���� �����մϴ�')
			  return 1
		  end if
	   else  
			ls_reqdat = this.getitemstring(row,'sdate')
		   select to_char(to_date(:ls_reqdat)+7,'yyyymmdd') into :ls_next_day  from dual;
			if sDate < ls_next_day then
			  messagebox('�˸�','����䱸���� �Ƿ����ڿ��� 7������ ��¥�� ���� �����մϴ�')
			  return 1
		  end if
		end if	
	END IF	
	
ELSEIF this.GetColumnName() = 'dept' THEN

	sDept = this.gettext()
	
   ireturn = f_get_name2('�μ�', 'Y', sdept, sname, sname2)	 
	this.setitem(1, "dept", sdept)
	this.setitem(1, "deptname", sName)
   return ireturn 	 
	
	
ELSEIF this.GetColumnName() = 'empno' THEN

	sEmpno = this.gettext()
	
   ireturn = f_get_name2('���', 'Y', sEmpno, sEmpnm, sname2)	 
	this.setitem(1, "empno", sEmpno)
	this.setitem(1, "empnm", sEmpnm)
	
	select a.deptcode, b.deptname into :sDept, :sname from p1_master a, p0_dept b
	 where a.empno = :sEmpno and a.deptcode = b.deptcode;
	this.setitem(1, "dept", sDept)
	this.setitem(1, "deptname", sName)
   return ireturn 	 
	
ELSEIF this.getcolumnname() = "jpno"	then

	string	sJpno, sIpdpt, sGyel
	sJpno = this.gettext() 

  SELECT A.RDATE,		A.YODAT,   A.RDPTNO,   A.ESTGU,   A.REMPNO,   FUN_GET_EMPNO(A.REMPNO),     A.PORDNO,   
         B.CVNAS2,	A.IPDPT,	  A.SAUPJ,    C.GYEL, 	 A.SHPJPNO
    INTO :sDate,   	:sDate2,   :sDept,     :sGubun,   :sEmpno,    :sEmpnm,   			:sPordno,  
         :sName,		:sIpdpt,   :sSaupj,	  :sGyel,	 :sGwNo
    FROM ESTIMA A, VNDMST B, ESTIMA_EAXMI C 
   WHERE A.RDPTNO = B.CVCOD(+)
	  AND A.SABU   = :gs_sabu
	  AND SUBSTR(A.ESTNO,1,12) = :sJpno 
	  AND A.SABU = C.SABU(+)
	  AND SUBSTR(A.ESTNO,1,12) = C.ESTNO(+)
	  AND rownum = 1 ;

	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[�Ƿڹ�ȣ]')
		this.setitem(1, "jpno", sNull)
		return 1
	end if

   if not (spordno = '' or isnull(sPordno)) then 
		messageBox('Ȯ ��', '�۾����ÿ� ���� �����Ƿ��ڷ�� ������ �� �����ϴ�.')
		this.setitem(1, "jpno", sNull)
		return 1
	end if

	this.setitem(1, "sdate",   sDate)	
	this.setitem(1, "edate", 	sDate2)		
	this.setitem(1, "dept", 	sDept)	
	this.setitem(1, "deptname", sName)	
	this.setitem(1, "gubun",    sGubun)	
	this.setitem(1, "empno", 	sEmpno)	
	this.setitem(1, "empnm", sEmpnm)	
	this.setitem(1, "ipdpt", sIpdpt)	
	this.setitem(1, "gyel", sGyel)	
	this.setitem(1, "gwno", sGWno)
	
//	this.setitem(1, "saupj", sSaupj)	
	
	p_inq.TriggerEvent(Clicked!)
ELSEIF this.getcolumnname() = "saupj"	then
//�԰�â�� 
//	f_child_saupj(dw_detail, 'ipdpt', Trim(GetText()) )
ELSEIF this.getcolumnname() = "ipdpt"	then
	sGubun = Trim(GetText())
	
	// �԰���â�� MRO�� ��� �Ƿڱ����� MRO�� �����Ѵ�	
	SELECT JUPROD INTO :sJuprod FROM VNDMST WHERE CVCOD = :sGubun;
	If sJuprod = 'Z' Then
		SetItem(1, 'gubun', '9')
	End If
END IF
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code = ''
gs_codename = ''

// �μ�
IF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"dept",gs_code)
	SetItem(1,"deptname",gs_codename)

ELSEif this.getcolumnname() = "jpno" 	then
	
	gs_Gubun = '1'
	open(w_estima_popup)
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
	
elseIF this.GetColumnName() = 'empno'	THEN
	
	this.accepttext()
	gs_gubun  = this.getitemstring(1, 'dept')

	Open(w_sawon_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1, "empno", gs_code)
	SetItem(1, "empnm", gs_codename)
	this.setitem(1, "dept", gs_gubun)
	
	string sdata
	Select deptname2 Into :sData From p0_dept where deptcode = :gs_gubun;
	this.setitem(1, "deptname", sdata)

end if


end event

type cb_save from commandbutton within w_pdt_04000
integer x = 594
integer y = 3232
integer width = 347
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

type cb_exit from commandbutton within w_pdt_04000
event key_in pbm_keydown
integer x = 3136
integer y = 3232
integer width = 370
integer height = 108
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&X)"
end type

type cb_retrieve from commandbutton within w_pdt_04000
integer x = 233
integer y = 3232
integer width = 347
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ȸ(&R)"
end type

type rr_3 from roundrectangle within w_pdt_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 632
integer width = 4544
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_1 from roundrectangle within w_pdt_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 188
integer width = 4293
integer height = 416
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4343
integer y = 176
integer width = 238
integer height = 188
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from datawindow within w_pdt_04000
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 640
integer width = 4526
integer height = 1652
integer taborder = 20
string dataobject = "d_pdt_04000"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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

event itemchanged;string	sNull, sProject, sjijil, sispec_code, ssht
string	sCode,  sName, 	&
			sItem,  sSpec, &
			sEmpno, sDate,	sItdsc, sIspec, sItnbr, sOpseq, sTuncu, sItgu, soutemp , ls_next_day, ls_reqdat
long		lRow, lReturnRow
dec {5}	dPrice
dec {3}	dQty, dBalQty, djegoqty, dInqty, dOutqty
Integer  iReturn
SetNull(sNull)

lRow  = this.GetRow()	

IF this.GetColumnName() = 'itnbr'	THEN
	
	sItem = THIS.GETTEXT()	
	sspec = this.getitemstring(lrow, "pspec")

	ireturn = wf_item(sitem, sspec, lrow)
	return ireturn
	
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sItdsc = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name3('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sIspec_code)
	
	/* ��ȣ */
	select itm_shtnm into :ssht
	  from itmsht
	 where itnbr = :sitnbr
	   and saupj = :gs_saupj;
	
	this.SetItem(lRow, "itm_shtnm", ssht)
	
	if sitnbr > '.' then
		wf_item(sitnbr, sspec, lrow)
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sIspec = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name3('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sIspec_code)
	if sitnbr > '.' then
		wf_item(sitnbr, sspec, lrow)
	end if	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name3('����', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sIspec_code)
	if sitnbr > '.' then
		wf_item(sitnbr, sspec, lrow)
	end if	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sispec_code = trim(this.GetText())
	sspec = this.getitemstring(lrow, "pspec")	
	ireturn = f_get_name3('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.SetItem(lRow, "itemas_jijil", sjijil)
	this.SetItem(lRow, "itemas_ispec_code", sIspec_code)
	if sitnbr > '.' then
		wf_item(sitnbr, sspec, lrow)
	end if	
	RETURN ireturn
// ���ֿ������� ���
ELSEif this.getcolumnname() = "guqty" 	then

	dQty	= dec(this.GetText())
	
	wf_Cal_Qty(dQty, lRow)
	
// �ŷ�ó
ELSEIF this.GetColumnName() = "cvcod" THEN
	
	sCode  = this.GetText()								
	sItem  = this.GetItemString(lRow, "itnbr")
	sOpseq = this.GetItemString(lRow, "opseq")	
    
	if sCode = "" or isnull(sCode) then 
		THIS.SETITEM(LROW, "CVCOD", SNULL)
		THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNULL)
		this.setitem(lRow, "unprc", 0)		
		this.setitem(Lrow, "cnvprc", 0)
		this.setitem(lrow, "tuncu", 'WON')
		return 
	end if

	/* �ŷ�ó Ȯ�� */
   SELECT A.CVNAS, A.EMP_ID, A.OUTORDER_EMP
     INTO :sName, :sEmpno, :soutemp
     FROM "VNDMST" A
    WHERE A.CVCOD = :sCode
	 	AND A.CVGU IN ('1','2','9'); 
		 
	IF SQLCA.SQLCODE <> 0 THEN
		THIS.SETITEM(LROW, "CVCOD", SNULL)
		THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNULL)
		THIS.SETITEM(LROW, "sempno", SNULL)
		this.setitem(lRow, "unprc", 0)		
		this.setitem(Lrow, "cnvprc", 0)
		this.setitem(lrow, "tuncu", 'WON')
		F_MESSAGE_CHK(33, '[�ŷ�ó]')
		RETURN 1
	END IF
	
	THIS.SETITEM(LROW, "VNDMST_CVNAS2", SNAME)
	
	if dw_detail.getitemstring(1, "gubun") = '3' then
		if soutEmp = '' or isnull(soutEmp) then soutEmp = is_outemp //���ִ���ڰ� ���� �� �⺻���ִ��
		this.SetItem(lRow, "sempno", soutEmp)									
	Else
		if sEmpno = '' or isnull(sEmpno) then sEmpno = is_empno //���Ŵ���ڰ� ���� �� �⺻���Ŵ��
		this.SetItem(lRow, "sempno", sEmpno)					
	End if
	
	dprice = 0
	STUNCU = 'WON'
			 
	/* �ܰ����� Ȯ�� */
   SELECT NVL(B.UNPRC, 0), cunit
     INTO :dPrice, :sTuncu
     FROM "DANMST" B 
    WHERE B.ITNBR	   = :sItem 
	 	AND B.OPSEQ    = :SOPSEQ
	 	AND B.CVCOD 	= :sCode ; 

/* ���� �ŷ�ó�� �ƴ� ��쿡�� �Է� �����ϵ��� �� */
//	IF sqlca.sqlcode <> 0 	THEN
//		F_MESSAGE_CHK(303, '[�ܰ� ����]')
//		this.setitem(lRow, "unprc", 0)
//		this.setitem(lrow, "tuncu", 'WON')
//		RETURN 1
//   END IF	
	
	this.setitem(lRow, "cnvprc", DPRICE)
	this.setitem(lrow, "tuncu", stuncu)
	
	// ���ֿ����ܰ� ��ȯ
	if dw_list.getitemdecimal(lrow, "cnvfat") = 1   then
		dw_list.setitem(lrow, "unprc", dprice)
	elseif dw_list.getitemstring(Lrow, "cnvart") = '/' then
		dw_list.setitem(Lrow, "unprc", round(dprice / dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	else
		dw_list.setitem(Lrow, "unprc", round(dprice * dw_list.getitemdecimal(Lrow, "cnvfat"),5))
	end if	

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
	Else
	  If ic_status = '1' then
		  //����䱸���� 7�� ����
		  select to_char(to_date(sysdate)+7,'yyyymmdd') into :ls_next_day  from dual;
		  if sDate < ls_next_day then
			  messagebox('�˸�','����䱸���� �������ڿ��� 7������ ��¥�� ���� �����մϴ�')
			  return 1
		  end if
	   else  
			ls_reqdat = this.getitemstring(row,'rdate')
		   select to_char(to_date(:ls_reqdat)+7,'yyyymmdd') into :ls_next_day  from dual;
			if sDate < ls_next_day then
			  messagebox('�˸�','����䱸���� �Ƿ����ڿ��� 7������ ��¥�� ���� �����մϴ�')
			  return 1
		  end if
		end if	
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
	 
ELSEIF this.getcolumnname() = "project_no"	then
	sProject = trim(this.gettext())
	
	if sProject = '' or isnull(sproject) then return 
	
//	SELECT "VW_PROJECT"."SABU"  
//     INTO :sCode
//     FROM "VW_PROJECT"  
//    WHERE ( "VW_PROJECT"."SABU"  = :gs_sabu ) AND  
//          ( "VW_PROJECT"."PJTNO" = :sProject )   ;
	SELECT "FLOW_PROJECT"."PROJ_CODE"  
     INTO :sCode
     FROM "FLOW_PROJECT"  
    WHERE ( "FLOW_PROJECT"."PROJ_CODE" = :sProject )   ;
			 
	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[������Ʈ ��ȣ]')
		this.setitem(lRow, "project_no", sNull)
	   return 1
	END IF
//ELSEIF this.getcolumnname() = 'shpjpno' then    /* Maker ����*/
//	sItem 	= GetItemString(Lrow,'itnbr')	
//	sspec 	= GetText()
//	sCode 	= GetItemString(Lrow,'cvcod')
//   	dBalQty	= this.GetItemDecimal(Lrow,"vnqty")
//	sDate  	= dw_detail.GetItemString(1, "sdate")
//	
//	If IsNull(sspec) Or Trim(sspec) = '' Then sspec = '.'
//	If 	Not IsNull(sItnbr) Then	
//		/* ��纰 ���Դܰ�*/
//		SELECT Fun_danmst_danga10(:sDate, :scode, :sitem, :sspec) INTO :dprice FROM DUAL;
//		//dprice = sqlca.Fun_danmst_danga10(sDate, scode, sitem, sspec);
//		setitem(Lrow, "unprc", dprice)
//		// ��ü���ֿ����ܰ� ����
//		if 	getitemdecimal(Lrow, "cnvfat") =  1  then
//			setitem(Lrow, "cnvprc", dprice)
//		elseif 	getitemstring(Lrow, "cnvart") = '*'  then
//			IF 	dBalQty = 0 then
//				setitem(Lrow, "cnvprc", 0)			
//			else
//				setitem(Lrow, "cnvprc", ROUND(dprice / getitemdecimal(Lrow, "cnvfat"),5))
//			end if
//		else
//			setitem(Lrow, "cnvprc", ROUND(dprice * getitemdecimal(Lrow, "cnvfat"),5))
//		end if	
//	End If		
	
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


w_mdi_frame.sle_msg.text = "  �ʼ��Է��׸� :  " + this.Describe(sColumnName) + "   �Է��ϼ���."

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
	w_mdi_frame.sle_msg.text = '�Ϲ� �ŷ�ó ��ȸ�� F2 KEY �� ��������!'
	
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

elseif this.getcolumnname() = "project_no" 	then
//	gs_gubun = '1'
//	open(w_project_popup)
//	if isnull(gs_code)  or  gs_code = ''	then	return
//	this.setitem(lRow, "project_no", gs_code)

	open(w_wflow_project_pop)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(lRow, "project_no", gs_code)

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

event getfocus;w_mdi_frame.sle_msg.text = '��� ���� �������� Doublic Click�� �Ͻʽÿ�'
end event

event rowfocuschanged;w_mdi_frame.sle_msg.text = '��� ���� �������� Doublic Click�� �Ͻʽÿ�'
end event

event clicked;//If Row <= 0 then
//	Return 
//ELSE
//	SetRow(row)
//END IF
//
end event

