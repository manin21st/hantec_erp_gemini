$PBExportHeader$w_imt_02100.srw
$PBExportComments$���ֹ��ְ���
forward
global type w_imt_02100 from w_inherite
end type
type dw_1 from datawindow within w_imt_02100
end type
type st_2 from statictext within w_imt_02100
end type
type sle_bal from singlelineedit within w_imt_02100
end type
type dw_hidden from datawindow within w_imt_02100
end type
type p_serch from uo_picture within w_imt_02100
end type
type p_vnd from uo_picture within w_imt_02100
end type
type st_3 from statictext within w_imt_02100
end type
type p_1 from uo_picture within w_imt_02100
end type
type p_2 from picture within w_imt_02100
end type
type rr_1 from roundrectangle within w_imt_02100
end type
type rr_2 from roundrectangle within w_imt_02100
end type
end forward

global type w_imt_02100 from w_inherite
integer height = 3772
string title = "���ֹ��ְ���"
dw_1 dw_1
st_2 st_2
sle_bal sle_bal
dw_hidden dw_hidden
p_serch p_serch
p_vnd p_vnd
st_3 st_3
p_1 p_1
p_2 p_2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_02100 w_imt_02100

type variables
string  ls_auto    //�ڵ�ä������


end variables

forward prototypes
public function integer wf_update (long lrow, string sPordno, string sOpseq)
public subroutine wf_reset ()
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_update (long lrow, string sPordno, string sOpseq);//���������� ���(opseq <> '9999') : �۾�����-������(���ָ� �������� ����)
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

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(true)

p_serch.enabled = true
p_serch.PictureName = "C:\erpman\image\�ϰ�����_up.gif"
p_del.enabled = true
p_del.PictureName = "C:\erpman\image\����_up.gif"
p_mod.enabled = true
p_mod.PictureName = "C:\erpman\image\����_up.gif"


end subroutine

public function integer wf_required_chk (integer i);string s_blynd, sToday

if dw_insert.AcceptText() = -1 then return -1

stoday  = f_today()
s_blynd = dw_insert.GetItemString(i,'blynd')  //���ֻ���

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

if isnull(dw_insert.GetItemNumber(i,'vnqty')) or &
	dw_insert.GetItemNumber(i,'vnqty') = 0 then
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

if isnull(dw_insert.GetItemString(i,'ipdpt')) or &
	dw_insert.GetItemString(i,'ipdpt') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� â��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ipdpt')
	dw_insert.SetFocus()
	return -1		
end if	

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

on w_imt_02100.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.sle_bal=create sle_bal
this.dw_hidden=create dw_hidden
this.p_serch=create p_serch
this.p_vnd=create p_vnd
this.st_3=create st_3
this.p_1=create p_1
this.p_2=create p_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_bal
this.Control[iCurrent+4]=this.dw_hidden
this.Control[iCurrent+5]=this.p_serch
this.Control[iCurrent+6]=this.p_vnd
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.p_1
this.Control[iCurrent+9]=this.p_2
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
end on

on w_imt_02100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.sle_bal)
destroy(this.dw_hidden)
destroy(this.p_serch)
destroy(this.p_vnd)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////
// ���ִ��� ��뿡 ���� ȭ�� ����
sTring sCnvgu, sCnvart
String	 ls_dept, ls_estgu


/* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

if sCnvgu = 'Y' then // ���ִ��� ����
	dw_insert.dataobject = 'd_imt_02100_1_1'
Else						// ���ִ��� ������
	dw_insert.dataobject = 'd_imt_02100_1'	
End if

// ���źμ� Login Ȯ�� ����.

SELECT "SYSCNFG"."DATANAME"  
  INTO :ls_dept 
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 12 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' )   ;

// ����/���ִ����
f_child_saupj(dw_1, 'sempno', gs_saupj)
//datawindowchild state_child, state_child1
//integer rtncode
//// - Head
//rtncode 	= dw_1.GetChild('sempno', state_child)
//IF 	rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ����")
//state_child.SetTransObject(SQLCA)
//If	gs_saupj	= '%'	then
//	state_child.Retrieve("1", "2", gs_saupj)    // -- ��ü
//Else	
//	if	gs_dept  = ls_dept 	then
//		state_child.Retrieve("1", "1", gs_saupj)    // -- ����
//	Else
//		state_child.Retrieve("2", "2", gs_saupj)    // -- ���� 
//	End If
//End If

// - Detail
f_child_saupj(dw_insert, 'sempno', gs_saupj)
//rtncode 	= dw_insert.GetChild('sempno', state_child)
//IF 	rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ����")
//state_child.SetTransObject(SQLCA)
//If	gs_saupj	= '%'	then
//	state_child.Retrieve("1", "2", gs_saupj)    // -- ��ü
//Else	
//	if	gs_dept  = ls_dept 	then
//		state_child.Retrieve("1", "1", gs_saupj)    // -- ����
//	Else
//		state_child.Retrieve("2", "2", gs_saupj)    // -- ���� 
//	End If
//End If	

dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

// ----  Text ���� (Condition Text)
if	gs_dept  = ls_dept 	then
	dw_1.object.t_name.text = '���Ŵ����'    // -- ����
Else
	dw_1.object.t_name.text = '���ִ����'    // -- ���� 
End If

string get_name

if	gs_dept  = ls_dept 	then
	SELECT "SYSCNFG"."DATANAME"  
	  INTO :get_name  
	  FROM "SYSCNFG"  
	 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
			 ( "SYSCNFG"."SERIAL" = 14 ) AND  
			 ( "SYSCNFG"."LINENO" = '1' )   ;              // -- ����
Else
	SELECT "SYSCNFG"."DATANAME"  
	  INTO :get_name  
	  FROM "SYSCNFG"  
	 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
			 ( "SYSCNFG"."SERIAL" = 14 ) AND  
			 ( "SYSCNFG"."LINENO" = '2' )   ;              // -- ����
End If			

//dw_1.setitem(1, 'sempno', get_name) //���� ����� �⺻ ����
dw_1.setitem(1, 'baldate', is_today) //�������� �⺻ ����
dw_1.setitem(1, 'frdate', f_afterday(f_today(), -30))
dw_1.setitem(1, 'todate', f_today())

/* ���ֹ�ȣ �ڵ�ä�����θ� ȯ�漳������ �˻��� */
select dataname
  into :ls_auto
  from syscnfg
 where sysgu = 'S' and serial = 6 and lineno = '60';
 
If isNull(ls_auto) or Trim(ls_auto) = '' then
	ls_auto = 'Y'
End if

if 	ls_auto = 'Y' then 
	sle_bal.Visible 	= false
	st_2.Visible 		= false
	st_3.Visible		= false
end if

dw_hidden.settransobject(sqlca)

//DataWindowChild state1
//
//dw_1.GetChild('sempno', state1)
//
//state1.setSort("rfgub A")
//state1.sort()

f_mod_saupj(dw_1, 'saupj')
f_mod_saupj(dw_insert, 'saupj')

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

type dw_insert from w_inherite`dw_insert within w_imt_02100
integer x = 37
integer y = 332
integer width = 4571
integer height = 1984
integer taborder = 20
string title = "[����/�պ���  Double Click ] "
string dataobject = "d_imt_02100_1"
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

ELSEIF this.GetColumnName() = 'pspec' THEN	
	if isnull( gettext() ) or trim( gettext() ) = '' then
		setitem(ll_row, "pspec", '.')
		return 2
	End if
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

event dw_insert::doubleclicked;call super::doubleclicked;if dw_insert.AcceptText() = -1 Then Return 
IF This.RowCount() < 1 THEN RETURN 
IF Row < 1 THEN RETURN 

//--------------------------------------------------------------------------------------------

string  sBlynd, sDate, sJpno, sEstno
long    k, il_currow, lCount, lseq

sblynd = this.getitemstring(Row, 'blynd')

IF this.getcolumnname() = 'blynd' then
	sblynd = this.gettext()
	IF 	sblynd = '3' or sblynd = '2'  then //���ִ� ������ �� ����
		f_message_chk(71, '[���ֻ���]')
		return 1  		
	END IF
End if 
// -- �������� ���ֿ�����ȣ�� ã�Ƽ� Ȯ���� ����Ÿ�� �̰��Ѵ�.
//gs_code 	= this.getitemstring(Row, 'jestno')
//If	isNull(gs_code) or gs_code = ""	then
	gs_code   = this.getitemstring(Row, 'estno')
//End If
sEstno    = gs_code
sDate     = this.getitemstring(Row, 'rdate')  //�Ƿ�����

il_currow = row 

Open(W_IMT_02010_POPUP)

if Isnull(gs_code) or Trim(gs_code) = "" then return
dw_hidden.reset()
dw_hidden.ImportClipboard()

lCount = dw_hidden.rowcount()

if lCount < 1 then 
	SetPointer(Arrow!)
	return 
end if

lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'A0')

IF lSeq < 0	 or lseq > 9999	THEN
	f_message_chk(51, '')
   RETURN 
END IF

COMMIT;

sJpno = sDate + string(lSeq, "0000")

FOR k = 1 TO lCount
	dw_insert.rowscopy(il_currow, il_currow, primary!, dw_insert, il_currow + k, primary!)
	dw_insert.setitem(il_currow + k, 'cvcod', dw_hidden.GetitemString(k, 'cvcod'))
	dw_insert.setitem(il_currow + k, 'vndmst_cvnas2', dw_hidden.GetitemString(k, 'cvnm'))
	dw_insert.setitem(il_currow + k, 'vnqty', dw_hidden.GetitemDecimal(k, 'vnqty'))
	dw_insert.setitem(il_currow + k, 'cnvqty', dw_hidden.GetitemDecimal(k, 'cnvqty'))
	dw_insert.setitem(il_currow + k, 'unprc', dw_hidden.GetitemDecimal(k, 'unprc'))
	dw_insert.setitem(il_currow + k, 'cnvprc', dw_hidden.GetitemDecimal(k, 'cnvprc'))
	dw_insert.setitem(il_currow + k, 'tuncu', dw_hidden.GetitemString(k, 'tuncu'))
	dw_insert.setitem(il_currow + k, 'yodat', dw_hidden.GetitemString(k, 'nadate'))
	dw_insert.SetItem(il_currow + k, "estno", sJpno + string(k, "000"))
	dw_insert.SetItem(il_currow + k, "jestno", sEstno)
	dw_insert.SetItem(il_currow + k, "estima_widat", sdate)	
NEXT

dw_insert.setitem(il_currow, 'vnqty',  dw_insert.GetitemDecimal(il_currow, 'vnqty')  &
												 - dw_hidden.GetitemDecimal(1, 'tot_qty'))

dw_insert.setitem(il_currow, 'cnvqty', dw_insert.GetitemDecimal(il_currow, 'cnvqty')  &
												 - dw_hidden.GetitemDecimal(1, 'tot_cnvqty'))

dw_hidden.reset()


MessageBox("��ǥ��ȣ Ȯ��", "�Ƿڹ�ȣ : " +sDate+ '-' + string(lSeq,"0000")+		&
									 "~r~r�����Ǿ����ϴ�.")

if 	dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   	messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
	wf_reset()
	ib_any_typing = FALSE
	return 
end if	

dw_insert.ScrollToRow(il_currow + lCount)
dw_insert.SetFocus()

SetPointer(Arrow!)

end event

type p_delrow from w_inherite`p_delrow within w_imt_02100
boolean visible = false
integer x = 4137
integer y = 2764
end type

type p_addrow from w_inherite`p_addrow within w_imt_02100
boolean visible = false
integer x = 3963
integer y = 2764
end type

type p_search from w_inherite`p_search within w_imt_02100
integer x = 3387
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event p_search::clicked;call super::clicked;long i, k, iRtnValue, lcount, lAdd, ltot, ll_count = 0 , ll_i
string s_daytime, s_empno, s_baljugu, sBaldate, sdate , sBlynd,sEstima_gu_pordno
datetime dttoday

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

lCount = dw_insert.rowcount()

if 	lCount <= 0 then
	return 
end if	

if dw_insert.rowcount() < 1 then return 

For i = 1 to dw_insert.rowcount() 
	 if dw_insert.object.blynd[i] = '2' and dw_insert.object.baljugu[i] = 'Y'  then 
	 	 ll_count = ll_count + 1 
	 end if 	
Next

if ll_count < 1 then 
	Messagebox('Ȯ��', '���� �� ������ Ȯ���Ͻÿ�.~n����-->����, ����-->üũ') 
	Return
End if 

For ll_i = 1 to dw_insert.rowcount() 
	s_empno  = dw_insert.getitemstring(ll_i, 'sempno')  //���Ŵ����
	if 	isnull(s_empno) or trim(s_empno) = '' then
		Messagebox("���ִ����", "���ִ���ڸ� �Է��Ͻʽÿ�")
		return
	end if
Next 


FOR i = 1 TO lCount
	w_mdi_frame.sle_msg.text = '�ڷ� Check : [Total : ' + string(lcount) + '  Current : ' + string(i) + ' ]'
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT
w_mdi_frame.sle_msg.text = ''

if Messagebox('Ȯ ��','���õ� ������ ���ؼ� ���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 

SetPointer(HourGlass!)
//�������ð� 'Y'�� �ڷḸ �������ڿ� �ð� move 
SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;

s_daytime  = String(dtToday,'YYYYMMDD HH:MM:SS')   //�������ýð�

FOR k=1 TO dw_insert.rowcount()
		sle_msg.text = '���� Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
    	s_baljugu = dw_insert.getitemstring(k, "baljugu")  //�������� ����
		sBlynd  = dw_insert.getitemstring(k,'blynd') 
		sestima_gu_pordno = dw_insert.getitemstring(k,'estima_gu_pordno') 

//		if s_baljugu = 'Y' and sBlynd = '2' then
//			if trim(sestima_gu_pordno) = '' or isnull(sestima_gu_pordno) then
//				Messagebox('Ȯ��', '������� �Ƿڹ�ȣ�� �������� �ʾҽ��ϴ�.~n�Ƿڹ�ȣ�� ���� ������ �� ����ó�� �� �� �ֽ��ϴ�') 
//				return
//			End if 
// 		end if
NEXT

lAdd = 0
FOR k=1 TO dw_insert.rowcount()
	sle_msg.text = '���� Check : [Total : ' + string(lcount) + '  Current : ' + string(k) + ' ]'	
    	s_baljugu = dw_insert.getitemstring(k, "baljugu")  //�������� ����
		sBlynd  = dw_insert.getitemstring(k,'blynd') 

    	if s_baljugu = 'Y' and sBlynd = '2' then
       	dw_insert.setitem(k, "baljutime", s_daytime)
			dw_insert.setitem(k, "blynd", '3')
		 	lAdd++
 		end if
NEXT
w_mdi_frame.sle_msg.text = ''

sDate   = dw_1.getitemstring(1, 'baldate')      //��������
if 	sDate = '' or isnull(sdate) then 
	sDate = f_today()
end if

IF 	ls_auto = 'N' THEN 
	sBaldate = trim(sle_bal.text)
	IF 	(sBaldate = '' or isnull(sBaldate)) AND lAdd > 0  THEN 
		MessageBox("Ȯ ��", "������ ���ֹ�ȣ�� �Է��ϼ���!") 
		sle_bal.setfocus()
		return 
	END IF
ELSE
	sBaldate = sDate 
END IF

if 	dw_insert.update() = 1 then
	
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

SetPointer(Arrow!)

p_inq.TriggerEvent(Clicked!)



end event

type p_ins from w_inherite`p_ins within w_imt_02100
boolean visible = false
integer x = 3790
integer y = 2764
end type

type p_exit from w_inherite`p_exit within w_imt_02100
end type

type p_can from w_inherite`p_can within w_imt_02100
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_imt_02100
boolean visible = false
integer x = 3442
integer y = 2764
end type

type p_inq from w_inherite`p_inq within w_imt_02100
integer x = 3730
end type

event p_inq::clicked;call super::clicked;string s_blynd, s_frdate, s_todate, s_empno, s_cvcod, sYebi2='0'
String s_itnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code
String 	ls_dept, ls_estgu, ls_pdtgu

if dw_1.AcceptText() = -1 then return 

s_blynd 	= dw_1.GetItemString(1,'blynd')  			//���ֻ��� 
s_frdate	= trim(dw_1.GetItemString(1,'frdate'))  	//�Ƿ����� from
s_todate	= trim(dw_1.GetItemString(1,'todate'))  	//�Ƿ����� to
s_empno 	= dw_1.GetItemString(1,'sempno') 		//���ִ����
s_cvcod 	= dw_1.GetItemString(1,'cvcod')  			// �ŷ�ó
s_itnbr 	= dw_1.GetItemString(1,'itnbr')  			// ǰ  ��
s_itdsc 	= dw_1.GetItemString(1,'itdsc')  			// ǰ  ��
s_ispec 	= dw_1.GetItemString(1,'ispec')  			// ��  ��
s_jijil 		= dw_1.GetItemString(1,'jijil')  				// ��  ��
s_ispec_code = dw_1.GetItemString(1,'ispec_code')  // �԰��ڵ�
ls_pdtgu 	= dw_1.GetItemString(1,'steam')  			// ������.

if 	isnull(s_empno)  or trim(s_empno)  = "" then s_empno  = '%'
if 	isnull(s_frdate) or trim(s_frdate) = "" then s_frdate = '10000101'
if 	isnull(s_todate) or trim(s_todate) = "" then s_todate = '99991231'

if 	isnull(s_cvcod)  or trim(s_cvcod)  = "" then 
	s_cvcod  = '%' 
Else 
	s_cvcod = s_cvcod + '%' 
End if
if 	isnull(s_itnbr)  or trim(s_itnbr)  = "" then 
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

if isnull(ls_pdtgu)  or trim(ls_pdtgu)  = "" then 
	ls_pdtgu  = '%' 
Else 
	ls_pdtgu =  ls_pdtgu + '%' 
End if

//if s_cvcod = '' or isnull(s_cvcod) then 
//	dw_insert.SetFilter("")
//else
//	dw_insert.SetFilter("cvcod = '"+ s_cvcod +" '")
//end if
//dw_insert.Filter()
//
//

// ���źμ� Login Ȯ�� ����.
SELECT "SYSCNFG"."DATANAME"  
  INTO :ls_dept 
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 12 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' )   ;
if	ls_dept	=	gs_dept	then
	ls_estgu	= '1'             // -- ����
Else
	ls_estgu	= '3'             // -- ����
End If

ls_estgu	= '3'             // -- ����

If s_blynd = '%' Then
	sYebi2 = '%'
ElseIf s_blynd = '2' Then	// ����
	sYebi2 = '4'
Else
	sYebi2 = '0'
End If

if 	dw_insert.Retrieve(gs_sabu, s_blynd, s_frdate, s_todate, s_empno, s_itnbr,  &
                                   s_itdsc, s_ispec, s_jijil, s_ispec_code, s_cvcod, ls_estgu ,ls_pdtgu, sYebi2) <= 0 			then 
	f_message_chk(50,'')
	dw_1.SetFocus()
end if	

dw_insert.SetFocus()

ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_imt_02100
boolean visible = false
integer x = 3730
integer y = 2976
end type

type p_mod from w_inherite`p_mod within w_imt_02100
integer x = 4096
end type

event p_mod::clicked;call super::clicked;long i, k, iRtnValue, lcount, lAdd, ltot
string s_daytime, s_empno, s_baljugu, sBaldate, sdate 
datetime dttoday

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

lCount = dw_insert.rowcount()

if 	lCount <= 0 then
	return 
end if	

s_empno  = dw_1.getitemstring(1, 'sempno')  //���Ŵ����
if 	isnull(s_empno) or trim(s_empno) = '' then
	Messagebox("���ִ����", "���ִ���ڸ� �Է��Ͻʽÿ�")
	return
end if

FOR i = 1 TO lCount
	w_mdi_frame.sle_msg.text = '�ڷ� Check : [Total : ' + string(lcount) + '  Current : ' + string(i) + ' ]'
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT
w_mdi_frame.sle_msg.text = ''

if Messagebox('Ȯ ��','���� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) = 2 then return 

SetPointer(HourGlass!)
//�������ð� 'Y'�� �ڷḸ �������ڿ� �ð� move 
SELECT 	SYSDATE
  INTO	:dtToday
  FROM 	DUAL;


if 	dw_insert.update() = 1 then
	
	iRtnValue = 1
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

SetPointer(Arrow!)

p_inq.TriggerEvent(Clicked!)
	
end event

type cb_exit from w_inherite`cb_exit within w_imt_02100
integer x = 3214
integer y = 2568
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_imt_02100
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

type cb_ins from w_inherite`cb_ins within w_imt_02100
integer x = 603
integer y = 2736
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_02100
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

type cb_inq from w_inherite`cb_inq within w_imt_02100
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

type cb_print from w_inherite`cb_print within w_imt_02100
integer x = 1015
integer y = 2568
integer width = 402
string text = "�ŷ�ó���"
end type

event cb_print::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = dw_1.GetItemString(1,'sempno') //���Ŵ����

open(w_pdm_01045)
end event

type st_1 from w_inherite`st_1 within w_imt_02100
end type

type cb_can from w_inherite`cb_can within w_imt_02100
integer x = 2862
integer y = 2568
integer taborder = 90
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_imt_02100
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





type gb_10 from w_inherite`gb_10 within w_imt_02100
integer y = 2700
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_02100
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02100
end type

type dw_1 from datawindow within w_imt_02100
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 56
integer width = 2843
integer height = 256
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02100_a"
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
String  sItnbr, sItDsc ,sIspec ,sispeccode, sjijil
int    ireturn , ll_i 

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
   if scvcod = '3' then 
		cb_search.enabled = false
		cb_mod.enabled = false
		cb_del.enabled = false
	else	
		cb_search.enabled = true
		cb_mod.enabled = true
		cb_del.enabled = true
	end if
   dw_insert.reset()	
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
		
		//���ֹ����� �ڵ� ���� 
		if dw_insert.rowcount() < 1 then return 
		For ll_i= 1 to dw_insert.rowcount() 
			 dw_insert.object.sempno[ll_i] = scvcod
		Next	
	End if
END IF	


Choose Case GetColumnName() 
	Case	"itnbr" 
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("ǰ��", "��ϵ��� ���� ǰ���Դϴ�", stopsign!)
         p_can.triggerevent(clicked!)
			setitem(1, "itnbr", snull)
			setitem(1, "itdsc", snull)
			setitem(1, "ispec", snull)
			Return 1
		END IF
	
		SetItem(1,"itdsc",   sItDsc)
		SetItem(1,"ispec",   sIspec)
		
	/* �԰� */
	Case "itdsc"
		sItdsc = trim(GetText())	
		/* ǰ������ ǰ��ã�� */
		f_get_name4_sale('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
         p_can.triggerevent(clicked!)			
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(1,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         p_can.triggerevent(clicked!)
			SetColumn("itdsc")
			Return 1
		End If
		
	/* �԰� */
	Case "ispec"
		sIspec = trim(GetText())	
		/* ǰ������ ǰ��ã�� */
		f_get_name4_sale('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(1,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         		p_can.triggerevent(clicked!)
			SetColumn("ispec")
			Return 1
		End If		
		
END Choose

end event

event itemerror;return 1
end event

event rbuttondown;string get_dptno, get_cvnm, get_date, s_estno
integer nRow

setnull(gs_code)
setnull(gs_codename)

nRow     = GetRow()
If nRow <= 0 Then Return


Choose Case GetcolumnName() 
	Case "cvcod"
		gs_gubun ='1'
		Open(w_vndmst_popup)
	
		IF isnull(gs_Code)  or  gs_Code = ''	then
			return
		END IF
		this.SetItem(1, "cvcod", gs_Code)
		this.SetItem(1, "cvnas", gs_Codename)
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case "itdsc"
		gs_gubun = '1'
		gs_codename = GetText()
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	Case "ispec"
		gs_gubun = '1'
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
END Choose
end event

type st_2 from statictext within w_imt_02100
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

type sle_bal from singlelineedit within w_imt_02100
event ue_key pbm_keydown
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

type dw_hidden from datawindow within w_imt_02100
boolean visible = false
integer x = 1467
integer y = 2740
integer width = 411
integer height = 432
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_02010_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_serch from uo_picture within w_imt_02100
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3904
integer y = 24
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\�ϰ�����_up.gif"
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\�ϰ�����_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\�ϰ�����_up.gif"
end event

event clicked;call super::clicked;long k

FOR k=1 TO dw_insert.rowcount()
	IF dw_insert.object.blynd[k] = '2' then 
	   dw_insert.setitem(k, 'baljugu', 'Y')	
	end if 
NEXT

end event

type p_vnd from uo_picture within w_imt_02100
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
boolean visible = false
integer x = 4315
integer y = 184
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\�ŷ�ó���_up.gif"
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\�ŷ�ó���_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\�ŷ�ó���_dn.gif"
end event

event clicked;call super::clicked;String ls_grant

if 	dw_1.AcceptText() = -1 then return 

Select  l_saupj	into :ls_grant  from login_t
 where L_USERID = :gs_userid;
 
if	ls_grant <> '%' 	then
	messagebox('Ȯ��', '�ŷ�ó��Ͽ��� �۾��� �Ͽ� ����Ͻñ� �ٶ��ϴ� !!')
	return
End If

gs_code = dw_1.GetItemString(1,'sempno') //���Ŵ����

open(w_pdm_01045)
end event

type st_3 from statictext within w_imt_02100
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

type p_1 from uo_picture within w_imt_02100
integer x = 3218
integer y = 24
boolean bringtotop = true
string picturename = "C:\erpman\image\�ڵ�����_up.gif"
end type

event clicked;call super::clicked;String sEstNo, sgubun, host_guno, sError='N', sguno
Int    iRtn, nRow, nCnt

If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

iRtn = MessageBox('���ְ���ǰ �۾������� �����ϼ���.!!', + &
                          "�ҿ䷮ ���� : ��(Y) ~r~n~r~n" + &
                          "�ҿ䷮ ���� : �ƴϿ�(N) ~r~n~r~n" + &
								  "�۾�   ��� : ���(C) ~r~n~r~n", Question!, YesNoCancel! )
If iRtn = 1 Then
	sGubun = 'I'
ElseIf iRtn = 2 Then
	sGubun = 'D'
Else
	Return
End If

sEstNo = dw_insert.GetItemString(nRow,'estno')

// ����ֳ��� Ȯ��(���ֵǾ��ų� �����������̸� ��ҺҰ� )
If sGubun = 'D' Then
		select gu_pordno into :sguno from estima where sabu = :gs_sabu and estno = :sEstNo;
			
		select count(*) into :nCnt from estima a 
		 where a.sabu = :gs_sabu and a.estno like :sguno||'%' and plncrt = '4'
		   and (blynd = '3' or yebi2 >= '1' );
		if nCnt > 0 then
			MessageBox('Ȯ��','����ֵ� �����̰ų� ������������ �ڷ��Դϴ�.!!')
			Return
		end if;
Else
	sGuno = Trim(dw_insert.GetItemString(nRow, 'estima_gu_pordno'))
	If sGuno > '' Then
		MessageBox('Ȯ��','������� ������ �����մϴ�.!!')
		Return
	end if;
End If
	
DECLARE ERP000009010 PROCEDURE FOR ERP000009010(:gs_sabu, :sEstno, :sgubun) USING SQLCA;
EXECUTE ERP000009010;

FETCH ERP000009010 INTO :sError;

CLOSE ERP000009010;

p_inq.TriggerEvent(Clicked!)

select gu_pordno into :host_guno from estima where sabu = :gs_sabu and estno = :sEstNo;

If sGubun = 'I' Then	MessageBox('Ȯ ��'+sError, host_guno+' ���� �����Ǿ����ϴ�.!!')

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ڵ�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ڵ�����_up.gif"
end event

type p_2 from picture within w_imt_02100
integer x = 3031
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\������_up.gif"
boolean focusrectangle = false
end type

event clicked;String sEstNo, ls_status , sYebi, ls_chk = 'N', ls_chk2 = 'N', ls_estno, ls_estno2
long i, lCount, ll_i, ll_i2 = 0 

if dw_insert.rowcount() < 1 then return 
//�ϰ�����ó��
For ll_i = 1 to dw_insert.rowcount() 
	if dw_insert.object.blynd[ll_i] = '1' and dw_insert.object.chk[ll_i] = 'Y' then 
 		if messagebox('Ȯ��', '���� ���� ���� ������ �����մϴ�.~n���� ���� ���� ������ ����ó�� �Ͻðڽ��ϱ�?', exclamation!, okcancel!, 2) = 2 then return
		 	For ll_i2 = 1 to dw_insert.rowcount() 
				if dw_insert.object.blynd[ll_i2] = '1' and dw_insert.object.chk[ll_i2] = 'Y' then 
					ls_estno = dw_insert.object.blynd[ll_i2] 
					
					update estima 
					   set blynd = '8'
					where estno = :ls_estno ; 
					
					commit; 
					
					dw_insert.object.blynd[ll_i2] = '8'
					
				end if 	
			Next 
	end if
Next

//����
ls_estno2 = ""
For ll_i2 = 1 to dw_insert.rowcount() 
	if dw_insert.object.blynd[ll_i2] = '8' and dw_insert.object.chk[ll_i2] = 'Y' then 
		IF ls_estno2  = "" then 
			ls_estno2 = dw_insert.object.estno[ll_i2]
			
			Delete from estima_ref where estno2 = :ls_estno2 ; 
			commit; 
			exit 			
		End if 
	end if 	
Next 

//���
ls_estno2 = ""
For ll_i2 = 1 to dw_insert.rowcount() 
	if dw_insert.object.blynd[ll_i2] = '8' and dw_insert.object.chk[ll_i2] = 'Y' then 
		IF ls_estno2  = "" then 
			ls_estno2 = dw_insert.object.estno[ll_i2]
			
		End if 
		
		ls_estno = dw_insert.object.estno[ll_i2]
		
		insert into estima_ref values (:ls_estno, :ls_estno2 ) ;  
		
		commit; 
		
	end if 	
Next 


For ll_i = 1 to dw_insert.rowcount() 
	 if  dw_insert.object.blynd[ll_i] = '8' and dw_insert.object.chk[ll_i] = 'Y' then 
		  ls_chk = 'Y' 
	 end if 
Next 

if ls_chk = 'N' then 
	messagebox('Ȯ��', '������ �� ������ ���� ���� �ʽ��ϴ�. ���ֻ��� ������ Ȯ���Ͻÿ�') 
	return 
End if 
	
//��ǥ��ȣ
sEstno = " "
For ll_i = 1 to dw_insert.rowcount() 
	 if dw_insert.object.blynd[ll_i] = '8' and dw_insert.object.chk[ll_i] = 'Y' then 
	 	sEstno = sEstno + "" + dw_insert.object.estno[ll_i] + ","
	 end if 
Next 
sEstno = mid(sEstno, 1, len(sEstno) - 1 ) 


//ls_status  = dw_1.GetItemString(1, 'estgu')

//gs_code  = "%26SABU=1%26ESTNO="+ sEstNo + "%26ESTGU=" + ls_status		//���ֹ�ȣ
gs_code  = "%26SABU=1%26ESTNO="+ sEstNo  //���ֹ�ȣ
gs_gubun = '00048'										//�׷���� ������ȣ
gs_codename = '���Ź��ְ���'									//�����Է¹���

lcount = dw_insert.rowcount()


// ����ǰ�ǿ� ���� ���ڰ��� �������
//sYebi = dw_insert.GetItemString(1, 'yebi2')
//If IsNull(sYebi) Then sYebi = '0'
//
If ls_chk = 'Y' Then
	// �׷���� ������ȣ
	//SELECT TRIM(DATANAME) INTO :gs_gubun FROM SYSCNFG WHERE SYSGU = 'W' AND SERIAL = 1 AND LINENO = 'B';
	
	WINDOW LW_WINDOW
	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
	
	lw_window.x = 0
	lw_window.y = 0
End If
end event

type rr_1 from roundrectangle within w_imt_02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 48
integer width = 2885
integer height = 268
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_imt_02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 324
integer width = 4608
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 46
end type

