$PBExportHeader$w_sal_06055.srw
$PBExportComments$���� ���� ȸ�� ����
forward
global type w_sal_06055 from w_inherite
end type
type gb_7 from groupbox within w_sal_06055
end type
type gb_6 from groupbox within w_sal_06055
end type
type gb_5 from groupbox within w_sal_06055
end type
type rb_1 from radiobutton within w_sal_06055
end type
type rb_2 from radiobutton within w_sal_06055
end type
type dw_ip from datawindow within w_sal_06055
end type
type cbx_1 from checkbox within w_sal_06055
end type
type dw_sunsu from u_d_select_sort within w_sal_06055
end type
type dw_negod from u_d_select_sort within w_sal_06055
end type
type dw_interface from u_key_enter within w_sal_06055
end type
type pb_1 from u_pb_cal within w_sal_06055
end type
type pb_2 from u_pb_cal within w_sal_06055
end type
type rr_1 from roundrectangle within w_sal_06055
end type
type rr_3 from roundrectangle within w_sal_06055
end type
end forward

global type w_sal_06055 from w_inherite
string title = "���� ���� ȸ�� ����"
gb_7 gb_7
gb_6 gb_6
gb_5 gb_5
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
cbx_1 cbx_1
dw_sunsu dw_sunsu
dw_negod dw_negod
dw_interface dw_interface
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_06055 w_sal_06055

type variables
String SaleConfirm
String       isNgno[]             // ���ó���� Nego��ȣ
int             iiNgseq  
end variables

forward prototypes
public function integer wf_check_nego (string arg_cino, string arg_cvcod, string arg_weight)
public function integer wf_ret_sunsu (integer row)
public function integer wf_check_nego_charge ()
public function integer wf_calc_move (string scino, integer ix)
end prototypes

public function integer wf_check_nego (string arg_cino, string arg_cvcod, string arg_weight);/* �� Nego������ �����ϸ� �ش� Nego No.�� �Է¹޴´� */
Double dSunSu, dMaxSeq, dCiamt, dCiWamt, dCiuamt, dSunsuWamt, dSunsuUamt
Double dNgAmt, dNgWamt, dNgUamt, dNgWrate, dNgUrate, weight
Long   ix, iy, nCnt, nRow
String sFrom, sTo, sNgno, sPino
DataStore ds3

iiNgseq = 0

/* �̼��� �ڷ�� �����Ѵ� */
nCnt = dw_sunsu.RowCount()
For ix = nCnt To 1 Step -1
	If dw_sunsu.GetItemString(ix, 'chk') <> 'Y' Then dw_sunsu.DeleteRow(ix)
Next

If dw_sunsu.RowCount() <= 0 Then Return -1

dw_negod.Reset()

/* Ci,Pi No�� ����ݾ�(Charge����)  ��ȸ */
ds3 = Create datastore
ds3.DataObject = 'd_sal_06050_ds3'
ds3.SetTransObject(sqlca)

ds3.Retrieve(gs_sabu, arg_cino)

/* ����ġ */
weight = Double(arg_weight)
If IsNull(weight) Then weight = 1

/* ������ �ʱ�ȭ */
dSunSu = 0
ix = 0

SetPointer(HourGlass!)

For iy = 1 To ds3.RowCount()
	/* ������� ���� */
	sPino		= Trim(ds3.GetItemString(iy, 'pino'))
	dCiamt	= ds3.GetItemNumber(iy, 'ciamt')
	dCiWamt	= ds3.GetItemNumber(iy, 'wamt')
	dCiuamt	= ds3.GetItemNumber(iy, 'uamt')
	
	If IsNull(dCiAmt)  Then dCiAmt = 0
	If IsNull(dCiWAmt) Then dCiWAmt = 0
	If IsNull(dCiUAmt) Then dCiUAmt = 0
	
	/* ����ó���� �������� �д´�. */
	DO WHILE true
		/* ó���� ������� ���� ��� Exit */
		If dCiAmt <= 0 Then Exit
		
		If dSunSu = 0 Then		
			ix += 1
			If ix > dw_sunsu.RowCount() Then Exit
			
			sNgno  	  = dw_sunsu.GetItemString(ix,'ngno')
			dSunSu 	  = dw_sunsu.GetItemNumber(ix,'sunsu')
			dSunSuwamt = dw_sunsu.GetItemNumber(ix,'sunsuwamt')
			dSunSuuamt = dw_sunsu.GetItemNumber(ix,'sunsuuamt')
		
			/* Nego ȯ�� */
			dNgWrate = dw_sunsu.GetItemNumber(ix,'wrate')
			dNgUrate = dw_sunsu.GetItemNumber(ix,'urate')
			If IsNull(dNgWrate) Or dNgWrate = 0 Then dNgWrate = 1
			If IsNull(dNgUrate) Or dNgUrate = 0 Then dNgUrate = 1
			
			/* Nego�� Max���� */
			Select nvl(max(ngseq),0) into :dMaxSeq
			  from expnegod
			 where sabu = :gs_sabu and
					 ngno = :sNgno;
		End If
	
		/* �����ݾ��� ������⺸�� Ŭ��� */
		If dSunsu > dCiAmt Then
			dNgAmt  = dCiAmt
			dNgWAmt = Truncate(Round((dCiAmt * dNgWrate)/weight,2),0)
			dNgUAmt = Truncate(Round((dCiAmt * dNgUrate)/weight,2),2)	
		Else
			dNgAmt  = dSunsu
			dNgWAmt = dSunsuWAmt
			dNgUAmt = dSunsuUAmt			
		End If
		
		/* ó���� �������� ���� */
		dSunSu     -= dNgAmt
		dSunSuWAmt -= dNgWAmt
		dSunSuUAmt -= dNgUAmt

		/* ó���� ������� ���� */
		dCiAmt  = dCiAmt  - dNgAmt
		dCiWAmt = dCiWAmt - dNgWAmt
		dCiUAmt = dCiUAmt - dNgUAmt
		
		/* Nego Detail �ۼ� */
		dMaxSeq += 1
		
		nRow = dw_negod.InsertRow(0)
		dw_negod.SetItem(nRow, "SABU", gs_sabu)
		dw_negod.SetItem(nRow, "NGNO", sNgno)
      dw_negod.SetItem(nRow, "NGSEQ",dMaxSeq)
		dw_negod.SetItem(nRow, "CINO", arg_cino)
	   dw_negod.SetItem(nRow, "PINO", sPino)
		dw_negod.SetItem(nRow, "NGAMT",dNgAmt)
		dw_negod.SetItem(nRow, "WAMT",dNgWamt)
		dw_negod.SetItem(nRow, "UAMT",dNgUamt)
		dw_negod.SetItem(nRow, "DATAGU",'2')
		
		/* ó���� Nego��ȣ ��� */
		iiNgSeq += 1
		isNgNo[iiNgSeq] = sNgno
	LOOP
Next

Destroy ds3

If dw_negod.Update() <> 1 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	MessageBox('Ȯ ��','Nego�ڷ� ������ ������ �߻��߽��ϴ�!!')
	Return -1
End If

Return 0
end function

public function integer wf_ret_sunsu (integer row);String sCvcod, sSaupj, sCino
Double dCiAmt, dNgamt

sCvcod = dw_insert.GetItemString(row, 'cvcod')
sSaupj = dw_insert.GetItemString(row, 'saupj')
sCino  = dw_insert.GetItemString(row, 'cino')

/* ������ ��Ȳ ��ȸ */
If dw_sunsu.Retrieve(gs_sabu, sCvcod, sSaupj) > 0 Then
	cb_ins.Enabled = True
Else
	cb_ins.Enabled = False
End If

/* �⿬�� ������ ��Ȳ ��ȸ */
If dw_negod.Retrieve(gs_sabu, sCino) > 0 Then
	dCiamt = dw_insert.GetItemNumber(row, 'expamt')
	dNgamt = dw_negod.GetItemNumber(1, 'sum_ngamt')
	If dCiamt <= dNgamt Then	cb_ins.Enabled = False
	
	p_del.Enabled = True
Else
	p_del.Enabled = False
End If

return 1
end function

public function integer wf_check_nego_charge ();string sCostCd, sCostNo, sCurr, sNgdt, sCino, sPino, sNgno
Dec{2} dCostAmt,dCostForAmt,dCostAmtd,dCostForAmtd,dNgamt,dTotAmt
Dec{5} dDivRate
Dec{2} dSumAmtd,dSumForAmtd
Long   rCnt,iy, nCnt, ix, iz, iseq

/* Nego��Ͻ� ���Ǵ� ���� �� ��� dw ����Ѵ� */
DataStore ds1, ds2

//If iiNgSeq <= 0 Then Return 0

/* Invoice ���ó��� */
ds1 = Create datastore
ds1.DataObject = 'd_sal_06090_d'
If ds1.SetTransObject(sqlca) <> 1 Then Return -1

/* Nego��� ���� */
ds2 = Create datastore
ds2.DataObject = 'd_sal_06090_c'
If ds2.SetTransObject(sqlca) <> 1 Then Return -1

For iz = 1 To iiNgSeq
	sNgno = isNgNo[iz]
	
	/* ���͸� ������ �����( datagu = '1') */
	ds1.SetFilter("")
	ds1.Filter()
	
	/* Invoice ���ó��� ��ȸ */
	ds1.Retrieve(gs_sabu, sNgno)

	/* Nego��� ���� */
	If ds2.Retrieve(gs_sabu, sNgno) <= 0 Then Return 0
	
	/* ������ detail �ۼ� */
	For ix = 1 To ds2.RowCount()
		sCostNo = ds2.GetItemString(ix,'costno')
		iseq	  = ds2.getitemnumber(ix,'iseq')
		
		DELETE FROM EXPCOSTD	 WHERE SABU = :gs_sabu AND COSTNO = :sCostNo;
		If sqlca.sqlcode <> 0 Then
			f_message_chk(160,'')
			RollBack;
			Return -1
		End If
	
		/* ����� ���ݾ� */
		dCostAmt = ds2.GetItemNumber(ix,'costamt')
		dCostForAmt = ds2.GetItemNumber(ix,'costforamt')
	
		nCnt = ds1.RowCount()
		
		/* ����Ȯ���� nego �ݾ׸� ó����� : CI,PI No �Է�*/
		If nCnt > 0 Then
			dTotAmt = ds1.GetItemNumber(1,'sum_ngamt')
	 
			dSumAmtd = 0
			dSumForAmtd = 0
			For iy = 1 To nCnt
				/* Ci �� ������ �������� �ʴ´� */
				sCino = ds1.GetItemString(iy,'cino')
				sPino = ds1.GetItemString(iy,'pino')
				If IsNull(sCino) Or sCino = '' Then Continue
				
				/* ������ ����� ��� */
				dNgAmt = ds1.GetItemNumber(iy,'ngamt')
				If dTotAmt <> 0 Then dDivRate = dNgAmt / dTotAmt
				
				/*��е� ���ݾ� */
				dCostAmtd    = TrunCate(dCostAmt * dDivRate,0)
				dCostForAmtd = TrunCate(dCostForAmt * dDivRate,2)
				dSumAmtd += dCostAmtd
				dSumForAmtd += dCostForAmtd
			  
				/* ���� ó�� */
				If iy = nCnt Then
					dCostAmtd += TrunCate( dCostAmt - dSumAmtd ,0)
					dCostForAmtd += TrunCate( dCostForAmt - dSumForAmtd ,2)
				End If
		
				sPino = ds1.GetItemString(iy,'pino')
				INSERT INTO "EXPCOSTD"  
						 ( "SABU",           "COSTNO",          "ISEQ",			  "COSTSEQ",      "CINO",
							"PINO",           "COSTAMT",         "COSTVAT",      "COSTFORAMT",
							"NGNO" )  
				VALUES ( :gs_sabu,        :sCostNo,          :iseq,			  :iy,            :sCino,   
							:sPino,           :dCostamtd,        0,              :dCostForamtd,
							:sNgno )  ;
	
				If sqlca.sqlcode <> 0 Then
					f_message_chk(160,'')
					RollBack;
					Return -1
				End If
			Next
		Else
			/* ������ �������� ��� */
			INSERT INTO "EXPCOSTD"  
					 ( "SABU",           "COSTNO",          "ISEQ",			  "COSTSEQ",      "CINO",
						"PINO",           "COSTAMT",         "COSTVAT",      "COSTFORAMT",
						"NGNO" )  
			 VALUES ( :gs_sabu,        :sCostNo,          :iseq,			  1,            	NULL,   
						 NULL,          	:dCostAmt,         0,              :dCostForAmt,
						 :sNgno ) ;
			If sqlca.sqlcode <> 0 Then
				f_message_chk(160,'')
				RollBack;
				Return -1
			End If
		End If
	Next
Next

Destroy ds1
Destroy ds2

Return 0
end function

public function integer wf_calc_move (string scino, integer ix);Double dWeight, dMax
String sCurr, sSaupj
Dec {2} dWrate, dWamt, dUamt
Dec {4} dUrate

sCurr  = dw_insert.GetItemString(ix,"CURR")
sSaupj = dw_insert.GetItemString(ix,"saupj")

/* ����ġ */
Select to_number(rfna2) into :dWeight
  from reffpf
 where rfcod = '10' and
       rfgub = :sCurr;
If sqlca.sqlcode <> 0 Then Return -1

/* ����ȯ�� */
dWrate = dw_insert.GetItemNumber(ix,"export_wrate")
dUrate = dw_insert.GetItemNumber(ix,"export_urate")

/* ������� �ڵ���ǥ ���� */
update kif05ot0
	set wrate = :dWrate,
	    urate = :dUrate,
	    wamt = trunc((expamt * :dWrate)/:dweight,0),
		 uamt = trunc((expamt * :dWrate)/:dweight,2)
 where sabu  = :sSaupj and
		 cino  = :sCino;
		 
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),string(sqlca.sqlerrtext))
	RollBack;
	f_message_chk(32,'[������� �ڵ���ǥ]')
	Return -1
End If

/* ������� ǰ�� �ڵ���ǥ ���� */
update kif05ot1
	set wamt = trunc((ciamt * :dWrate)/:dweight,0),
		 uamt = trunc((ciamt * :dWrate)/:dweight,2)
 where sabu  = :sSaupj and
		 cino  = :sCino;
		 
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),string(sqlca.sqlerrtext))
	RollBack;
	f_message_chk(32,'[������� ǰ�� �ڵ���ǥ]')
	Return -1
End If

/* �������� ���� */
select nvl(a.wamt - sum(b.wamt),0),
       nvl(a.uamt - sum(b.uamt),0),
		 max(b.ciseq)
  into :dWamt, :dUamt, :dMax
  from kif05ot0 a, kif05ot1 b
 where a.sabu = b.sabu and
       a.cino = b.cino and
		 a.sabu = :sSaupj and
		 a.cino = :sCino
 group by a.wamt, a.uamt;
		 
update kif05ot1
	set wamt = wamt + nvl(:dWamt,0),
		 uamt = uamt + nvl(:dUamt,0)
 where sabu  = :sSaupj and
		 cino  = :sCino and
		 ciseq = :dMax;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),string(sqlca.sqlerrtext))
	RollBack;
	f_message_chk(32,'[������� �ڵ���ǥ ���� ����]')
	Return -1
End If

Return 0
end function

on w_sal_06055.create
int iCurrent
call super::create
this.gb_7=create gb_7
this.gb_6=create gb_6
this.gb_5=create gb_5
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.cbx_1=create cbx_1
this.dw_sunsu=create dw_sunsu
this.dw_negod=create dw_negod
this.dw_interface=create dw_interface
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_7
this.Control[iCurrent+2]=this.gb_6
this.Control[iCurrent+3]=this.gb_5
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.dw_ip
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.dw_sunsu
this.Control[iCurrent+9]=this.dw_negod
this.Control[iCurrent+10]=this.dw_interface
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.pb_2
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_3
end on

on w_sal_06055.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_7)
destroy(this.gb_6)
destroy(this.gb_5)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.cbx_1)
destroy(this.dw_sunsu)
destroy(this.dw_negod)
destroy(this.dw_interface)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)
dw_interface.SetTransObject(sqlca)
dw_sunsu.SetTransObject(sqlca)
dw_negod.SetTransObject(sqlca)

dw_ip.SetTransObject(sqlca)
f_child_saupj(dw_ip, 'sarea', gs_saupj)
dw_ip.InsertRow(0)


/* User�� ���ұ��� Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
End If

// �ΰ��� ����� ����
f_mod_saupj(dw_ip, 'saupj')

/* --------------------------------------------- */
/* ����Ȯ���� ���� (1:����,2:���,3:b/l,4:����)  */
/* --------------------------------------------- */
select substr(dataname,1,1) into :SaleConfirm
  from syscnfg
 where sysgu = 'S' and
       serial = 8 and
       lineno = 10;


dw_ip.SetItem(1, 'sdatef', Left(f_today(),6)+'01')
dw_ip.SetItem(1, 'sdatet', f_today())

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')

dw_interface.Visible = False
end event

type dw_insert from w_inherite`dw_insert within w_sal_06055
integer x = 59
integer y = 268
integer width = 4539
integer height = 2056
integer taborder = 40
string dataobject = "d_sal_06055_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;If row <= 0 Then Return

SelectRow(0,   FALSE)
SelectRow(row, TRUE)

wf_ret_sunsu(row)
end event

type p_delrow from w_inherite`p_delrow within w_sal_06055
integer x = 2693
integer y = 3540
end type

type p_addrow from w_inherite`p_addrow within w_sal_06055
integer x = 2519
integer y = 3540
end type

type p_search from w_inherite`p_search within w_sal_06055
integer x = 3922
string picturename = "C:\erpman\image\����ó��_up.gif"
end type

event p_search::clicked;call super::clicked;Long   ix,nRcnt,nCnt,nRow, nMaxSeq, Lrow
String sDatef,sDatet,sDept, sCino, sItnbr,sAccod
String sNgno, sCurr, sCvcod, sLocalYn, sSaupj, sCustNo
Double dNgAmt, dNgUamt, dNgWamt, dWrate,dNgamtD, dNgUamtD, dNgWamtD, dUrate,dWeight
Double dNgSeq = 0
			 
nRcnt = dw_insert.RowCount()
If nRcnt <= 0 Then Return

dw_interface.Reset()

/* �˻��� Ű */
sDatef = dw_ip.GetItemString(1,'sdatef')
sDatet = dw_ip.GetItemString(1,'sdatet')
sLocalYn = dw_ip.GetItemString(1,'localyn')

/* ����μ� */
select dept_cd into :sDept
  from cia02m
 where cost_cd = ( select substr(dataname,1,6) from syscnfg
						  where sysgu = 'A' and serial = 20 and datagu  = 1 );

sDept = Trim(sDept)
	 
SetPointer(HourGlass!)

/* ������� ȸ�� ����(��������Ȳ) */
//datastore ds
//ds = create datastore
//ds.settransobject(sqlca)
//ds.dataobject = "d_sal_06055_ds"
//ds.settransobject(sqlca)

/* ȸ��ý������� �̿� */
For ix = 1 To nRcnt
	If dw_insert.GetItemString(ix,'chk') = 'Y' then

		/* ���⼼�ݰ�꼭 �ڵ���ǥ �ڷ� */
		nRow = dw_interface.InsertRow(0)
		sCino = dw_insert.GetItemString(ix,"CINO" )
		sCvcod  = Trim(dw_insert.GetItemString(ix,"CVCOD"))
		sCustNo  =Trim(dw_insert.GetItemString(ix,"cust_no"))

		/* �������ó�� ������ ��� �������ó�� ���� �߻� */
		If Not IsNull(sCustNo) And sCustNo <> '' Then
			sCvcod = sCustNo
		End If
		
		dw_interface.SetItem(nRow,"CINO",    sCino)
		dw_interface.SetItem(nRow,"CVCOD",   sCvcod )
		dw_interface.SetItem(nRow,"DEPT_CD", sDept )
		
		sSaupj = dw_insert.GetItemString(ix,"SAUPJ" )
		dw_interface.SetItem(nRow,"SABU",   gs_sabu)
		dw_interface.SetItem(nRow,"CIDATE", dw_insert.GetItemString(ix,"SALEDT" )) // ����Ȯ������ 
		dw_interface.SetItem(nRow,"CISTS",  dw_insert.GetItemString(ix,"CISTS" ))
		dw_interface.SetItem(nRow,"OUTCFDT",dw_insert.GetItemString(ix,"OUTCFDT"))

		dw_interface.SetItem(nRow,"SELLER",  dw_insert.GetItemString(ix,"SELLER"))
		dw_interface.SetItem(nRow,"CONSIGNEE",  dw_insert.GetItemString(ix,"CONSIGNEE"))
		dw_interface.SetItem(nRow,"SHIPDAT",  dw_insert.GetItemString(ix,"SHIPDAT"))
		dw_interface.SetItem(nRow,"VF_FROM",  dw_insert.GetItemString(ix,"VF_FROM"))
		dw_interface.SetItem(nRow,"VF_TO",  dw_insert.GetItemString(ix,"VF_TO"))
		dw_interface.SetItem(nRow,"EXPLCNO",  dw_insert.GetItemString(ix,"EXPLCNO"))
		dw_interface.SetItem(nRow,"BUYER",  dw_insert.GetItemString(ix,"BUYER"))
		dw_interface.SetItem(nRow,"OTHER_REF",  dw_insert.GetItemString(ix,"OTHER_REF"))
		dw_interface.SetItem(nRow,"TERM_DELI_PAY",  dw_insert.GetItemString(ix,"TERM_DELI_PAY"))
		dw_interface.SetItem(nRow,"CINOTES",  dw_insert.GetItemString(ix,"CINOTES"))
		dw_interface.SetItem(nRow,"SHIPMARK",  dw_insert.GetItemString(ix,"SHIPMARK"))
		dw_interface.SetItem(nRow,"CTQTY",  dw_insert.GetItemNumber(ix,"CTQTY"))
		dw_interface.SetItem(nRow,"CURR",  dw_insert.GetItemString(ix,"CURR"))
		dw_interface.SetItem(nRow,"WRATE",  dw_insert.GetItemNumber(ix,"WRATE"))
		dw_interface.SetItem(nRow,"URATE",  dw_insert.GetItemNumber(ix,"URATE"))
		
		/* ��������ȣ�� ����(2000.09.27) kif05ot0�� expno varchar2(11) -> varchar2(20) */
		dw_interface.SetItem(nRow,"EXPNO",  dw_insert.GetItemString(ix,"exppmtno"))
		dw_interface.SetItem(nRow,"EXPAMT",  dw_insert.GetItemNumber(ix,"EXPAMT"))
		dw_interface.SetItem(nRow,"WAMT",  dw_insert.GetItemNumber(ix,"WAMT"))
		dw_interface.SetItem(nRow,"UAMT",  dw_insert.GetItemNumber(ix,"UAMT"))
		dw_interface.SetItem(nRow,"BLNO",  dw_insert.GetItemString(ix,"BLNO"))
		dw_interface.SetItem(nRow,"VF",  dw_insert.GetItemString(ix,"VF"))		
		dw_interface.SetItem(nRow,"VATGU",  dw_insert.GetItemString(ix,"VATGU"))
		dw_interface.SetItem(nRow,"SAUPJ",  sSaupj)
		dw_interface.SetItem(nRow,"SACCOD",  '01')
		dw_interface.SetItem(nRow,"ALC_GU", 'N')


		/* ���⼼�ݰ�꼭 ǰ�� �ڵ���ǥ �ڷ� */
		insert into kif05ot1
			value ( sabu,    cino,   ciseq,   pino,   piseq,   itnbr,   order_spec,
					  ciqty,   ciprc,  ciamt,   wamt,   uamt,
					  accod  )    /* salegu ���� 2002.2.22  ����ö */
			select  d.sabu, a.cino, a.ciseq, a.pino, a.piseq, a.itnbr, a.order_spec,
					  a.ciqty, a.ciprc,a.ciamt, a.wamt, a.uamt,
					  decode(nvl(d.localyn,'N'),'N',decode(a.order_spec,'.',fun_get_itnacc(a.itnbr,'2'),fun_get_itnacc(a.itnbr,'7')),
					  									 'Y',decode(a.order_spec,'.',fun_get_itnacc(a.itnbr,'3'),fun_get_itnacc(a.itnbr,'7')),
														 null)
			  from expcid a, itemas b, expcih d
			 where a.itnbr = b.itnbr and
					 a.sabu = d.sabu and
					 a.cino  = d.cino and
					 a.sabu = :gs_sabu and 
					 a.cino = :sCino ;
					 
		If sqlca.sqlcode <> 0 Then
			f_message_chk(32,'[SQLcode 1: ' + string(sqlca.sqlerrtext)+']')
			RollBack;
//			destroy ds
			p_can.TriggerEvent(Clicked!)
			Return -1
		End If
		
		/* ci max seq */
		select max(ciseq) into :nMaxSeq
		  from expcid 
		 where sabu = :gs_sabu and
		       cino = :sCino;
		If IsNull(nMaxSeq) then nMaxSeq = 0
		
		nMaxSeq += 1

		/* ����� ��ü�� ǰ�� */
		SELECT SUBSTR(bigo,1,15) INTO :sItnbr FROM ITNCT
		 WHERE ITTYP = '9' AND
				 TITNM = '��Ÿ����';

		/* ��� �����ڵ� */
		select decode(nvl(:sLocalyn,'N'),'N',fun_get_itnacc(:sitnbr,'2'),'Y',fun_get_itnacc(:sitnbr,'3'),null)
		  into :sAcCod
		  from dual;

		/* ��� ǰ�� �ڵ���ǥ �ڷ� */
		insert into kif05ot1
			value ( sabu,    cino,   ciseq,   pino,     piseq,   itnbr,   order_spec,
					  ciqty,   ciprc,  ciamt,   wamt,     uamt,	  accod )
			select  :gs_sabu, cino,   :nMaxSeq + rownum, pino,    rownum,  :sItnbr, '.',
					  0,       0,      chramt,  wamt,     uamt,    :sAccod
			  from expcich
			 where sabu = :gs_sabu and 
					 cino = :sCino ;

		If sqlca.sqlcode <> 0 Then
			f_message_chk(32,'[SQLcode 2: ' + string(sqlca.sqlerrtext)+']')
			RollBack;
//			destroy ds
			p_can.TriggerEvent(Clicked!)
			Return -1
		End If
	
		/* ��nego  */
		insert into kif05ot2
				  ( sabu,      cino,      ngno,     ngseq,   ngamt,
					 curr,      wrate,     uamt,     wamt,    cvcod )
			select :gs_sabu, z.cino,    z.ngno,   rownum,  z.ngamt,
					 z.curr,    z.wrate,   Z.uamt,   Z.wamt,  Z.cvcod
			  from (	select y.cino,    y.ngno,   sum(y.ngamt) as ngamt,
								 x.curr,    x.wrate,   sum(y.uamt) as uamt,   sum(y.wamt) as wamt,  x.cvcod
						  from expnegoh x, expnegod y
						 where x.ngno = y.ngno and
								 y.cino = :sCino and
								 y.datagu = '2'
						 group by y.cino, y.ngno, x.curr, x.wrate, x.cvcod ) z;

			If sqlca.sqlcode <> 0 Then
				sle_msg.Text = string(sqlca.sqlcode) + ' ' + sqlca.sqlerrtext
				f_message_chk(32,'[SQLcode 3: ' + string(sqlca.sqlcode)+']')
				RollBack;
				p_can.TriggerEvent(Clicked!)
				Return
			End If

//		ds.retrieve(scino)
//		For Lrow = 1 to ds.rowcount()
//			 sngno 	= ds.getitemstring(Lrow, "ngno")
//			 dngamt 	= ds.getitemdecimal(Lrow, "ngamt")
//			 dnguamt	= ds.getitemdecimal(Lrow, "nguamt")
//			 dngwamt	= ds.getitemdecimal(Lrow, "ngwamt")
//			 scurr 	= ds.getitemstring(Lrow, "curr")
//			 dwrate	= ds.getitemdecimal(Lrow, "wrate")
//			 	
//			select nvl(sum(ngamt),0), nvl(sum(uamt),0) , nvl(sum(wamt),0)
//			  into :dNgamtD, :dNgUamtD, :dNgWamtD
//			  from expnegod 
//			 where sabu = :gs_sabu and
//					 ngno = :sNgno and
//					 datagu = '1';
//
//			dNgSeq  = dNgseq + 1
//			dNgAmt  = Truncate(dNgAmt - dNgAmtD,2)
//			
//			/* ����ġ */
//			If sCurr <> 'WON' Then
//				Select to_number(rfna2) into :dWeight
//				  from reffpf
//				 where rfcod = '10' and
//						 rfgub = :sCurr;
//				If sqlca.sqlcode <> 0 Then Return -1
//	
//				If IsNull(dWeight) Then dWeight = 1
//					dNgUAmt = Truncate((dNgAmt * dUrate)/dWeight,2)
//					dNgWAmt = Truncate((dNgAmt * dWrate)/dWeight,0)
//				Else
//					dNgUAmt = Truncate(dNgUAmt - dNgUAmtD,2)
//					dNgWAmt = Truncate(dNgWAmt - dNgWAmtD,2)
//				End If
//
//				insert into kif05ot2
//						  ( sabu,      cino,      ngno,     ngseq,   ngamt,
//							 curr,      wrate,     uamt,     wamt,    cvcod )
//				 values ( :gs_sabu, :sCino,    :sNgno,   :dNgseq, :dNgAmt,
//							 :sCurr,    :dWrate,   :dNgUamt, :dNgWamt,:scvcod ) ;
//			 
//				If sqlca.sqlcode <> 0 Then
//					sle_msg.Text = string(sqlca.sqlcode) + ' ' + sqlca.sqlerrtext
//					f_message_chk(32,'[SQLcode 3: ' + string(sqlca.sqlcode)+']')
//					RollBack;
//					destroy ds
//					p_can.TriggerEvent(Clicked!)
//					Return
//				End If
//		Next
		nCnt += 1
	End If
Next

//Destroy ds

If nCnt <=0 Then
	f_message_chk(57,'')
	Return
End If

If dw_interface.Update() <> 1 then
	f_message_chk(32,'[SQLcode 4: ' + string(sqlca.sqlcode)+']')
	RollBack;
	Return
Else
	/* Local ��꼭 ȸ�����۽� ����ȯ���� ���۽� �ٽ� ����Ѵ� */
	If dw_ip.GetItemString(1,'chk') = 'Y' then
		For ix = 1 To dw_insert.RowCount()		
			If dw_insert.GetItemString(ix,'chk') = 'Y' Then
				sCino = dw_insert.GetItemString(ix,"CINO" )
				If wf_calc_move(sCino, ix) <> 0 Then
					RollBack;
					Return
				End If
			End If
		Next
	End If
	
	Commit;
	string	sArea
	sarea  = Trim(dw_ip.GetItemString(1,'sarea'))
	dw_insert.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sarea+'%')
End If

sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\����ó��_up.gif"
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\����ó��_dn.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06055
integer x = 3913
integer y = 2708
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_ins::clicked;call super::clicked;String sCino, sCvcod, sSaupj, sWeight
Long   nRow

nRow = dw_insert.GetSelectedRow(0)
If nRow <= 0 Then Return

sCino  = dw_insert.GetItemString(nRow, 'cino')
sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sSaupj = dw_insert.GetItemString(nRow, 'saupj')
sWeight = dw_insert.GetItemString(nRow, 'weight')
		 
/* �����ݳ����� ������ Nego�ڷḦ ������ �������Ѵ� */
If wf_check_nego(sCino, sCvcod, sweight) = -1 Then
	RollBack;
	wf_ret_sunsu(nRow)
	return -1
End If

/* �����ݳ����� ���� �����ᰡ ���� ��� �ش� Nego�� ���ؼ� ������� �Ѵ� */
If wf_check_nego_charge() = -1 Then
	RollBack;
	wf_ret_sunsu(nRow)
	return -1
End If

COMMIT;

wf_ret_sunsu(nRow)

end event

type p_exit from w_inherite`p_exit within w_sal_06055
end type

type p_can from w_inherite`p_can within w_sal_06055
end type

event p_can::clicked;call super::clicked;cbx_1.Checked = False

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_sal_06055
integer x = 2341
integer y = 3520
end type

type p_inq from w_inherite`p_inq within w_sal_06055
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String sDatef,sDatet, sSaupj, sarea
Long   nRcnt

If dw_ip.AcceptText() <> 1 Then Return
If dw_ip.RowCount() <= 0 Then Return

sSaupj = Trim(dw_ip.GetItemString(1,'saupj'))
sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
sarea  = Trim(dw_ip.GetItemString(1,'sarea'))

dw_ip.SetFocus()
IF f_datechk(sDatef) <> 1 THEN
	f_message_chk(30,'[��������]')
	dw_ip.SetColumn("sdatef")
	Return
END IF

IF f_datechk(sDatet) <> 1 THEN
	f_message_chk(30,'[��������]')
	dw_ip.SetColumn("sdatet")
	Return
END IF

IF IsNull(sSaupj) Or sSaupj = '' THEN
	f_message_chk(1400,'[�ΰ������]')
	dw_ip.SetColumn("saupj")
	Return
END IF

If IsNull(sArea) Then sArea = ''

If rb_1.Checked = True Then
	nRcnt = dw_insert.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sArea+'%')
Else
	nRcnt = dw_interface.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sArea+'%')
End If

If nRcnt <= 0 Then
	f_message_chk(50,'')
	dw_ip.Setfocus()
End If
end event

type p_del from w_inherite`p_del within w_sal_06055
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\�������_d.gif"
end type

event p_del::clicked;call super::clicked;Long ix,nRcnt,nCnt,nRow
String sDatef,sDatet,sJasa, sCiNo, sSaupj, sArea

nRcnt = dw_interface.RowCount()
If nRcnt <= 0 Then Return

/* �˻��� Ű */
sDatef = dw_ip.GetItemString(1,'sdatef')
sDatet = dw_ip.GetItemString(1,'sdatet')
sSaupj = dw_ip.GetItemString(1,'saupj')
sarea  = Trim(dw_ip.GetItemString(1,'sarea'))

If IsNull(sArea) Then sArea = ''

SetPointer(HourGlass!)

For ix = nRcnt To 1 Step -1
	If dw_interface.GetItemString(ix,'chk') = 'Y' then
		
		sCiNo = dw_interface.GetItemString(ix,'cino')
		/* ���⼼�ݰ�꼭 ǰ�� �ڵ���ǥ ���� */
      DELETE FROM "KIF05OT0"
        WHERE ( "KIF05OT0"."SABU" = :gs_sabu ) AND
		        ( "KIF05OT0"."CINO" = :sCiNo ) AND
				  ( "KIF05OT0"."BAL_DATE" IS NULL );

		If sqlca.sqlcode = 0 And sqlca.sqlnRows >= 1 Then
			/* ���⼼�ݰ�꼭 ǰ�� �ڵ���ǥ ���� */
			DELETE FROM "KIF05OT1"  
			  WHERE ( "KIF05OT1"."SABU" = :gs_sabu ) AND
					  ( "KIF05OT1"."CINO" = :sCiNo );
		Else
			RollBack;
			MessageBox('Ȯ ��','�� ��ǥ����� �ڷᰡ �����մϴ�')
			Return
		End If
		
		/* ��Nego ǰ�� �ڵ���ǥ ���� */
		DELETE FROM "KIF05OT2"
		  WHERE ( "KIF05OT2"."SABU" = :gs_sabu ) AND
				  ( "KIF05OT2"."CINO" = :sCiNo );
		If sqlca.sqlcode <> 0  Then
			RollBack;
			MessageBox('Ȯ ��','��ǥ������ ������ �߻��߽��ϴ�')
			Return
		End If
		
		nCnt += 1
	End If
Next

If nCnt <=0 Then
	f_message_chk(57,'')
	Return
End If

Commit;

dw_interface.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sArea+'%')

sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'

end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\�������_up.gif"
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\�������_dn.gif"
end event

type p_mod from w_inherite`p_mod within w_sal_06055
integer x = 1819
integer y = 2676
string picturename = "C:\erpman\image\����ó��_up.gif"
end type

type cb_exit from w_inherite`cb_exit within w_sal_06055
integer x = 3122
integer y = 2732
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_sal_06055
integer x = 1115
integer y = 2772
string text = "����(&S)"
end type

event cb_mod::clicked;call super::clicked;String sCino, sCvcod, sSaupj
Long   nRow

nRow = dw_insert.GetSelectedRow(0)
If nRow <= 0 Then Return

sCino  = dw_insert.GetItemString(nRow, 'cino')
sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sSaupj = dw_insert.GetItemString(nRow, 'saupj')

/* ������ó���Ȱ��� ������ �����Ѵ� */
Delete from expnegod
 where sabu = :gs_sabu and
       cino = :sCino and
		 datagu = '2';
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(57,'[Nego������ ����]')
	Return -1
End If

/* �����ݳ����� ���� �����ᰡ ���� ��� �ش� Nego�� ���ؼ� ������� �Ѵ� */
If sqlca.sqlnrows > 0 Then
	If wf_check_nego_charge() = -1 Then
		RollBack;
		f_message_chk(57,'[Nego ������ ������ ����]')
		return -1
	End If
End If

COMMIT;

wf_ret_sunsu(nRow)
end event

type cb_ins from w_inherite`cb_ins within w_sal_06055
integer x = 741
integer y = 2772
string text = "����(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06055
integer x = 2245
integer y = 2732
integer width = 498
integer taborder = 70
boolean enabled = false
string text = "�������(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_sal_06055
integer x = 96
integer y = 2732
end type

type cb_print from w_inherite`cb_print within w_sal_06055
integer x = 1298
integer y = 3548
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_06055
end type

type cb_can from w_inherite`cb_can within w_sal_06055
integer x = 2766
integer y = 2732
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sal_06055
integer x = 1723
integer y = 2732
integer width = 498
integer taborder = 60
string text = "����ó��(&W)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06055
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06055
end type

type gb_7 from groupbox within w_sal_06055
integer x = 681
integer y = 2720
integer width = 818
integer height = 176
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 67108864
string text = "������"
end type

type gb_6 from groupbox within w_sal_06055
integer x = 1664
integer y = 2680
integer width = 1856
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_5 from groupbox within w_sal_06055
integer x = 64
integer y = 2680
integer width = 421
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type rb_1 from radiobutton within w_sal_06055
integer x = 91
integer y = 60
integer width = 219
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "ó��"
boolean checked = true
end type

event clicked;dw_insert.Reset()
dw_interface.Reset()

dw_sunsu.Reset()
dw_negod.Reset()

p_search.Enabled = True
p_del.Enabled = False
p_search.PictureName = 'C:\erpman\image\����ó��_up.gif'
p_del.PictureName = 'C:\erpman\image\�������_d.gif'

dw_insert.SetFocus()
dw_insert.Visible = True
dw_interface.Visible = False

cbx_1.Checked = False

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')
end event

type rb_2 from radiobutton within w_sal_06055
integer x = 91
integer y = 136
integer width = 219
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "���"
end type

event clicked;dw_insert.Reset()
dw_interface.Reset()

dw_sunsu.Reset()
dw_negod.Reset()

p_search.Enabled = False
p_del.Enabled = True
p_search.PictureName = 'C:\erpman\image\����ó��_d.gif'
p_del.PictureName = 'C:\erpman\image\�������_up.gif'

dw_interface.SetFocus()
dw_insert.Visible = False
dw_interface.Visible = True

cbx_1.Checked = False

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')
end event

type dw_ip from datawindow within w_sal_06055
event ue_processenter pbm_dwnprocessenter
integer x = 379
integer y = 32
integer width = 2345
integer height = 208
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06055_4"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sSuDate,sNull, sLocalYn, sSaupj

SetNull(sNull)
Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'sarea', sSaupj)
	Case "sdatef" , "sdatet"
		sSuDate = Trim(this.GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[����Ⱓ]')
			this.SetItem(1,GetColumnName() ,snull)
			Return 1
		END IF
	Case 'localyn'
		dw_insert.SetRedraw(False)
		If GetText() = 'N' Then
			/* Direct�� ���� ����ȯ���� ���� �Ұ� */
			SetItem(1,'chk','N')
			Modify("chk.visible = 0")
			
			dw_insert.DataObject = 'd_sal_06055_1'
		Else
			/* Local�� ��� */
//			If SaleConfirm = '2' Then Modify("chk.visible = 1")
			
			dw_insert.DataObject = 'd_sal_06055_3'
		End If
		dw_insert.SetTransObject(sqlca)
		dw_insert.SetRedraw(True)
END Choose
end event

event itemerror;return 1
end event

type cbx_1 from checkbox within w_sal_06055
integer x = 2770
integer y = 144
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "��ü����"
end type

event clicked;long ix
String sStatus

IF This.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

If rb_1.Checked = True Then
  For ix = 1 To dw_insert.RowCount()
	  dw_insert.SetItem(ix,'chk',sStatus)
  Next
ElseIf rb_2.Checked = True Then
  For ix = 1 To dw_interface.RowCount()
	  dw_interface.SetItem(ix,'chk',sStatus)
  Next
End If
end event

type dw_sunsu from u_d_select_sort within w_sal_06055
integer x = 32
integer y = 3344
integer width = 1755
integer height = 532
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "�̿��� ������(ȸ����ǥ�����ڷ�)-�����ݾ� �Է�"
string dataobject = "d_sal_06055_5"
end type

type dw_negod from u_d_select_sort within w_sal_06055
integer x = 1888
integer y = 3288
integer width = 1550
integer height = 532
integer taborder = 11
boolean bringtotop = true
boolean titlebar = true
string title = "���� ������"
string dataobject = "d_sal_06055_6"
end type

type dw_interface from u_key_enter within w_sal_06055
integer x = 59
integer y = 272
integer width = 4539
integer height = 2052
integer taborder = 90
string dataobject = "d_sal_06055_2"
boolean vscrollbar = true
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06055
integer x = 1120
integer y = 48
integer width = 78
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('sdatef')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06055
integer x = 1586
integer y = 48
integer width = 78
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('sdatet')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 40
integer width = 320
integer height = 188
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_06055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 260
integer width = 4562
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

