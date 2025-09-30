$PBExportHeader$w_imt_03080.srw
$PBExportComments$�����û ���
forward
global type w_imt_03080 from w_inherite
end type
type rr_4 from roundrectangle within w_imt_03080
end type
type dw_1 from datawindow within w_imt_03080
end type
type rb_1 from radiobutton within w_imt_03080
end type
type rb_2 from radiobutton within w_imt_03080
end type
type dw_3 from datawindow within w_imt_03080
end type
type pb_2 from u_pb_cal within w_imt_03080
end type
type pb_1 from u_pb_cal within w_imt_03080
end type
type pb_3 from u_pb_cal within w_imt_03080
end type
type pb_4 from u_pb_cal within w_imt_03080
end type
type pb_5 from u_pb_cal within w_imt_03080
end type
type rr_2 from roundrectangle within w_imt_03080
end type
end forward

global type w_imt_03080 from w_inherite
boolean visible = false
string title = "�����û ���"
rr_4 rr_4
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
dw_3 dw_3
pb_2 pb_2
pb_1 pb_1
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
rr_2 rr_2
end type
global w_imt_03080 w_imt_03080

type variables
char 		  ic_status
String     is_cvcod            // �ŷ�ó
String     is_occod            // �����ΰ���
String     is_ijacod				 // ��������
end variables

forward prototypes
public function integer wf_cvcod_chk (string scvcod)
public function string wf_accod_chk (string s_cod)
public function integer wf_kif07oto_delete ()
public function integer wf_kif07oto_insert ()
end prototypes

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

public function string wf_accod_chk (string s_cod);string sacc1, sacc2, get_dc, get_sang, sopt, s_nam1

sacc1 = left(s_cod, 5)
sacc2 = mid(s_cod, 6, 2)

SELECT DC_GU,   SANG_GU  
  INTO :get_dc, :get_sang
  FROM KFZ01OM0  
 WHERE ACC1_CD = :sacc1 AND  ACC2_CD =  :sacc2  ;

//������, ���ޱ� ������ ���뱸���� �����̰� ��豸���� 'Y' �� �ڷ� <= �ʿ���� �� DB
//OPT��  X => �����Է±���, N => �ܻ���Աݸ�, Y => ������ǥ�� 
IF SQLCA.SQLCODE <> 0 THEN 
	sOpt = 'X'  
ELSE	
	SELECT RFGUB     INTO :s_nam1     FROM REFFPF  
	 WHERE SABU = '1' AND RFCOD = '1D' AND RFGUB <> '00' AND RFNA2 = :s_cod ;
	IF SQLCA.SQLCODE <> 0 THEN 
		sOpt = 'X'  
	ELSE	
		IF get_dc = '1' and get_sang = 'Y' THEN 
			sOpt = 'Y'
		else
			sOpt = 'N'
		END IF	
	END IF	
END IF

return sOpt

end function

public function integer wf_kif07oto_delete ();String  sGubun, sJpno
Long    lRow, lCount

lCount = dw_insert.RowCount()

FOR  lRow = 1	TO  lCount		

	sGubun   = dw_insert.GetItemString(lRow, "settle")
	sJpno    = dw_insert.GetItemString(lRow, "expjpno")

	IF sGubun = 'N'	THEN				
 	   DELETE FROM "KIF07OT0"  
		   	WHERE "SABU" = :gs_sabu AND  "EXPJPNO" = :sJpno ;
		IF Sqlca.SqlCode <> 0 THEN
			RollBack ;
			MessageBox('Ȯ��', 'Kif07ot0������ Error �߻�!!!')
			Return -1
		END IF				
				
 	   DELETE FROM "KIF07OT1"  
		   	WHERE "SABU" = :gs_sabu AND  "EXPJPNO" = :sJpno ;				
		
		IF Sqlca.SqlCode <> 0 THEN
			RollBack ;
			MessageBox('Ȯ��', 'Kif07ot1������ Error �߻�!!!')
			Return -1
		END IF
	END IF

NEXT

Return 1

end function

public function integer wf_kif07oto_insert ();String  sGubun, sJpno, soccdat, socccod, sforcur, spolcno, spoblno, sbigu, ssetdat, smulgu, &
        scvcod, slcmagu, slcmadat, smablno, sMaip_dept, swdept, svatgu, sdescr, &
        scrosno, saccod, sgyul_date, sgyul_method, ssend_bank, ssend_dep, ssend_nm, sorcvcod 
Decimal {2} dforamt, dfprrat, dwonamt, dvatamt, dchaipfor, dchaipwon, dmichamt, &
				dijaamt, dinchul_gyeamt, dinchul_cash, dorioamt
Long    lRow, lCount, ll, lser
String	ls_sawon, ls_chulcod, ls_saupj, ls_jungcvd//����ŷ�ó
String   sija_accod, sinchul_gyecod, sBigbn

If dw_1.AcceptText() <> 1 Then Return -1

sMaip_dept 	= dw_1.GetItemString(1, "dept_cd")//���Ժμ�
ls_sawon   	= dw_1.GetItemString(1, "emp_no")//������ �߰�
scrosno    	= dw_3.GetItemString(1, "crossno")
saccod     	= dw_3.GetItemString(1, "saccod") 
sgyul_date 	= dw_3.GetItemString(1, "gyul_date")
sgyul_method = dw_3.GetItemString(1, "gyul_method")
ssend_bank 	= dw_3.GetItemString(1, "send_bank")
ssend_dep  	= dw_3.GetItemString(1, "send_dep")
ssend_nm   	= dw_3.GetItemString(1, "send_nm")
ls_chulcod 	= dw_3.GetItemString(1, "depotno")//������ �߰�(��ݰ��¹�ȣ)
ls_saupj	  	= dw_1.GetItemString(1, "saupj")//������ �߰�(����ŷ�ó)

lCount =	dw_insert.RowCount()
FOR  lRow = 1	TO	lCount

	sGubun   	= dw_insert.GetItemString(lRow, "settle")
	sJpno    	= dw_insert.GetItemString(lRow, "expjpno")
	sOccdat  	= dw_insert.GetItemString(lRow, "occdat")
	sOcccod  = dw_insert.GetItemString(lRow, "occcod")
	dForamt  	= dw_insert.GetItemDecimal(lRow, "foramt")
	sForcur  	= dw_insert.GetItemString(lRow, "forcur")
	dFprrat  	= dw_insert.GetItemDecimal(lRow, "fprrat")
	dWonamt  = dw_insert.GetItemDecimal(lRow, "wonamt")
	dVatamt  	= dw_insert.GetItemDecimal(lRow, "vatamt")
	sPolcno  	= dw_insert.GetItemString(lRow, "polcno")
	sPoblno  	= dw_insert.GetItemString(lRow, "poblno")
	sBigu    	= dw_insert.GetItemString(lRow, "bigu")
	sSetdat  	= dw_insert.GetItemString(lRow, "setdat")
	sCvcod   	= dw_insert.GetItemString(lRow, "cvcod")
	sMulgu   	= dw_insert.GetItemString(lRow, "mulgu")
	sLcmagu  	= dw_insert.GetItemString(lRow, "lcmagu")
	sLcmadat 	= dw_insert.GetItemString(lRow, "lcmadat")
	sMablno  	= dw_insert.GetItemString(lRow, "mablno")
	// ��뺰 ��ǥ��� ���� : �ŷ�ó ���忡 LC�� ������ �� ��� ó��
	sBigbn	   = dw_insert.GetItemString(lRow, "ac_confirm")	

	swdept   	= dw_insert.GetItemString(lRow, "sdept_cd") //�����μ�
	svatgu   	= dw_insert.GetItemString(lRow, "vatgu")//�ΰ�������
	
	sdescr   	= dw_insert.GetItemString(lRow, "descr")//����
     if	sdescr = "" or isnull(sdescr) 	then
		sdescr = dw_insert.GetItemString(lRow, "reffpf_rfna1")
	Else
		sdescr = sdescr + '   ' + dw_insert.GetItemString(lRow, "reffpf_rfna1")
		
	End If
	
	ls_jungcvd 	= dw_1.GetItemString(1, "cvcod")//������ �߰�(����ŷ�ó)
	IF Trim(ls_jungcvd) = '' OR IsNull(ls_jungcvd) THEN
		ls_jungcvd = scvcod 
	END IF
	
	// ���Ű��������� ��쿡�� ����
	ll = 0
	select kumusd, kumwon, biamt1, ilamt, gyecod, chamt, csamt, 1 
	  into :dchaipfor, :dchaipwon, :dmichamt, :dijaamt, :sinchul_gyecod, :dinchul_gyeamt, :dinchul_cash, :ll
	  from polcsethd
	 Where sabu = :gs_sabu and sujpno = :sjpno;	 
	If sqlca.sqlcode <> 0 then
	   dchaipfor = 0
		dchaipwon = 0
		dmichamt  = 0
		dijaamt   = 0
		Setnull(sinchul_gyecod)
		dinchul_gyeamt = 0
		dinchul_cash   = 0
		Setnull(sija_accod)		
	Else
		sija_accod = is_ijacod
	end if
	
	//VATGU �����ڵ� 'AT' �� ���Կ�����(13)
	IF 	sGubun = 'Y'	THEN				
	   INSERT INTO "KIF07OT0"  
         ( "SABU",     "EXPJPNO",   "ACCDAT",   "ACCCOD",   "FORMAT",   "FORCUR",   
           "FORRAT",   "WONAMT",    "VATAMT",   "VATGU",    "SETTLE",   "POLCNO",   
           "POBLNO",   "BIGU",     	"CVCOD",    "MULGU",    "SETDAT",   "LCMAGU",   
           "LCMADAT",  "MABLNO",    "ALC_GU", 	"SAUPJ",
			  "SDEPT_CD", "DESCR",     "SACCOD",   "GYUL_DATE","GYUL_METHOD","SEND_BANK",   
	   	  "SEND_DEP", "SEND_NM",   "CROSSNO",	"EXPDPT", "SAWON", "JCVCOD", "DEPOTNO",
			  "CHAIPFOR", "CHAIPWON",  "MICHAMT",  "IJA_ACCOD1", "IJA_ACCOD2", "IJAAMT",
			  "INCHUL_GYECOD", "INCHUL_GYEAMT", "INCHUL_CASH", "BIGBN")   
	   VALUES 
		   ( :gs_sabu,  	:sJpno,    	:sOccdat,   :sOcccod,	:dForamt,   :sForcur,
			  :dFprrat,    :dWonamt,   :dVatamt,   :svatgu,    'Y',        :sPolcno,
			  :sPoblno,	   :sBigu,     :sCvcod,    :sMulgu,    :sSetdat,	:sLcmagu,
			  :sLcmadat,   :sMablno,   'N', 			:ls_saupj,
			  :swdept,     :sdescr,    :saccod,    :sgyul_date, :sgyul_method, :ssend_bank, 
			  :ssend_dep,  :ssend_nm,  :scrosno,   :sMaip_dept , :ls_sawon, :ls_jungcvd, :ls_chulcod,
			  :dchaipfor,  :dchaipwon, :dmichamt,  substr(:sija_accod, 1, 5), substr(:sija_accod, 6, 2), 
			  :dijaamt,    :sinchul_gyecod, :dinchul_gyeamt, :dinchul_cash, :sBigbn);
		IF Sqlca.SqlCode <> 0 THEN
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack ;
			MessageBox('Ȯ��', 'kif07ot0����� Error �߻�!!!')
			Return -1
		END IF
		
		// Local L/C�� ���[����ڵ尡 �����ݾ�]���� ���ݰ�꼭 ������ local�� kif07ot1�� �����Ѵ�.
		if Left(spolcno, 1) = 'L' and ll = 1 then
			Datastore ds
			ds = create datastore
			ds.dataobject = 'd_imt_03082'
			ds.settransobject(sqlca)
			ds.retrieve(gs_sabu, sjpno)
			For lser = 1 to ds.rowcount()
				 sorcvcod = ds.getitemstring(lser, "cvcod")
				 dorioamt = ds.getitemdecimal(lser, "ioamt") 
	
				 insert into KIF07OT1 (sabu, expjpno, cvcod, wonamt, polcno, poblno)
									VALUES (:gs_sabu, :sjpno, :sorcvcod, :dorioamt, :spolcno, :spoblno);
				 IF Sqlca.SqlCode <> 0 THEN
					 RollBack ;
					 destroy ds				 
					 MessageBox('Ȯ��', 'KIF07OT1 Error �߻�!!!')
					 Return -1
				 END IF
	
			Next
			destroy ds
		End if
		
	End if	

NEXT

Return 1
end function

on w_imt_03080.create
int iCurrent
call super::create
this.rr_4=create rr_4
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_3=create dw_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_4
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_3
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_3
this.Control[iCurrent+9]=this.pb_4
this.Control[iCurrent+10]=this.pb_5
this.Control[iCurrent+11]=this.rr_2
end on

on w_imt_03080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_4)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.rr_2)
end on

event open;call super::open;//���� �ΰ��� �ڵ� �ý��ۿ��� ��������
SELECT DATANAME  
  INTO :is_occod 
  FROM SYSCNFG  
 WHERE SYSGU = 'A' AND SERIAL = 13 AND LINENO = '01' ;
 
IF isnull(is_occod) then is_occod = '' 

//��������
SELECT DATANAME  
  INTO :is_ijacod
  FROM SYSCNFG  
 WHERE SYSGU = 'Y' AND SERIAL = 32 AND LINENO = '5' ;

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_1.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_insert.settransobject(sqlca)

dw_1.insertrow(0)
dw_3.insertrow(0)

p_can.TriggerEvent("clicked")

end event

type dw_insert from w_inherite`dw_insert within w_imt_03080
integer x = 27
integer y = 820
integer width = 4571
integer height = 1500
integer taborder = 20
string dataobject = "d_imt_03080"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;RETURN 1
	
	
end event

event dw_insert::editchanged;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;string scheck, sCvcod, s_cod, s_nam1, s_nam2, sNull, saccod, sOpt,sNo, sOccod
long   lcount
dec    damt, dwonamt, dvamt, dtotamt

setnull(sNull)

IF this.GetColumnName() = "settle" and rb_1.checked  THEN
	scheck = this.GetText()
	
	IF	scheck <> 'Y'	Then	RETURN 

	dw_3.accepttext()
	
	sOccod = this.getitemstring(row, 'occcod')
	saccod = dw_3.getitemstring(1, 'saccod')
	if isnull(saccod) or saccod = '' then 
		MessageBox("Ȯ ��","�������� �Է��ϼ���!")
		dw_3.setcolumn('saccod')
		dw_3.setfocus()
      return 1
	end if
	
	sOpt = wf_accod_chk(saccod)
	//������, ���ޱ� ������ ���뱸���� �����̰� ��豸���� 'Y' �� �ڷ� 
	//OPT��  X => �����Է±���, N => �ܻ���Աݸ�, Y => ������ǥ�� 
   IF sOpt = 'Y' THEN 	
		sNo = dw_3.getitemstring(1, 'crossno')
		if isnull(sNo) or sNO = '' then 
			MessageBox("Ȯ ��","������ǥ�� �����ϼ���!")
			dw_3.setcolumn('crossno')
			dw_3.setfocus()
			return 1
		end if
		
		damt = dw_3.getitemDecimal(1, 'amt')
		
		if sOccod = is_occod then 
			dWonamt = 0 
		else
			dwonamt = this.getitemdecimal(row, 'wonamt')
		end if
		dvamt   = this.getitemdecimal(row, 'vatamt')
		dtotamt = this.getitemdecimal(row, 'tot_amt')
		if dtotamt + dwonamt + dvamt > damt then 
			MessageBox("Ȯ ��","������ǥ�ݾ��� �ʰ��Ͽ����� �ݾ��� Ȯ���ϼ���!")
			return 1
		end if
		
	ELSEIF sOpt = 'X' THEN 
		MessageBox("Ȯ ��","�������� �����ڵ带 Ȯ���ϼ���!")
      return 1		
	END IF

	sCvcod = this.getitemstring(row, 'cvcod')
	
//	if not (is_cvcod = '' or isnull(is_cvcod)) then 
//		if sCvcod <> is_cvcod then 
//		   messagebox("Ȯ ��", "�ŷ�ó�� Ȯ���ϼ���")
//			return 1
//		end if
//	end if

   IF wf_cvcod_chk(sCvcod) < 0 THEN RETURN 1

	////////////////////////////////////////////////////////////////////////////////////////
	// ���� �ι� �����ϱ�(���Ժμ��� => �����ι��� ã�� )
	////////////////////////////////////////////////////////////////////////////////////////
	string  get_deptnm, sdept_cd, sDept
	Dec     dVatamt
	sDept = dw_1.getitemstring(1, 'dept_cd')

   IF not (sDept = '' or isnull(sDept)) then 
		SELECT COST_CD, COST_NM  
		  INTO :sdept_cd, :get_deptnm
		  FROM CIA02M  
		 WHERE DEPT_CD = :sdept AND USEGBN = '1' AND ROWNUM = 1 ;
	
		this.object.sdept_cd[row] = sdept_cd
		this.object.wdeptnm[row]  = get_deptnm
	END IF
	
	dVatamt = this.getitemdecimal(row, 'vatamt')
	
	If isNull(dVatamt) then dVatamt = 0
	
	//�ΰ��� �ݾ��� ������ �Ϲݰ����̰� ������ ���� ���������� ����
	if dVatamt <> 0 then 
		this.setitem(row, 'vatgu', '11')
	else
		this.setitem(row, 'vatgu', snull)
//		if getitemstring(row, 'ac_confirm') = 'Y' Then	// �ϰ��������� ����� ��� �ΰ��� ������ null
//			this.setitem(row, 'vatgu', snull)
//		else
//			this.setitem(row, 'vatgu', '11')
//		end if
	end if
	
//	SELECT COST_NM  
//     INTO :s_nam1  
//     FROM CIA02M  
//    WHERE COST_CD = 'C0001' AND USEGBN = '1' ;
//	
//	this.setitem(row, 'sdept_cd', 'C0001')
//	this.setitem(row, 'wdeptnm', s_nam1)
ELSEif this.GetColumnName() = "sdept_cd" Then
   s_cod = Trim(this.GetText())
	
	if s_cod = '' or isnull(s_cod) then
		this.object.wdeptnm[row] = sNull
		return 
	END IF
   SELECT COST_NM  
     INTO :s_nam1  
     FROM CIA02M  
    WHERE COST_CD = :s_cod AND USEGBN = '1' ;

   IF SQLCA.SQLCODE = 0 THEN 
		this.object.wdeptnm[row] = s_nam1
	ELSE
      F_message_chk(33, "[�����μ�]")
		this.object.sdept_cd[row] = snull
		this.object.wdeptnm[row] = sNull
		RETURN 1
	END IF	
END IF

end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "sdept_cd"	THEN		
	open(w_cia02m_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	this.SetItem(this.getrow(), "sdept_cd", gs_code)
	this.SetItem(this.getrow(), "wdeptnm", gs_codename)
END IF


end event

type p_delrow from w_inherite`p_delrow within w_imt_03080
boolean visible = false
integer x = 5093
integer y = 36
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_imt_03080
boolean visible = false
integer x = 5070
integer y = 100
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_imt_03080
boolean visible = false
integer x = 4942
integer y = 392
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_imt_03080
boolean visible = false
integer x = 5147
integer y = 572
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_imt_03080
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_imt_03080
integer taborder = 0
end type

event p_can::clicked;call super::clicked;string deptno, deptnm, snull

SetNull(sNull)

dw_insert.Reset()

select v.cvnas2 into :deptnm
  from vndmst v
 where v.cvcod = :gs_dept ;

dw_1.object.dept_cd[1] = gs_dept
dw_1.object.dept_nm[1] = deptnm

dw_1.object.cvcod[1] = sNull
dw_1.object.cvnm[1] = sNull

rb_1.checked = true
rb_1.TriggerEvent("clicked")

end event

type p_print from w_inherite`p_print within w_imt_03080
boolean visible = false
integer x = 5051
integer y = 148
integer height = 140
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_03080
integer x = 3749
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;IF dw_1.accepttext() = -1			THEN 	RETURN 

string	sf_Date, st_date, sDept, sLcno, sBlno, sOccod, scvcod, sf_jdate, st_jdate, sSaupj

sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))
st_Date =  trim(dw_1.getitemstring(1, 'to_date'))
sDept   =  trim(dw_1.getitemstring(1, 'dept_cd'))
sBlno   =  trim(dw_1.getitemstring(1, 'Blno'))
sLcno   =  trim(dw_1.getitemstring(1, 'lcno'))
sOccod  =  trim(dw_1.getitemstring(1, 'occod'))
scvcod  =  trim(dw_1.getitemstring(1, 'cvcod'))
sf_jDate =  trim(dw_1.getitemstring(1, 'f_jdate'))
st_jDate =  trim(dw_1.getitemstring(1, 't_jdate'))
sSaupj   = trim(dw_1.getitemstring(1, 'saupj'))

if sLcno  = '' or isnull(sLcno) then sLcno = '%' 
if sBlno  = '' or isnull(sBlno) then sBlno = '%' 
if sOccod = '' or isnull(sOccod) then sOccod = '%' 
if scvcod = '' or isnull(scvcod) then scvcod = '%' 
IF isnull(sf_jDate) or sf_jDate = "" 	THEN
	sf_jdate = '10000101'
END IF
IF isnull(st_jDate) or st_jDate = "" 	THEN
	st_jdate = '99991231'
END IF

// �ű� ���
IF rb_1.checked = true	THEN
	
	dw_insert.SetTransObject(Sqlca)
	
	IF	dw_insert.Retrieve(gs_sabu, 'N', sLcno, sBlno, sOccod, scvcod, is_occod, sf_jdate, st_jdate, sSaupj  ) <	1		THEN
		f_message_chk(50, '[�̽�û�ڷ�]')
		dw_insert.SetFocus()
		RETURN
	END IF

ELSE

	IF isnull(sf_Date) or sf_Date = "" 	THEN
		sf_date = '10000101'
	END IF
	IF isnull(st_Date) or st_Date = "" 	THEN
		st_date = '99991231'
	END IF

	IF isnull(sDept) or sDept = "" 	THEN 		sDept = '%'

	IF	dw_insert.Retrieve(gs_sabu, 'Y', sf_Date, st_date, sDept, sLcno, sBlno, sOccod, scvcod, &
	                    sf_jdate, st_jdate, sSaupj) <	1 THEN
		f_message_chk(50, '[���û�ڷ�]')
		dw_1.SetFocus()
		RETURN
	END IF

END IF

end event

type p_del from w_inherite`p_del within w_imt_03080
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\�������_up.gif"
end type

event p_del::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_1.accepttext() = -1			THEN 	RETURN 
IF dw_3.accepttext() = -1			THEN 	RETURN 
IF dw_insert.accepttext() = -1			THEN 	RETURN 
IF dw_insert.RowCount() < 1			THEN 	RETURN 

long		lRow
string	sDate, sGubun, sNull, ls_dept, ls_empno
			
SetNull(sNull)

IF Messagebox('Ȯ��', '�����û ��Ҹ� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) <> 1 then return 

FOR  lRow = 1	TO		dw_insert.RowCount()

	sGubun = dw_insert.GetItemString(lRow, "settle")

	IF sGubun = 'N'	THEN				// �������
		dw_insert.SetItem(lRow, "setdat", sNull)
		dw_insert.SetItem(lRow, "cvcod", sNull)
	END IF

NEXT

IF dw_insert.Update() > 0		THEN
	//�ڷ� ���� 
	IF wf_kif07oto_delete() = -1 THEN 
		ROLLBACK;
		f_Rollback()
	END IF	
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\�������_up.gif"
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\�������_dn.gif"
end event

type p_mod from w_inherite`p_mod within w_imt_03080
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\�����û_up.gif"
end type

event p_mod::clicked;call super::clicked;//�����û

SetPointer(HourGlass!)

IF dw_1.accepttext() = -1			THEN 	RETURN 
IF dw_3.accepttext() = -1			THEN 	RETURN 
IF dw_insert.accepttext() = -1			THEN 	RETURN 
IF dw_insert.RowCount() < 1			THEN 	RETURN 

long		lRow
string	sDate, sGubun, sNull, smsg, ls_dept, ls_empno, svatgu
Dec      dVatamt
			
SetNull(sNull)

sDate =  trim(dw_1.getitemstring(1, 'fr_date'))
ls_dept  = Trim(dw_1.GetItemString(1, 'dept_cd'))
ls_empno = Trim(dw_1.GetItemString(1, 'emp_no'))

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[��û����]')
	dw_insert.SetFocus()
	RETURN
END IF

IF ls_dept = '' Or IsNull(ls_dept) THEN
	f_message_chk(30, '[���Ժμ�]')
	dw_1.SetFocus()
	dw_1.SetColumn('dept_cd')
	Return 
END IF

IF ls_empno = '' Or IsNull(ls_empno) THEN
	f_message_chk(30, '[��û��]')
	dw_1.SetFocus()
	dw_1.SetColumn('emp_no')
	Return 
END IF

FOR  lRow = 1	TO		dw_insert.RowCount()
	sGubun = dw_insert.GetItemString(lRow, "settle")
	sVatgu = dw_insert.GetItemString(lRow, "vatgu")
	dVatamt = dw_insert.GetItemNumber(lRow, 'vatamt')
	
	IF sGubun = 'Y' Then
		If sVatgu <> '13'	And dVatAmt <= 0 THEN
			MessageBox('Ȯ ��','�ΰ����� ��ϵ��� �ʾҽ��ϴ�!!')
			dw_insert.SetFocus()
			dw_insert.SetRow(lRow)
			dw_insert.ScrollToRow(lRow)
			dw_insert.SetColumn('vatgu')
			Return
		End If
		
		If sVatgu = '13'	And dVatAmt > 0 THEN
			MessageBox('Ȯ ��','�������� �ΰ����� ����Ͻ� �� �����ϴ�.!!')
			dw_insert.SetFocus()
			dw_insert.SetRow(lRow)
			dw_insert.ScrollToRow(lRow)
			dw_insert.SetColumn('vatgu')
			Return
		End If
	END IF
NEXT

IF Messagebox('Ȯ��','�����û ó�� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) <> 1 then return 

FOR  lRow = 1	TO		dw_insert.RowCount()
	sGubun = dw_insert.GetItemString(lRow, "settle")
	IF sGubun = 'Y'	THEN				// �������� ���
		dw_insert.SetItem(lRow, "setdat", sDate)
	END IF
NEXT

IF dw_insert.Update() > 0		THEN
	//��������� �������̽��� �ڷ� �߰� 
	IF wf_kif07oto_insert() = -1 THEN 
		ROLLBACK;
		f_Rollback()
	END IF	
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\�����û_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\�����û_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_imt_03080
end type

type cb_mod from w_inherite`cb_mod within w_imt_03080
end type

type cb_ins from w_inherite`cb_ins within w_imt_03080
end type

type cb_del from w_inherite`cb_del within w_imt_03080
end type

type cb_inq from w_inherite`cb_inq within w_imt_03080
end type

type cb_print from w_inherite`cb_print within w_imt_03080
end type

type st_1 from w_inherite`st_1 within w_imt_03080
end type

type cb_can from w_inherite`cb_can within w_imt_03080
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_imt_03080
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_03080
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03080
end type

type rr_4 from roundrectangle within w_imt_03080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 808
integer width = 4590
integer height = 1528
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_imt_03080
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 14
integer y = 188
integer width = 4599
integer height = 316
string title = "none"
string dataobject = "d_imt_03080_a"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;string  snull, sdate, scode, sname1, sname2, sNo, get_nm
int     ireturn, icount 

setnull(snull)

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[��û����]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[��û����]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "dept_cd" Then
   scode = Trim(this.GetText())
	iReturn = f_get_name2("�μ�", "Y", scode, sname1, sname2) 
	this.object.dept_cd[1] = scode
	this.object.dept_nm[1] = sname1
	return iReturn 
// LC��ȣ
ELSEIF this.GetColumnName() = 'lcno' THEN
	sNo = trim(this.GetText())
	
	IF sno = '' or isnull(sno) then return 
	
	SELECT SABU
	  INTO :get_nm
	  FROM POLCHD
	 WHERE SABU = :gs_Saupj		AND
			 POLCNO = :sNo ;	
			  
	IF sqlca.sqlcode	<> 0 THEN
		f_message_chk(33, '[L/C No]')
		this.setitem(1, "lcno", sNull)
		RETURN 1
	END IF	
// BL��ȣ
ELSEIF this.GetColumnName() = 'blno' THEN

	sNo = trim(this.GetText())
	
	IF sno = '' or isnull(sno) then return 
		
	SELECT Count(*) 
	  INTO :iCount
	  FROM POLCBL
	 WHERE SABU = :gs_Saupj		AND
			 POBLNO = :sNo     ;	
				  
	IF iCount < 1		THEN
		f_message_chk(33, '[B/L No]')
		this.setitem(1, "blno", sNull)
		RETURN 1
	END IF	

ELSEIF this.GetColumnName() = "cvcod" THEN
	
	sCode = this.GetText()								
	
	if scode = '' or isnull(scode) then 
		this.setitem(1, 'cvnm', sNull)
      return 
	end if	
	
	//�ŷ�ó�� ����, �ؿ�, ���ظ� ������ �� ����
   SELECT CVNAS2
     INTO :sName1
     FROM VNDMST 
    WHERE CVCOD = :sCode   AND
	 		 CVSTATUS = '0'   AND 
			 CVGU  IN ('1', '2', '3') ;
	 		 
	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[�ŷ�ó]')
		this.setitem(1, 'cvcod', sNull)
		this.setitem(1, 'cvnm', snull)
	   return 1
	ELSE
		this.setitem(1,  'cvnm', sName1)
   END IF
ELSEIF this.GetColumnName() = "emp_no" THEN
	sCode = GetText()
	
	if scode = '' or isnull(scode) then 
		this.setitem(1, 'emp_nm', sNull)
      return 
	end if	
	
	SELECT "P1_MASTER"."EMPNAME"
	  INTO :sName1 
     FROM "P1_MASTER", "VNDMST"
    WHERE ( p1_master.deptcode = vndmst.cvcod (+)) and  
          ( "P1_MASTER"."SERVICEKINDCODE" = '1' ) AND  
          ( "P1_MASTER"."EMPNO" = :sCode )	;
	IF Sqlca.SqlCode <> 0 THEN
		MessageBox('Ȯ��', '��ϵ��� ���� �����ȣ �Դϴ�!')
		this.setitem(1, 'emp_no', sNull)
		this.setitem(1, 'emp_nm', snull)
		Return 1
	END IF
	this.setitem(1,  'emp_nm', sName1)
END IF
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "dept_cd"	THEN		
	open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	this.SetItem(1, "dept_cd", gs_code)
	this.SetItem(1, "dept_nm", gs_codename)
ELSEIF	this.getcolumnname() = "cvcod"	THEN		
	open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvnm", gs_codename)
	this.triggerevent(itemchanged!)
ELSEIF this.getcolumnname() = "lcno" 	THEN

	open(w_lc_popup)
	
	if isnull(gs_code)  or  gs_code = ''	then	return

	this.setitem(1, "lcno", gs_code)
ELSEIF this.getcolumnname() = "blno" 	THEN

	open(w_bl_popup4)
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	
	this.setitem(1, "blno", gs_code)
ELSEIF this.getcolumnname() = "emp_no" 	THEN
	open(w_sawon_popup)
	
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "emp_no", gs_code)
	this.setitem(1, "emp_nm", gs_codename)
	
END IF


end event

type rb_1 from radiobutton within w_imt_03080
integer x = 110
integer y = 72
integer width = 370
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
string text = "��û ���"
boolean checked = true
end type

event clicked;ic_Status = '1'

p_mod.Enabled = True
p_mod.PictureName = "c:\erpman\image\�����û_up.gif"

p_del.Enabled = false
p_del.PictureName = "c:\erpman\image\�������_d.gif"

dw_insert.DataObject = 'd_imt_03080'
dw_insert.SetTransObject(SQLCA)

dw_3.setredraw(false)

dw_3.reset()
dw_3.insertrow(0)

dw_3.setredraw(true)

dw_1.settaborder("to_date", 0)
//dw_1.Modify("fr_date.BackGround.Color= 12639424") 
dw_1.Modify("to_date.Visible= 0") 
dw_1.Modify("to_date_t.Visible= 0") 

dw_1.setitem(1, 'fr_date', is_today)
dw_1.setitem(1, 'emp_no', gs_empno)
dw_1.setitem(1, 'emp_nm', gs_username)
//�ΰ������
f_mod_saupj(dw_1,'saupj')

//dw_1.setitem(1, 'f_jdate', left(is_today,6) + '01')
//dw_1.setitem(1, 't_jdate', is_today)

dw_insert.setfocus()

setnull(is_cvcod)

dw_3.Enabled = TRUE
end event

type rb_2 from radiobutton within w_imt_03080
integer x = 521
integer y = 72
integer width = 370
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
string text = "��û ���"
end type

event clicked;ic_Status = '2'

p_mod.Enabled = false
p_mod.PictureName = "c:\erpman\image\�����û_d.gif"

p_del.Enabled = true
p_del.PictureName = "c:\erpman\image\�������_up.gif"
dw_insert.DataObject = 'd_imt_03081'
dw_insert.SetTransObject(SQLCA)

dw_3.setredraw(false)

dw_3.reset()
dw_3.insertrow(0)

dw_3.setredraw(true)

dw_1.Modify("to_date.Visible= 1") 
dw_1.Modify("to_date_t.Visible= 1") 
dw_1.settaborder("to_date", 20)
//dw_1.Modify("fr_date.BackGround.Color= 16777215") 

dw_1.setitem(1, 'fr_date', left(is_today,6) + '01')
dw_1.setitem(1, 'to_date', is_today)

dw_1.setitem(1, 'f_jdate', '')
dw_1.setitem(1, 't_jdate', '')

setnull(is_cvcod)

dw_1.setcolumn('fr_date')
dw_1.setfocus()

dw_3.Enabled = False
end event

type dw_3 from datawindow within w_imt_03080
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 14
integer y = 496
integer width = 4599
integer height = 312
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_03080_popup"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_processenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event buttonclicking;string  get_gbn, sacc_cd1, sacc_cd2
decimal damt

if dw_1.accepttext() = -1 then return 
//��ȸ���� - ��ǥ������, ��������, ���Ժμ�
//           (gs_gubun, gs_codename, gs_code)
// ���� ������������ �������� ����Ÿ�� �о �θ�ŷ�ó�� üũ�Ͽ� �μ��� ��ȸ�� ������
// �ŷ�ó�� ��ȸ�� �������� �����Ѵ�.(KFZ01OM0 �� GBN1 �ŷ�ó�� '1', �μ��� '3')
//
gs_codename = this.getitemstring(1, 'saccod')

sacc_cd1 = left(gs_codename, 5)
sacc_cd2 = mid(gs_codename, 6, 2)

SELECT "KFZ01OM0"."GBN1"  
  INTO :get_gbn  
  FROM "KFZ01OM0"  
 WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc_cd1 ) AND  
		 ( "KFZ01OM0"."ACC2_CD" = :sacc_cd2 )   ;

IF SQLCA.SQLCODE <> 0 THEN 
	MESSAGEBOX("Ȯ ��", "�����ڵ忡 ���������� Ȯ���ϼ���!")
   Return 
END IF	

setnull(is_cvcod)
IF get_gbn = '1' THEN  			//�ŷ�ó�� ��������
	gs_code     = dw_1.getitemstring(1, 'cvcod')
   is_cvcod    = gs_code	
ELSEIF get_gbn = '3' THEN  	//�μ��� ��������
	gs_code     = dw_1.getitemstring(1, 'dept_cd')
ELSEIF get_gbn = '4' THEN  	//����� ��������
	gs_code     = dw_1.getitemstring(1, 'emp_no')	
ELSEIF IsNull(get_gbn) OR get_gbn = '' THEN  	//�μ��� ��������
	MessageBox('Ȯ��', '�������� Ȯ���ϼ���!!!')
	Return
ELSE 
	gs_code     = ''
END IF

gs_gubun    = dw_1.getitemstring(1, 'fr_date')

if gs_code = '' or isnull(gs_code) then 
	if get_gbn = '1' then 
		messagebox("Ȯ ��", "�ŷ�ó�� ���� �Է��ϼ���!")
		dw_1.setcolumn('cvcod')
		dw_1.setfocus()
	else
		messagebox("Ȯ ��", "���Ժμ�/����ڸ� ���� �����ϼ���!")
		dw_1.setcolumn('dept_cd')
		dw_1.setfocus()
	end if
	return 
end if	

if gs_gubun  = '' or isnull(gs_gubun) then 
	messagebox("Ȯ ��", "�����û���ڸ� ���� �Է��ϼ���!")
	dw_1.setcolumn('fr_date')
	dw_1.setfocus()
end if	
	
if gs_codename = '' or isnull(gs_codename) then 
	messagebox("Ȯ ��", "�������� ���� �����ϼ���!")
	return 
end if	

open(w_kfz19ot0_popup2)

if gs_code = '' or isnull(gs_code) then return 

this.setitem(1, 'crossno', gs_code)
this.setitem(1, 'amt', dec(gs_codename))

p_inq.TriggerEvent(Clicked!)

end event

event itemchanged;String  s_cod, s_nam1, s_nam2, snull, sacc1, sacc2, get_dc, get_sang, sopt, get_gbn1, s_cod1
Integer i_rtn, li_cnt

setnull(snull)

IF this.GetColumnName() = "saccod" THEN
	s_cod = this.GETTEXT()

	this.SetItem(1, 'depotno', snull)
   this.SetItem(1, 'crossno', snull)
	this.SetItem(1, 'gyul_date', snull)
	this.SetItem(1, 'gyul_method', snull)
	this.SetItem(1, 'send_bank', snull)
	this.SetItem(1, 'send_dep', snull)
	this.SetItem(1, 'send_nm', snull)
	this.SetItem(1, 'amt', 0)
   setnull(is_cvcod)
   p_inq.TriggerEvent(Clicked!)

   sacc1 = left(s_cod, 5)
   sacc2 = mid(s_cod, 6, 2)
	
   SELECT DC_GU,   SANG_GU, GBN1
	  INTO :get_dc, :get_sang, :get_gbn1
	  FROM KFZ01OM0  
	 WHERE ACC1_CD = :sacc1 AND  ACC2_CD =  :sacc2  ;
   
	//������, ���ޱ� ������ ���뱸���� �����̰� ��豸���� 'Y' �� �ڷ� <= �ʿ���� 5/21 ��
	//OPT��  X => �����Է±���, N => �ܻ���Ա�, ���� , ���Ա� Y => ������ǥ�� 
	IF SQLCA.SQLCODE <> 0 THEN 
		sOpt = 'X'  
	ELSE	
		SELECT RFGUB     INTO :s_nam1     FROM REFFPF  
		 WHERE SABU = '1' AND RFCOD = '1D' AND RFGUB <> '00' AND RFNA2 = :s_cod ;

		IF SQLCA.SQLCODE <> 0 THEN 
			sOpt = 'X'  
		ELSE	
			IF get_dc = '1' and get_sang = 'Y' THEN 
				sOpt = 'Y'
			else
				sOpt = 'N'
			END IF	
		END IF	
	END IF

	IF sOpt = 'N' THEN 
//		this.Object.crossno.Background.Color= 79741120
		this.Object.bt_crossno.Visible= False
		
		IF get_gbn1 = '5' OR get_gbn1 = '6' THEN
			this.SetTabOrder("depotno", 60)
//			this.Object.depotno.Background.Color= 65535
		ELSE
			this.SetTabOrder("depotno", 0)
//			this.Object.depotno.Background.Color= 79741120
		END IF	
		
		this.SetTabOrder("gyul_date", 70)
		this.SetTabOrder("gyul_method", 80)
		this.SetTabOrder("send_bank", 90)
		this.SetTabOrder("send_dep", 100)
		this.SetTabOrder("send_nm", 110)

//		this.Object.gyul_date.Background.Color= 16777215
//		this.Object.gyul_method.Background.Color= 16777215
//		this.Object.send_bank.Background.Color= 16777215
//		this.Object.send_dep.Background.Color= 65535
//		this.Object.send_nm.Background.Color= 16777215
	ELSEIF sOpt = 'Y' THEN 	
//		this.Object.crossno.Background.Color= 12639424
		this.Object.bt_crossno.Visible= True
		
		
		this.SetTabOrder("depotno", 0)
		this.SetTabOrder("gyul_date", 0)
		this.SetTabOrder("gyul_method", 0)
		this.SetTabOrder("send_bank", 0)
		this.SetTabOrder("send_dep", 0)
		this.SetTabOrder("send_nm", 0)
		
//		this.Object.depotno.Background.Color= 79741120	
//		this.Object.gyul_date.Background.Color= 79741120
//		this.Object.gyul_method.Background.Color= 79741120
//		this.Object.send_bank.Background.Color= 79741120
//		this.Object.send_dep.Background.Color= 79741120
//		this.Object.send_nm.Background.Color= 79741120
	ELSE
		MessageBox("Ȯ ��","�������� �����ڵ带 Ȯ���ϼ���!")
		this.SetItem(1, 'saccod', snull)
		
		this.Object.bt_crossno.Visible= False
//		this.Object.crossno.Background.Color= 79741120
		
		this.SetTabOrder("gyul_date", 0)
		this.SetTabOrder("gyul_method", 0)
		this.SetTabOrder("send_bank", 0)
		this.SetTabOrder("send_dep", 0)
		this.SetTabOrder("send_nm", 0)
	
//		this.Object.gyul_date.Background.Color= 79741120
//		this.Object.gyul_method.Background.Color= 79741120
//		this.Object.send_bank.Background.Color= 79741120
//		this.Object.send_dep.Background.Color= 79741120
//		this.Object.send_nm.Background.Color= 79741120
      return 1		
	END IF

elseif this.GetColumnName() = "gyul_date" Then
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then
		return
	end if	
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[����������]")
		this.object.gyul_date[1] = ""
		return 1
	end if
	
elseif this.GetColumnName() = "send_dep" Then
	
	s_cod = Trim(GetText())	
	s_cod1 = getitemstring(1, "saccod")
   sacc1 = left(s_cod1, 5)
   sacc2 = mid(s_cod1, 6, 2)
	
   SELECT GBN1
	  INTO :get_gbn1
	  FROM KFZ01OM0  
	 WHERE ACC1_CD = :sacc1 AND  ACC2_CD =  :sacc2  ;	

	
	if get_gbn1 = '5' then
		SELECT "KFM04OT0"."AB_NAME"
		  INTO :s_nam1
			FROM "KFM04OT0"  
		 WHERE "KFM04OT0"."AB_NO" = :s_cod ;
	Elseif get_gbn1 = '6' then
		SELECT "KFM03OT0"."LO_NAME"
		  INTO :s_nam1
			FROM "KFM03OT0"  
		 WHERE "KFM03OT0"."LO_CD" = :s_cod ;		
	else
		sqlca.sqlcode = -1
	End if
	
	IF Sqlca.SqlCode <> 0 THEN
		MessageBox('Ȯ��', '��ϵ��� ���� �ڵ� �Դϴ�!')
		SetItem(1, 'send_dep', '')
		SetItem(1, 'send_bank', '')
		Return 1
	END IF
	SetItem(1, 'send_bank', s_nam1)
END IF

IF GetColumnName() = 'depotno' THEN
	s_cod = Trim(GetText())
	  SELECT COUNT(*)
	  	 INTO	:li_cnt
		 FROM "KFM04OT0"  
		WHERE "KFM04OT0"."AB_DPNO" = :s_cod ;
		
		IF li_cnt <= 0 THEN
			MessageBox('Ȯ��', '��ϵ��� ���� �������ڵ� �Դϴ�!')
			SetItem(1, 'depotno', '')
			Return 1
		END IF

END IF
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_gubun)

String s_cod, sacc1, sacc2, get_gbn1

IF GetColumnName() = 'depotno' THEN
	
	s_cod = getitemstring(1, "saccod")
   sacc1 = left(s_cod, 5)
   sacc2 = mid(s_cod, 6, 2)
	
   SELECT GBN1
	  INTO :get_gbn1
	  FROM KFZ01OM0  
	 WHERE ACC1_CD = :sacc1 AND  ACC2_CD =  :sacc2  ;	
	
	if get_gbn1 = '5' then
		open(w_kfm04ot0_popup)
	Else
		open(w_kfm03ot0_popup)		
	End if
	
	IF get_gbn1 = '5' then
		IF gs_gubun = '' OR IsNull(gs_gubun) THEN	
			Return
		End if
	End if
	
	SetItem(1, 'depotno', gs_code)

END IF

IF GetColumnName() = 'send_dep' THEN
	open(w_kfm04ot0_popup)
	
	IF gs_gubun = '' OR IsNull(gs_gubun) THEN	Return
	
	SetItem(1, 'send_dep', gs_gubun)
	
	TriggerEvent(itemchanged!)
	
END IF
end event

type pb_2 from u_pb_cal within w_imt_03080
integer x = 1234
integer y = 216
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'to_date', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_03080
integer x = 791
integer y = 216
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'fr_date', gs_code)



end event

type pb_3 from u_pb_cal within w_imt_03080
integer x = 791
integer y = 304
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('f_jdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'f_jdate', gs_code)



end event

type pb_4 from u_pb_cal within w_imt_03080
integer x = 1234
integer y = 304
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('t_jdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 't_jdate', gs_code)



end event

type pb_5 from u_pb_cal within w_imt_03080
integer x = 2683
integer y = 600
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_3.SetColumn('gyul_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_3.GetRow()
If ll_row < 1 Then Return
dw_3.SetItem(ll_row, 'gyul_date', gs_code)



end event

type rr_2 from roundrectangle within w_imt_03080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 32
integer width = 937
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

