$PBExportHeader$w_pdt_02030_9.srw
$PBExportComments$�۾����ý� �������� ȭ��(MULTI)
forward
global type w_pdt_02030_9 from window
end type
type dw_3 from datawindow within w_pdt_02030_9
end type
type dw_2 from u_key_enter within w_pdt_02030_9
end type
type p_inq from uo_picture within w_pdt_02030_9
end type
type p_1 from uo_picture within w_pdt_02030_9
end type
type p_addrow from uo_picture within w_pdt_02030_9
end type
type p_4 from uo_picture within w_pdt_02030_9
end type
type p_3 from uo_picture within w_pdt_02030_9
end type
type dw_1 from datawindow within w_pdt_02030_9
end type
type rr_1 from roundrectangle within w_pdt_02030_9
end type
type rr_2 from roundrectangle within w_pdt_02030_9
end type
end forward

global type w_pdt_02030_9 from window
integer x = 142
integer y = 868
integer width = 3749
integer height = 1436
boolean titlebar = true
string title = "ǰ�� �߰�"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_3 dw_3
dw_2 dw_2
p_inq p_inq
p_1 p_1
p_addrow p_addrow
p_4 p_4
p_3 p_3
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02030_9 w_pdt_02030_9

type variables
string is_sysno, is_pordno, is_uptgbn, is_pdtgu, is_jdate
end variables

forward prototypes
public function integer wf_check (ref string scolumn)
public subroutine wf_item_check (long arg_row, string arg_itnbr, string arg_spspec, string arg_opseq)
public function integer wf_convert_qty (string arg_itnbr, decimal arg_qty, string arg_gubun)
end prototypes

public function integer wf_check (ref string scolumn);string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, scvcod, sopseq, spordno, stoday, sopcode
integer  ireturn
Decimal  {5} dunprc
long     lfind, lrow, ix

sToday = f_today()

if dw_1.accepttext() = -1 then return -1
if dw_2.accepttext() = -1 then return -1
If dw_1.RowCount() <= 0 Then Return -1

setnull(snull)

spordno = dw_1.getitemstring(1, "morout_copy_pordno")

For ix = 1 To dw_1.RowCount()
	/* �����ڵ� */
	sopcode = dw_1.getitemstring(ix, "morout_copy_opseq")
	if isnull(sopcode) or trim(sopcode) = '' then
		f_message_chk(30,'[��������]') 
		dw_1.setitem(ix, "morout_copy_opseq", '')
		scolumn = "morout_copy_opseq"
		RETURN  -1
	end if

	/* ������ */
	sopcode = dw_1.getitemstring(ix, "morout_copy_opdsc")
	if isnull(sopcode) or trim(sopcode) = '' then
		f_message_chk(30,'[������]') 
		dw_1.setitem(ix, "morout_copy_opdsc", '')
		scolumn = "morout_copy_opdsc"
		RETURN  -1
	end if

	/* �۾��ڵ� */
	sopcode = dw_1.getitemstring(ix, "morout_copy_roslt")
//	if isnull(sopcode) or trim(sopcode) = '' then
//		f_message_chk(30,'[�����ڵ�]') 
//		dw_1.setitem(ix, "morout_copy_roslt", '')
//		scolumn = "morout_copy_roslt"
//		RETURN  -1
//	end if

	/* �˻籸�� */
	sopcode = dw_1.getitemstring(ix, "morout_copy_qcgub")
	if isnull(sopcode) or trim(sopcode) = '' then
		f_message_chk(30,'[�˻籸��]') 
		dw_1.setitem(ix, "morout_copy_qcgub", '')
		scolumn = "morout_copy_qcgub"
		RETURN  -1
	end if

	/* �ð������� */
	sopcode = dw_1.getitemstring(ix, "morout_copy_esgbn")
	if isnull(sopcode) or trim(sopcode) = '' then
		f_message_chk(30,'[�ð�������]') 
		dw_1.setitem(ix, "morout_copy_esgbn", '')
		scolumn = "morout_copy_esgbn"
		RETURN  -1
	end if

///* ���������*/
//sreff = dw_1.getitemstring(1, "morout_copy_esdat")
//dw_1.setitem(1, "morout_copy_fsdat", sreff)		
//dw_1.setitem(1, "morout_copy_system_str_date", sreff)
//if isnull(sreff) or trim(sreff) = '' or f_datechk(sreff) = -1 then
//	f_message_chk(35,'[���������(1)]') 
//	dw_1.setitem(1, "morout_copy_esdat", '')
//	dw_1.setitem(1, "morout_copy_fsdat", '')
//	dw_1.setitem(1, "morout_copy_system_str_date", '')	
//	scolumn = "morout_copy_esdat"
//	RETURN  -1
//end if
//
///* ���������� */
//sreff1 = dw_1.getitemstring(1, "morout_copy_eedat")	
//dw_1.setitem(1, "morout_copy_fedat", sreff1)
//dw_1.setitem(1, "morout_copy_system_end_date", sreff1)
//if isnull(sreff1) or trim(sreff1) = '' or f_datechk(sreff1) = -1 then
//	f_message_chk(35,'[����������(2)]') 
//	dw_1.setitem(1, "morout_copy_eedat", '')
//	dw_1.setitem(1, "morout_copy_fedat", '')		
//	dw_1.setitem(1, "morout_copy_system_end_date", '')
//	scolumn = "morout_copy_eedat"			
//	RETURN  -1			
//end if
//
//if sreff > sreff1 then
//	f_message_chk(35,'[����������(3)]') 
//	dw_1.setitem(1, "morout_copy_eedat", '')
//	dw_1.setitem(1, "morout_copy_fedat", '')
//	scolumn = "morout_copy_eedat"
//	RETURN  -1			
//end if
//
/* �۾��� */
	ireturn = 0
	sreff = dw_1.getitemstring(ix, "morout_copy_wkctr")
	select a.wkctr, a.wcdsc, b.jocod, b.jonam
	  into :sitnbr, :sreff, :sitdsc, :sispec
	  from wrkctr a, jomast b
	 where a.wkctr = :sreff and a.jocod = b.jocod (+);
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[�۾���]')
		setnull(sreff)		
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = -1
	end if
	if not isnull(sreff)  and isnull(sitdsc) then
		f_message_chk(91,'[��]')
		setnull(sreff)
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = -1
	end if
	dw_1.setitem(ix, "morout_copy_wkctr", sitnbr)
	dw_1.setitem(ix, "wrkctr_wcdsc", sreff)
	dw_1.setitem(ix, "morout_copy_jocod", sitdsc)
	dw_1.setitem(ix, "jomast_jonam", sispec)
	if ireturn = -1 then
		scolumn = "morout_copy_wkctr"
		return -1
	end if

	/* ���� */
	ireturn = 0
	sreff = dw_1.getitemstring(ix, "morout_copy_mchcod")
	if not isnull(sreff) then
		select mchnam
		  into :sreff1
		  from mchmst
		 where sabu = :gs_sabu and mchno = :sreff;
		if sqlca.sqlcode <> 0 then
			f_message_chk(92,'[����]')
			setnull(sreff)
			setnull(sreff1)		
			ireturn = -1
		end if
		dw_1.setitem(ix, "mchmst_mchnam", sreff1)
		if ireturn = -1 then
			scolumn = "morout_copy_mchcod"
			return -1
		end if
	end if
	
	/* �������� */
	sreff = dw_1.getitemstring(ix, "morout_copy_purgc")
	if sreff = 'Y' then
		Setnull(sCvcod)
		scvcod = dw_1.getitemstring(ix, "morout_copy_wicvcod")
		sopseq = dw_1.getitemstring(ix, "morout_copy_opseq")
		ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1�̸� ����, 0�� ����	
		if ireturn = 0 then
			sitnbr = dw_1.getitemstring(ix, "morout_copy_itnbr")
			
			select unprc into :dunprc from danmst
				 where itnbr = :sitnbr and cvcod = :scvcod and opseq = :sopseq;
				 
			 if sqlca.sqlcode <> 0 then
				 f_message_chk(82,'[ ' + sitdsc + ' ]')
			 end if
		end if	
		dw_1.setitem(ix, "morout_copy_wicvcod", scvcod)	
		dw_1.setitem(ix, "vndmst_cvnas2",  sitdsc)
		if ireturn  = 1 then
			f_message_chk(30,'[���ְŷ�ó]')
			scolumn = "morout_copy_wicvcod"
			RETURN -1
		end if
		
	//	if dw_1.getitemdecimal(ix, "morout_copy_wiunprc") < 1 then
	//		f_message_chk(80,'[���ִܰ�]') 
	//		scolumn = "morout_copy_wiunprc"
	//		RETURN  -1	
	//	end if	
		
	end if

	/* �۾�����ð� */
	dunprc = dw_1.getitemdecimal(ix, "morout_copy_estim")
	if dunprc < 0 then
		f_message_chk(93,'[�۾�����ð�]') 
		scolumn = "morout_copy_estim"
		RETURN  -1
	end if
Next

// �������� �� ������ �� �İ��� ����(�� �����߰��� ��쿡�� �Է�),
dw_1.SetSort("morout_copy_opseq")
dw_1.Sort()

if dw_1.rowcount() > 1 then
	For Lrow = 1 to dw_1.rowcount()
		
		 // ��������
		 if Lrow = 1 then
			 dw_1.setitem(Lrow, "morout_copy_lastc", '1')
		 Elseif Lrow = dw_1.rowcount() then
			 dw_1.setitem(Lrow, "morout_copy_lastc", '3')
		 Else
			 dw_1.setitem(Lrow, "morout_copy_lastc", '0')
		 End if
		
		 //������ ���� check
		 dw_1.setitem(Lrow - 1, "morout_copy_de_opseq", dw_1.getitemstring(Lrow, "morout_copy_opseq"))		 
		 if Lrow = dw_1.rowcount() then
			 dw_1.setitem(Lrow, 		"morout_copy_de_opseq", snull)
		 End if	

		 //������ ���� check
		 if Lrow = 1 then 
			 dw_1.setitem(Lrow, "morout_copy_pr_opseq", '0000')
		 Else
			 dw_1.setitem(Lrow, "morout_copy_pr_opseq", dw_1.getitemstring(Lrow - 1, "morout_copy_opseq"))
		 End if
	Next
else
	dw_1.setitem(1, "morout_copy_lastc", '9')	
	dw_1.setitem(1, "morout_copy_pr_opseq", '0000')	
	dw_1.setitem(1, "morout_copy_de_opseq", snull)	
end if

if dw_2.update(true,false) = 1 then
	if dw_1.update(true,false) = 1 then
	Else
		Rollback;
		Messagebox("��������", "�������忡 �����Ͽ����ϴ�", stopsign!)
		return -1
	end if
else
	Rollback;
	Messagebox("��������", "�������忡 �����Ͽ����ϴ�", stopsign!)
	return -1
end if

return 1
end function

public subroutine wf_item_check (long arg_row, string arg_itnbr, string arg_spspec, string arg_opseq);/* ǰ�񸶽��͸� check�Ͽ� ����(�������� = '6')�� ��쿡�� �۾����ø� �⺻���� setting */
String sitgu, spurgc, sittyp, sipchango, snull, sDitnbr, srtnbr 
String ls_saupj, sunmsr, sPdtgu

Select itgu, ittyp, unmsr into :sitgu, :sittyp, :sunmsr
  from itemas 
 where itnbr = :arg_itnbr;
 
/* ������ ��� ���ַ� setting */
if sitgu 	= '6' then
	spurgc	= 'Y'
else
	spurgc	= 'N'
end if

ls_saupj	= gs_saupj
sPdtgu   = is_pdtgu

Setnull(snull)

/* �ŷ�ó�� ���ܰ��� ���� */
String scvcod, sTuncu, scvnas
decimal {3} dUnprc

if spurgc = 'Y' then
	f_buy_unprc(arg_itnbr, arg_spspec, arg_opseq, scvcod, scvnas, dUnprc, sTuncu)
	dw_2.setitem(arg_row, "momast_copy_cvcod",  scvcod)
	dw_2.setitem(arg_row, "vndmst_cvnas2", scvnas)
	dw_2.setitem(arg_row, "momast_copy_unprc",  dUnprc)	
	dw_2.setitem(arg_row, "momast_copy_routct",  'N')	
	
Else
	dw_2.setitem(arg_row, "momast_copy_cvcod",  snull)
	dw_2.setitem(arg_row, "vndmst_cvnas2", snull)
	dw_2.setitem(arg_row, "momast_copy_unprc",  0)	
	dw_2.setitem(arg_row, "momast_copy_routct",  'Y')
end if

dw_2.setitem(arg_row, "itemas_unmsr", sunmsr)
dw_2.setitem(arg_row, "momast_copy_purgc", spurgc)

dw_2.setitem(arg_row, "momast_copy_pdprc", sqlca.fun_erp100000012(f_today(), arg_itnbr, '.'))	/* ����⺻�ܰ� ���� */

/* â�� �⺻���� SETTING�ϰ� ����ڰ� ���� */
/* â��� ����ǰ, ����ǰ�� ��� ù��° â�� �����Ѵ� */
if sIttyp = '1' Or sIttyp = '8' then
	Select Min(cvcod) Into :sIpchango from Vndmst where cvgu = '5' and juprod = '1' and ipjogun = :ls_saupj ;
elseif sittyp = '2' then
	//Select Min(cvcod) Into :sIpchango from Vndmst where cvgu = '5' and juprod = '2' and jumaechul = '2' and jumaeip = :sPdtgu;
	Select Min(cvcod) Into :sIpchango from Vndmst where cvgu = '5' and juprod = '2' and jumaechul = '1' and jumaeip = :spdtgu and ipjogun = :ls_saupj; // ����â��
end if
dw_2.setitem(arg_row, "momast_copy_ipchango", sIpchango)

Long lcnt
Lcnt = 0
Select count(*) Into :lcnt from pstruc_pdt
 Where pdtgu = :is_pdtgu and pinbr = :arg_itnbr;
 
if Isnull(Lcnt) or Lcnt < 1 then
	Select stdnbr Into :sDitnbr From itemas
	 Where itnbr = :arg_Itnbr;

	/* ��ǥǰ���� ���� BOM �˻� */
	Lcnt = 0
	Select count(*) Into :lcnt from pstruc_pdt
	 Where pdtgu = :is_pdtgu and pinbr = :sDitnbr;
	sRtnbr = sDitnbr
Else
	sRtnbr = arg_itnbr
end if

if isnull(sRtnbr) or trim(sRtnbr) = '' then sRtnbr = arg_itnbr

dw_2.setitem(arg_row, "momast_copy_stditnbr", arg_itnbr)


end subroutine

public function integer wf_convert_qty (string arg_itnbr, decimal arg_qty, string arg_gubun);// arg_gubun = 'M' : m  -> ��
// arg_gubun = 'Q' : �� -> M
Dec dstdqty, dvalue
String sPdtgu

sPdtgu = is_pdtgu

SELECT MAX(STDQTY) INTO :dstdqty FROM PSTRUC_PDT WHERE PDTGU = :spdtgu AND PINBR = :arg_itnbr;
If IsNull(dstdqty) Or dstdqty = 0 Then dstdqty = 1

If arg_gubun = 'M' Then
	dValue = Truncate(arg_qty * dstdqty,0)
Else
	dValue = Truncate(arg_qty / dstdqty,0)
End If

Return dValue
end function

on w_pdt_02030_9.create
this.dw_3=create dw_3
this.dw_2=create dw_2
this.p_inq=create p_inq
this.p_1=create p_1
this.p_addrow=create p_addrow
this.p_4=create p_4
this.p_3=create p_3
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.dw_3,&
this.dw_2,&
this.p_inq,&
this.p_1,&
this.p_addrow,&
this.p_4,&
this.p_3,&
this.dw_1,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_02030_9.destroy
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.p_inq)
destroy(this.p_1)
destroy(this.p_addrow)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;f_window_center_response(this)

Long Lrow

is_sysno  = gs_codename
is_pordno = gs_code
is_pdtgu  = gs_gubun
is_jdate  = gs_codename2
If f_datechk(is_jdate) <> 1 Then
	is_jdate = f_today()
End If

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

Lrow = dw_2.InsertRow(0)
dw_2.setitem(Lrow, "momast_copy_sabu",   gs_sabu)
dw_2.setitem(Lrow, "momast_copy_pordno", is_pordno)
dw_2.setitem(Lrow, "momast_copy_pdsts",  '1')
dw_2.setitem(Lrow, "momast_copy_purgc",  'N')
dw_2.setitem(Lrow, "pagbn", 'N')
dw_2.setitem(Lrow, "momast_copy_master_no", is_sysno)
dw_2.setitem(Lrow, "momast_copy_matchk", '2')
dw_2.SetItem(Lrow, 'momast_copy_mocnt', 0)

dw_2.setitem(Lrow, "momast_copy_jidat",  is_jdate)
dw_2.setitem(Lrow, "momast_copy_esdat",  is_jdate)
dw_2.setitem(Lrow, "momast_copy_eedat",  is_jdate)
dw_2.setitem(Lrow, "momast_copy_fsdat",  is_jdate)
dw_2.setitem(Lrow, "momast_copy_fedat",  is_jdate)
dw_2.setitem(Lrow, "momast_copy_system_end_date",  is_jdate)
dw_2.setitem(Lrow, "momast_copy_system_str_date",  is_jdate)

end event

type dw_3 from datawindow within w_pdt_02030_9
boolean visible = false
integer x = 46
integer y = 8
integer width = 1445
integer height = 164
integer taborder = 10
string title = "none"
string dataobject = "d_pdt_02030_9c"
boolean border = false
boolean livescroll = true
end type

type dw_2 from u_key_enter within w_pdt_02030_9
integer x = 50
integer y = 192
integer width = 3643
integer height = 224
integer taborder = 10
string dataobject = "d_pdt_02030_9b"
boolean border = false
end type

event itemchanged;call super::itemchanged;String usechk,sitnbr, sitdsc, sispec, sjijil, sispec_code, ls_pspec, sporgu
String scvcod, snull, sreff
Long   lrow
Int    ireturn

lrow = GetRow()
If lrow <= 0 Then Return

SetNull(sNull)

Choose Case  Getcolumnname()
	Case 	"momast_copy_itnbr"	
		sItnbr = trim(GetText())

		Select useyn  into :usechk
		  From itemas
		 where itnbr = :sItnbr
		 using sqlca;
			 if sqlca.sqlcode = 0 and (usechk = '1' or usechk = '2' ) then
				 f_message_chk(53,'[������� �� ����]') 
				 setitem(lrow, "momast_copy_itnbr", '')	
				 SetColumn("momast_copy_itnbr")
				 SetFocus()
				 Return 1
			 else
				ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
				setitem(lrow, "momast_copy_itnbr", sitnbr)	
				setitem(lrow, "itemas_itdsc", sitdsc)	
				setitem(lrow, "itemas_ispec", sispec)
				setitem(lrow, "itemas_jijil", sjijil)	
				
				setitem(lrow, "momast_copy_pdtgu", is_Pdtgu)
				
				wf_item_check(lrow, sitnbr, ls_pspec ,'9999')
				RETURN ireturn
			 end if
	Case "momast_copy_porgu" 
		sporgu = Trim(GetText())
		If sPorgu = '12' Or sPorgu = '20' Then
		Else
			f_message_chk(79,'[�۾����ñ���]') 
			Return 1
		End If
	/* ���� */
	Case 'momast_copy_custno'
  	  sCvcod = this.GetText()
	  IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(lrow,"custnm",sNull)
			Return 
		End If
	
	  SELECT "VNDMST"."CVNAS2"		INTO :sreff
		 FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" =:sCvcod ;
		
	 IF SQLCA.SQLCODE = 0 THEN				
		 SetItem(lrow,"custnm",sreff)
		 SetFocus()
	 Else
		 f_message_chk(33,'')
		 SetItem(lrow,"custnm",sNull)
		 Return 1
	 END IF
	// ���ü���(m)
	Case 	"momast_copy_pdmqty"
		if dec(gettext()) < 1 then
			f_message_chk(78,'[���ü���]') 
			setitem(Lrow, "momast_copy_pdmqty", 0)
			RETURN  1
		end if
		
		SetItem(Lrow, 'momast_copy_pdqty', wf_convert_qty(GetItemString(Lrow, 'momast_copy_itnbr'), Dec(GetText()), 'M'))
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;String colname
Long   lrow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

colname = this.getcolumnname()
lrow	  = this.getrow()
if this.accepttext() = -1 then return

if colname = "momast_copy_itnbr" or colname = "itemas_itdcs" or colname = "itemas_ispec" then
   gs_code = this.getitemstring(lrow, "momast_copy_itnbr")
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(lrow,"momast_copy_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif colname = "momast_copy_custno" then
	OPEN(W_VNDMST_POPUP)
	If IsNull(gs_code) Then Return
	
	SetItem(lrow,"momast_copy_custno",gs_code)
	SetItem(lrow,"custnm",gs_codename)
end if

end event

type p_inq from uo_picture within w_pdt_02030_9
integer x = 2770
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\��ȸ_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\��ȸ_up.gif'
end event

event clicked;call super::clicked;string sitnbr
Long   nRow, lRow, ix
Dec    dPdqty, dTbcqt, dInwon

If dw_2.AcceptText() <> 1 Then Return

nRow = dw_2.GetRow()
If nRow <= 0 Then Return

sItnbr = Trim(dw_2.GetItemString(nRow, 'momast_copy_itnbr'))
If IsNull(sItnbr) Or sItnbr = '' Then
	f_message_chk(1400,'[ǰ��]')
	Return
End If

dPdqty = dw_2.GetItemNumber(nRow, 'momast_copy_pdqty')
If dPdqty <= 0 Then
	f_message_chk(1400,'[���ü���]')
	Return
End If

If dw_3.Retrieve(sItnbr) <= 0 Then
	MessageBox('Ȯ��','������ ��ϵ��� �ʾҽ��ϴ�.!!')
	Return
End If

dw_1.Reset()
For ix = 1 To dw_3.RowCount()
	lrow = dw_1.InsertRow(0)

	dw_1.setitem(lrow, "morout_copy_sabu", 		gs_sabu)
	dw_1.setitem(lrow, "morout_copy_pordno", 		is_pordno)
	dw_1.setitem(lrow, "morout_copy_itnbr", 		sItnbr)
	dw_1.setitem(lrow, "morout_copy_pspec", 		'.')
	dw_1.setitem(lrow, "morout_copy_pdqty", 		dpdqty)
	dw_1.setitem(lrow, "morout_copy_master_no",	is_sysno)	

	dw_1.SetItem(lrow, 'morout_copy_opseq', dw_3.GetItemString(ix, 'opseq'))
	dw_1.SetItem(lrow, 'morout_copy_opdsc', dw_3.GetItemString(ix, 'opdsc'))
	dw_1.SetItem(lrow, 'morout_copy_roslt', dw_3.GetItemString(ix, 'roslt'))
	dw_1.SetItem(lrow, 'morout_copy_esgbn', dw_3.GetItemString(ix, 'wrkctr_basic'))
	dw_1.SetItem(lrow, 'morout_copy_esset', 0)
	dw_1.SetItem(lrow, 'morout_copy_stdmn', 0)
	
	// �ð����ؼ���
	dTbcqt = dw_3.GetItemNumber(ix, 'tbcqt')
	dInwon = dw_3.GetItemNumber(ix, 'inwon')
	If IsNull(dTbcqt) Or dTbcqt = 0 Then dTbcqt = 1
	If IsNull(dInwon) Or dInwon = 0 Then dInwon = 1
	
	dw_1.SetItem(lrow, 'morout_copy_esinw', dInwon )
	dw_1.SetItem(lrow, 'morout_copy_esmch', dw_3.GetItemNumber(ix, 'mchr')* dpdqty/dTbcqt/60 )
	dw_1.SetItem(lrow, 'morout_copy_esman', dw_3.GetItemNumber(ix, 'manhr')* dpdqty/dTbcqt/60 * dInwon)
	dw_1.SetItem(lrow, 'manhr', dw_3.GetItemNumber(ix, 'manhr')* dpdqty/dTbcqt/60 )
	
	dw_1.SetItem(lrow, 'morout_copy_estim', dw_1.GetItemNumber(lrow, 'morout_copy_esmch') + dw_1.GetItemNumber(lrow, 'morout_copy_esman') )
	
	dw_1.SetItem(lrow, 'morout_copy_qcgub', dw_3.GetItemString(ix, 'qcgub'))
	dw_1.SetItem(lrow, 'morout_copy_wkctr', dw_3.GetItemString(ix, 'wkctr'))
	dw_1.SetItem(lrow, 'morout_copy_jocod', dw_3.GetItemString(ix, 'jocod'))
	dw_1.SetItem(lrow, 'wrkctr_wcdsc',      dw_3.GetItemString(ix, 'wrkctr_wcdsc'))
	dw_1.SetItem(lrow, 'jomast_jonam', 		 dw_3.GetItemString(ix, 'jomast_jonam'))
	dw_1.setitem(lrow, "morout_copy_mogub",		'Y')
	dw_1.setitem(lrow, "morout_copy_moseq",		10)
	
	dw_1.setitem(lrow, "morout_copy_esdat", is_jdate)
	dw_1.setitem(lrow, "morout_copy_eedat", is_jdate)
	dw_1.setitem(lrow, "morout_copy_fsdat", is_jdate)
	dw_1.setitem(lrow, "morout_copy_fedat", is_jdate)
	dw_1.setitem(lrow, "morout_copy_system_str_date", is_jdate)
	dw_1.setitem(lrow, "morout_copy_system_end_date", is_jdate)
Next
end event

type p_1 from uo_picture within w_pdt_02030_9
integer x = 3150
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\�����_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event clicked;call super::clicked;Long nRow

If dw_1.AcceptText() <> 1 Then Return

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

dw_1.deleterow(nRow)
end event

type p_addrow from uo_picture within w_pdt_02030_9
integer x = 2971
integer y = 24
integer width = 178
string picturename = "C:\erpman\image\���߰�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���߰�_up.gif"
end event

event clicked;call super::clicked;String sitnbr, spspec, smaster_no
Dec    dpdqty
Long nRow 

If dw_2.AcceptText() <> 1 Then Return

nRow = dw_2.GetRow()
If nRow <= 0 Then Return

sItnbr = Trim(dw_2.GetItemString(nRow, 'momast_copy_itnbr'))
If IsNull(sItnbr) Or sItnbr = '' Then
	f_message_chk(1400,'[ǰ��]')
	Return
End If

dPdqty = dw_2.GetItemNumber(nRow, 'momast_copy_pdqty')
If dPdqty <= 0 Then
	f_message_chk(1400,'[���ü���]')
	Return
End If

nRow = dw_1.insertrow(0)	
	
dw_1.setitem(nRow, "morout_copy_sabu", 		gs_sabu)
dw_1.setitem(nRow, "morout_copy_pordno", 		is_pordno)
dw_1.setitem(nRow, "morout_copy_itnbr", 		sItnbr)
dw_1.setitem(nRow, "morout_copy_pspec", 		'.')
dw_1.setitem(nRow, "morout_copy_pdqty", 		dpdqty)
dw_1.setitem(nRow, "morout_copy_master_no",	is_sysno)
dw_1.setitem(nRow, "morout_copy_mogub",		'Y')
dw_1.setitem(nRow, "morout_copy_moseq",		10)

dw_1.setcolumn("morout_copy_opseq")
dw_1.setfocus()	
end event

type p_4 from uo_picture within w_pdt_02030_9
integer x = 3511
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;Closewithreturn(parent, 'N')
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\���_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

type p_3 from uo_picture within w_pdt_02030_9
integer x = 3323
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;if dw_1.accepttext() = -1 then return

string scolumn

if wf_check(scolumn) = -1 then
//	dw_1.setcolumn(scolumn)
	dw_1.setfocus()
	return
else
	Commit;
	
	/* �۾����� ��� ���� -�Ҵ� �����ϱ� ����... */
	update momast_head_copy set calc4 = 'Y' where sabu = :gs_sabu and master_no = :is_sysno;
	Commit;

	dw_2.ResetUpdate()
	dw_1.ResetUpdate()
	Closewithreturn(parent, 'Y')	
end if


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

type dw_1 from datawindow within w_pdt_02030_9
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 50
integer y = 452
integer width = 3643
integer height = 852
integer taborder = 10
string dataobject = "d_pdt_02030_9a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;if key  = keyf1! then
	this.triggerevent(rbuttondown!)
end if
end event

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, scvcod, sopseq, stoday, sPordno, stropseq, srtnggu, &
			sIogbn, sDptno, sOpdsc, sPurgc, stuncu, scvnas, sroslt, spropseq, sdeopseq, stimegu, sqcgub, sbasic, swkctr, swcdsc
long     lrow,  lcnt
integer  ireturn, dinwon
Decimal {5} dunprc, dstdst, dstdmc, dmanhr, dmchr, dpqty 
String   ls_pspec

setnull(snull)

lrow   = GetRow()
If lrow <= 0 Then Return

if accepttext() = -1 then
	Messagebox("�ڷ�Ȯ��", "�ڷ�Ȯ�ν� ���� �߻�", stopsign!)
	return 1
end if

if	 this.getcolumnname() = "morout_copy_opseq" then
		sopseq  = gettext()
		
		If Len(sopseq) <> 4 then
			MessageBox('Ȯ��','���������� 4�ڸ��Դϴ�.!!')
			Return 1
		End If
//		sitnbr  = getitemstring(lrow, "morout_copy_itnbr")
//		spordno = getitemstring(lrow, "morout_copy_pordno")
//		
//		// ������ ������ȣ�� �ִ� �� �˻�
//		Lcnt = 0
//		Select count(*) into :lcnt from morout_copy
//		 Where Sabu = :gs_sabu And pordno = :spordno And opseq = :sopseq;		
//		if Lcnt > 0 then
//			Messagebox("������ȣ", "������ ������ȣ�� �����մϴ�", stopsign!)
//			setitem(lrow, "morout_copy_opdsc", sopseq)
//			setitem(lrow, "morout_copy_opdsc", snull) 
//			setitem(lrow, "morout_copy_roslt", snull)	
//			setitem(lrow, "morout_copy_de_opseq", snull) 
//			setitem(lrow, "morout_copy_pr_opseq", snull)
//			return 1
//		end if
//		
//		// �������� �˻�
//		Select pdqty into :dpqty from momast_copy where sabu = :gs_sabu And pordno = :spordno;
//		if isnull( dpqty ) then dpqty = 0
//		
//		/* �ð����� ������ ȯ�漳������ �˻� (1:ǥ�ؽð�, 2:��սð�) */
//		select dataname
//		  into :stimegu
//		  from syscnfg
//		 where sysgu = 'Y' and serial = '15' and lineno = '3';
//		 
//		if isnull( stimegu ) or trim( stimegu ) = '' or ( stimegu <> '1' And stimegu <> '2' ) Then
//			stimegu = '2'
//		End if
//		
//		/* �������� ������ ȯ�漳������ �˻� (1:��������� ����, 2:��ü����)*/
//		select dataname
//		  into :srtnggu
//		  from syscnfg
//		 where sysgu = 'Y' and serial = '15' and lineno = '6';
//	
//		/* ���������� ����� ��쿡�� ������ϴ� ������ �ջ��Ѵ� */
//		if srtnggu = '1' then
//			select Max(decode(uptgu, 'Y', opseq, '')) into :stropseq
//			  from routng
//			 where itnbr = :sitnbr and opseq < :sopseq;
//		else
//			stropseq = sopseq
//		End if;
//		 
//		if isnull( stropseq ) then stropseq = '0000' 
//		
//		setnull(sopdsc)
//		setnull(sroslt)
//		Select a.opdsc, a.roslt, a.qcgub, b.wkctr, b.wcdsc, b.basic, 
//				 nvl(c.stdst, 0), nvl(c.stdmc, 0), nvl(c.manhr, 0), nvl(c.mchr, 0)		
//		  into :sopdsc, :sroslt, :sqcgub, :swkctr, :swcdsc, :sbasic, :dstdst, :dstdmc, :dmanhr, :dmchr 
//		  from routng a, wrkctr b,
//		  		(select nvl(sum(a.stdst), 0) as stdst, nvl(sum(a.stdmc), 0)   as stdmc,
//						  nvl(sum(decode(:stimegu, '1', a.manhr, a.manhr1)), 0) as manhr,
//				 		  nvl(sum(decode(:stimegu, '1', a.mchr,  a.mchr1)), 0)  as mchr
//				  	from routng a, wrkctr b
//				  Where a.itnbr = :sitnbr And a.opseq > :stropseq And a.opseq <= :sopseq
//		 			 and a.wkctr = b.wkctr) c
//		 Where a.itnbr = :sitnbr And a.opseq = :sopseq
//		 	and a.wkctr = b.wkctr;
//			 
//		if isnull( dstdst ) then dstdst = 0
//		if isnull( dstdmc ) then dstdmc = 0
//		if isnull( dmanhr ) then dmanhr = 0
//		if isnull( dmchr  ) then dmchr  = 0
//		
//		dmanhr = dmanhr * dpqty;
//		dmchr  = dmchr  * dpqty;
//		 
//		setitem(lrow, "morout_copy_opdsc", sopdsc) 
//		setitem(lrow, "morout_copy_roslt", sroslt)
//		setitem(lrow, "morout_copy_esinw", dstdmc)
//		setitem(lrow, "morout_copy_estim", dstdst + dmanhr + dmchr)
//		setitem(lrow, "morout_copy_esset", dstdst)
//		setitem(lrow, "morout_copy_esman", dmanhr)
//		setitem(lrow, "morout_copy_esmch", dmchr)		
//		setitem(lrow, "morout_copy_esgbn", sBasic)
//		setitem(lrow, "morout_copy_wkctr", swkctr)
//		setitem(lrow, "wrkctr_wcdsc", swcdsc)		
//		
//		// �Էµ� �����ڵ� ������ �������� �����ڵ带 �˻�
//		setnull(spropseq)
//		Select Max(opseq) into :spropseq From morout_copy
//		 Where Sabu = :gs_sabu And pordno = :spordno And opseq < :sopseq;
//		 
//		if isnull( spropseq ) then spropseq = '0000'
//		
//		// �Էµ� �����ڵ� ������ �������� �����ڵ带 �˻�
//		setnull(sdeopseq)
//		Select Min(opseq) into :sdeopseq From morout_copy
//		 Where Sabu = :gs_sabu And pordno = :spordno And opseq > :sopseq;
//		 
//		setitem(lrow, "morout_copy_de_opseq", sdeopseq) 
//		setitem(lrow, "morout_copy_pr_opseq", spropseq)	
	
Elseif this.getcolumnname() = "morout_copy_esdat" then
	if isnull(this.gettext()) or trim(this.gettext()) = '' then
		f_message_chk(35,'[���������]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		RETURN  1
	end if
	if f_datechk(this.gettext()) = -1 then
		f_message_chk(35,'[���������]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')		
		RETURN  1			
	end if
	this.setitem(lrow, "morout_copy_fsdat", this.gettext())
elseif this.getcolumnname() = "morout_copy_eedat" then
	if isnull(this.gettext()) or trim(this.gettext()) = '' then
		f_message_chk(35,'[����������]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_eedat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		this.setitem(lrow, "morout_copy_fedat", '')		
		RETURN  1			
	end if
	if f_datechk(this.gettext()) = -1 then
		f_message_chk(35,'[����������]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_eedat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		this.setitem(lrow, "morout_copy_fedat", '')		
		RETURN  1			
	end if
	if this.getitemstring(lrow, "morout_copy_esdat") > this.gettext() then
		f_message_chk(35,'[����������]') 
		this.setitem(lrow, "morout_copy_esdat", '')
		this.setitem(lrow, "morout_copy_eedat", '')
		this.setitem(lrow, "morout_copy_fsdat", '')
		this.setitem(lrow, "morout_copy_fedat", '')
		RETURN  1			
	end if
	this.setitem(lrow, "morout_copy_fedat", this.gettext())
elseif this.getcolumnname() = "morout_copy_wkctr" then
	ireturn = 0
	sreff = this.gettext()
	select a.wkctr, a.wcdsc, b.jocod, b.jonam
	  into :sitnbr, :sreff1, :sitdsc, :sispec
	  from wrkctr a, jomast b
	 where a.wkctr = :sreff and a.jocod = b.jocod (+);
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[�۾���]')
		setnull(sreff1)		
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	if not isnull(sreff1)  and isnull(sitdsc) then
		f_message_chk(91,'[��]')
		setnull(sreff1)
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	this.setitem(lrow, "morout_copy_wkctr", sitnbr)
	this.setitem(lrow, "wrkctr_wcdsc", sreff1)
	this.setitem(lrow, "morout_copy_jocod", sitdsc)
	this.setitem(lrow, "jomast_jonam", sispec)
	return ireturn
elseif this.getcolumnname() = "morout_copy_mchcod" then
	ireturn = 0
	sreff = this.getitemstring(lrow, "morout_copy_mchcod")
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[����]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = 1
	end if
	this.setitem(lrow, "mchmst_mchnam", sreff1)
	return ireturn	
elseif this.getcolumnname() = "morout_copy_purgc"  then	
	this.setitem(lrow, "morout_copy_wicvcod", '')
	this.setitem(lrow, "vndmst_cvnas2", '')
	this.setitem(lrow, "morout_copy_wiunprc", 0)
	
	sPordno = getitemstring(lrow, "morout_copy_pordno")
	sItnbr  = getitemstring(lrow, "morout_copy_itnbr")	
	sopseq  = getitemstring(lrow, "morout_copy_opseq")	
	sopdsc  = getitemstring(lrow, "morout_copy_opdsc")	
	sPurgc  = this.gettext()
	
	if sPurgc = 'N' then
		// ���ְ� �ƴ� ��쿡�� ���� ��� ������ �ڵ���� ������ Setting�Ѵ�.
		Select Iogbn Into :sIogbn from iomatrix where sabu = '1' and autpdt = 'Y';
		if sqlca.sqlcode <> 0 then
			Messagebox("�������", "�ڵ����� ���ұ����� �˻��� �� �����ϴ�", stopsign!)
			return 1
		end if
		
		select pdtgu into :sdptno from momast_copy
		 where sabu = :gs_sabu and pordno = :spordno;

		// 2001/05/11 �� �߰� ==> ����â�� �ֿ켱���� �߰� 
		select depot_no 
		  into :sCvcod
		  from routng
		 where itnbr = :sItnbr and opseq = :sopseq ;			
	
		if isnull(sCvcod) or sCvcod = '' then 
			select cvcod   into :sCvcod
			  from vndmst where cvgu = '5' and jumaeip = :sDptno and rownum = 1;
		end if
			
		Update Holdstock_copy
			Set out_store = :sCvcod,
				 Hold_gu	  = :sIogbn, 
				 out_chk	  = '1',
				 naougu	  = '1' 				 
		 Where sabu = :gs_sabu and Pordno = :sPordno and opseq = :sOpseq;
			
		Commit;	
		
	Else
			
		sitnbr 		= getitemstring(lrow, "morout_copy_itnbr")
		ls_pspec 	= getitemstring(lrow, "morout_copy_pspec")
		
		f_buy_unprc(sitnbr, ls_pspec, sopseq, scvcod, scvnas, dUnprc, sTuncu)				
		
		select cvcod, unprc into :sCvcod, :dUnprc from danmst
			 where itnbr = :sitnbr and opseq = :sopseq and sltcd = 'Y';
			 
		 if sqlca.sqlcode <> 0 then
	 		 f_message_chk(82,'[ ' + sOpdsc + ' ]')
		 end if
		 
		setitem(Lrow, "morout_copy_wicvcod", sCvcod)
		setitem(lrow, "morout_copy_wiunprc", dunprc)
		ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1�̸� ����, 0�� ����
		setitem(Lrow, "vndmst_cvnas2", sItdsc)		 
		
		// ������ ��쿡�� ���� ��� ������ ������� ������ Setting�Ѵ�.
		Select Iogbn Into :sIogbn from iomatrix where sabu = '1' and autvnd = 'Y';
		if sqlca.sqlcode <> 0 then
			Messagebox("������", "������� ���ұ����� �˻��� �� �����ϴ�", stopsign!)
			return 1
		end if
		Update Holdstock_copy
			Set out_store = :sCvcod,
				 Hold_gu	  = :sIogbn, 
				 out_chk	  = '2',
				 naougu	  = '2' 
		 Where sabu = :gs_sabu and Pordno = :sPordno and opseq = :sOpseq;
		Commit;		
		
	end if	
	
elseif this.getcolumnname() = "morout_copy_wicvcod"	then
	scvcod = this.getitemstring(lrow, "morout_copy_wicvcod")
	sopseq = this.getitemstring(lrow, "morout_copy_opseq")
	ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	if ireturn = 0 then
		sitnbr = getitemstring(lrow, "morout_copy_itnbr")
		select unprc into :dunprc from danmst
			 where itnbr = :sitnbr and cvcod = :scvcod and opseq = :sopseq and sltcd = 'Y';
		 if sqlca.sqlcode <> 0 then
	 		 f_message_chk(82,'[ ' + sitdsc + ' ]')
			 scvcod = ''
			 dunprc = 0
			 sitnbr = ''
			 sitdsc = ''
			 ireturn = 1
		 else
			 this.setitem(lrow, "morout_copy_wiunprc", dunprc)
		 end if
	end if	
	
	sPordno = getitemstring(Lrow, "morout_copy_pordno")
	sopseq  = getitemstring(lrow, "morout_copy_opseq")		
	
	// �Ҵ��� ����ó�� ����
	Update Holdstock_copy
		Set out_store = sCvcod
	 Where sabu = :gs_sabu and Pordno = :sPordno;
	Commit;			
	
	this.setitem(lrow, "morout_copy_wicvcod", scvcod)	
	this.setitem(lrow, "vndmst_cvnas2",  sitdsc)
   this.setitem(lrow, "morout_copy_wiunprc", dunprc)
	RETURN ireturn
elseif this.getcolumnname() = "morout_copy_wiunprc"  then
	if dec(this.gettext()) < 1 then
		f_message_chk(80,'[���ִܰ�]') 
		RETURN  1	
	end if	
elseif this.getcolumnname() = "morout_copy_esset"  then
	setitem(lrow, "morout_copy_estim", getitemdecimal(lrow, "morout_copy_esman") + getitemdecimal(lrow, "morout_copy_esmch") + dec(gettext()))
elseif this.getcolumnname() = "morout_copy_esman"  then
	setitem(lrow, "morout_copy_estim", getitemdecimal(lrow, "morout_copy_esset") + getitemdecimal(lrow, "morout_copy_esmch") + dec(gettext()))	
elseif this.getcolumnname() = "morout_copy_esmch"  then
	setitem(lrow, "morout_copy_estim", getitemdecimal(lrow, "morout_copy_esset") + getitemdecimal(lrow, "morout_copy_esman") + dec(gettext()))
elseif this.getcolumnname() = "morout_copy_roslt"  then
	sRoslt = Trim(GetText())
	
	select rfna1 into :sopdsc from reffpf where rfcod = '21' and rfgub = :sRoslt;
	setitem(lrow, 'morout_copy_opdsc', sopdsc)
// �����ο� ������
elseif this.getcolumnname() = "morout_copy_esinw"  then
	dinwon = Dec(GetText())
	
	SetItem(lrow, 'morout_copy_esman', GetItemNumber(lrow, 'manhr') * dinwon)	// Man Hour ���԰���
	SetItem(lrow, 'morout_copy_estim', GetItemNumber(lrow, 'manhr') * dinwon + GetItemNumber(lrow, 'morout_copy_esmch'))

end if
end event

event itemerror;return 1
end event

event rbuttondown;string colname
long   lrow

SETNULL(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

colname = this.getcolumnname()
lrow    = this.getrow()

if     colname = "morout_copy_mchcod" then
		 gs_code = this.gettext()
		 gs_gubun    = this.getitemstring(lrow, "morout_copy_wkctr")
		 gs_codename = this.getitemstring(lrow, "wrkctr_wcdsc")
		 open(w_mchmst_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_copy_mchcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_copy_wicvcod" then
		 gs_code = getitemstring(lrow, "morout_copy_itnbr")
		 gs_codename = this.getitemstring(lrow, "morout_copy_opseq")
		 open(w_danmst_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_copy_wicvcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_copy_wkctr" then
		 gs_code = this.gettext()
		 open(w_workplace_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "morout_copy_wkctr", gs_code)
		 this.triggerevent(itemchanged!)
end if


end event

type rr_1 from roundrectangle within w_pdt_02030_9
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 448
integer width = 3694
integer height = 872
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02030_9
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 176
integer width = 3694
integer height = 260
integer cornerheight = 40
integer cornerwidth = 55
end type

