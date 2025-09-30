$PBExportHeader$w_imt_03045.srw
$PBExportComments$���Ժ����(��뺰)
forward
global type w_imt_03045 from w_inherite
end type
type rr_3 from roundrectangle within w_imt_03045
end type
type rr_4 from roundrectangle within w_imt_03045
end type
type dw_detail from datawindow within w_imt_03045
end type
type rb_insert from radiobutton within w_imt_03045
end type
type rb_delete from radiobutton within w_imt_03045
end type
type rr_2 from roundrectangle within w_imt_03045
end type
end forward

global type w_imt_03045 from w_inherite
boolean visible = false
integer width = 4654
string title = "���Ժ����(��뺰)"
rr_3 rr_3
rr_4 rr_4
dw_detail dw_detail
rb_insert rb_insert
rb_delete rb_delete
rr_2 rr_2
end type
global w_imt_03045 w_imt_03045

type variables
boolean ib_ItemError
char    ic_status
string  is_Last_Jpno, is_Date

String    is_occod, is_occod2  //�����ΰ��� �ڵ�
String    is_saupj              //�ΰ������(������ L/C, B/L�� �ִ� �ΰ�������� �Ѱ���) 
end variables

forward prototypes
public function integer wf_delete ()
public function integer wf_update ()
public function integer wf_initial ()
public function integer wf_cvcod_chk (string scvcod)
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_delete ();string	sGubun
long		lRow, lRowCount
lRowCount = dw_insert.RowCount()


FOR  lRow = lRowCount 	TO		1		STEP  -1
		
	sGubun = dw_insert.GetItemString(lRow, "settle")
	IF sGubun = 'Y'	THEN
		MessageBox("Ȯ��", "����� �ڷ�� ������ �� �����ϴ�.")
		dw_insert.SetRow(lRow)
		dw_insert.SetFocus()
		RETURN -1
	END IF

	sGubun = dw_insert.GetItemString(lRow, "lcmagu")
	IF sGubun = 'Y'	THEN
		MessageBox("Ȯ��", "B/L ������ �ڷ�� ������ �� �����ϴ�.")
		dw_insert.SetRow(lRow)
		dw_insert.SetFocus()
		RETURN -1
	END IF
	
NEXT

RETURN 1
end function

public function integer wf_update ();string	sJpno, sDate
long		lRow
dec		dSeq


dw_detail.AcceptText()
sDate = f_Today()

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'P0')

IF dSeq < 0		THEN	RETURN -1

COMMIT;


sJpno = sDate + string(dSeq, "0000")

FOR	lRow = 1		TO		dw_insert.RowCount()

	dw_insert.SetItem(lRow, "expjpno", sJpno + string(lRow, "000"))

NEXT


MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r�����Ǿ����ϴ�.")


RETURN 1
end function

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_insert.reset()

dw_detail.enabled = TRUE
dw_insert.enabled = true

dw_detail.insertrow(0)

p_mod.enabled = true
p_del.enabled = false
p_ins.enabled = true
p_addrow.enabled = true
p_delrow.enabled = true

p_mod.PictureName = "C:\erpman\image\����_up.gif"
p_del.PictureName = "C:\erpman\image\����_d.gif"
p_ins.PictureName    = "C:\erpman\image\�߰�_up.gif"
p_addrow.PictureName = "C:\erpman\image\���߰�_up.gif"
p_delrow.PictureName = "C:\erpman\image\�����_up.gif"

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	// ��Ͻ�
	dw_detail.settaborder("GUBUN", 10)
	dw_detail.settaborder("NO", 	 20)
	dw_detail.settaborder("JPNO",  0)
	dw_detail.Modify("no2_t.Visible = false")
	dw_detail.Modify("no_t.Visible = true")
	
//	dw_detail.Modify("gubun.BackGround.Color= 12639424") 
	dw_detail.setcolumn("NO")

	p_inq.enabled = false
	p_inq.PictureName = "C:\erpman\image\��ȸ_d.gif"
	w_mdi_frame.sle_msg.text = "���"
ELSE
	dw_detail.settaborder("GUBUN", 0)
	dw_detail.settaborder("NO", 	 0)
	dw_detail.settaborder("JPNO",  10)

	dw_detail.Modify("no2_t.Visible = true")
	dw_detail.Modify("no_t.Visible = false")
	
//	dw_detail.Modify("gubun.BackGround.Color= 79741120") 
//	dw_detail.Modify("no.BackGround.Color= 79741120") 
//	dw_detail.Modify("jpno.BackGround.Color= 65535") 

	dw_detail.setcolumn("JPNO")

	p_inq.enabled = true
	p_inq.PictureName = "C:\erpman\image\��ȸ_up.gif"
	w_mdi_frame.sle_msg.text = "����"
END IF

///* User�� ����� Setting */
//setnull(gs_code)
//If 	f_check_saupj() = 1 Then
//	dw_detail.SetItem(1, 'saupj', gs_code)
//	if 	gs_code <> '%' then
//		dw_detail.setItem(1, 'saupj', gs_code)
//        	dw_detail.Modify("saupj.protect=1")
//		dw_detail.Modify("saupj.background.color = 80859087")
//	End if
//End If

// �ΰ��� ����� ����
f_mod_saupj(dw_detail, 'saupj')
is_saupj = dw_detail.GetItemString(1, 'saupj')
IF isnull(is_saupj) or trim(is_saupj) = '' then is_saupj = '' 

dw_detail.SetItem(1, 'gubun','1')
f_child_saupj(dw_detail, 'occcod', '1')

dw_detail.setfocus()

dw_detail.setredraw(true)

return  1

end function

public function integer wf_cvcod_chk (string scvcod);string  get_sano, get_uptae, get_jongk, get_ownam, get_resident, get_addr, get_cvgu
	
SELECT CVGU,       SANO,      UPTAE,      JONGK,      OWNAM,  	    RESIDENT,	    ADDR1
  INTO :get_cvgu, :get_sano, :get_uptae, :get_jongk, :get_ownam,  :get_resident, :get_addr
  FROM VNDMST  
 WHERE VNDMST.CVCOD = :sCvcod   ;

IF SQLCA.SQLCODE <>  0 THEN 
	MessageBox('Ȯ ��','�ŷ�ó�� Ȯ���ϼ���!')
	return -1
END IF   	

IF get_cvgu = '2'  THEN  //�ؿ� �ŷ�ó�� ����
   return 1
ELSEIF get_cvgu = '1' OR get_cvgu = '3' THEN  //����, ���ุ üũ

	if (Isnull(get_sano) or TRIM(get_sano) = '') AND &
		(Isnull(get_resident) or TRIM(get_resident) = '') then
		f_message_chk(1401,'[����ڹ�ȣ/�ֹε�Ϲ�ȣ]')
		return -1
	end if
	
	if Isnull(get_ownam) or TRIM(get_ownam) = '' then
		f_message_chk(1401,'[��ǥ�ڸ�]')
		return -1
	end if
	
	if Isnull(get_uptae) or TRIM(get_uptae) = '' then
		f_message_chk(1401,'[����]')
		return -1
	end if
	
	if Isnull(get_jongk) or TRIM(get_jongk) = '' then
		f_message_chk(1401,'[����]')
		return -1
	end if
	
	if Isnull(get_addr) or TRIM(get_addr) = '' then
		f_message_chk(1401,'[�ּ�]')
		return -1
	end if
ELSE
	MessageBox('Ȯ ��','�ŷ�ó�� ����, �ؿ�, ���ุ �Է��� �� �Խ��ϴ�.')
	return -1
END IF   	

RETURN 1
end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////
string	sGubun, sNo,		&
			sCode, sgub, slcno, 				&
			sTitle, sNull, sCvcod, sdate, get_nm, ssaupj , sOcccod
dec{2}	damt, dvat
long		lRow, lcount


sGubun = dw_detail.GetItemString(1, "gubun")
sOcccod =dw_detail.GetItemString(1, "occcod")

// L/C��ȣ, B/L��ȣ
IF isnull(sOcccod) or sOcccod = "" 	THEN
	
	IF sGubun = '1'	THEN
		sTitle = '[L/C��ȣ]'
	ELSEIF sGubun = '2'	THEN
		sTitle = '[B/L��ȣ]'
	END IF
	f_message_chk(30, sTitle)
	dw_detail.SetColumn("occcod")
	dw_detail.SetFocus()
	RETURN -1

END IF

SELECT "REFFPF"."SABU"  INTO :get_nm
  FROM "REFFPF",  "KFZ01OM0"  
 WHERE "REFFPF"."SABU" = '1'    AND  "REFFPF"."RFCOD" = '55'   AND  
		 "REFFPF"."RFGUB" <> '00' AND  "REFFPF"."RFGUB" = :sOcccod AND 
		 "REFFPF"."RFNA2" = "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" ;
			
IF SQLCA.SQLCODE <> 0 THEN 
	MessageBox('Ȯ ��', '�����ڵ忡 ��ϵ� ����(S)�� �������� ��ϵǾ����� �ʽ��ϴ�.' + &
							  + "~n~n" + '�����ڵ带 Ȯ���ϼ���!' )
	dw_detail.ScrollToRow(1)
	dw_detail.SetColumn("occcod")
	dw_detail.SetFocus()
	RETURN -1
END IF
	
//////////////////////////////////////////////////////////////////////
FOR	lRow = dw_insert.RowCount()		TO		1  STEP  -1

	IF sGubun = '1'	THEN		// LC
		sCode = dw_insert.GetItemString(lRow, "polcno")
		IF isnull(sCode) or sCode = "" 	THEN
			f_message_chk(30, '[L/C NO]')
			dw_insert.ScrollToRow(lRow)
			dw_insert.SetColumn("polcno")
			dw_insert.SetFocus()
			RETURN -1
		END IF
	End If
	
	IF sGubun = '2'	THEN		// BL
		sCode = dw_insert.GetItemString(lRow, "poblno")
		IF isnull(sCode) or sCode = "" 	THEN
			f_message_chk(30, '[B/L NO]')
			dw_insert.ScrollToRow(lRow)
			dw_insert.SetColumn("poblno")
			dw_insert.SetFocus()
			RETURN -1
		END IF
	End If
	
	IF sGubun = '1'	THEN		// LC
		dw_insert.SetItem(lRow, "bigu",   '1')
		dw_insert.SetItem(lRow, "poblno", sNull)
		dw_insert.SetItem(lRow, "mulgu",  'N')	
	ELSE
		dw_insert.SetItem(lRow, "bigu",   '2')	// BL
		dw_insert.SetItem(lRow, "poblno", sNo)
	END IF

	dw_insert.SetItem(lRow, "occcod", 	 sOcccod)
	
	sCode = dw_insert.GetItemString(lRow, "occcod")
	IF isnull(sCode) or sCode = "" 	THEN
		f_message_chk(30, '[����ڵ�]')
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("occcod")
		dw_insert.SetFocus()
		RETURN -1
	END IF

	sSaupj = dw_insert.GetItemString(lRow, "saupj")
	IF isnull(sSaupj) or sSaupj = "" 	THEN
		f_message_chk(30, '[�����]')
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("saupj")
		dw_insert.SetFocus()
		RETURN -1
	END IF

	sCvcod = dw_insert.GetItemString(lRow, "cvcod")
//	IF isnull(sCvcod) or sCvcod = "" 	THEN
//		dw_insert.DeleteRow(lRow)
//		CONTINUE
//   END IF

	IF wf_cvcod_chk(scvcod) < 0 THEN 
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("cvcod")
		dw_insert.SetFocus()
		RETURN -1
	END IF

   lcount ++

//	IF wf_cvcod_chk(scvcod) < 0 THEN 
//		dw_insert.ScrollToRow(lRow)
//		dw_insert.SetColumn("cvcod")
//		dw_insert.SetFocus()
//		RETURN -1
//	END IF
	
	sdate = trim(dw_insert.GetItemString(lRow, "occdat"))
	IF isnull(sdate) or sdate = "" 	THEN
		f_message_chk(30, '[��������]')
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("occdat")
		dw_insert.SetFocus()
		RETURN -1
	END IF

	// L/C��ȣ check
	slcno = dw_insert.GetItemString(lRow, "polcno")
	IF slcno = '' or isnull(slcno) THEN
		f_message_chk(30, '[L/C No]')
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("polcno")
		dw_insert.SetFocus()
		RETURN -1
	END IF

   //��뿡 ��ȭ�ݾ��̳� �ΰ����� ������ �������
	dAmt = dw_insert.GetItemDecimal(lRow, "wonamt")
	dVat = dw_insert.GetItemDecimal(lRow, "vatamt")
	IF (isnull(damt) or damt <= 0) and (isnull(dvat) or dvat <= 0)	THEN
		f_message_chk(30, '[��ȭ�ݾ�/�ΰ���]')
		dw_insert.ScrollToRow(lRow)
		dw_insert.SetColumn("wonamt")
		dw_insert.SetFocus()
		RETURN -1
	END IF

	/////////////////////////////////////////////////////////////////////////
	//	1. ������ -> ���߰��� data�� �Ƿڹ�ȣ : �������� + 1 ->SETITEM
	// 2. ��ǥ��ȣ�� NULL �ΰ͸� �������� + 1 		
	/////////////////////////////////////////////////////////////////////////
	IF iC_status = '2'	THEN
		string	sJpno
		sJpno = dw_insert.GetitemString(lRow, "expjpno")
		IF IsNull(sjpno)	OR sJpno = '' 	THEN
			is_Last_Jpno = string(dec(is_Last_Jpno) + 1)
			dw_insert.SetItem(lRow, "expjpno", is_Last_Jpno)
		END IF
	END IF

NEXT

if lcount < 1 then return -1

RETURN 1
end function

on w_imt_03045.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_detail=create dw_detail
this.rb_insert=create rb_insert
this.rb_delete=create rb_delete
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.rr_4
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.rb_insert
this.Control[iCurrent+5]=this.rb_delete
this.Control[iCurrent+6]=this.rr_2
end on

on w_imt_03045.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_detail)
destroy(this.rb_insert)
destroy(this.rb_delete)
destroy(this.rr_2)
end on

event open;call super::open;//���� �ΰ��� �ڵ� �ý��ۿ��� ��������
SELECT DATANAME  
  INTO :is_occod 
  FROM SYSCNFG  
 WHERE SYSGU = 'A' AND SERIAL = 13 AND LINENO = '01' ;

IF isnull(is_occod) or trim(is_occod) = '' then is_occod = '' 

SELECT DATANAME  
  INTO :is_occod2
  FROM SYSCNFG  
 WHERE SYSGU = 'A' AND SERIAL = 13 AND LINENO = '02' ;

IF isnull(is_occod2) or trim(is_occod2) = '' then is_occod2 = '' 

//�⺻ �ΰ������ �ڵ� �ý��ۿ��� ��������
//SELECT DATANAME  
//  INTO :is_saupj
//  FROM SYSCNFG  
// WHERE SYSGU = 'Y' AND SERIAL = 32 AND LINENO = '3' ;

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_insert.settransobject(sqlca)

is_Date = f_Today()

// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

type dw_insert from w_inherite`dw_insert within w_imt_03045
integer x = 27
integer y = 372
integer width = 4562
integer height = 1948
integer taborder = 20
string dataobject = "d_imt_03045_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;string	sCode, sName,	&
			sDate,			&
			sNull, slcno, sBlno, smaxlc, sminlc, sGubun, get_yn, stitle
long		lRow, i, icount, get_count
		
if dw_detail.accepttext() = -1 then return 

SetNull(sNull)
lRow  = this.GetRow()	
If lRow <= 0 Then Return

sGubun = dw_detail.getItemstring(1, 'gubun')
sBlno = dw_insert.getitemstring(lRow, 'poblno')

// ����ڵ�
IF this.GetColumnName() = 'occcod' THEN

	sCode = this.gettext()

	if scode = '' or isnull(scode) then return 
	
	if scode = is_occod or scode = is_occod2 then 
		this.setitem(lRow, 'prcgub', 'N')
	else
		this.setitem(lRow, 'prcgub', 'Y')
	end if	
	
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '55' ) AND  
         ( "REFFPF"."RFGUB" = :sCode )   ;
	 
	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33,'[����ڵ�]')
		this.setitem(lRow, "occcod", sNull)
		return 1
	END IF

// �ŷ�ó
ELSEIF this.GetColumnName() = "cvcod" THEN
	
	sCode = this.GetText()								
	
	if scode = '' or isnull(scode) then 
		this.setitem(lRow, 'vndmst_cvnas2', sNull)
      return 
	end if	
	
	//�ŷ�ó�� ����, �ؿ�, ���ظ� ������ �� ����
   SELECT CVNAS2
     INTO :sName
     FROM VNDMST 
    WHERE CVCOD = :sCode   AND
	 		 CVSTATUS = '0'   AND 
			 CVGU  IN ('1', '2', '3') ;
	 		 
	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[�ŷ�ó]')
		this.setitem(lrow, 'cvcod', sNull)
		this.setitem(lrow, 'vndmst_cvnas2', snull)
	   return 1
	ELSE
		this.setitem(lRow, 'vndmst_cvnas2', sName)
   END IF
// ��������
ELSEIF this.GetColumnName() = 'occdat' THEN

	sDate  = trim(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[��������]')
		this.setitem(lRow, "occdat", sNull)
		return 1
	END IF
	
//// �ΰ��� > ��ȭ�ݾ� -> ERROR
//IF this.GetColumnName() = 'vatamt' THEN
//
//	dec dAmt, dVat
//	dVat = dec(this.gettext())
//	dAmt = this.GetItemDecimal(lRow, "wonamt")
//	
//	IF dVat > dAmt		THEN
//		MessageBox("Ȯ��", "�ΰ����� ��ȭ�ݾ׺��� Ŭ �� �����ϴ�.")
//		this.SetItem(lRow, "vatamt", 0)
//		RETURN 1
//	END IF
//	
//END IF
//

// ��ǰ�� �������� : B/L ��ȣ�� ����
ELSEIF this.GetColumnName() = 'mulgu' THEN
	sCode = this.GetText()

	// Bl������ ��� 
	If sGubun = '2' Then
		if sBlno = '' or isnull(sBlno) then
			f_message_chk(30, "[B/L No]")
			this.setcolumn('poblno')
			this.setfocus()
			return 1
		end if
			
		SELECT MAX("POLCBL"."POLCNO"), MIN("POLCBL"."POLCNO")    
		  INTO :smaxlc, :sminlc  
		  FROM "POLCBL"  
		 WHERE "POLCBL"."SABU" = :gs_sabu AND "POLCBL"."POBLNO" = :sblno   ;
	
		if smaxlc = sminlc then 
			this.setitem(lrow, "polcno", smaxlc)
		else
			gs_code = sblno
			open(w_impexp_lcno_popup)
			
			if gs_code = '' or isnull(gs_code) then return 
			
			this.setitem(lrow, "polcno", gs_code)
			
		end if	
	End If
// LC NO
ELSEIF this.GetColumnName() = 'polcno'		THEN
	slcno = this.GetText()
	IF slcno ='' or isnull(slcno) then return 
		
	IF sGubun = '1'	THEN		// LC
		SELECT Count(*), MAX(POMAGA) 
		  INTO :iCount, :get_yn
		  FROM POLCHD
		 WHERE SABU = :gs_sabu		AND
		 		 POLCNO = :slcno ;	
				  
		sTitle = '[L/C ��ȣ]'

		IF iCount < 1		THEN
			f_message_chk(33, sTitle)
			this.setitem(lrow, "polcno", sNull)
			RETURN 1
		ELSE
         if get_yn = 'Y' then 
				messagebox('Ȯ ��', '����ó���� L/C�� ����� �� �����ϴ�.')
				this.setitem(lrow, "polcno", sNull)
				RETURN 1
         end if			 
		END IF
	End If
	
	// Bl������ ��� 
	If sGubun = '2' Then
		if sBlno = '' or isnull(sBlno) then
			f_message_chk(30, "[B/L No]")
			this.setcolumn('poblno')
			this.setfocus()
			return 1
		end if
		
		SELECT Count(*) 
		  INTO :iCount
		  FROM POLCBL
		 WHERE SABU = :gs_sabu	AND POBLNO = :sblno AND  POLCNO = :slcno ;	
				  
		IF iCount < 1		THEN
			f_message_chk(33, '[L/C No]')
			this.setitem(lrow, "polcno", sNull)
			RETURN 1
		END IF
	End If
// BL NO
ELSEIF this.GetColumnName() = 'poblno'		THEN
	sCode = Trim(GetText())
	If IsNull(sCode) Or sCode = '' Then Return
	
	// Bl������ ��� 
	If sGubun = '2' Then
		SELECT Count(*) 
		  INTO :iCount
		  FROM POLCBL
		 WHERE SABU = :gs_sabu		AND
		 		 POBLNO = :sCode;	
				  
		sTitle = '[B/L ��ȣ]'

		IF iCount < 1		THEN
			f_message_chk(33, sTitle)
			this.setitem(lrow, "poblno", sNull)
			RETURN 1
		ELSE
		   SELECT Count(*)
			  INTO :get_count  
			  FROM "POLCBL"  
			 WHERE ( "POLCBL"."SABU" = :gs_sabu ) AND  
					 ( "POLCBL"."POBLNO" = :sCode ) AND  
					 ( "POLCBL"."MAGYEO" = 'Y' )   ;

         if get_count > 0 then 
				messagebox('Ȯ ��', '����ó���� B/L�� ����� �� �����ϴ�.')
				this.setitem(lrow, "poblno", sNull)
				RETURN 1
         end if			 
			
			dw_insert.setitem(lrow, "mulgu", 'N')
			dw_insert.setitem(lrow, "polcno", sNull)
		END IF
	End If
ELSEIF this.GetColumnName() = 'prcgub'		THEN
	sCode = this.gettext()

	if scode = 'N' then return 
	
   sName = this.getitemstring(lRow, 'occcod')   
	
	if sName = is_occod or sname = is_occod2 then 
		messagebox("Ȯ ��", "���� �ΰ����� ���� B/L ������ ����ó�����ܸ� �����Ͽ��� �մϴ�.!")
		this.setitem(lRow, 'prcgub', 'N')
		return 1
	end if	
	
END IF
end event

event dw_insert::itemerror;call super::itemerror;////////////////////////////////////////////////////////////////////////////
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


w_mdi_frame.sle_msg.text  = "  �ʼ��Է��׸� :  " + this.Describe(sColumnName) + "   �Է��ϼ���."

RETURN 1
	
	
end event

event dw_insert::losefocus;call super::losefocus;this.AcceptText()
end event

event dw_insert::rbuttondown;call super::rbuttondown;long	lRow
String sGubun
string  sBlno
	
lRow  = this.GetRow()	
If lrow <= 0 Then Return

gs_code = ''
gs_codename = ''
gs_gubun = ''

sGubun = dw_detail.GetItemString(1, 'gubun')

IF  this.GetColumnName() = 'cvcod'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	This.SetItem(lRow,"cvcod",gs_code)
	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.getcolumnname() = "polcno" 	THEN

	if dw_detail.accepttext() = -1 then return 

	// lc������ ���
	If sGubun = '1' Then
		open(w_lc_popup)
		if isnull(gs_code)  or  gs_code = ''	then	return
		this.setitem(lrow, "polcno", gs_code)
		this.TriggerEvent("itemchanged")
	// bl������ ���
	ElseIf sGubun = '2' Then
		sBlno = dw_insert.getitemstring(lrow, 'plblno')
		
		if sBlno = '' or isnull(sBlno) then
			f_message_chk(30, "[B/L No]")
			dw_insert.setcolumn('plblno')
			dw_insert.setfocus()
			return 
		end if
	
		gs_code = sBlno
		Open(w_impexp_lcno_popup)
		if isnull(gs_code)  or  gs_code = ''	then	return
		this.setitem(lrow, "polcno", gs_code)
	End If
ELSEIF this.getcolumnname() = "poblno" 	THEN

	if dw_detail.accepttext() = -1 then return
	
	// bl������ ���
	If sGubun = '2' Then	
		open(w_bl_popup4)
		if isnull(gs_code)  or  gs_code = ''	then	return
		this.setitem(lrow, "poblno", gs_code)
		this.TriggerEvent("itemchanged")
	End If
END IF

end event

event dw_insert::editchanged;call super::editchanged;dec {0} 	dwonamt 
long		lRow
Double 	dFprrat, dForamt
String		ls_rfna2, ls_forcur
lRow = this.GetRow()

IF this.getcolumnname() = "foramt" 				or 	&
	this.getcolumnname() = "fprrat"		THEN

	this.AcceptText()
	
	ls_forcur	=	this.getitemstring(lrow, "forcur")
	if 	ls_forcur = 'WON' then
		this.SetItem(lRow, "wonamt", this.getitemdecimal(lRow, "foramt") )
	
//		this.SetItem(lRow, "vatamt", truncate(this.getitemdecimal(lRow, "foramt") / 10, 0) )
	else 	
		dFprrat	= this.getitemdecimal(lRow, "fprrat")
		dForamt	= this.getitemdecimal(lRow, "foramt")
		Select     rfna2 	Into :ls_rfna2  from Reffpf  
		   Where 	rfgub = :ls_forcur
			 And  	rfcod = '10' ;				           	 // ------  ��ȭ������ ȯ�������� ������.
		if	isNull(LS_rfna2) or LS_rfna2 = '' or Not IsNumber( ls_rfna2 )	then
			ls_rfna2	= '1'
		End If	
		
		dFprrat	= dFprrat / integer(ls_rfna2)
//		dwonamt 	= truncate(dForamt * dFprrat, 0)
		dwonamt 	= dForamt * dFprrat
		this.SetItem(lRow, "wonamt", truncate(dwonamt,0) )
	
//		this.SetItem(lRow, "vatamt", truncate(dwonamt/10, 0) )
	end if
ELSEIF this.getcolumnname() = "wonamt" THEN

	this.AcceptText()
	
//   this.SetItem(lRow, "vatamt", truncate(this.getitemdecimal(lRow, "wonamt") / 10, 0) )
END IF



end event

type p_delrow from w_inherite`p_delrow within w_imt_03045
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;long	lrow
lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN

////////////////////////////////////////////////////////
string	sGubun

sGubun = dw_insert.GetItemString(lRow, "settle")
IF sGubun = 'Y'	THEN
	MessageBox("Ȯ��", "����� �ڷ�� ������ �� �����ϴ�.")
	RETURN 
END IF

sGubun = dw_insert.GetItemString(lRow, "lcmagu")
IF sGubun = 'Y'	THEN
	MessageBox("Ȯ��", "B/L ������ �ڷ�� ������ �� �����ϴ�.")
	RETURN 
END IF

IF f_msg_delete() = -1 THEN	RETURN
	
dw_insert.DeleteRow(lRow)
end event

type p_addrow from w_inherite`p_addrow within w_imt_03045
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1	THEN	RETURN

IF f_CheckRequired(dw_insert) = -1	THEN	RETURN


//////////////////////////////////////////////////////////
string	sGubun, sTitle, sBank, sBanknm, sMaxlc, sMinlc, ssaupj, sOcccod
long		lRow

sGubun  = dw_detail.GetItemString(1, "gubun")
sOcccod = dw_detail.GetItemString(1, "occcod")
sSaupj  = dw_detail.GetItemString(1, "saupj")

// L/C��ȣ, B/L��ȣ
IF isnull(sOcccod) or sOcccod = "" 	THEN
	
	IF sGubun = '1'	THEN
		sTitle = '[L/C��ȣ]'
	ELSE
		sTitle = '[B/L��ȣ]'
	END IF
	f_message_chk(30, sTitle)
	dw_detail.SetColumn("occcod")
	dw_detail.SetFocus()
	RETURN
END IF
////////////////////////////////////////////////////////////////////////////

lRow = dw_insert.InsertRow(0)

dw_insert.SetItem(lRow, "bigu",   sGubun)
dw_insert.SetItem(lRow, "occcod", sOcccod)

//if sGubun = '1' then 
//   SELECT "POLCHD"."POOPBK", "VNDMST"."CVNAS2"  
//     INTO :sBank,  :sBanknm
//     FROM "POLCHD", "VNDMST"  
//    WHERE ( "POLCHD"."POOPBK" = "VNDMST"."CVCOD" ) and  
//			 ( "VNDMST"."CVGU"  IN ('1', '2', '3') ) and 
//          ( ( "POLCHD"."SABU" = :gs_sabu ) AND ( "POLCHD"."POLCNO" = :sno ) )   ;
//
//	dw_insert.SetItem(lRow, "cvcod", sBank)
//	dw_insert.SetItem(lRow, "vndmst_cvnas2", sBanknm)
//
//	//l/c no �� ����� �������� 
//   SELECT MIN("POLCDT"."SAUPJ")  
//     INTO :ssaupj
//     FROM "POLCDT"  
//    WHERE ( "POLCDT"."SABU"   = :gs_sabu  ) AND  
//          ( "POLCDT"."POLCNO" = :sno  )   ;
//	
//Else
//	
//	SELECT MAX("POLCBL"."POLCNO"), MIN("POLCBL"."POLCNO"), MIN("POLCBL"."SAUPJ")    
//	  INTO :smaxlc, :sminlc, :ssaupj  
//	  FROM "POLCBL"  
//	 WHERE "POLCBL"."SABU" = :gs_sabu AND "POLCBL"."POBLNO" = :sno   ;
//
//	 dw_insert.setitem(Lrow, "polcno", sMinlc)	  
//	 if sMaxlc = sMinlc then
//		 dw_insert.setitem(Lrow, "lcmdgu", 'N')
//	 else
//		 dw_insert.setitem(Lrow, "lcmdgu", 'Y')
//	 end if;
//end if
//IF ssaupj = '' then 
//	dw_insert.SetItem(lRow, "saupj", is_saupj)
//else
//	dw_insert.SetItem(lRow, "saupj", ssaupj)
//end if

//////////////////////////////////////////////////////////////////////////
dw_insert.SetItem(lRow, "occdat", f_today())
dw_insert.SetItem(lRow, "saupj", sSaupj)
dw_insert.SetItem(lRow, 'ac_confirm', 'Y') 	// ��뺰�� �ϰ���� ����

dw_insert.ScrollToRow(lRow)
dw_insert.SetColumn("occcod")
dw_insert.SetFocus()
end event

type p_search from w_inherite`p_search within w_imt_03045
boolean visible = false
integer x = 2501
integer y = 12
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_imt_03045
boolean visible = false
integer taborder = 40
boolean enabled = false
end type

event p_ins::clicked;call super::clicked;Datastore ds_reffpf_55_1, ds_reffpf_55_2

IF dw_detail.AcceptText() = -1	THEN	RETURN

//IF f_CheckRequired(dw_insert) = -1	THEN	RETURN

dw_insert.reset()

//////////////////////////////////////////////////////////
string	sNo, sGubun, sTitle, sBank, sBanknm, sMaxlc, sMinlc, sCode, ssaupj
long		lRow

sGubun = dw_detail.GetItemString(1, "gubun")
sNo 	 = dw_detail.GetItemString(1, "no")

// L/C��ȣ, B/L��ȣ
IF isnull(sNo) or sNo = "" 	THEN
	
	IF sGubun = '1'	THEN
		sTitle = '[L/C��ȣ]'
	ELSE
		sTitle = '[B/L��ȣ]'
	END IF
	f_message_chk(30, sTitle)
	dw_detail.SetColumn("no")
	dw_detail.SetFocus()
	RETURN

END IF

IF sgubun = '1' then
	ds_reffpf_55_1 = Create DataStore
	ds_reffpf_55_1.DataObject = "dd_reffpf_55_1"  
	
	ds_reffpf_55_1.setTransobject(sqlca)
	
	ds_reffpf_55_1.retrieve()
	
   SELECT "POLCHD"."POOPBK", "VNDMST"."CVNAS2"  
     INTO :sBank,  :sBanknm
     FROM "POLCHD", "VNDMST"  
    WHERE ( "POLCHD"."POOPBK" = "VNDMST"."CVCOD" ) and  
			 ( "VNDMST"."CVGU"  IN ('1', '2', '3') ) and 
          ( ( "POLCHD"."SABU" = :gs_sabu ) AND ( "POLCHD"."POLCNO" = :sno ) )   ;

	//l/c no �� ����� �������� 
   SELECT MIN("POLCDT"."SAUPJ")  
     INTO :ssaupj
     FROM "POLCDT"  
    WHERE ( "POLCDT"."SABU"   = :gs_sabu  ) AND  
          ( "POLCDT"."POLCNO" = :sno  )   ;
	
	FOR  	lRow = 1		TO		ds_reffpf_55_1.RowCount()
		lRow = dw_insert.InsertRow(0)
	   sCode = ds_reffpf_55_1.GetItemString(lRow, "rfgub")
		dw_insert.SetItem(lRow, "occcod", sCode)
		dw_insert.SetItem(lRow, "bigu", sGubun)
		dw_insert.SetItem(lRow, "cvcod", sBank)
		dw_insert.SetItem(lRow, "vndmst_cvnas2", sBanknm)
		dw_insert.SetItem(lRow, "occdat", f_today())

		IF is_saupj = '' then 
			dw_insert.SetItem(lRow, "saupj", ssaupj)
		else
			dw_insert.SetItem(lRow, "saupj", is_saupj)
		end if

		if sCode = is_occod or scode = is_occod2 then 
			dw_insert.SetItem(lRow, "prcgub", 'N')
	   end if 		
	NEXT
	
	//////////////////////////////////////////////////////////////////////////
	destroy ds_reffpf_55_1
ELSE
	ds_reffpf_55_2 = Create DataStore
	ds_reffpf_55_2.DataObject = "dd_reffpf_55_2"  
	
	ds_reffpf_55_2.setTransobject(sqlca)
	
	ds_reffpf_55_2.retrieve()
	
	SELECT MAX("POLCBL"."POLCNO"), MIN("POLCBL"."POLCNO"), MIN("POLCBL"."SAUPJ")    
	  INTO :smaxlc, :sminlc, :ssaupj  
	  FROM "POLCBL"  
	 WHERE "POLCBL"."SABU" = :gs_sabu AND "POLCBL"."POBLNO" = :sno   ;

	FOR  	lRow = 1		TO		ds_reffpf_55_2.RowCount()
		lRow = dw_insert.InsertRow(0)
		
		dw_insert.setitem(Lrow, "polcno", sMinlc)	  
		if sMaxlc = sMinlc then
			dw_insert.setitem(Lrow, "lcmdgu", 'N')
		else
			dw_insert.setitem(Lrow, "lcmdgu", 'Y')
		end if;
		
	   sCode = ds_reffpf_55_2.GetItemString(lRow, "rfgub")
		dw_insert.SetItem(lRow, "occcod", sCode)
		dw_insert.SetItem(lRow, "bigu", sGubun)
		dw_insert.SetItem(lRow, "occdat", f_today())
		
		IF is_saupj = '' then 
			dw_insert.SetItem(lRow, "saupj", ssaupj)
		else
			dw_insert.SetItem(lRow, "saupj", is_saupj)
		end if
		
		if sCode = is_occod or scode = is_occod2 then 
			dw_insert.SetItem(lRow, "prcgub", 'N')
	   end if 		
	NEXT
	
	//////////////////////////////////////////////////////////////////////////
	destroy ds_reffpf_55_2
END IF	
dw_insert.ScrollToRow(1)
dw_insert.SetColumn("occcod")
dw_insert.SetFocus()


end event

type p_exit from w_inherite`p_exit within w_imt_03045
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_imt_03045
integer taborder = 90
end type

event p_can::clicked;call super::clicked;rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_print from w_inherite`p_print within w_imt_03045
boolean visible = false
integer x = 2318
integer y = 16
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_03045
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sNull
int      icount

SetNull(sNull)


//////////////////////////////////////////////////////////////////////////
sJpno  = TRIM(dw_detail.GetItemString(1, "jpno"))
	
IF isnull(sJpno) or sJpno = "" 	THEN
	f_message_chk(30, '[��ǥ��ȣ]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	RETURN
END IF


sJpno = sJpno + '%'
IF	dw_insert.Retrieve(gs_Sabu, sJpno) <	1		THEN
	f_message_chk(50, '[��ǥ��ȣ]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	RETURN
END IF

 SELECT COUNT(*)
   INTO :icount  
   FROM IMPEXP  
  WHERE SABU = :gs_sabu AND EXPJPNO LIKE :sJpno AND LCMAGU = 'Y' ;

IF icount > 0 then 
	dw_detail.enabled = false
	dw_insert.enabled = false	
	p_mod.enabled = false	
   p_del.enabled = false	
   p_ins.enabled = false	
   p_addrow.enabled = false	
	p_delrow.enabled = false	

	p_mod.PictureName = "C:\erpman\image\����_d.gif"
	p_del.PictureName = "C:\erpman\image\����_d.gif"
	p_ins.PictureName    = "C:\erpman\image\�߰�_d.gif"
	p_addrow.PictureName = "C:\erpman\image\���߰�_d.gif"
	p_delrow.PictureName = "C:\erpman\image\�����_d.gif"
	
	w_mdi_frame.sle_msg.text = 'B/L ����ó���� ����� ������ �� �����ϴ�'	
		
	return 
END IF	

// ���Ű������� ���۵� ������ ������ �� ����
IF dw_insert.getitemstring(1, "gunm") = '���Ű���' then 
	dw_detail.enabled = false
	dw_insert.enabled = false	

	p_mod.enabled = false	
   p_del.enabled = false	
   p_ins.enabled = false	
   p_addrow.enabled = false	
	p_delrow.enabled = false	

	p_mod.PictureName = "C:\erpman\image\����_d.gif"
	p_del.PictureName = "C:\erpman\image\����_d.gif"
	p_ins.PictureName    = "C:\erpman\image\�߰�_d.gif"
	p_addrow.PictureName = "C:\erpman\image\���߰�_d.gif"
	p_delrow.PictureName = "C:\erpman\image\�����_d.gif"
	
	w_mdi_frame.sle_msg.text = '���Ű������� �̹Ƿ� ������ �� �����ϴ�.'	
	return 
END IF	

//////////////////////////////////////////////////////////////////////////
// �����Ƿڹ�ȣ
is_Last_Jpno = dw_insert.GetItemString(dw_insert.RowCount(), "expjpno")

dw_detail.enabled = false
p_del.enabled = true
p_del.PictureName = "C:\erpman\image\����_up.gif"

dw_insert.SetColumn("occcod")
dw_insert.SetFocus()
end event

type p_del from w_inherite`p_del within w_imt_03045
integer taborder = 80
end type

event p_del::clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////
integer  irow

IF wf_Delete() = -1		THEN	RETURN

IF f_msg_delete() = -1 	THEN	RETURN

FOR  iRow = dw_insert.rowcount() 	TO		1		STEP  -1
	
	dw_insert.DeleteRow(iRow)
	
NEXT

//////////////////////////////////////////////////////////////////
IF dw_insert.Update() > 0		THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
END IF

p_can.TriggerEvent("clicked")
	
	

end event

type p_mod from w_inherite`p_mod within w_imt_03045
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_insert.AcceptText() = -1		THEN	RETURN


//////////////////////////////////////////////////////////////////////////////////
//		
//		1. ��ǥä������('P0')
//
//////////////////////////////////////////////////////////////////////////////////

IF	wf_CheckRequiredField() = -1		THEN		RETURN

IF f_msg_update() = -1 	THEN	RETURN


/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	wf_update()

END IF

////////////////////////////////////////////////////////////////////////
IF dw_insert.Update() > 0		THEN
	COMMIT;

ELSE
	f_Rollback()
	ROLLBACK;
END IF


p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from w_inherite`cb_exit within w_imt_03045
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_imt_03045
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_imt_03045
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_imt_03045
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_imt_03045
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_imt_03045
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_imt_03045
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_imt_03045
boolean visible = true
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_imt_03045
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_imt_03045
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_imt_03045
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_imt_03045
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_03045
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03045
boolean visible = true
end type

type rr_3 from roundrectangle within w_imt_03045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 184
integer width = 4590
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_imt_03045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 364
integer width = 4590
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_imt_03045
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 27
integer y = 212
integer width = 4571
integer height = 120
integer taborder = 10
string title = "none"
string dataobject = "d_imt_03045_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sGubun, sTitle,	&
			sJpno, sNo,			&
			sLcno, sBlno,		&
			sNull, get_yn, socccod
int		iCount, get_count, k
SetNull(sNull)


// LC, BL��ȣ
IF this.GetColumnName() = 'no'		THEN
	
	sNo = this.GetText()
	
	IF sno = '' or isnull(sno) then return 
	
	sGubun = this.GetItemString(1, "gubun")
	
	IF sGubun = '1'	THEN		// LC
	
		SELECT Count(*), MAX(POMAGA) 
		  INTO :iCount, :get_yn
		  FROM POLCHD
		 WHERE SABU = :gs_sabu		AND
		 		 POLCNO = :sNo ;	
				  
		sTitle = '[L/C ��ȣ]'

		IF iCount < 1		THEN
			f_message_chk(33, sTitle)
			this.setitem(1, "no", sNull)
			RETURN 1
		ELSE
         if get_yn = 'Y' then 
				messagebox('Ȯ ��', '����ó���� L/C�� ����� �� �����ϴ�.')
				this.setitem(1, "no", sNull)
				RETURN 1
         end if			 
		END IF	
	ELSE
		
		SELECT Count(*) 
		  INTO :iCount
		  FROM POLCBL
		 WHERE SABU = :gs_sabu		AND
		 		 POBLNO = :sNo       ;	
				  
		sTitle = '[B/L ��ȣ]'

		IF iCount < 1		THEN
			f_message_chk(33, sTitle)
			this.setitem(1, "no", sNull)
			RETURN 1
		ELSE
		   SELECT Count(*)
			  INTO :get_count  
			  FROM "POLCBL"  
			 WHERE ( "POLCBL"."SABU" = :gs_sabu ) AND  
					 ( "POLCBL"."POBLNO" = :sNO ) AND  
					 ( "POLCBL"."MAGYEO" = 'Y' )   ;

         if get_count > 0 then 
				messagebox('Ȯ ��', '����ó���� B/L�� ����� �� �����ϴ�.')
				this.setitem(1, "no", sNull)
				RETURN 1
         end if			 
			
			FOR k=1 TO dw_insert.rowcount()
				dw_insert.setitem(k, "mulgu", 'N')
				dw_insert.setitem(k, "polcno", sNull)
			NEXT

		END IF	

	END IF
ELSEIF this.GetColumnName() = 'jpno'		THEN
	
	sJpno = TRIM(this.GetText())
	
	IF sJpno ='' or isnull(sJpno) then 
		Return 
	END IF	
	
	SELECT OCCCOD, BIGU
	  INTO :socccod, :sGubun
	  FROM IMPEXP
	 WHERE SABU = :gs_sabu		AND
	 		 SUBSTR(EXPJPNO,1,12) = :sJpno AND
			 AC_CONFIRM IS NOT NULL ;
	
	IF SQLCA.SQLCODE = 100	THEN
		f_message_chk(33,'[��ǥ��ȣ]')
		this.setitem(1, "jpno", sNull)
		RETURN 1
	END IF
	
	IF sGubun = '1'	THEN
		this.SetItem(1, "gubun", '1')
		this.SetItem(1, "occcod", socccod)
		dw_insert.DataObject = 'd_imt_03045_2'
		dw_insert.SetTransObject(SQLCA)
	ELSE
		this.SetItem(1, "gubun", '2')
		this.SetItem(1, "occcod", socccod)		
		dw_insert.DataObject = 'd_imt_03045_3'
		dw_insert.SetTransObject(SQLCA)
	END IF

	p_inq.TriggerEvent(Clicked!)
	
ELSEIF this.GetColumnName() = 'gubun'		THEN

	sGubun = this.GetText()
	
	this.setitem(1, "no", snull)
	this.setcolumn("no")
	
	IF sgubun = '1' then
		dw_insert.DataObject = 'd_imt_03045_2'
		dw_insert.SetTransObject(SQLCA)
   ELSEIF sgubun = '2' then
		dw_insert.DataObject = 'd_imt_03045_3'
		dw_insert.SetTransObject(SQLCA)
	END IF
	
	f_child_saupj(dw_detail, 'occcod', sGubun)
END IF


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
string	sGubun

IF this.getcolumnname() = "no" 	THEN

	sGubun = this.GetItemString(1, "gubun")
	
	IF sGubun = '1'	THEN
		open(w_lc_popup)
	ELSEIF sGubun = '2'	THEN
		open(w_bl_popup4)
	END IF
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "no", gs_code)
	this.TriggerEvent("itemchanged")
   RETURN 1
ELSEIF this.getcolumnname() = "jpno" 	THEN
	gs_gubun = 'Y'	// ��� �ϰ������ ���
	open(w_suip_popup)
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", Left(gs_code,12))

	this.TriggerEvent("itemchanged")
   RETURN 1
END IF

end event

type rb_insert from radiobutton within w_imt_03045
integer x = 105
integer y = 80
integer width = 242
integer height = 72
boolean bringtotop = true
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

event clicked;ic_status = '1'	// ���

p_ins.enabled = TRUE
p_ins.PictureName    = "C:\erpman\image\�߰�_up.gif"

wf_Initial()

dw_insert.DataObject = 'd_imt_03045_2'
dw_insert.SetTransObject(SQLCA)



end event

type rb_delete from radiobutton within w_imt_03045
integer x = 357
integer y = 76
integer width = 242
integer height = 72
boolean bringtotop = true
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

event clicked;ic_status = '2'

p_ins.enabled = FALSE
p_ins.PictureName    = "C:\erpman\image\�߰�_d.gif"

wf_Initial()
end event

type rr_2 from roundrectangle within w_imt_03045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 44
integer width = 622
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

