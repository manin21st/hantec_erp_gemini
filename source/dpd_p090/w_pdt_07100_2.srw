$PBExportHeader$w_pdt_07100_2.srw
$PBExportComments$Lot SimulationMainȭ��(�����Ƿڻ��� POPUP)
forward
global type w_pdt_07100_2 from window
end type
type p_select from uo_picture within w_pdt_07100_2
end type
type p_close from uo_picture within w_pdt_07100_2
end type
type p_cancel from uo_picture within w_pdt_07100_2
end type
type p_update from uo_picture within w_pdt_07100_2
end type
type st_2 from statictext within w_pdt_07100_2
end type
type st_1 from statictext within w_pdt_07100_2
end type
type dw_update from datawindow within w_pdt_07100_2
end type
type dw_1 from datawindow within w_pdt_07100_2
end type
type dw_list from datawindow within w_pdt_07100_2
end type
type rr_1 from roundrectangle within w_pdt_07100_2
end type
end forward

global type w_pdt_07100_2 from window
integer x = 110
integer y = 248
integer width = 3872
integer height = 1872
boolean titlebar = true
string title = "�����Ƿ� �ڷ� ����"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_select p_select
p_close p_close
p_cancel p_cancel
p_update p_update
st_2 st_2
st_1 st_1
dw_update dw_update
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
end type
global w_pdt_07100_2 w_pdt_07100_2

type variables
string     is_yymm             //���س��
integer    id_seq                 //����

string     is_cnvgu            //��ȯ�����뿩��
string     is_cnvart            //��ȯ������
string		is_gwgbn
end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_cal_qty (decimal ad_qty, long al_row)
public function integer wf_estima_insert (string ar_date, string ar_dept, string ar_empno, string ar_pjtno, string ar_depot, ref string re_jpno)
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

// ���ִ����� ���� ��ü���ַ� ��ȯ(�Ҽ��� 2�ڸ� ������ ���)
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

public function integer wf_estima_insert (string ar_date, string ar_dept, string ar_empno, string ar_pjtno, string ar_depot, ref string re_jpno);String     sCvcod, sTuncu ,sCvnas, sJpno, sDate, sItnbr, sitgu, sempno, sempno2, sestgu, &
           sSaupj, ls_gwgbn
Dec {5}    dUnprc
dec {6}    dcnvfat       //��ȯ���
dec {3}    dvnqty
long	     lRow, lSeq, lcount, i

sDate = dw_1.GetItemString(1, "sdate")  //�Ƿ�����

lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')

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

lcount = dw_list.RowCount()

//�԰��� â��� �ΰ��� ������� ������
select ipjogun
  into :sSaupj
  from vndmst
 where cvcod  = :ar_depot ; 
 
 //�׷���� ��������
Select dataname into :ls_gwgbn
  from syscnfg
 where sysgu = 'W' and
       serial = 1 and
		 lineno = '2';
  
FOR	lRow = 1		TO		lCount
	IF dw_list.getitemstring(lRow, 'opt') = 'Y' THEN 
      i++	
		i = dw_update.insertrow(0)
		dw_update.SetItem(i, "sabu",  gs_sabu)
		dw_update.SetItem(i, "estno", sJpno + string(i, "000"))
		dw_update.SetItem(i, "saupj", sSaupj)
		sEstgu = dw_list.getitemstring( lrow, 'estgu')  
		dw_update.SetItem(i, "ESTGU", sEstgu)  
		
		dw_update.SetItem(i, "yebi1", dw_list.getitemstring( lrow, 'accod')) //�����ڵ� 
		
		sItnbr = dw_list.getitemstring( lrow, 'itnbr')
      dw_update.SetItem(i, "ITNBR", sitnbr) //ǰ�� 
      dw_update.SetItem(i, "PSPEC", '.')    //���

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
		IF ls_gwgbn = 'Y' THEN
			dw_update.SetItem(i, "BLYND",  '9')   		//�Ƿڰ������·�  
			dw_update.SetItem(i, "gubun",  '0')
		ELSE
			dw_update.SetItem(i, "BLYND",  '1')   		//�Ƿڻ��·�  
			dw_update.SetItem(i, "gubun",  '4')
		END IF
		dw_update.SetItem(i, "RDATE",  ar_date)   //�Ƿ�����
		dw_update.SetItem(i, "RDPTNO", ar_dept)   //�Ƿںμ�   
		dw_update.SetItem(i, "REMPNO", ar_empno)  //�Ƿڴ����
		
		select emp_id into :sempno2 from vndmst where cvcod = :scvcod;

		if sempno2 = '' or isnull(sempno2) then 
			sempno2 = sempno
		end if
		
		dw_update.SetItem(i, "SEMPNO", sempno2)  
		dw_update.SetItem(i, "PROJECT_NO", ar_pjtno)  //project no  
		dw_update.SetItem(i, "PLNCRT", '3')      //����
		dw_update.SetItem(i, "IPDPT",   ar_depot)  //�԰�â��
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

on w_pdt_07100_2.create
this.p_select=create p_select
this.p_close=create p_close
this.p_cancel=create p_cancel
this.p_update=create p_update
this.st_2=create st_2
this.st_1=create st_1
this.dw_update=create dw_update
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_select,&
this.p_close,&
this.p_cancel,&
this.p_update,&
this.st_2,&
this.st_1,&
this.dw_update,&
this.dw_1,&
this.dw_list,&
this.rr_1}
end on

on w_pdt_07100_2.destroy
destroy(this.p_select)
destroy(this.p_close)
destroy(this.p_cancel)
destroy(this.p_update)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_update)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
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

event open;is_yymm  = gs_code
id_seq   = integer(gs_codename)

f_window_center_response(this)

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

//�׷���� ��������
Select dataname into :is_gwgbn
  from syscnfg
 where sysgu = 'W' and
       serial = 1 and
		 lineno = '2';
		 
p_cancel.TriggerEvent(Clicked!)


end event

type p_select from uo_picture within w_pdt_07100_2
integer x = 3145
integer y = 8
integer width = 178
string picturename = "c:\erpman\image\��ü����_up.gif"
end type

event clicked;call super::clicked;Long Lrow, lcount
dec {3}	dQty
string snull

setnull(snull)

if dw_1.AcceptText() = -1 then return 
if dw_list.AcceptText() = -1 then return 

lcount = dw_list.rowcount()

If this.pictureName = "c:\erpman\image\��ü����_up.gif" Then
	For Lrow = 1 to lcount
   	dw_list.Setitem(Lrow, "opt", 'Y')
      dqty = dw_list.getitemDecimal(lrow, 'lotqty')
      dw_list.setitem(lrow, 'estqty', dqty)	   
 		wf_Cal_Qty(dQty, lRow)
      dw_list.setitem(lrow, 'nadate', dw_1.getitemstring(1, 'edate'))	   
	Next
	
	this.pictureName = "c:\erpman\image\��ü����_up.gif"	
Else
	For Lrow = 1 to lcount
   	 dw_list.Setitem(Lrow, "opt", 'N')
       dw_list.setitem(lrow, 'estqty', 0)	   
       dw_list.setitem(lrow, 'vnqty',  0)	   
       dw_list.setitem(lrow, 'cnvqty', 0)	   
       dw_list.setitem(lrow, 'nadate', snull)	   
	Next
	
	this.pictureName = "c:\erpman\image\��ü����_up.gif"
End if
end event

event ue_lbuttonup;call super::ue_lbuttonup;If this.pictureName = "c:\erpman\image\��ü����_up.gif" or  &
   this.pictureName = "c:\erpman\image\��ü����_dn.gif" Then
	this.pictureName = "c:\erpman\image\��ü����_up.gif"
else
	this.pictureName = "c:\erpman\image\��ü����_up.gif"
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;If this.pictureName = "c:\erpman\image\��ü����_up.gif" or  &
   this.pictureName = "c:\erpman\image\��ü����_dn.gif" Then
	this.pictureName = "c:\erpman\image\��ü����_dn.gif"
else
	this.pictureName = "c:\erpman\image\��ü����_dn.gif"
end if
end event

type p_close from uo_picture within w_pdt_07100_2
integer x = 3666
integer y = 8
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\�ݱ�_up.gif"
end type

event clicked;setnull(gs_code)

CLOSE(PARENT)
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "c:\erpman\image\�ݱ�_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "c:\erpman\image\�ݱ�_dn.gif"
end event

type p_cancel from uo_picture within w_pdt_07100_2
integer x = 3493
integer y = 8
integer width = 178
string picturename = "c:\erpman\image\���_up.gif"
end type

event clicked;dw_list.retrieve(gs_sabu, is_yymm, id_seq)
dw_list.setfocus()
p_select.pictureName = "c:\erpman\image\��ü����_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "c:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "c:\erpman\image\���_up.gif"
end event

type p_update from uo_picture within w_pdt_07100_2
integer x = 3319
integer y = 8
integer width = 178
string picturename = "c:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;int    i, lCount, ireturn, k, j = 0
string sjpno, sdate, sdept, sempno, sPjtno, sdepot, sn_cod, so_cod

setNull(gs_code)
setNull(gs_gubun)

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

if lCount < 1 then return 

if dw_1.AcceptText() = -1 then return -1
if dw_list.AcceptText() = -1 then return -1

sDate    = trim(dw_1.GetItemString(1, "sdate"))
sDept 	= dw_1.GetItemString(1, "dept")
sempno 	= dw_1.GetItemString(1, "empno")
spjtno 	= dw_1.GetItemString(1, "jpno")  //������Ʈ ��ȣ
sdepot 	= dw_1.GetItemString(1, "depot")  

// �Ƿ�����
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[�Ƿ�����]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sDepot) or sDepot = "" 	THEN
	f_message_chk(30,'[�԰���â��]')
	dw_1.SetColumn("depot")
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
if wf_estima_insert(sdate, sdept, sempno, spjtno, sdepot, sjpno) = -1 then return 

IF dw_update.Update() > 0		THEN
//	for i = 1 to dw_update.RowCount()
//		sn_cod = dw_update.GetItemString(i, 'cvcod')
//		if sn_cod <> so_cod and i > 1 then
//			so_cod = sn_cod
//			j++
//		end if
//
//		if j > 0 then
//			gs_gubun = '2'
//		else
//			gs_gubun = '1'
//		end if
//	next
//	gs_code = left(dw_update.getitemstring(1, 'estno'),12)
	COMMIT;

	IF is_gwgbn = 'Y' then
		String sEstNo
		sEstNo = left(sjpno,12)
		gs_code  = "%26SABU=1%26ESTNO="+ sEstNo +"&BLYND=9"		//���ֹ�ȣ
		gs_gubun = '00035'										//�׷���� ������ȣ
		gs_codename = '�����Ƿڼ�'									//�����Է¹���
		
		// �׷���� ������ȣ
		SELECT TRIM(DATANAME) INTO :gs_gubun FROM SYSCNFG WHERE SYSGU = 'W' AND SERIAL = 1 AND LINENO = 'A';
		
		WINDOW LW_WINDOW
		OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)

		lw_window.x = 0
		lw_window.y = 0
	End If
ELSE
	ROLLBACK;
	f_Rollback()
	return 
END IF

SetPointer(Arrow!)

MessageBox("��ǥ��ȣ Ȯ��", "�Ƿڹ�ȣ : " + left(sjpno, 8) + '-' + mid(sjpno, 9, 4) +  &
                            " �����Ǿ����ϴ�.")


//gs_code = left(sjpno,12)
//open(w_pdt_04000_2)

close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "c:\erpman\image\����_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "c:\erpman\image\����_dn.gif"
end event

type st_2 from statictext within w_pdt_07100_2
integer x = 1070
integer y = 1708
integer width = 1221
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "�ּ� LOT���� ���� LOT���� �����Ͽ� ���ȴ�."
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdt_07100_2
integer x = 37
integer y = 1708
integer width = 1221
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "�� ���ֿ������� �Ƿڼ����� ǰ�񸶽�Ÿ "
boolean focusrectangle = false
end type

type dw_update from datawindow within w_pdt_07100_2
boolean visible = false
integer x = 736
integer y = 816
integer width = 2958
integer height = 220
string dataobject = "d_pdt_07100_d"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_pdt_07100_2
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer y = 8
integer width = 3131
integer height = 220
integer taborder = 10
string dataobject = "d_pdt_07100_c"
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

event itemchanged;string	sDate, sDept, sName, sNull, sname2, sempno, sempnm, sProject
int      ireturn 

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

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
	IF ireturn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :sdept, :sname
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE"(+) ) and  
				 ( "P1_MASTER"."DEPTCODE"    = "P0_DEPT"."DEPTCODE"(+) ) and  
				 ( ( "P1_MASTER"."EMPNO"     = :sEmpno ) )   ;
   
		this.setitem(1, "dept", sdept)
		this.setitem(1, "deptname", sName)
	END IF	
   return ireturn 	 
ELSEIF this.getcolumnname() = "jpno"	then
	sProject = trim(this.gettext())
	
	if sProject = '' or isnull(sproject) then return 
	
//	SELECT "VW_PROJECT"."SABU"  
//     INTO :sName
//     FROM "VW_PROJECT"  
//    WHERE ( "VW_PROJECT"."SABU"  = :gs_sabu ) AND  
//          ( "VW_PROJECT"."PJTNO" = :sProject )   ;
	SELECT "FLOW_PROJECT"."PROJ_CODE"  
     INTO :sName
     FROM "FLOW_PROJECT"  
    WHERE ( "FLOW_PROJECT"."PROJ_CODE" = :sProject )   ;
	 
	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[������Ʈ ��ȣ]')
		this.setitem(1, "jpno", sNull)
	   return 1
	END IF

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
elseif this.getcolumnname() = "jpno" 	then
//	gs_gubun = '1'
//	open(w_project_popup)
//	if isnull(gs_code)  or  gs_code = ''	then	return
//	this.setitem(1, "jpno", gs_code)
	open(w_wflow_project_pop)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", gs_code)	
end if


end event

type dw_list from datawindow within w_pdt_07100_2
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 268
integer width = 3762
integer height = 1384
integer taborder = 20
string dataobject = "d_pdt_07100_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
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

type rr_1 from roundrectangle within w_pdt_07100_2
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 236
integer width = 3826
integer height = 1440
integer cornerheight = 40
integer cornerwidth = 55
end type

