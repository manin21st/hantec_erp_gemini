$PBExportHeader$w_sal_06020_popup.srw
$PBExportComments$P/I ���(���Ź����Ƿ�) Popup
forward
global type w_sal_06020_popup from window
end type
type dw_update from datawindow within w_sal_06020_popup
end type
type dw_1 from datawindow within w_sal_06020_popup
end type
type cb_close from commandbutton within w_sal_06020_popup
end type
type cb_cancel from commandbutton within w_sal_06020_popup
end type
type cb_update from commandbutton within w_sal_06020_popup
end type
type dw_list from datawindow within w_sal_06020_popup
end type
type gb_2 from groupbox within w_sal_06020_popup
end type
type gb_1 from groupbox within w_sal_06020_popup
end type
end forward

global type w_sal_06020_popup from window
integer x = 5
integer y = 320
integer width = 3634
integer height = 1848
boolean titlebar = true
string title = "�����Ƿ� �ڷ� ����"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_update dw_update
dw_1 dw_1
cb_close cb_close
cb_cancel cb_cancel
cb_update cb_update
dw_list dw_list
gb_2 gb_2
gb_1 gb_1
end type
global w_sal_06020_popup w_sal_06020_popup

type variables
String    is_pino

string     is_cnvgu            //��ȯ�����뿩��
string     is_cnvart            //��ȯ������

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_cal_qty (decimal ad_qty, long al_row)
public function integer wf_estima_insert (string ar_date, string ar_dept, string ar_empno, string ar_pjtno, ref string re_jpno)
end prototypes

public function integer wf_required_chk (integer i);if dw_list.GetItemString(i,'opt') = 'N' then return 1

if isnull(dw_list.GetItemDecimal(i,'estqty')) or &
	dw_list.GetItemDecimal(i,'estqty') = 0 then
	f_message_chk(1400,'[ '+string(i)+' ��  �Ƿڼ���]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('estqty')
	dw_list.SetFocus()
	return -1		
end if	

if isnull(dw_list.GetItemDecimal(i,'vnqty')) or &
	dw_list.GetItemDecimal(i,'vnqty') = 0 then
	f_message_chk(1400,'[ '+string(i)+' ��  ���ֿ�����]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('vnqty')
	dw_list.SetFocus()
	return -1		
end if	

if isnull(dw_list.GetItemString(i,'nadate')) or &
	trim(dw_list.GetItemString(i,'nadate')) = "" then
	f_message_chk(1400,'[ '+string(i)+' ��  ���⿹����]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('nadate')
	dw_list.SetFocus()
	return -1		
end if	

Return 2

end function

public subroutine wf_cal_qty (decimal ad_qty, long al_row);IF dw_list.AcceptText() = -1	THEN	RETURN 

string	sItem
dec		dBalQty, dMinqt, dMulqt
dec		dMul

sItem  = dw_list.GetItemString(al_Row, "itnbr")
	
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

// ���ִ����� ���� ��ü���ַ� ��ȯ(�Ҽ��� 3�ڸ� ������ ���)
if is_cnvgu = 'N' then 
	dw_list.Setitem(al_row, "cnvqty", dBalqty)
else	
	if dw_list.getitemdecimal(al_row, "cnvfat") = 1  then
		dw_list.Setitem(al_row, "cnvqty", dBalqty)
	elseif is_cnvart = '/' then
		if dBalqty = 0 then
			dw_list.Setitem(al_row, "cnvqty",0)	
		Else
			dw_list.Setitem(al_row, "cnvqty",round(dBalqty / dw_list.getitemdecimal(Al_row, "cnvfat"),3))
		end if
	else
		dw_list.Setitem(al_row, "cnvqty",round(dBalqty * dw_list.getitemdecimal(Al_row, "cnvfat"),3))
	end if
end if



end subroutine

public function integer wf_estima_insert (string ar_date, string ar_dept, string ar_empno, string ar_pjtno, ref string re_jpno);String     sCvcod, sTuncu ,sCvnas, sJpno, sDate, sItnbr, sitgu, sempno, sempno2, sdepot, sdepot2
Dec {5}    dUnprc
dec {6}    dcnvfat       //��ȯ���
dec {3}    dvnqty
long	     lRow, lSeq, lcount, i, lSeqNo

sDate = dw_1.GetItemString(1, "sdate")  //�Ƿ�����

lSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'A0')

IF lSeq < 0	 or lseq > 9999	THEN	
	f_message_chk(51, '')
   RETURN -1
END IF

COMMIT;

sJpno = sDate + string(lSeq, "0000")

re_Jpno = sJpno

//�ŷ�ó�� ���Ŵ���ڰ� ���� ��쿡 ���Ŵ����
select dataname
  into :sempno
  from syscnfg
 where sysgu = 'Y' and serial = 14 and lineno = '1';

//�⺻â��
select dataname
  into :sdepot
  from syscnfg
 where sysgu = 'Y' and serial = 19 and lineno = '2';

lcount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount
	IF dw_list.getitemstring(lRow, 'opt') = 'Y' THEN 
      i++	
		dw_update.insertrow(i)
		dw_update.SetItem(i, "sabu",  gs_sabu)
		dw_update.SetItem(i, "estno", sJpno + string(i, "000"))

		dw_update.SetItem(i, "saupj",  dw_list.getitemString(lrow, 'saupj'))  //�ΰ������
		
		/* ���ֿ� ���Ź��ֹ�ȣ ���� */
		dw_list.SetItem(lRow,'pur_req_no',sJpno )
		
		dw_update.SetItem(i, "ESTGU", '2')  //�Ƿڱ����� ��ǰ���� ���� 
		
		dw_update.SetItem(i, "order_no",  dw_list.getitemString(lrow, 'order_no'))  //���ֹ�ȣ
		dw_update.SetItem(i, "yebi1",  dw_list.getitemString(lrow, 'accod'))  //�����ڵ�
		
		sItnbr = dw_list.getitemstring( lrow, 'itnbr')
		lSeqNo = dw_list.getitemNumber( lrow, 'seqno')
		If IsNull(lSeqNo) Then lSeqNo = 0
		
      dw_update.SetItem(i, "ITNBR", sitnbr) //ǰ�� 
      dw_update.SetItem(i, "PSPEC", '.')    //���
      dw_update.SetItem(i, "SEQNO", lSeqNo) //��������
		
		sItgu = dw_list.getitemstring( lrow, 'itgu')  //��������
		if sitgu >= '1' and sitgu <= '6' then
			dw_update.setitem(i, "itgu", sitgu)
		else
			dw_update.setitem(i, "itgu", '1')
		end if
		if sitgu = '3' or sitgu = '4' then
			dw_update.SetItem(i, "suipgu", '2')
		else
			dw_update.SetItem(i, "suipgu", '1')
		end if	
		
      f_buy_unprc(sitnbr, '.' , '9999', sCvcod, sCvnas, dUnprc, sTuncu)  //�ŷ�ó, �ܰ�, ��ȭ 

		if sTuncu = '' or isnull(sTuncu) then sTuncu = 'WON'
		dw_update.SetItem(i, "CVCOD",  scvcod)   //�ŷ�ó 
		dw_update.SetItem(i, "TUNCU",  sTuncu)   //��ȭ���� 
		dw_update.SetItem(i, "GUQTY",  dw_list.getitemDecimal(lrow, 'estqty'))  //�Ƿڼ���

		dvnqty = dw_list.getitemDecimal(lrow, 'vnqty')
		dw_update.SetItem(i, "VNQTY",  dvnqty )   //���ֿ�����

		dw_update.SetItem(i, "WIDAT",  f_today())  //�Է����� 
		dw_update.SetItem(i, "YODAT",  dw_list.getitemstring( lrow, 'nadate')) //����䱸�� 
		dw_update.SetItem(i, "BLYND",  '1')   		//�Ƿڻ��·�  
		dw_update.SetItem(i, "RDATE",  ar_date)   //�Ƿ�����
		dw_update.SetItem(i, "RDPTNO", ar_dept)   //�Ƿںμ�   
		dw_update.SetItem(i, "REMPNO", ar_empno)  //�Ƿڴ����
		
		/* �ŷ�ó�� ���Ŵ���ڸ� �⺻���� �ϰ� ������ ȯ�漳���� �̿� */
		select emp_id into :sempno2 from vndmst where cvcod = :scvcod;
		if sempno2 = '' or isnull(sempno2) then 
			sempno2 = sempno
		end if
		
		/* ������ ���â�� �⺻���� �ϰ� ������ ȯ�漳���� �̿� */
		sdepot2 = dw_list.getitemstring(Lrow, "depot_no")
		if sdepot2 = '' or isnull(sdepot2) then 
			sdepot2 = sdepot
		end if		
		
		dw_update.SetItem(i, "SEMPNO", sempno2)  
		dw_update.SetItem(i, "PROJECT_NO", ar_pjtno)  //project no  
		dw_update.SetItem(i, "PLNCRT", '2')      //����,�߰� ����
		dw_update.SetItem(i, "IPDPT",   sdepot2)  //�԰�â��
		dw_update.SetItem(i, "PRCGU",  '2')      //���� ���� 
		dw_update.SetItem(i, "SAKGU",  'N')      //���İ������� 
		dw_update.SetItem(i, "CHOYO",  'N')      //÷������ 
		dw_update.SetItem(i, "OPSEQ", '9999')    //�����ڵ�  
		dw_update.SetItem(i, "AUTCRT", 'N')      //�ڵ����� ����    
		if is_cnvgu = 'N' then 
			dw_update.SetItem(i, "CNVFAT",  1) 
			dw_update.SetItem(i, "CNVART",  is_cnvart) 
			dw_update.SetItem(i, "UNPRC",   dUnprc)   //�ܰ� 
			dw_update.SetItem(i, "CNVPRC",  dUnprc ) 
			dw_update.SetItem(i, "CNVQTY",  dvnqty ) 
		else
			dcnvfat = dw_list.getitemdecimal(lRow, "cnvfat")

			if dcnvfat <= 0 or isnull(dcnvfat) then dcnvfat = 1

			if dcnvfat = 1 then
				dw_update.SetItem(i, "CNVFAT",  1) 
				dw_update.SetItem(i, "CNVART",  is_cnvart) 
				dw_update.SetItem(i, "UNPRC",   dUnprc)   //�ܰ� 
				dw_update.SetItem(i, "CNVPRC",  dUnprc ) 
				dw_update.SetItem(i, "CNVQTY",  dvnqty ) 
			elseif is_cnvart = '/' then
				dw_update.SetItem(i, "CNVFAT",  dcnvfat) 
				dw_update.SetItem(i, "CNVART",  is_cnvart) 
				dw_update.SetItem(i, "CNVPRC",   dUnprc)   //�ܰ� 
				dw_update.SetItem(i, "UNPRC",  round(dUnprc / dcnvfat, 5)) 
				dw_update.SetItem(i, "CNVQTY",  round(dvnqty / dcnvfat, 3)) 
			else
				dw_update.SetItem(i, "CNVFAT",  dcnvfat) 
				dw_update.SetItem(i, "CNVART",  is_cnvart) 
				dw_update.SetItem(i, "CNVPRC",   dUnprc)   //�ܰ� 
				dw_update.SetItem(i, "UNPRC",  round(dUnprc * dcnvfat, 5)) 
				dw_update.SetItem(i, "CNVQTY",  round(dvnqty * dcnvfat, 3)) 
			end if
			
			
		end if
	END IF
NEXT

return 1
end function

on w_sal_06020_popup.create
this.dw_update=create dw_update
this.dw_1=create dw_1
this.cb_close=create cb_close
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_list=create dw_list
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.dw_update,&
this.dw_1,&
this.cb_close,&
this.cb_cancel,&
this.cb_update,&
this.dw_list,&
this.gb_2,&
this.gb_1}
end on

on w_sal_06020_popup.destroy
destroy(this.dw_update)
destroy(this.dw_1)
destroy(this.cb_close)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event key;// Page Up & Page Down & Home & End Key ��� ����
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

event open;If gs_code = '' Or IsNull(gs_code) Then
	Close(this)
	Return
End If

f_window_center_response(this)

is_pino = gs_code

dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_update.SetTransObject(SQLCA)
dw_1.insertrow(0)
dw_1.setitem(1, 'sdate', f_today())

/* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
select dataname
  into :is_cnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
If isNull(is_cnvgu) or Trim(is_cnvgu) = '' then
	is_Cnvgu = 'N'
End if

/* �����Ƿ� -> ����Ȯ�� �����ڸ� ȯ�漳������ �˻��� */
select dataname
  into :is_cnvart
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '4';
If isNull(is_cnvart) or Trim(is_cnvart) = '' then
	is_cnvart = '*'
End if

cb_cancel.TriggerEvent(Clicked!)


end event

type dw_update from datawindow within w_sal_06020_popup
boolean visible = false
integer x = 197
integer y = 1700
integer width = 1221
integer height = 220
string dataobject = "d_sal_06020_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_sal_06020_popup
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 160
integer y = 44
integer width = 3287
integer height = 208
integer taborder = 10
string dataobject = "d_sal_06020_popup1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sDate, sDept, sName, sNull, sname2, sempno, sempnm
int      ireturn 

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN
	/* �Ƿ����� ���� �Ұ� */
	Return 2
	
	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[�Ƿ�����]')
		this.setitem(1, "sdate", f_today())
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'edate' THEN

	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[����䱸��]')
		this.setitem(1, "edate", sNull)
		return 1
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
   return ireturn 	 
	
END IF

end event

event itemerror;return 1
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

type cb_close from commandbutton within w_sal_06020_popup
integer x = 3122
integer y = 1624
integer width = 329
integer height = 100
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ݱ�(&X)"
end type

event clicked;setnull(gs_code)

CLOSE(PARENT)
end event

type cb_cancel from commandbutton within w_sal_06020_popup
integer x = 2784
integer y = 1624
integer width = 329
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

event clicked;dw_list.retrieve(gs_sabu, is_pino)
dw_list.setfocus()

end event

type cb_update from commandbutton within w_sal_06020_popup
integer x = 2446
integer y = 1624
integer width = 329
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

event clicked;int    i, lCount, ireturn, k
string sjpno, sdate, sdept, sempno, sPjtno

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

if lCount < 1 then return 

if dw_1.AcceptText() = -1 then return -1
if dw_list.AcceptText() = -1 then return -1

sDate    = trim(dw_1.GetItemString(1, "sdate"))
sDept 	= dw_1.GetItemString(1, "dept")
sempno 	= dw_1.GetItemString(1, "empno")
spjtno 	= dw_1.GetItemString(1, "jpno")  //������Ʈ ��ȣ

// �Ƿ�����
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	RETURN
END IF

// �Ƿںμ�
IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30,'[�Ƿںμ�]')
	dw_1.SetColumn("dept")
	dw_1.SetFocus()
	RETURN
END IF

// �Ƿڴ����
IF isnull(sempno) or sempno = "" 	THEN
	f_message_chk(30,'[�Ƿڴ����]')
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	RETURN
END IF

FOR i = 1 TO lCount
	ireturn = wf_required_chk(i)
	IF ireturn = -1 THEN
		RETURN
	ELSEIF ireturn = 2 then 
		k++
	END IF
NEXT

IF k < 1 then 
	MessageBox("Ȯ��", "�����Ƿ��ڷḦ ������ �ڷḦ �����ϼ���!")
	return 
END IF

IF MessageBox("Ȯ��", "�����Ƿ��ڷḦ ���� �Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN

//sjpno �� reference��
if wf_estima_insert(sdate, sdept, sempno, spjtno, sjpno) = -1 then return 

IF dw_update.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	return 
END IF

SetPointer(Arrow!)

MessageBox("��ǥ��ȣ Ȯ��", "�Ƿڹ�ȣ : " + left(sjpno, 8) + '-' + mid(sjpno, 9, 4) +  &
                            " �����Ǿ����ϴ�.")

close(parent)
end event

type dw_list from datawindow within w_sal_06020_popup
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 268
integer width = 3447
integer height = 1292
integer taborder = 20
string dataobject = "d_sal_06020_popup"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;Send( Handle(this), 256, 9, 0 )
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

event itemerror;return 1
end event

event itemchanged;string sdate, snull, scode
long   lrow
dec {3}	dQty

setnull(snull)
lrow = this.getrow()
If lrow <= 0 Then Return

dw_1.accepttext()

IF this.GetColumnName() = "opt" THEN
   scode = this.GetText()
	
	if scode = 'Y' then   //���ý� �Ƿڼ����� ��ȯ����, ����䱸�� ����
      dqty = this.getitemDecimal(lrow, 'lotqty')
      this.setitem(lrow, 'estqty', dqty)	   
 		wf_Cal_Qty(dQty, lRow)
      this.setitem(lrow, 'nadate', dw_1.getitemstring(1, 'edate'))	   
	else
      this.setitem(lrow, 'estqty', 0)	   
      this.setitem(lrow, 'vnqty',  0)	   
      this.setitem(lrow, 'cnvqty', 0)	   
      this.setitem(lrow, 'nadate', snull)	   
	end if
	
ELSEIF this.getcolumnname() = 'estqty' then
   dQty = dec(this.GetText())
	wf_Cal_Qty(dQty, lRow)
ELSEIF this.GetColumnName() = "nadate" THEN
	sdate = Trim(this.Gettext())
	IF sdate ="" OR IsNull(sdate) THEN RETURN
	
	IF f_datechk(sdate) = -1 THEN
		f_message_chk(35,'[����䱸��]')
		this.SetItem(lrow, "nadate", snull)
		this.Setcolumn("nadate")
		this.SetFocus()
		Return 1
	END IF
END IF
end event

event constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'")
Modify("jijil_t.text = '" + f_change_name('3') + "'")
end event

type gb_2 from groupbox within w_sal_06020_popup
integer x = 41
integer width = 3442
integer height = 260
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
end type

type gb_1 from groupbox within w_sal_06020_popup
integer x = 2405
integer y = 1568
integer width = 1083
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
end type

