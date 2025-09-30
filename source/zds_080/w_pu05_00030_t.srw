$PBExportHeader$w_pu05_00030_t.srw
$PBExportComments$** ���ֺ���(���ֹ��ְ���) ó��
forward
global type w_pu05_00030_t from w_inherite
end type
type st_2 from statictext within w_pu05_00030_t
end type
type sle_bal from singlelineedit within w_pu05_00030_t
end type
type p_vnd from uo_picture within w_pu05_00030_t
end type
type st_3 from statictext within w_pu05_00030_t
end type
type rr_2 from roundrectangle within w_pu05_00030_t
end type
type dw_1 from datawindow within w_pu05_00030_t
end type
type cbx_chk from checkbox within w_pu05_00030_t
end type
type gb_1 from groupbox within w_pu05_00030_t
end type
end forward

global type w_pu05_00030_t from w_inherite
integer height = 2516
string title = "���ֺ��� ����"
st_2 st_2
sle_bal sle_bal
p_vnd p_vnd
st_3 st_3
rr_2 rr_2
dw_1 dw_1
cbx_chk cbx_chk
gb_1 gb_1
end type
global w_pu05_00030_t w_pu05_00030_t

type variables
string  ls_auto    //�ڵ�ä������


end variables

forward prototypes
public function integer wf_update (long lrow, string spordno, string sopseq)
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
end prototypes

public function integer wf_update (long lrow, string spordno, string sopseq);//���������� ���(opseq <> '9999') : �۾�����-������(���ָ� �������� ����)
//��ü������ ���(opseq = '9999')  : �۾�����(���ָ� �������� ����)
IF sopseq = '9999' THEN 
     UPDATE MOMAST  
        SET PURGC = 'N',  
            CVCOD = NULL,   
            UNPRC = 0  
		WHERE SABU = :gs_sabu AND PORDNO = :spordno   ;
ELSE
	  UPDATE MOROUT  
        SET PURGC = 'N',  
            WICVCOD = NULL,   
            WIUNPRC = 0  
		WHERE SABU = :gs_sabu AND PORDNO = :spordno AND OPSEQ = :sopseq  ;
END IF		

IF sqlca.sqlcode <> 0 then
	return -1	
END IF
return 1
end function

public function integer wf_required_chk (integer i);string s_blynd, sToday
Dec    ld_vnqty

if dw_insert.AcceptText() = -1 then return -1

stoday  = f_today()
s_blynd = dw_insert.GetItemString(i,'blynd')  //���ֻ���
ld_vnqty = dw_insert.Object.vnqty[i]

if s_blynd <> '2' then return 1 //���ֻ��°� ���䰡 �ƴϸ� �ʼ��Է�üũ ���� ����

if	isnull(trim(dw_insert.GetItemString(i,'yodat'))) or &
	trim(dw_insert.GetItemString(i,'yodat')) = '' then
	f_message_chk(1400,'[ '+string(i)+' �� ���ֿ䱸��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('yodat')
	dw_insert.SetFocus()
	return -1		
end if	

//if	dw_insert.GetItemString(i,'yodat') < sToday  then
//	MessageBox("Ȯ��", "����䱸���� �������ں��� ���� �� �����ϴ�.", stopsign!)	
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('yodat')
//	dw_insert.SetFocus()
//	return -1		
//end if	

if ld_vnqty <= 0  Or isNull(ld_vnqty) Then
	f_message_chk(1400,'[ '+string(i)+' �� ���ֿ�����]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('vnqty')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'cvcod')) or &
	dw_insert.GetItemString(i,'cvcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� ����ó]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	return -1		
end if	

//if isnull(dw_insert.GetItemString(i,'ipdpt')) or &
//	dw_insert.GetItemString(i,'ipdpt') = "" then
//	f_message_chk(1400,'[ '+string(i)+' �� â��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('ipdpt')
//	dw_insert.SetFocus()
//	return -1		
//end if	

if isnull(dw_insert.GetItemNumber(i,'unprc')) or &
	dw_insert.GetItemNumber(i,'unprc') = 0 then
	f_message_chk(1400,'[ '+string(i)+' �� ���ִܰ�]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('unprc')
	dw_insert.SetFocus()
	return -1		
end if	

return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()

string get_name

SELECT "SYSCNFG"."DATANAME"  
  INTO :get_name  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 14 ) AND  
		 ( "SYSCNFG"."LINENO" = '2' )   ;
		 
dw_1.setredraw(true)
dw_insert.setredraw(true)

p_del.enabled = true
p_del.PictureName = "C:\erpman\image\����_up.gif"
p_mod.enabled = true
p_mod.PictureName = "C:\erpman\image\����_up.gif"


end subroutine

on w_pu05_00030_t.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_bal=create sle_bal
this.p_vnd=create p_vnd
this.st_3=create st_3
this.rr_2=create rr_2
this.dw_1=create dw_1
this.cbx_chk=create cbx_chk
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_bal
this.Control[iCurrent+3]=this.p_vnd
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.cbx_chk
this.Control[iCurrent+8]=this.gb_1
end on

on w_pu05_00030_t.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_bal)
destroy(this.p_vnd)
destroy(this.st_3)
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.cbx_chk)
destroy(this.gb_1)
end on

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////
// ���ִ��� ��뿡 ���� ȭ�� ����
//sTring sCnvgu, sCnvart
//
///* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
//select dataname
//  into :sCnvgu
//  from syscnfg
// where sysgu = 'Y' and serial = '12' and lineno = '3';
// 
//If isNull(sCnvgu) or Trim(sCnvgu) = '' then
//	sCnvgu = 'N'
//End if
//
//if sCnvgu = 'Y' then // ���ִ��� ����
//	dw_insert.dataobject = 'd_imt_02100_1_1'
//Else						// ���ִ��� ������
//	dw_insert.dataobject = 'd_imt_02100_1t'	
//End if

dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

string get_name

SELECT "SYSCNFG"."DATANAME"  
  INTO :get_name  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 14 ) AND  
		 ( "SYSCNFG"."LINENO" = '2' )   ;
		 
dw_1.setitem(1, 'sempno', get_name) //���� ����� �⺻ ����
dw_1.setitem(1, 'baldate', is_today) //�������� �⺻ ����
dw_1.setitem(1, 'frdate', f_afterday(f_today(), -30))
dw_1.setitem(1, 'todate', f_today())

/* ���ֹ�ȣ �ڵ�ä�����θ� ȯ�漳������ �˻��� */
select dataname
  into :ls_auto                                       //�ν��Ͻ� ����
  from syscnfg
 where sysgu = 'S' and serial = 6 and lineno = '60';
 
If isNull(ls_auto) or Trim(ls_auto) = '' then
	ls_auto = 'Y'
End if

if ls_auto = 'Y' then 
	sle_bal.Visible = false
	st_2.Visible = false
	st_3.Visible = false
end if

IF f_change_name('1') = 'Y' then 
//	dw_insert.Object.ispec_t.text =  f_change_name('2')
//	dw_insert.Object.jijil_t.text =  f_change_name('3')
END IF




end event

event key;// Page Up & Page Down & Home & End Key ��� ����
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

type dw_insert from w_inherite`dw_insert within w_pu05_00030_t
integer x = 37
integer y = 204
integer width = 4571
integer height = 2096
integer taborder = 20
string title = "[����/�պ���  Double Click ] "
string dataobject = "d_pu05_00030_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String snull, scvcod, get_nm, get_nm2, sblynd, old_sblynd, spordno, get_pdsts, sGajpno, stats, sjestno , sJpno  
long   ll_row, ii_row
int    ireturn
Decimal {5} dData
Decimal dstno, dSeq 

SetNull(snull)

ll_row = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	scvcod = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(ll_row, "cvcod", scvcod)	
	this.setitem(ll_row, "vndmst_cvnas2", get_nm)	
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "blynd" THEN
   old_sblynd = this.getitemstring(ll_row, 'old_blynd')
	sblynd = this.GetText()
   
	IF sblynd = '3' then //���ִ� ������ �� ����
      f_message_chk(71, '[���ֻ���]')
		this.SetItem(ll_row, "blynd", old_sblynd)
      return 1  		
	ELSEIF old_sblynd = '4' then
		sPordno = this.getitemstring(row, 'pordno')
		If not ( sPordno = '' or isnull(sPordno) ) then 
		   SELECT PDSTS  
			  INTO :get_pdsts  
			  FROM MOMAST  
			 WHERE SABU = :gs_sabu AND PORDNO = :sPordno  ;
			 
         if sqlca.sqlcode = 0 then
				if get_pdsts = '6' then 
					MessageBox("Ȯ ��","�۾����ð� ��� �����Դϴ�. �ڷḦ Ȯ���ϼ���" + "~n~n" +&
											 "���ֻ��¸� �����ų �� �����ϴ�.", StopSign! )
					this.SetItem(ll_row, "blynd", old_sblynd)
					Return 1
				end if
			else	
				MessageBox("Ȯ ��","�۾����ù�ȣ�� Ȯ���ϼ���" + "~n~n" +&
										 "���ֻ��¸� �����ų �� �����ϴ�.", StopSign! )
				this.SetItem(ll_row, "blynd", old_sblynd)
				Return 1
			end if	
		End if	
	END IF
// ����䱸��
ELSEIF this.GetColumnName() = 'yodat' THEN
	String sDate
	sDate  = trim(this.gettext())

	IF f_datechk(sDate) = -1	then
		this.setitem(ll_Row, "yodat", f_today())
		return 1
	END IF

//	IF f_today() > sDate	THEN
//		MessageBox("Ȯ��", "����䱸���� �������ں��� ���� �� �����ϴ�.")
//		this.setitem(ll_Row, "yodat", f_today())
//		return 1
//	END IF
ELSEIF this.GetColumnName() = "ipdpt" THEN
	scvcod = this.GetText()
	
	ireturn = f_get_name2('â��', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(ll_row, "ipdpt", scvcod)	
	this.setitem(ll_row, "ipdpt_name", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "baljugu" THEN
	scvcod = this.GetText()
   IF scvcod = 'Y' then 	
      IF this.getitemstring(ll_row, 'blynd') = '4' THEN 
			MessageBox("Ȯ ��","���°� ����� �ڷ�� �������ø� ���� �� �����ϴ�.", StopSign! )
			this.SetItem(ll_row, "baljugu", 'N')
			Return 1
		END IF	
	END IF	
END IF

IF this.getcolumnname() = 'vnqty' then
   dData = dec(this.GetText())
	
	if isnull(dData) then dData = 0
   
	// ��ü���ֿ����� ����
	if getitemdecimal(Ll_row, "cnvfat") = 1   then
		setitem(Ll_row, "cnvqty", dData)
	elseif getitemstring(Ll_row, "cnvart") = '/'  then
		IF ddata = 0 then
			setitem(Ll_row, "cnvqty", 0)			
		else
			setitem(Ll_row, "cnvqty", ROUND(dData / getitemdecimal(Ll_row, "cnvfat"),3))
		end if
	else
		setitem(Ll_row, "cnvqty", ROUND(dData * getitemdecimal(Ll_row, "cnvfat"),3))
	end if
ELSEIF this.getcolumnname() = 'unprc' then
   dData = dec(this.GetText())
	
	if isnull(dData) then dData = 0
   
	// ��ü���ֿ����ܰ� ����
	if getitemdecimal(ll_row, "cnvfat") = 1   then
		setitem(LL_row, "cnvprc", dData)
	elseif getitemstring(LL_row, "cnvart") = '*'  then
		IF ddata = 0 then
			setitem(LL_row, "cnvprc", 0)			
		else
			setitem(LL_row, "cnvprc", ROUND(dData / getitemdecimal(LL_row, "cnvfat"),5))
		end if
	else
		setitem(LL_row, "cnvprc", ROUND(dData * getitemdecimal(LL_row, "cnvfat"),5))
	end if		
ELSEIF this.getcolumnname() = 'parqty' then
   dData = dec(this.GetText())	
	
	// �����۾�
	if dData > 0 then
		
		if dData >= getitemdecimal(Ll_row, "vnqty") then
			Messagebox("���ֺ���", "���ֺ��ҷ��� ������ ���� ũ�ų� �����ϴ�.", stopsign!)
			setitem(Ll_row, "parqty", 0)
			return 1
		end if 
		
		sGajpno = getitemstring(ll_row, "estno")			
		// ��ǥ��ȣä��
		dSeq = SQLCA.FUN_JUNPYO(gs_sabu, Left(sGajpno, 8), 'A0')		
		IF dSeq < 1		THEN
			ROLLBACK;
			f_message_chk(51,'[�԰��Ƿڹ�ȣ]')
			RETURN -1
		END IF
		Commit;
		sJpno  	 = Left(sGajpno, 8) + string(dSeq, "0000")						

		setitem(Ll_row, "vnqty", getitemdecimal(Ll_row, "vnqty") - dData)
		setitem(Ll_row, "cnvqty", getitemdecimal(Ll_row, "cnvqty") - dData)		
		
		ii_row = Ll_row + 1
		dw_insert.insertrow(ii_row)
		dw_insert.object.data[ii_row] = dw_insert.object.data[Ll_row]
		
		Setitem(ii_row, "estno", sJpno + String(1, '000'))		
		setitem(ii_row, "vnqty", dData)
		setitem(ii_row, "cnvqty", dData)		
		setitem(ii_row, "estima_guqty", 0)
		setitem(ii_row, "estima_balseq", 0)
		setitem(ii_row, "parqty", 0)
		setitem(ii_row, "cnvqty", dData)
		setitem(ii_row, "baljugu", 'N')				
		setitem(ii_row, "jestno",  sGajpno)				
		setitem(Ll_row, "parqty", 0)		
		return 1
	End if

	
	// �պ��۾�
	if dData < 0 then
		
		if dData * -1 > getitemdecimal(Ll_row, "vnqty") then
			Messagebox("�����պ�", "�����պ����� ������ ���� ũ�ų� �����ϴ�.", stopsign!)
			setitem(Ll_row, "parqty", 0)
			return 1
		end if 
		
		SetNull(sblynd)
			
		// �� �����Ƿ� ������ ��ȸ�Ͽ� ���� �Ǵ� ��һ����̸� �Ұ�
		sjestno = getitemstring(ll_row, "jestno")
		Select blynd into :stats From Estima
		 Where Sabu = :gs_sabu And estno = :sjestno;
		 
		if sqlca.sqlcode <> 0 or sblynd = '3' or sblynd = '4' then
			Messagebox("�����պ�", "�� �Ƿڳ����� ���� �Ǵ� ��ҵ� �����Դϴ�[�Ǵ� �� �Ƿڳ���].", stopsign!)
			setitem(Ll_row, "parqty", 0)
			return 1
		end if 
		
		setitem(Ll_row, "vnqty", 	getitemdecimal(Ll_row, "vnqty") 	- (dData * -1))		
		setitem(Ll_row, "cnvqty", 	getitemdecimal(Ll_row, "cnvqty") - (dData * -1))				
		
		ii_row = 0
		ii_row = Find("estno = '"+ sjestno+"'", 1, RowCount())
		if ii_row > 0 then
			setitem(ii_row, "vnqty", 	getitemdecimal(ii_row, "vnqty")  + (dData * -1))
			setitem(ii_row, "cnvqty",	getitemdecimal(ii_row, "cnvqty") + (dData * -1))
		Else
			Messagebox("�����պ�", "�� �Ƿڳ����� ȭ�鿡�� �˻��� �� �����ϴ�.", stopsign!)
			setitem(Ll_row, "parqty", 0)
			return 1
		End if
		
		// �������� 0�̵Ǹ� Row����
		if getitemdecimal(ll_row, "vnqty") = 0 then
		   Deleterow(ll_row)
		End if
	End if	
END IF
end event

event dw_insert::itemerror;return 1
end event

event rbuttondown;string snull
long   ll_row

SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(snull)

ll_row = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:����,4:�μ�,5:â��   
      f_message_chk(70, '[����ó]')
		this.SetItem(ll_row, "cvcod", snull)
		this.SetItem(ll_row, "vndmst_cvnas2", snull)
      return 1  		
   END IF
	this.SetItem(ll_row, "cvcod", gs_Code)
	this.SetItem(ll_row, "vndmst_cvnas2", gs_Codename)
END IF

IF this.GetColumnName() = "ipdpt" THEN
	Open(w_vndmst_46_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then return 
	this.SetItem(ll_row, "ipdpt", gs_Code)
	this.SetItem(ll_row, "ipdpt_name", gs_Codename)
END IF
end event

event dw_insert::ue_pressenter;IF this.GetColumnName() = "gurmks" THEN return

Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::doubleclicked;call super::doubleclicked;//if dw_insert.AcceptText() = -1 Then Return 
//IF This.RowCount() < 1 THEN RETURN 
//IF Row < 1 THEN RETURN 
//
////--------------------------------------------------------------------------------------------
//
//string  sBlynd, sDate, sJpno, sEstno
//long    k, il_currow, lCount, lseq
//
//sblynd = this.getitemstring(Row, 'blynd')
//
//IF sblynd = '3' or sblynd = '4' then //���ִ� ������ �� ����
//	f_message_chk(71, '[���ֻ���]')
//	return 1  		
//END IF
//
//gs_code   = this.getitemstring(Row, 'estno')
//sEstno    = gs_code
//sDate     = this.getitemstring(Row, 'rdate')  //�Ƿ�����
//
//il_currow = row 
//
//Open(W_IMT_02010_POPUP)
//
//if Isnull(gs_code) or Trim(gs_code) = "" then return
//dw_hidden.reset()
//dw_hidden.ImportClipboard()
//
//lCount = dw_hidden.rowcount()
//
//if lCount < 1 then 
//	SetPointer(Arrow!)
//	return 
//end if
//
//lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')
//
//IF lSeq < 0	 or lseq > 9999	THEN
//	f_message_chk(51, '')
//   RETURN 
//END IF
//
//COMMIT;
//
//sJpno = sDate + string(lSeq, "0000")
//
//FOR k = 1 TO lCount
//	dw_insert.rowscopy(il_currow, il_currow, primary!, dw_insert, il_currow + k, primary!)
//	dw_insert.setitem(il_currow + k, 'cvcod', dw_hidden.GetitemString(k, 'cvcod'))
//	dw_insert.setitem(il_currow + k, 'vndmst_cvnas2', dw_hidden.GetitemString(k, 'cvnm'))
//	dw_insert.setitem(il_currow + k, 'vnqty', dw_hidden.GetitemDecimal(k, 'vnqty'))
//	dw_insert.setitem(il_currow + k, 'cnvqty', dw_hidden.GetitemDecimal(k, 'cnvqty'))
//	dw_insert.setitem(il_currow + k, 'unprc', dw_hidden.GetitemDecimal(k, 'unprc'))
//	dw_insert.setitem(il_currow + k, 'cnvprc', dw_hidden.GetitemDecimal(k, 'cnvprc'))
//	dw_insert.setitem(il_currow + k, 'tuncu', dw_hidden.GetitemString(k, 'tuncu'))
//	dw_insert.setitem(il_currow + k, 'yodat', dw_hidden.GetitemString(k, 'nadate'))
//	dw_insert.SetItem(il_currow + k, "estno", sJpno + string(k, "000"))
//	dw_insert.SetItem(il_currow + k, "jestno", sEstno)
//	dw_insert.SetItem(il_currow + k, "estima_widat", sdate)	
//NEXT
//
//dw_insert.setitem(il_currow, 'vnqty',  dw_insert.GetitemDecimal(il_currow, 'vnqty')  &
//												 - dw_hidden.GetitemDecimal(1, 'tot_qty'))
//
//dw_insert.setitem(il_currow, 'cnvqty', dw_insert.GetitemDecimal(il_currow, 'cnvqty')  &
//												 - dw_hidden.GetitemDecimal(1, 'tot_cnvqty'))
//
//dw_hidden.reset()
//
//
//MessageBox("��ǥ��ȣ Ȯ��", "�Ƿڹ�ȣ : " +sDate+ '-' + string(lSeq,"0000")+		&
//									 "~r~r�����Ǿ����ϴ�.")
//
//if dw_insert.update() = 1 then
//	w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
//	wf_reset()
//	ib_any_typing = FALSE
//	return 
//end if	
//
//dw_insert.ScrollToRow(il_currow + lCount)
//dw_insert.SetFocus()
//
//SetPointer(Arrow!)
//
end event

type p_delrow from w_inherite`p_delrow within w_pu05_00030_t
boolean visible = false
integer x = 4137
integer y = 2764
end type

type p_addrow from w_inherite`p_addrow within w_pu05_00030_t
boolean visible = false
integer x = 3963
integer y = 2764
end type

type p_search from w_inherite`p_search within w_pu05_00030_t
boolean visible = false
integer x = 3269
integer y = 2764
end type

type p_ins from w_inherite`p_ins within w_pu05_00030_t
boolean visible = false
integer x = 3790
integer y = 2764
end type

type p_exit from w_inherite`p_exit within w_pu05_00030_t
end type

type p_can from w_inherite`p_can within w_pu05_00030_t
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pu05_00030_t
boolean visible = false
integer x = 3442
integer y = 2764
end type

type p_inq from w_inherite`p_inq within w_pu05_00030_t
integer x = 3625
end type

event p_inq::clicked;call super::clicked;string s_blynd, s_frdate, s_todate, s_cvcod


if dw_1.AcceptText() = -1 then return 

s_blynd = dw_1.GetItemString(1,'blynd')  //���ֻ��� 
s_frdate= trim(dw_1.GetItemString(1,'frdate'))  //�Ƿ����� from
s_todate= trim(dw_1.GetItemString(1,'todate'))  //�Ƿ����� to

s_cvcod = dw_1.GetItemString(1,'cvcod')  // �ŷ�ó


if isnull(s_frdate) or trim(s_frdate) = "" then s_frdate = '10000101'
if isnull(s_todate) or trim(s_todate) = "" then s_todate = '99991231'


If dw_insert.DataObject = 'd_pu05_00030_a' Then

	if dw_insert.Retrieve(gs_sabu, s_blynd, s_frdate, s_todate,s_cvcod) <= 0 then 
		//f_message_chk(50,'')
		dw_1.SetFocus()
	end if	
Else
	if dw_insert.Retrieve(gs_sabu, s_frdate, s_todate, s_cvcod) <= 0 then 
		//f_message_chk(50,'')
		dw_1.SetFocus()
	end if	
End If

dw_insert.SetFocus()

ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_pu05_00030_t
boolean visible = false
integer x = 3730
integer y = 2976
end type

type p_mod from w_inherite`p_mod within w_pu05_00030_t
integer x = 4096
end type

event p_mod::clicked;call super::clicked;
if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

If dw_insert.DataObject = 'd_pu05_00030_a' Then                
	
	// ���� ��� =================================================================================
	long i, k, iRtnValue, lcount, lAdd, ltot
	string s_daytime, s_empno, s_baljugu, sBaldate, sdate , s_cvcod 
	datetime dttoday 
	dec      ld_vnqty ,ld_unprc
	String ls_check ,ls_ordate

	lCount = dw_insert.rowcount()
	
	if lCount <= 0 then
		return 
	end if	
	
	s_empno  = dw_1.getitemstring(1, 'sempno')  //���Ŵ����
	
	if isnull(s_empno) or trim(s_empno) = '' then
		Messagebox("���ִ����", "���ִ���ڸ� �Է��Ͻʽÿ�")
		return
	end if
	
	
	FOR i = 1 TO lCount
		w_mdi_frame.sle_msg.text = '�ڷ� Check : [Total : ' + string(lcount) + '  Current : ' + string(i) + ' ]'
		
		ls_check = Trim(dw_insert.Object.baljugu[i])
		
		If ls_check <> 'Y' Then Continue ;
		
		
		s_cvcod  = dw_insert.getitemstring(i, 'cvcod')  //�ŷ�ó 
		ld_vnqty = dw_insert.Object.vnqty[i]
		ls_ordate = Trim(dw_insert.Object.yodat[i])
		ld_unprc  = dw_insert.Object.unprc[i]
		
		if ld_vnqty <= 0  Or isNull(ld_vnqty) Then
			f_message_chk(1400,'[ '+string(i)+' �� ���ֿ�����]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('vnqty')
			dw_insert.SetFocus()
			return 		
		end if	
		
		if isnull(s_cvcod) or trim(s_cvcod) = '' then
			f_message_chk(1400,'[ '+string(i)+' �� ���ֹ���ó]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('cvcod')
			dw_insert.SetFocus()
			
			return	
		end if
      
      if isnull(ls_ordate) or trim(ls_ordate) = '' then
			f_message_chk(1400,'[ '+string(i)+' �� ��������]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('yodat')
			dw_insert.SetFocus()
			
			return
		ElseIf f_datechk(ls_ordate) = -1 Then
			f_message_chk(35,'[ '+string(i)+' �� ��������]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('yodat')
			dw_insert.SetFocus()
			
			
		end if
		
		if ld_unprc <= 0 Or isNull(ld_unprc) then
			f_message_chk(1400,'[ '+string(i)+' �� ���ִܰ�]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('unprc')
			dw_insert.SetFocus()
			return 		
		end if
		
  
		//IF wf_required_chk(i) = -1 THEN RETURN               //�����޼����� �ȶ� , ������ �𸣰ʹ� ajh
	NEXT
	w_mdi_frame.sle_msg.text = ''
	
	if Messagebox('Ȯ ��','���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 
	
	SetPointer(HourGlass!)
	//�������ð� 'Y'�� �ڷḸ �������ڿ� �ð� move 
	SELECT 	SYSDATE
	  INTO	:dtToday
	  FROM 	DUAL;
	
	s_daytime  = String(dtToday,'YYYYMMDD HH:MM:SS')   //�������ýð�
	
	lAdd = 0
	FOR k=1 TO dw_insert.rowcount()
		sle_msg.text = '���� Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
		 s_baljugu = dw_insert.getitemstring(k, "baljugu")  //�������� ����
		 if s_baljugu = 'Y' then
			 dw_insert.setitem(k, "baljutime", s_daytime)
			 lAdd++
		 end if
	NEXT
	w_mdi_frame.sle_msg.text = ''
	
	sDate   = dw_1.getitemstring(1, 'baldate')      //��������
	if sDate = '' or isnull(sdate) then 
		sDate = f_today()
	end if
	
	IF ls_auto = 'N' THEN 
		sBaldate = trim(sle_bal.text)
		IF (sBaldate = '' or isnull(sBaldate)) AND lAdd > 0  THEN 
			MessageBox("Ȯ ��", "������ ���ֹ�ȣ�� �Է��ϼ���!") 
			sle_bal.setfocus()
			return 
		END IF
	ELSE
		sBaldate = sDate 
	END IF
	
	if dw_insert.update() = 1 then
		
		IF lAdd > 0 then 
			iRtnValue = sqlca.erp000000080(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
		ELSE
			iRtnValue = 1
		END IF
	
		IF iRtnValue = 1 THEN
			w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
			ib_any_typing= FALSE
			commit ;
		ELSE
			ROLLBACK;
			f_message_chk(41,'')
			Return
		END IF
	else
		rollback ;
		messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
		return 
	end if	
Else                                                            
	// ���� ���============================================================================== 
	Long    Lrow, get_count, dBalseq, dseq
	String  sbaljpno, sbgubun
	Integer iReturn
	
	iReturn = Messagebox('Ȯ ��','�����ڷḦ ���ó�� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) 
	
	IF iReturn = 2 THEN  Return 
	
	For Lrow = 1 to dw_insert.rowcount()
		 IF dw_insert.getitemstring(Lrow, "cnfm") = 'N' then continue
			  
		 sBaljpno 	= dw_insert.getitemstring(Lrow, "baljpno")
		 dBalseq  	= dw_insert.getitemNumber(Lrow, "balseq")
			 
		 // �����Ƿ� ������ ���� �ڷḦ ����
		 // �Ƿڼ����� ��Ҽ������� ����
		 // ���¸� �Ƿڷ� ����
		 UPDATE "ESTIMA"  
			 SET "BLYND" 	= '1',   
				  "BALJUTIME" = NULL,
				  "BALJPNO"   = NULL,
				  "BALSEQ"    = 0
		 WHERE ( "ESTIMA"."SABU" 	 = :gs_sabu ) AND  
				 ( "ESTIMA"."BALJPNO" = :sBaljpno ) AND  
				 ( "ESTIMA"."BALSEQ"  = :dBalseq )   ;
	
		 If sqlca.sqlcode <> 0  then
			 Rollback;
			 Messagebox("Ȯ ��", "�����Ƿ� �ڷ� ������ �����߻�", stopsign!)
			 return
		 END IF	 		
	
						 
		 // ���� ��� �̷�
		 dseq = 0
		 Select max(calseq) into :dseq from podel_history
		  where sabu = :gs_sabu and baljpno = :sbaljpno and balseq = :dbalseq;
			  
		 if isnull(dseq) then dseq = 0
		 dseq = dseq + 1
			 
		 INSERT INTO "PODEL_HISTORY"  
					( "SABU",        "BALJPNO",       "BALGU",       "BALDATE",       "CVCOD",   
					  "BAL_EMPNO",   "BAL_SUIP",      "PLNOPN",      "PLNCRT",        "PLNAPP",   
					  "PLNBNK",      "BGUBUN",        "BALSEQ",      "ITNBR",         "PSPEC",   
					  "OPSEQ",       "GUDAT",         "NADAT",       "BALQTY",        "RCQTY",   
					  "BFAQTY",      "BPEQTY",        "BTEQTY",      "BJOQTY",        "BCUQTY",   
					  "LCOQTY",      "BLQTY",         "ENTQTY",      "LCBIPRC",       "LCBIAMT",   
					  "ORDER_NO",    "BALSTS",        "ESTGU",       "ESTNO",         "SAYEO",   
					  "FNADAT",      "TUNCU",         "UNPRC",       "UNAMT",         "LSIDAT",   
					  "BQCQTYT",     "BIPWQTY",       "PORDNO",      "CRT_DATE",      "CRT_TIME",   
					  "CRT_USER",    "UPD_DATE",      "UPD_TIME",    "UPD_USER",      "IPDPT",   
					  "CNVFAT",      "CNVART",        "CNVQTY",      "CNVIPG",        "CNVFAQ",   
					  "CNVBPE",      "CNVBTE",        "CNVBJO",      "CNVQCT",        "CNVCUQ",   
					  "CNVPRC",      "CNVAMT",        "CNVBLQ",      "CNVENT",        "CNVLCO",   
					  "CANDAT",                       "CALSEQ",      "CANQTY",        "CANCNV" )  
			 SELECT A.SABU, 	     A.BALJPNO,       B.BALGU, 	    B.BALDATE, 	   B.CVCOD, 
					 B.BAL_EMPNO, 	  B.BAL_SUIP, 	    B.PLNOPN,    	 B.PLNCRT,     	B.PLNAPP,
					 B.PLNBNK, 		  B.BGUBUN,			 A.BALSEQ,	    A.ITNBR,		   A.PSPEC,	
					 A.OPSEQ,		  A.GUDAT,			 A.NADAT,	    A.BALQTY,	      A.RCQTY,
					 A.BFAQTY,		  A.BPEQTY,			 A.BTEQTY,	    A.BJOQTY,	      A.BCUQTY,
					 A.LCOQTY,		  A.BLQTY,			 A.ENTQTY,	    A.LCBIPRC,	      A.LCBIAMT,
					 A.ORDER_NO,	  A.BALSTS,			 NULL,          NULL,            A.SAYEO,
					 A.FNADAT,       A.TUNCU,		    A.UNPRC,		 A.UNAMT,		   A.LSIDAT,
					 A.BQCQTYT, 	  A.BIPWQTY, 	    A.PORDNO,		 TO_CHAR(SYSDATE, 'YYYYMMDD'), 
					 TO_CHAR(SYSDATE, 'HHMMSS'), 
					 :gs_userid,	  NULL,				 NULL,			 NULL, 			   A.IPDPT,	
					 A.CNVFAT,       A.CNVART,        A.CNVQTY,      A.CNVIPG,        A.CNVFAQ,
					 A.CNVBPE,		  A.CNVBTE,        A.CNVBJO,      A.CNVQCT,        A.CNVCUQ, 
					 A.CNVPRC,       A.CNVAMT, 		 A.CNVBLQ,      A.CNVENT,        A.CNVLCO, 
					 TO_CHAR(SYSDATE, 'YYYYMMDD'),	 :dseq,         A.BALQTY,        A.CNVQTY 
			  FROM POBLKT A, POMAST B
			 WHERE A.SABU 		= :gs_sabu
				AND A.BALJPNO	= :SBALJPNO
				AND A.BALSEQ	= :DBALSEQ
				AND A.SABU		= B.SABU
				AND A.BALJPNO	= B.BALJPNO;	 
					
			 If sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
				 Rollback;
				 Messagebox("��������̷�", "������� �̷� �ڷ������� �����߻�", stopsign!)
				 return
			 END IF	 		
		 
		  DELETE FROM "POBLKT"  
			WHERE ( "POBLKT"."SABU" 	= :gs_sabu ) AND  
					( "POBLKT"."BALJPNO" = :sBaljpno ) AND  
					( "POBLKT"."BALSEQ" 	= :dBalseq )   ;
			
		 If sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
			 Rollback;
	
			 Messagebox("�����Ƿ� ����", "�ڷ������� �����߻�", stopsign!)
			 return
		 else	 
			select count(*) into :get_count from poblkt 
			 where sabu = :gs_sabu and baljpno = :sBaljpno ;
	
			 if get_count < 1 then 
				 DELETE FROM "POMAST"  
				  WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
						  ( "POMAST"."BALJPNO" = :sBaljpno )   ;
						  
				 If sqlca.sqlcode <> 0  then
					 Rollback;
					 Messagebox("���ֻ���", "�����ڷ� ������ �����߻�", stopsign!)
					 return
				 END IF	 		
	
			 end if
		 end if
	 
	Next
	
	Commit;

End If
	
SetPointer(Arrow!)

p_inq.TriggerEvent(Clicked!)
	
end event

type cb_exit from w_inherite`cb_exit within w_pu05_00030_t
boolean visible = false
integer x = 3214
integer y = 2568
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_pu05_00030_t
boolean visible = false
integer x = 2510
integer y = 2568
integer taborder = 70
end type

event cb_mod::clicked;call super::clicked;long i, k, iRtnValue, lcount, lAdd, ltot
string s_daytime, s_empno, s_baljugu, sBaldate, sdate 
datetime dttoday

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

lCount = dw_insert.rowcount()

if lCount <= 0 then
	return 
end if	

s_empno  = dw_1.getitemstring(1, 'sempno')  //���Ŵ����
if isnull(s_empno) or trim(s_empno) = '' then
	Messagebox("���ִ����", "���ִ���ڸ� �Է��Ͻʽÿ�")
	return
end if

FOR i = 1 TO lCount
	sle_msg.text = '�ڷ� Check : [Total : ' + string(lcount) + '  Current : ' + string(i) + ' ]'
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT
sle_msg.text = ''

if Messagebox('Ȯ ��','���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 

SetPointer(HourGlass!)
//�������ð� 'Y'�� �ڷḸ �������ڿ� �ð� move 
SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime  = String(dtToday,'YYYYMMDD HH:MM:SS')   //�������ýð�

lAdd = 0
FOR k=1 TO dw_insert.rowcount()
	sle_msg.text = '���� Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
    s_baljugu = dw_insert.getitemstring(k, "baljugu")  //�������� ����
    if s_baljugu = 'Y' then
       dw_insert.setitem(k, "baljutime", s_daytime)
		 lAdd++
	 end if
NEXT
sle_msg.text = ''

sDate   = dw_1.getitemstring(1, 'baldate')      //��������
if sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if

IF ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF (sBaldate = '' or isnull(sBaldate)) AND lAdd > 0  THEN 
		MessageBox("Ȯ ��", "������ ���ֹ�ȣ�� �Է��ϼ���!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = sDate 
END IF

if dw_insert.update() = 1 then
	
	IF lAdd > 0 then 
		iRtnValue = sqlca.erp000000080(gs_sabu, sDate, s_daytime, s_empno, sBaldate)
   ELSE
		iRtnValue = 1
	END IF

	IF iRtnValue = 1 THEN
		sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
		ib_any_typing= FALSE
		commit ;
	ELSE
		ROLLBACK;
		f_message_chk(41,'')
		Return
	END IF
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
	return 
end if	

SetPointer(Arrow!)

cb_inq.TriggerEvent(Clicked!)
	
end event

type cb_ins from w_inherite`cb_ins within w_pu05_00030_t
boolean visible = false
integer x = 603
integer y = 2736
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_pu05_00030_t
boolean visible = false
integer x = 2309
integer y = 2684
integer taborder = 80
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;//Long   irow, irow2, i, lrow
//String sPordno, sOpseq 
//
//if dw_insert.AcceptText() = -1 then return 
//
//if dw_insert.rowcount() <= 0 then return 
//
//irow = dw_insert.getrow() - 1
//irow2 = dw_insert.getrow() + 1
//if irow > 0 then   
//	FOR i = 1 TO irow
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//end if	
//
//FOR i = irow2 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT
//
//If MessageBox("�� ��","���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) <> 1 then Return
//
//lrow = dw_insert.Getrow()
//
//sPordno = dw_insert.getitemstring(lrow, 'pordno')
//sOpseq  = dw_insert.getitemstring(lrow, 'opseq')
//
//dw_insert.DeleteRow(lrow)
//
//If dw_insert.Update() = 1 then
//   if wf_update(lrow, sPordno, sOpseq) = -1 then
//		rollback ;
//		messagebox("��������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
//		return 
//	end if	
//	commit ;
//	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
//	ib_any_typing = false
//else
//	rollback ;
//	messagebox("��������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
//end if	
//
//
end event

type cb_inq from w_inherite`cb_inq within w_pu05_00030_t
boolean visible = false
integer x = 82
integer y = 2568
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;string s_blynd, s_frdate, s_todate, s_empno, s_cvcod
String s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code

if dw_1.AcceptText() = -1 then return 

s_blynd = dw_1.GetItemString(1,'blynd')  //���ֻ��� 
s_frdate= trim(dw_1.GetItemString(1,'frdate'))  //�Ƿ����� from
s_todate= trim(dw_1.GetItemString(1,'todate'))  //�Ƿ����� to
s_empno = dw_1.GetItemString(1,'sempno') //���ִ����
s_cvcod = dw_1.GetItemString(1,'cvcod')  // �ŷ�ó
s_itnbr = dw_1.GetItemString(1,'itnbr')  // ǰ  ��
s_itdsc = dw_1.GetItemString(1,'itdsc')  // ǰ  ��
s_ispec = dw_1.GetItemString(1,'ispec')  // ��  ��
s_jijil = dw_1.GetItemString(1,'jijil')  // ��  ��
s_ispec_code = dw_1.GetItemString(1,'ispec_code')  // �԰��ڵ�

if isnull(s_empno)  or trim(s_empno)  = "" then s_empno  = '%'
if isnull(s_frdate) or trim(s_frdate) = "" then s_frdate = '10000101'
if isnull(s_todate) or trim(s_todate) = "" then s_todate = '99991231'
if isnull(s_itnbr)  or trim(s_itnbr)  = "" then 
	s_itnbr  = '%' 
Else 
	s_itnbr = s_itnbr + '%' 
End if

if isnull(s_itdsc)  or trim(s_itdsc)  = "" then 
	s_itdsc  = '%' 
Else 
	s_itdsc = '%' + s_itdsc + '%' 
End if

if isnull(s_ispec)  or trim(s_ispec)  = "" then 
	s_ispec  = '%' 
Else 
	s_ispec = '%' + s_ispec + '%' 
End if

if isnull(s_jijil)  or trim(s_jijil)  = "" then 
	s_jijil  = '%' 
Else 
	s_jijil = '%' + s_jijil + '%' 
End if

if isnull(s_ispec_code)  or trim(s_ispec_code)  = "" then 
	s_ispec_code  = '%' 
Else 
	s_ispec_code = '%' + s_ispec_code + '%' 
End if

if s_cvcod = '' or isnull(s_cvcod) then 
	dw_insert.SetFilter("")
else
	dw_insert.SetFilter("cvcod = '"+ s_cvcod +" '")
end if
dw_insert.Filter()

if dw_insert.Retrieve(gs_sabu, s_blynd, s_frdate, s_todate, s_empno, s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code) <= 0 then 
	f_message_chk(50,'')
	dw_1.SetFocus()
end if	

dw_insert.SetFocus()

ib_any_typing = FALSE

end event

type cb_print from w_inherite`cb_print within w_pu05_00030_t
boolean visible = false
integer x = 1015
integer y = 2568
integer width = 402
string text = "�ŷ�ó���"
end type

event cb_print::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = dw_1.GetItemString(1,'sempno') //���Ŵ����

open(w_pdm_01045)
end event

type st_1 from w_inherite`st_1 within w_pu05_00030_t
end type

type cb_can from w_inherite`cb_can within w_pu05_00030_t
boolean visible = false
integer x = 2862
integer y = 2568
integer taborder = 90
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_pu05_00030_t
boolean visible = false
integer x = 434
integer y = 2568
integer width = 562
integer taborder = 40
string text = "�ϰ����ּ���"
end type

event cb_search::clicked;call super::clicked;long k

FOR k=1 TO dw_insert.rowcount()
   dw_insert.setitem(k, 'baljugu', 'Y')	
NEXT

end event





type gb_10 from w_inherite`gb_10 within w_pu05_00030_t
boolean visible = false
integer y = 2700
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_pu05_00030_t
end type

type gb_button2 from w_inherite`gb_button2 within w_pu05_00030_t
end type

type st_2 from statictext within w_pu05_00030_t
boolean visible = false
integer x = 3319
integer y = 220
integer width = 535
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "������ ���ֹ�ȣ "
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_bal from singlelineedit within w_pu05_00030_t
event ue_key pbm_keydown
boolean visible = false
integer x = 3867
integer y = 204
integer width = 430
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
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
//	MessageBox("Ȯ ��", "��ϵ� ���ֹ�ȣ�Դϴ�. ������ ���ֹ�ȣ�� Ȯ���ϼ���!")
//	this.text = sNull
//	return 1
//END IF	
//
end event

type p_vnd from uo_picture within w_pu05_00030_t
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 3794
integer y = 24
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\�ŷ�ó���_up.gif"
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\�ŷ�ó���_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\�ŷ�ó���_dn.gif"
end event

event clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = dw_1.GetItemString(1,'sempno') //���Ŵ����

open(w_pdm_01045)
end event

type st_3 from statictext within w_pu05_00030_t
boolean visible = false
integer x = 3314
integer y = 220
integer width = 50
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "*"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_pu05_00030_t
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 192
integer width = 4608
integer height = 2124
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_1 from datawindow within w_pu05_00030_t
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 9
integer y = 16
integer width = 2981
integer height = 164
integer taborder = 10
string dataobject = "d_pu05_00030_1"
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

event itemchanged;string snull, s_estgu, s_name, s_date, scvcod, get_nm, get_nm2
int    ireturn 

setnull(snull)

IF this.GetColumnName() ="frdate" THEN  //�Ƿ����� FROM
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[�Ƿ�����]')
		this.SetItem(1,"frdate",snull)
		this.Setcolumn("frdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="todate" THEN  //�Ƿ����� TO
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[�Ƿ�����]')
		this.SetItem(1,"todate",snull)
		this.Setcolumn("todate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="cvcod" THEN  
	scvcod = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', scvcod, get_nm, get_nm2)
	this.setitem(1, "cvcod", scvcod)	
	this.setitem(1, "cvnas", get_nm)	
	RETURN ireturn
ELSEIF this.GetColumnName() ="blynd" THEN  
	scvcod = this.GetText()
	dw_insert.SetRedraw(False)
   if scvcod = '3' then
		dw_insert.DataObject = 'd_pu05_00030_b'
		dw_insert.SetTransObject(SQLCA)
		cb_search.enabled = false
		cb_mod.enabled = false
		cb_del.enabled = false
		
	else
		dw_insert.DataObject = 'd_pu05_00030_a'
		dw_insert.SetTransObject(SQLCA)
		cb_search.enabled = true
		cb_mod.enabled = true
		cb_del.enabled = true
		
	end if
	
	dw_insert.reset()	
	
	dw_insert.SetRedraw(True)
	
ELSEIF this.GetColumnName() ="baldate" THEN  
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[��������]')
		this.SetItem(1,"baldate",is_today)
		this.Setcolumn("baldate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.getcolumnname() = "sempno" Then
	scvcod = Trim(this.Gettext())
	if IsNull(scvcod) or trim(sCvcod) = '' then
		setitem(1, "sempno", sNull)
	Else
		Select rfna1 into :s_name
		  From reffpf
		 Where rfcod = '43' and rfgub = :sCvcod;
		If sqlca.sqlcode <> 0 then
			MessageBox("���ִ��", "���ִ���ڰ� ����Ȯ�մϴ�", stopsign!)
			setitem(1, "sempno", sNull)			
			return 1
		End if
	End if
END IF	
end event

event itemerror;return 1
end event

event rbuttondown;string get_dptno, get_cvnm, get_date, s_estno

setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
ElseIF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	this.SetItem(1,"itnbr",gs_code)
ELSEIF this.GetColumnName() = "itdsc"	THEN
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
ELSEIF this.GetColumnName() = "ispec"	THEN
	Open(w_itemas_popup)
	this.SetItem(1,"itnbr",gs_code)
ELSEIF this.GetColumnName() = "jijil"	THEN
	Open(w_itemas_popup)
	this.SetItem(1,"jijil",gs_code)
END IF	
end event

type cbx_chk from checkbox within w_pu05_00030_t
integer x = 3045
integer y = 80
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ü����"
borderstyle borderstyle = stylelowered!
end type

event clicked;long k
If cbx_chk.checked Then
	FOR k=1 TO dw_insert.rowcount()
		If dw_insert.DataObject = 'd_pu05_00030_a' Then
			dw_insert.setitem(k, 'baljugu', 'Y')	
		Else
			dw_insert.setitem(k, 'cnfm', 'Y')	
		End If
	NEXT
Else
	FOR k=1 TO dw_insert.rowcount()
		If dw_insert.DataObject = 'd_pu05_00030_a' Then
			dw_insert.setitem(k, 'baljugu', 'N')	
		Else
			dw_insert.setitem(k, 'cnfm', 'N')	
		End If
	NEXT
End If

end event

type gb_1 from groupbox within w_pu05_00030_t
integer x = 2999
integer y = 24
integer width = 434
integer height = 148
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

