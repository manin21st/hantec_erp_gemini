$PBExportHeader$w_sal_01760.srw
$PBExportComments$�������� ���
forward
global type w_sal_01760 from w_inherite
end type
type rb_new from radiobutton within w_sal_01760
end type
type rb_ins from radiobutton within w_sal_01760
end type
type rb_upd from radiobutton within w_sal_01760
end type
type dw_list from u_key_enter within w_sal_01760
end type
type gb_4 from groupbox within w_sal_01760
end type
type gb_3 from groupbox within w_sal_01760
end type
type gb_2 from groupbox within w_sal_01760
end type
type gb_1 from groupbox within w_sal_01760
end type
type cb_alldel from commandbutton within w_sal_01760
end type
type st_2 from statictext within w_sal_01760
end type
type rb_copy from radiobutton within w_sal_01760
end type
type rr_1 from roundrectangle within w_sal_01760
end type
end forward

global type w_sal_01760 from w_inherite
string title = "�������� ���"
rb_new rb_new
rb_ins rb_ins
rb_upd rb_upd
dw_list dw_list
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
cb_alldel cb_alldel
st_2 st_2
rb_copy rb_copy
rr_1 rr_1
end type
global w_sal_01760 w_sal_01760

forward prototypes
public function integer wf_copy_offer (string arg_ofno, integer arg_ofseq)
public function integer wf_copy_calcst ()
public function integer wf_calc_cst (string scstno, string scstseq, string sgubun)
public function integer wf_set_cost (integer nrow)
public function integer wf_req_chk (string sgubun)
public function integer wf_delete_detail (integer nrow, string sitnbr)
public function integer wf_init (string smodstatus1)
end prototypes

public function integer wf_copy_offer (string arg_ofno, integer arg_ofseq);String sitnbr, sitdsc, sispec, sJijil, scbcode, sorder_spec, sreqdate, sCustNo, sIttyp, sItcls, stitnm
String sCustNm,   scurr, sNull, sOfdesc
Dec    dOfqty, dOfprc, dNull
String sCstNo, sCstSeq

SetNull(sNull)
SetNull(dNull)

SELECT MAX(CSTNO), MAX(CSTSEQ) INTO :sCstNo, :sCstSeq
  FROM CALCSTH
 WHERE SABU = :gs_sabu AND
		 OFNO = :arg_ofno and
		 OFSEQ = :arg_ofseq;
If Not IsNull(sCstNo) And sCstNo <> '' Then
	MessageBox('Ȯ ��','����ȣ : ' + sCstNo + ' �׹� : ' + sCstSeq + '~r~n~r~n' + '�̹� ���� ������ �����մϴ�.!!')
	dw_insert.SetItem(1, 'ofno',  sNull)
	dw_insert.SetItem(1, 'ofseq', dNull)
	Return 2
End If

  SELECT "OFDETL"."ITNBR",            "OFDETL"."ITDSC",            "OFDETL"."ISPEC",   
         "OFDETL"."JIJIL",            "OFDETL"."CBCODE",           "OFDETL"."ORDER_SPEC",   
         "OFDETL"."REQDATE",          "OFHEAD"."CUST_NO",          "OFHEAD"."CUST_NM",   
         "OFDETL"."OFQTY",            "OFDETL"."OFPRC",            "OFHEAD"."CURR",
			"OFDETL"."OFDESC",           "OFDETL"."ITTYP",            "OFDETL"."ITCLS", "ITNCT"."TITNM"
    INTO :sitnbr,            :sitdsc,            :sispec,   
         :sJijil,            :scbcode,           :sorder_spec,   
         :sreqdate,          :sCustNo,           :sCustNm,   
         :dOfqty,            :dOfprc,            :scurr  , 			:sOfdesc,
			:sIttyp,				  :sItcls,				 :stitnm
    FROM "OFDETL",   
         "OFHEAD", "ITNCT"
   WHERE ( "OFDETL"."SABU" = "OFHEAD"."SABU" ) and  
         ( "OFDETL"."OFNO" = "OFHEAD"."OFNO" ) and
			( "OFDETL"."ITTYP" = "ITNCT"."ITTYP"(+) ) and
			( "OFDETL"."ITCLS" = "ITNCT"."ITCLS"(+) ) and
			( "OFDETL"."SABU" = :gs_sabu ) and
			( "OFDETL"."OFNO" = :arg_ofno ) and

			( "OFDETL"."OFSEQ"= :arg_ofseq);

If sqlca.sqlcode <> 0 Then
	f_message_chk(50,'')
	dw_insert.SetItem(1, 'ofno',  sNull)
	dw_insert.SetItem(1, 'ofseq', dNull)
	Return 2
Else
	dw_insert.SetItem(1, 'itnbr', sitnbr)
	dw_insert.SetItem(1, 'stitnbr', sitnbr)
	
	dw_insert.SetItem(1, 'itdsc', sitdsc)
	dw_insert.SetItem(1, 'ispec', sispec)
	dw_insert.SetItem(1, 'jijil', sJijil)
	dw_insert.SetItem(1, 'pspec',   sorder_spec)
	dw_insert.SetItem(1, 'ispec_code',   scbcode)
	dw_insert.SetItem(1, 'ittyp',   sIttyp)
	dw_insert.SetItem(1, 'itcls',   sItcls)
	dw_insert.SetItem(1, 'titnm',   stitnm)
	dw_insert.SetItem(1, 'reqdate', sreqdate)
	dw_insert.SetItem(1, 'cust_no', sCustNo)
	dw_insert.SetItem(1, 'cust_nm', sCustNm)
	dw_insert.SetItem(1, 'ofqty',   dOfqty)
	dw_insert.SetItem(1, 'ofprc',   dOfprc)
	dw_insert.SetItem(1, 'curr',    scurr)
	dw_insert.SetItem(1, 'ofdesc',  sOfDesc)
End If

Return 0
end function

public function integer wf_copy_calcst ();String sCstNo, sCstSeq, sNewCstNo
Int    iCstNo

wf_init('U')
rb_upd.Checked = True

Open(w_sal_01760_popup)
IF gs_code ="" OR IsNull(gs_code) THEN RETURN 0

sCstNo	= gs_code
sCstSeq	= gs_gubun

/* �űԹ�ȣ ä�� */
iCstNo = sqlca.fun_junpyo(gs_sabu, is_today,'S2')
IF iCstNo <= 0 THEN
	ROLLBACK;
	f_message_chk(51,'')
	Return -1
END IF

sNewCstNo  = is_today + String(iCstNo,'0000')

Commit;

/* ���� */
INSERT INTO "CALCSTH"  
		( "SABU",   		  "CSTNO",   		  "CSTSEQ",   		  "ITMCLS",   		  "CSTDAT",   
		  "CSTGU",   		  "PDM",   			  "MEMO",   		  "CSTYEAR",   	  "OFNO",   
		  "OFSEQ",   		  "REQDATE",   	  "ITNBR",   		  "ITDSC",   		  "ISPEC",   
		  "JIJIL",   		  "PSPEC",   		  "CUST_NO",   	  "CUST_NM",   	  "OFQTY",   
		  "OFPRC",   		  "CURR",   		  "OFMEMO",   		  "MKGB",   		  "GCOST",   
		  "MATCOST",   	  "PRSCOST",   	  "TTAMT",   		  "STITNBR",   	  "CALGB",   
		  "ITTYP",   		  "ITCLS" )  
  SELECT "SABU",   		  :sNewCstNo, 		  '01',	   		  "ITMCLS",    	  :is_today,   
			"CSTGU",   		  "PDM",    		  "MEMO",   		  "CSTYEAR",   	  NULL,   
			NULL,	   		  "REQDATE",   	  "ITNBR",   		  "ITDSC",   		  "ISPEC",   
			"JIJIL",   		  "PSPEC",   		  "CUST_NO",   	  "CUST_NM",   	  "OFQTY",   
			"OFPRC",   		  "CURR",   		  "OFMEMO",   		  "MKGB",   		  "GCOST",   
			"MATCOST",   	  "PRSCOST",   	  "TTAMT",   		  "STITNBR",   	  "CALGB",   
			"ITTYP",   		  "ITCLS"  
	 FROM "CALCSTH"
	WHERE "SABU"  = :gs_sabu AND
			"CSTNO" = :sCstNo AND
			"CSTSEQ" = :sCstSeq;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	Return -1
End If
	
INSERT INTO "CALCSTD"  
		( "SABU",   		  "CSTNO",   		  "CSTSEQ",   		  "ITNBR",   		  "SHRAT",   
		  "MATCOST",   	  "PRSCOST",   	  "CSTQTY",   		  "CSTAMT",   		  "GUBUN",   
		  "SMG",   			  "CVCOD" )  
 SELECT "SABU",  			  :sNewCstNo, 		  '01',	   		  "ITNBR",   		  "SHRAT",   
			"MATCOST",   	  "PRSCOST",   	  "CSTQTY",   		  "CSTAMT",   		  "GUBUN",   
			"SMG",   		  "CVCOD"  
	 FROM "CALCSTD"
	WHERE "SABU"  = :gs_sabu AND
			"CSTNO" = :sCstNo AND
			"CSTSEQ" = :sCstSeq;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	Return -1
End If

INSERT INTO "CALCSTP"  
		( "SABU",   		  "CSTNO",   		  "CSTSEQ",   		  "ITNBR",   		  "SERID",   
		  "OPSEQ",   		  "WKCTR",   		  "MCHNO",   		  "COST_CD",   	  "COST_AMT",   		  "CVCOD" )  
 SELECT "SABU",   		  :sNewCstNo, 		  '01',     		  "ITNBR",   		  "SERID",   
		  "OPSEQ",   		  "WKCTR",   		  "MCHNO",   		  "COST_CD",   	  "COST_AMT",   		  "CVCOD"  
   FROM "CALCSTP"
  WHERE "SABU"  = :gs_sabu AND
		  "CSTNO" = :sCstNo AND
		  "CSTSEQ" = :sCstSeq;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	Return -1
End If

INSERT INTO "CALCSTU"  
		( "SABU",   		  "CSTNO",   		  "CSTSEQ",   		  "ITNBR",   		  "SERID",   
		  "OPSEQ",   		  "OPDSC",   		  "WKCTR",   		  "MCHNO",   		  "STDST",   
		  "MANHR",   		  "MCHR",   		  "PRSCOST",   	  "MKGUB",   		  "MATCOST",   		  "TBCQT" )  
 SELECT "SABU",   		  :sNewCstNo, 		  '01',   		 	  "ITNBR",   		  "SERID",   
		  "OPSEQ",   		  "OPDSC",   		  "WKCTR",   		  "MCHNO",   		  "STDST",   
		  "MANHR",   		  "MCHR",   		  "PRSCOST",   	  "MKGUB",   		  "MATCOST",   		  "TBCQT"  
   FROM "CALCSTU"
  WHERE "SABU"  = :gs_sabu AND
		  "CSTNO" = :sCstNo AND
		  "CSTSEQ" = :sCstSeq;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	Return -1
End If

/* ��ȸ */
dw_insert.SetItem(1,"cstno", sNewCstNo)
dw_insert.SetItem(1,"cstseq",'01')
p_inq.TriggerEvent(Clicked!)

Return 0
end function

public function integer wf_calc_cst (string scstno, string scstseq, string sgubun);Int ii

SetPointer(HourGlass!)

ii = sqlca.fun_get_calcst(gs_sabu, sCstNo, sCstSeq, '%', '%', sGubun)

If ii <> 1 Then
	messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Messagebox("��ü ���", "��ü ����� �����Ͽ����ϴ�.", stopsign!)
	Return -1
else
//	commit;
	Messagebox("��ü ���", "��ü ����� �Ϸ�Ǿ����ϴ�.", information!)	
	
	p_inq.TriggerEvent(Clicked!)
	Return 0
End if

Return 0
end function

public function integer wf_set_cost (integer nrow);Dec {3} dShrat, dmatcost, dprscost, dcstqty, dcstamt

If dw_list.RowCount() <= 0 Then Return 0

dShrat	= dw_list.GetItemNumber(nRow, 'shrat')
dmatcost = dw_list.GetItemNumber(nRow, 'matcost')
dprscost	= dw_list.GetItemNumber(nRow, 'prscost')
dcstqty	= dw_list.GetItemNumber(nRow, 'cstqty')

dcstamt	= Truncate((dcstqty + (dcstqty * dshrat / 100)) * ( dMatcost + dPrsCost),3)
dw_list.SetItem(nRow, 'cstamt', dCstAmt)

/* ������,������ ��� */
dw_insert.SetItem(1, 'matcost', dw_list.GetItemNumber(1, 'sum_matcost'))
dw_insert.SetItem(1, 'prscost', dw_list.GetItemNumber(1, 'sum_prscost'))


Return 0
end function

public function integer wf_req_chk (string sgubun);String sCstdate, sCstGu, sCstYear, sCstSeq, sItdsc, sIspec, sMkgb, sItnbr, sPdm, sIttyp, sItcls
Long 	 nRow
Dec    dCstQty, dOfqty

/* �⺻����, �������� �ʼ� üũ */
If sGubun = 'H' Then
	If dw_insert.AcceptText() <> 1 Then Return -1
	
	dw_insert.SetFocus()
	sPdm		= Trim(dw_insert.GetItemString(1, 'pdm'))
	sCstdate	= Trim(dw_insert.GetItemString(1, 'cstdat'))
	sCstGu	= Trim(dw_insert.GetItemString(1, 'cstgu'))
	sCstYear	= Trim(dw_insert.GetItemString(1, 'cstyear'))
	sCstSeq	= Trim(dw_insert.GetItemString(1, 'cstseq'))
	sItdsc	= Trim(dw_insert.GetItemString(1, 'itdsc'))
	sIspec	= Trim(dw_insert.GetItemString(1, 'ispec'))
	sMkgb		= Trim(dw_insert.GetItemString(1, 'mkgb'))
	sIttyp	= Trim(dw_insert.GetItemString(1, 'ittyp'))
	sItcls	= Trim(dw_insert.GetItemString(1, 'itcls'))
	dOfQty	= dw_insert.GetItemNumber(1, 'ofqty')
	
	If IsNull(sPdm) Or sPdm = '' Then
		f_message_chk(1400,'[PDM]')
		dw_insert.SetColumn('pdm')
		Return -1
	End If

	If IsNull(sCstDate) Or sCstDate = '' Then
		f_message_chk(1400,'[��������]')
		dw_insert.SetColumn('cstdat')
		Return -1
	End If
	
	If IsNull(sCstGu) Or sCstGu = '' Then
		f_message_chk(1400,'[��걸��]')
		dw_insert.SetColumn('CstGu')
		Return -1
	End If
	
	If IsNull(sCstYear) Or sCstYear = '' Then
		f_message_chk(1400,'[��������⵵]')
		dw_insert.SetColumn('CstYear')
		Return -1
	End If
	
	If IsNull(sCstSeq) Or sCstSeq = '' Then
		f_message_chk(1400,'[�׹�]')
		dw_insert.SetColumn('CstSeq')
		Return -1
	End If
	
	If IsNull(sItdsc) Or sItdsc = '' Then
		f_message_chk(1400,'[ǰ��]')
		dw_insert.SetColumn('Itdsc')
		Return -1
	End If
	
//	If IsNull(sIspec) Or sIspec = '' Then
//		f_message_chk(1400,'[�԰�]')
//		dw_insert.SetColumn('Ispec')
//		Return -1
//	End If
	
	If IsNull(sMkgb) Or sMkgb = '' Then
		f_message_chk(1400,'[��������]')
		dw_insert.SetColumn('Mkgb')
		Return -1
	End If

	If IsNull(sIttyp) Or sIttyp = '' Then
		f_message_chk(1400,'[ǰ�񱸺�]')
		dw_insert.SetColumn('ittyp')
		Return -1
	End If

	If IsNull(sItcls) Or sItcls = '' Then
		f_message_chk(1400,'[ǰ��з�]')
		dw_insert.SetColumn('itcls')
		Return -1
	End If
	
	If IsNull(dOfqty) Or dOfQty = 0 Then
		f_message_chk(1400,'[�����Ǹż���]')
		dw_insert.SetColumn('ofqty')
		Return -1
	End If
	
ElseIf sGubun = 'D' Then
	If dw_list.AcceptText() <> 1 Then Return -1
	
	nRow = dw_list.GetRow()
	If nRow <= 0 Then Return 1
	
	sItnbr	= Trim(dw_list.GetItemString(nRow, 'itnbr'))
	dCstQty	= dw_list.GetItemNumber(nRow, 'cstqty')

	dw_list.SetFocus()
	If IsNull(sItnbr) Or sItnbr = '' Then
		f_message_chk(1400,'[ǰ��]')
		dw_list.SetColumn('itnbr')
		Return -1
	End If
	If IsNull(dCstqty) Or dCstQty = 0 Then
		f_message_chk(1400,'[����]')
		dw_list.SetColumn('cstqty')
		Return -1
	End If	
End If

Return 1
end function

public function integer wf_delete_detail (integer nrow, string sitnbr);/* �ش�ǰ���� ���� �� �����׸��� �����Ѵ� */
String sCstNo, sCstSeq

If IsNull(sItnbr) Or sItnbr = '' Then Return 1

If dw_list.RowCount() <= 0 Then Return 1

sCstNo  = Trim(dw_list.GetItemString(nRow, 'cstno'))
sCstSeq = Trim(dw_list.GetItemString(nRow, 'cstseq'))

/* ����,�����׸� ���� */
DELETE FROM CALCSTU 
 WHERE SABU = :gs_sabu AND
       CSTNO = :sCstNo AND
		 CSTSEQ = :sCstSeq AND
		 ITNBR  = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'')
	Return -1
End If

DELETE FROM CALCSTP
 WHERE SABU = :gs_sabu AND
       CSTNO = :sCstNo AND
		 CSTSEQ = :sCstSeq AND
		 ITNBR  = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'')
	Return -1
End If

Return 1
end function

public function integer wf_init (string smodstatus1);
dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_list.Reset()

dw_insert.SetFocus()
Choose Case sModStatus1 
	Case 'I' /* �ű� */
		dw_insert.Modify('cstno.protect = 1')
		//dw_insert.Modify("cstno.background.color = 80859087")

		dw_insert.Modify('cstseq.protect = 0')
		//dw_insert.Modify("cstseq.background.color = '"+String(Rgb(190,225,184))+"'")
		dw_insert.Modify('cstdat.protect = 0')
		//dw_insert.Modify("cstdat.background.color = '"+String(Rgb(190,225,184))+"'")
	
		dw_insert.SetItem(1, 'cstdat',  is_today)
		dw_insert.SetItem(1, 'cstyear', Left(is_today,4))
		dw_insert.SetItem(1, 'cstseq',  '01')	/* �׹� */
		
		p_inq.Enabled = False
		p_inq.PictureName = 'C:\erpman\image\��ȸ_d.gif'
		p_search.Enabled = True
		p_search.PictureName = 'C:\erpman\image\��ü���_up.gif'
		p_addrow.Enabled = True  
		p_addrow.PictureName = 'C:\erpman\image\��ü����_up.gif'
		p_del.Enabled = True
		p_del.PictureName = 'C:\erpman\image\����_up.gif'
		p_ins.Enabled = True
		p_ins.PictureName = 'C:\erpman\image\�߰�_up.gif'
		p_mod.Enabled = True
		p_mod.PictureName = 'C:\erpman\image\����_up.gif'
		
	Case 'H', 'U' /* �׹��߰�,���� */
		dw_insert.Modify('cstno.protect = 0')
		//dw_insert.Modify("cstno.background.color = '"+String(Rgb(255,255,0))+"'")
		
		dw_insert.SetItem(1, 'cstdat',  is_today)
		dw_insert.SetItem(1, 'cstyear', Left(is_today,4))
		
		p_inq.Enabled = True
		p_inq.PictureName = 'C:\erpman\image\��ȸ_up.gif'
		
		dw_insert.SetColumn('cstno')
End Choose

p_search.Enabled = False
p_search.PictureName = 'C:\erpman\image\��ü���_d.gif'

dw_insert.SetFocus()

ib_any_typing = False

Return 1

//	/* �������� ���� �Ұ� */
////	dw_insert.Modify('order_date.protect = 0')
////	dw_insert.Modify("order_date.background.color = '"+String(Rgb(190,225,184))+"'")	
//	
//	dw_insert.Modify('depot_no.protect = 0')
//	dw_insert.Modify("depot_no.background.color = '"+String(Rgb(190,225,184))+"'")	
//	dw_insert.Modify('cvcod.protect = 0')
//   dw_insert.Modify("cvcod.background.color = '"+String(Rgb(255,255,0))+"'")
//	dw_insert.Modify('cvnas.protect = 0')
//   dw_insert.Modify("cvnas.background.color = '"+String(Rgb(255,255,255))+"'")
//	
//	dw_insert.Modify('sugugb.protect = 0')
//	dw_insert.Modify("sugugb.background.color = '"+String(Rgb(190,225,184))+"'")
//	dw_insert.Modify('dirgb.protect = 0')
//	dw_insert.Modify("dirgb.background.color = '"+String(Rgb(190,225,184))+"'")
//	dw_insert.Modify('house_no.protect = 0')
//	dw_insert.Modify("house_no.background.color = '"+String(Rgb(190,225,184))+"'")
//	dw_insert.Modify('saupj.protect = 0')
//	dw_insert.Modify("saupj.background.color = '"+String(Rgb(190,225,184))+"'")
//	
//	If isOrderYn = 'N' Then
//		dw_insert.Modify('order_no.protect = 0')
//		dw_insert.Modify("order_no.background.color = '"+String(Rgb(190,225,184))+"'")	
//		dw_insert.SetColumn("order_no")
//	Else
//
//		
//		dw_insert.SetColumn("cvcod")
//	End If
//	
//	cb_inq.Enabled = False
//	cb_mod.Enabled = False
//	cb_del.Enabled = False
//ELSE
///* ���� */
//	dw_insert.Modify('order_no.protect = 0')
//	dw_insert.Modify("order_no.background.color = 65535")
//
//	dw_insert.Modify('order_date.protect = 1')
//	dw_insert.Modify("order_date.background.color = 80859087")
//	
//	dw_insert.Modify('depot_no.protect = 1')
//   dw_insert.Modify("depot_no.background.color = 80859087")
//	
//	dw_insert.Modify('cvcod.protect = 1')
//   dw_insert.Modify("cvcod.background.color = 80859087")
//	dw_insert.Modify('cvnas.protect = 1')
//   dw_insert.Modify("cvnas.background.color = 80859087")
//
//	dw_insert.Modify('sugugb.protect = 1')
//   dw_insert.Modify("sugugb.background.color = 80859087")
//	dw_insert.Modify('dirgb.protect = 1')
//   dw_insert.Modify("dirgb.background.color = 80859087")
//	dw_insert.Modify('house_no.protect = 1')
//   dw_insert.Modify("house_no.background.color = 80859087")
//	dw_insert.Modify('saupj.protect = 1')
//   dw_insert.Modify("saupj.background.color = 80859087")
//	
//	dw_insert.SetColumn("order_no")
//
//	cb_inq.Enabled = True
//	cb_mod.Enabled = True
//	cb_del.Enabled = True
//END IF
//

end function

on w_sal_01760.create
int iCurrent
call super::create
this.rb_new=create rb_new
this.rb_ins=create rb_ins
this.rb_upd=create rb_upd
this.dw_list=create dw_list
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.cb_alldel=create cb_alldel
this.st_2=create st_2
this.rb_copy=create rb_copy
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_new
this.Control[iCurrent+2]=this.rb_ins
this.Control[iCurrent+3]=this.rb_upd
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.gb_4
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.cb_alldel
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.rb_copy
this.Control[iCurrent+12]=this.rr_1
end on

on w_sal_01760.destroy
call super::destroy
destroy(this.rb_new)
destroy(this.rb_ins)
destroy(this.rb_upd)
destroy(this.dw_list)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.cb_alldel)
destroy(this.st_2)
destroy(this.rb_copy)
destroy(this.rr_1)
end on

event open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_01760
integer y = 176
integer width = 3666
integer height = 944
string dataobject = "d_sal_017601"
boolean border = false
end type

event constructor;call super::constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'" )
Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::rbuttondown;String sIttyp
str_itnct lstr_sitnct

Long nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	/* ����ȣ */
	Case "cstno"
		Open(w_sal_01760_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cstno", gs_code)
		SetItem(1,"cstseq",gs_gubun)
		
		p_inq.TriggerEvent(Clicked!)
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case 'stitnbr'
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"stitnbr",gs_code)
		PostEvent(ItemChanged!)	
	Case 'itcls'
		sIttyp = GetItemString(nRow, 'ittyp')
		OpenWithParm(w_ittyp_popup, sIttyp)
		
		lstr_sitnct = Message.PowerObjectParm	
		
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		SetItem(nRow, "ittyp", lstr_sitnct.s_ittyp)
		SetItem(nRow, "itcls", lstr_sitnct.s_sumgub)
		SetItem(nRow, "titnm", lstr_sitnct.s_titnm)	
	/* ����ȣ */
	Case "cust_no"
		Open(w_cust_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cust_no",  gs_code)
		SetItem(1,"cust_nm",gs_codename)
	/* ������ȣ */
	Case "ofno","ofseq"
		gs_gubun = '1'	/* ������ ��ȸ */
		gs_code = '%'	/* ������ �ڷ� */
		Open(w_sal_01710)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow, "ofno",  gs_code)
		SetItem(nRow, "ofseq", Long(gs_codename))
		
		Return wf_copy_offer(gs_code, Long(gs_codename))
END Choose
end event

event dw_insert::itemchanged;Long nRow
Int  ireturn
String sItnbr, sItdsc, sIspec, sIoCust, sNull, sIoCustName, sjijil, sispeccode, sIttyp, sItcls
String sEmpNo, sEmpName, sOfDate, sOfNo, sCstNo, sCstSeq, sPspec
Dec    dOfSeq, dOfPrc

nRow = GetRow()
If nRow <= 0 Then Return

setNull(sNull)

Choose Case GetColumnName()
	/* ����ȣ */
	Case "cstno"
		sCstNo = Trim(GetText())
		IF sCstNo = "" OR IsNull(sCstNo) THEN RETURN
		
		SELECT MAX("CSTNO"), MAX("CSTSEQ")  INTO :sCstNo, :sCstSeq
		  FROM "CALCSTH"  
		 WHERE ( "SABU" = :gs_sabu ) AND
				 ( "CSTNO" = :sCstNo);
	
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[����ȣ]')
			SetItem(1,'cstno', sNull)
			SetItem(1,'cstseq',sNull)
			Return 1
		END IF

		SetItem(1,'cstseq',sCstSeq)
		
		p_inq.PostEvent(Clicked!)
	Case "itnbr"
		sItnbr = trim(GetText())
		ireturn = f_get_name4('ǰ��', 'N', sitnbr, sitdsc, sispec, sjijil, sispeccode)    //1�̸� ����, 0�� ����	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)
		setitem(1, "ispec", sispec)
		setitem(1, "jijil", sJijil)
		
		/* ��ǥǰ�� ���� */
		If ireturn = 0 Then
			SELECT ITTYP, ITCLS INTO :sIttyp, :sItcls
			  FROM ITEMAS
			 WHERE ITNBR = :sItnbr;
			 
			/* �⺻�ǸŴܰ� */
			dOfPrc = sqlca.fun_erp100000012(is_today, sItnbr, '.' );
			If IsNull(dOfprc) Then dOfprc = 0
			
			SetItem(1, 'ittyp', 	 sIttyp)
			SetItem(1, 'itcls', 	 sItcls)
			SetItem(1, 'stitnbr', sItnbr)
			SetItem(1, 'ofprc', 	 dOfprc)
		Else
			SetItem(1, 'stitnbr', sNull)
		End If
				
		RETURN ireturn
	Case 'pspec'
		sPspec = Trim(GetText())
		
		If IsNull(sPspec) Or sPspec = '' Then
			SetItem(1, 'pspec', '.')
			Return 1
		End If
	/* ��ǥǰ�� */
	Case "stitnbr"
		sItnbr = trim(GetText())
		ireturn = f_get_name2('ǰ��', 'N', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	

		If ireturn = 0 Then
			SELECT ITTYP, ITCLS INTO :sIttyp, :sItcls
			  FROM ITEMAS
			 WHERE ITNBR = :sItnbr;
			SetItem(1, 'ittyp', 	 sIttyp)
			SetItem(1, 'itcls', 	 sItcls)
			
			/* �⺻�ǸŴܰ� */
			dOfPrc = sqlca.fun_erp100000012(is_today, sItnbr, '.');
			If IsNull(dOfprc) Then dOfprc = 0
			
			SetItem(1, 'ofprc', dOfprc)
		End If
		
		RETURN ireturn
	Case 'itcls'
		sItnbr = GetText()
		sispec = getitemstring(1, 'ittyp')
		
		if sitnbr = '' or isnull(sitnbr) then 
			setitem(nRow, "ittyp", sNull)	
			setitem(nRow, "titnm", sNull)	
			return
		end if	
		
		ireturn = f_get_name2('ǰ��з�', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
		setitem(nRow, "itcls", sitnbr)
		setitem(nRow, "titnm", sitdsc)
		
		RETURN ireturn			
	/* �� ��ȣ */
	Case "cust_no"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			setitem(1, 'cust_nm', sNull)
			setitem(1, 'cust_no', sNull)
			Return 1
		End If
		
		SELECT "CUST_NAME"  INTO :sIocustName
		  FROM "CUSTOMER"
		 WHERE "CUST_NO" = :sIoCust;
		
		IF SQLCA.SQLCODE = 0 THEN
			setitem(1, 'cust_nm', left(sIocustName, 20))
		Else
			setitem(1, 'cust_nm', sNull)
			setitem(1, 'cust_no', sNull)
			Return 1
		End If
	/* ���� */
	Case "cstdate", "reqdate"
		sOfDate = Trim(GetText())
		IF sOfDate ="" OR IsNull(sOfDate) THEN RETURN
		
		IF f_datechk(sOfDate) = -1 THEN
			f_message_chk(35,'[����]')
			SetItem(1,GetColumnName(),snull)
			Return 1
		End If
	/* ������ȣ */
	Case "ofno"
		sOfNo = Trim(GetText())
		IF sOfNo = "" OR IsNull(sOfNo) THEN RETURN
		
		dOfSeq = GetItemNumber(1, 'ofseq')
		If Not IsNull(dOfSeq) Then
			Return wf_copy_offer(sOfno, dOfSeq)
		End If
	/* �������� */
	Case "ofseq"
		dOfSeq = Long(GetText())
		IF IsNull(dOfSeq) THEN RETURN
			
		sOfNo = GetItemString(1, 'ofno')
		If Not IsNull(sOfNo) Then
			Return wf_copy_offer(sOfno, dOfSeq)
		End If
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sal_01760
boolean visible = false
integer x = 4293
integer y = 2972
end type

type p_addrow from w_inherite`p_addrow within w_sal_01760
integer x = 3054
string picturename = "C:\erpman\image\��ü����_up.gif"
end type

event p_addrow::clicked;call super::clicked;String sCstNo, sCstSeq

sCstNo  = Trim(dw_insert.GetItemString(1,'cstno'))
sCstSeq = Trim(dw_insert.GetItemString(1,'cstseq'))

IF F_Msg_Delete() = -1 THEN Return

/* �����ڷ� ���� */
DELETE FROM CALCSTH WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
If Sqlca.sqlcode<> 0 Then
	RollBack;
	f_message_chk(160,'')
End If

DELETE FROM CALCSTD WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
If Sqlca.sqlcode<> 0 Then
	RollBack;
	f_message_chk(160,'')
End If

DELETE FROM CALCSTU WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
If Sqlca.sqlcode<> 0 Then
	RollBack;
	f_message_chk(160,'')
End If

DELETE FROM CALCSTP WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
If Sqlca.sqlcode<> 0 Then
	RollBack;
	f_message_chk(160,'')
End If

COMMIT;

p_can.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.Text = '�ڷḦ �����Ͽ����ϴ�.!!'
end event

event p_addrow::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ü����_dn.gif"
end event

event p_addrow::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ü����_up.gif"
end event

type p_search from w_inherite`p_search within w_sal_01760
integer x = 3401
string picturename = "C:\erpman\image\��ü���_up.gif"
end type

event p_search::clicked;call super::clicked;String sCstNo, sCstSeq, sGubun, sItnbr
Int    ii

If rb_new.Checked = True Then Return

If dw_insert.AcceptText() <> 1 Then Return
If dw_list.AcceptText() <> 1 Then Return

If ib_any_typing = True Then
	MessageBox('Ȯ ��','����� ������ �����ϼ���')
	Return
End If

sCstNo  = Trim(dw_insert.GetItemString(1,'cstno'))
sCstSeq = Trim(dw_insert.GetItemString(1,'cstseq'))
sItnbr  = Trim(dw_insert.GetItemString(1,'stitnbr'))

If IsNull(sCstNo) Or sCstNo = '' Then
	f_message_chk(30,'[����ȣ]')
	Return
End If

If IsNull(sCstSeq) Or sCstSeq = '' Then
	f_message_chk(30,'[�׹�]')
	Return
End If

setpointer(hourglass!)

sGubun = '1'

If dw_list.RowCount() >= 0 Then
	/* ����ǰ���� ���� ��� */
	If IsNull(sItnbr) Or sItnbr = '' Then
		sGubun = '2'
	Else
		ii = MessageBox("Ȯ ��","���������� ������ �ٽ� ����Ͻðڽ��ϱ�?" +"~n~n" +&
							"YES : ǥ�ذ��� ������  ������� ����" +"~n~n" + &
							"NO  : ��������������� ������� ����",Question!, YesNoCancel!, 1)
	
		If ii = 1 Then
			sGubun = '1'
		ElseIf ii = 2 Then
			sGubun = '2'
		Else
			Return
		End If
	End If
	If sGubun = '2' And dw_list.RowCount() <= 0 Then
		MessageBox('Ȯ ��','���������� ����ϼ���.!!')
		Return
	End If
Else
	If IsNull(sItnbr) Or sItnbr = '' Then
		MessageBox('Ȯ ��','���������� ����ϼ���.!!')
		Return
	End If
End If

If sGubun = '1' Then
	IF MessageBox("Ȯ ��","ǥ�ذ��� ������  ����� �����մϴ�.!!" +"~n~n" +&
								 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
Else
	IF MessageBox("Ȯ ��","��������������� ����� �����մϴ�.!!" +"~n~n" +&
								 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
End If

/* ������� */
wf_calc_cst(sCstNo, sCstSeq, sGubun)
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ü���_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ü���_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_01760
integer x = 3749
end type

event p_ins::clicked;call super::clicked;String sCstNo, sCstSeq
Long   nRow

IF dw_insert.AcceptText() = -1 THEN RETURN
IF dw_list.AcceptText() = -1 THEN RETURN

If wf_req_chk('D') <> 1 Then Return

sCstNo = dw_insert.GetItemString(1,"cstno")
sCstSeq = dw_insert.GetItemString(1,"cstseq")

IF rb_new.Checked = False THEN
  IF sCstNo = "" OR IsNull(sCstNo) THEN
	  messagebox('Ȯ ��','�ڷ� ��ȸ�� �߰��ϼ���.!!')
	  Return
  End If
Else
  messagebox('Ȯ ��','�ڷ� ������ �߰��ϼ���.!!')
  Return
END IF

nRow = dw_list.InsertRow(0)

dw_list.SetItem(nRow, "sabu",  gs_sabu)
dw_list.SetItem(nRow, "cstno", sCstNo)
dw_list.SetItem(nRow, "cstseq", sCstSeq)

dw_list.ScrollToRow(nRow)
	
dw_list.SetFocus()
dw_list.SetItemStatus(nRow,0, Primary!, NotModified!)
dw_list.SetItemStatus(nRow,0, Primary!, New!)

end event

type p_exit from w_inherite`p_exit within w_sal_01760
end type

type p_can from w_inherite`p_can within w_sal_01760
end type

event p_can::clicked;call super::clicked;rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_sal_01760
integer x = 3227
string picturename = "C:\erpman\image\����ȸ_up.gif"
end type

event clicked;String sCstNo, sCstSeq, sItnbr
Long   nRow
Dec    dPrsCost, dRtnCost

If dw_list.AcceptText() <> 1 Then Return

If wf_req_chk('H') <> 1 Then Return

nRow = dw_list.GetRow()
If nRow <= 0 Then Return

Choose Case dw_list.GetItemStatus(nRow,0, Primary!)
	Case New!, NewModified!
		MessageBox('Ȯ ��','������ �����Է��� �����մϴ�.!!')
		Return
End Choose

sCstNo	= Trim(dw_insert.GetItemString(1, 'cstno'))
sCstSeq	= Trim(dw_insert.GetItemString(1, 'cstseq'))

sItnbr   = dw_list.GetItemString(nRow, 'itnbr')
dPrsCost = dw_list.GetItemNumber(nRow, 'prscost')	/* ������ */

gs_code = sCstNo
gs_gubun = sItnbr
gs_codename = sCstSeq

OpenWithParm(w_sal_01760_gon_popup, dPrsCost)
dRtnCost = Message.DoubleParm

If gs_code = 'A' Then
	/* ������� */
	wf_calc_cst(sCstNo, sCstSeq, '2')
ElseIf gs_code = 'Y' Then
	p_inq.TriggerEvent(Clicked!)
End If
end event

event p_print::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����ȸ_dn.gif"
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����ȸ_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_01760
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sCstNo, sCstSeq, sCfmdate

If rb_new.Checked = True Then Return

If dw_insert.AcceptText() <> 1 Then Return

sCstNo  = Trim(dw_insert.GetItemString(1,'cstno'))
sCstSeq = Trim(dw_insert.GetItemString(1,'cstseq'))

If IsNull(sCstNo) Or sCstNo = '' Then
	f_message_chk(30,'[����ȣ]')
	Return
End If

If IsNull(sCstSeq) Or sCstSeq = '' Then
	f_message_chk(30,'[�׹�]')
	Return
End If

/* �׹��߰� �ϰ�� �ִ������ ���Ѵ� */
If rb_ins.Checked = True Then
	SELECT MAX("CSTSEQ")  INTO :sCstSeq
	  FROM "CALCSTH"  
	 WHERE ( "SABU" = :gs_sabu ) AND
			 ( "CSTNO" = :sCstNo);

	If IsNull(sCstSeq) Then sCstSeq = '00'
	
	sCstSeq = String(Long(sCstSeq) + 1,'00')
	
	dw_insert.SetItem(1, 'cstseq', sCstSeq)
	
	dw_insert.SetItemStatus(1,0, Primary!, NewModified!)
	
	/* �׹��߰��� ������ ���� ��������� �����ؾ��� */
	ib_any_typing = True
Else
	/* ��ȸ */
	If dw_insert.Retrieve(gs_sabu, sCstNo, sCstSeq) <= 0 Then
		f_message_chk(50,'')
		dw_insert.SetColumn("cstno")
		dw_insert.SetFocus()
		wf_init('U')
		Return
	Else
		dw_insert.Modify('cstdat.protect = 1')
		//dw_insert.Modify("cstdat.background.color = 80859087")
	
		/* �������� ��ȸ */
		dw_list.Retrieve(gs_sabu, sCstNo, sCstSeq)
	END IF
End If

dw_insert.Modify('cstno.protect = 1')
//dw_insert.Modify("cstno.background.color = 80859087")
dw_insert.Modify('cstseq.protect = 1')
//dw_insert.Modify("cstseq.background.color = 80859087")
	
/* �������� */
sCfmdate = dw_insert.GetItemString(1, 'cfmdate')
If Not IsNull(sCfmDate) Then
	p_search.Enabled = False  
	p_search.PictureName = 'C:\erpman\image\��ü���_d.gif'
	p_addrow.Enabled = False  
	p_addrow.PictureName = 'C:\erpman\image\��ü����_d.gif'
	
	p_del.Enabled = False
	p_del.PictureName = 'C:\erpman\image\����_d.gif'
	p_ins.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
	p_mod.Enabled = False
	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
Else
	p_search.Enabled = True
	p_search.PictureName = 'C:\erpman\image\��ü���_up.gif'
	p_addrow.Enabled = True  
	p_addrow.PictureName = 'C:\erpman\image\��ü����_up.gif'
	
	p_del.Enabled = True
	p_del.PictureName = 'C:\erpman\image\����_up.gif'
	p_ins.Enabled = True
	p_ins.PictureName = 'C:\erpman\image\�߰�_up.gif'
	p_mod.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\����_up.gif'
End If

//If dw_list.RowCount() > 0 Then
//	dw_list.SetFocus()
//	dw_list.ScrollToRow(1)
//	dw_list.SetRow(1)
//End If
end event

type p_del from w_inherite`p_del within w_sal_01760
end type

event p_del::clicked;call super::clicked;String sItnbr
Integer nRow

nRow = dw_list.GetRow()
IF nRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

sItnbr  = Trim(dw_list.GetItemString(nRow, 'itnbr'))

IF F_Msg_Delete() = -1 THEN Return

IF rb_new.Checked = False THEN
	If wf_delete_detail(nRow, sItnbr) <> 1 Then
		f_message_chk(31,'')
		ROLLBACK;
		Return
	END IF

	dw_list.DeleteRow(nRow)
	IF dw_list.Update() <> 1 THEN
		f_message_chk(31,'')
		ROLLBACK;
		Return
	END IF
	
	COMMIT;
Else
	dw_list.DeleteRow(nRow)
END IF

dw_list.SetColumn("itnbr")
dw_list.SetFocus()

w_mdi_frame.sle_msg.text = '�ڷḦ �����Ͽ����ϴ�!!'

end event

type p_mod from w_inherite`p_mod within w_sal_01760
end type

event p_mod::clicked;call super::clicked;String sNull, sCstDate, sCstNo
Int    iCstNo
		
SetNull(sNull)

If wf_req_chk('H') <> 1 Then Return
If wf_req_chk('D') <> 1 Then Return

IF F_Msg_Update() = -1 THEN Return

/* ������ȣ ä�� */
IF rb_new.Checked = True THEN	
	sCstDate = Trim(dw_insert.GetItemString(1, 'cstdat'))
	
	iCstNo = sqlca.fun_junpyo(gs_sabu,sCstDate,'S2')
	IF iCstNo <= 0 THEN
		ROLLBACK;
		f_message_chk(51,'')
		Return
	END IF
	
	sCstNo = sCstDate + String(iCstNo,'0000')
	Commit;

	dw_insert.SetItem(1,"sabu",  gs_sabu)
	dw_insert.SetItem(1,"cstno", sCstNo)
	MessageBox("Ȯ ��","ä���� ����ȣ�� "+sCstNo+" �� �Դϴ�!!")
ELSE
	dw_insert.SetItem(1,"sabu",  gs_sabu)
	sCstNo = Trim(dw_insert.GetItemString(1,"cstno"))
END IF

IF sCstNo = "" OR IsNull(sCstNo) THEN
	rollback;
	f_message_chk(51,'[����ȣ]')
	Return
End If

SetPointer(HourGlass!)

/* �ѿ��� */
dw_insert.SetItem(1, 'ttamt', dw_insert.GetItemNumber(1,'cal_ttamt'))

If dw_insert.Update(True, False) <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

If dw_list.Update(True, False) <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

COMMIT;

dw_insert.ResetUpdate()
dw_list.ResetUpdate()

rb_upd.Checked = True
p_search.Enabled = True
p_search.PictureName = 'C:\erpman\image\��ü���_up.gif'


w_mdi_frame.sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_sal_01760
boolean visible = false
integer x = 3323
integer y = 2740
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_sal_01760
boolean visible = false
integer x = 1298
integer y = 2740
integer width = 274
integer taborder = 90
end type

event cb_mod::clicked;call super::clicked;//String sNull, sCstDate, sCstNo
//Int    iCstNo
//		
//SetNull(sNull)
//
//If wf_req_chk('H') <> 1 Then Return
//If wf_req_chk('D') <> 1 Then Return
//
//IF F_Msg_Update() = -1 THEN Return
//
///* ������ȣ ä�� */
//IF rb_new.Checked = True THEN	
//	sCstDate = Trim(dw_insert.GetItemString(1, 'cstdat'))
//	
//	iCstNo = sqlca.fun_junpyo(gs_sabu,sCstDate,'S2')
//	IF iCstNo <= 0 THEN
//		ROLLBACK;
//		f_message_chk(51,'')
//		Return
//	END IF
//	
//	sCstNo = sCstDate + String(iCstNo,'0000')
//	Commit;
//
//	dw_insert.SetItem(1,"sabu",  gs_sabu)
//	dw_insert.SetItem(1,"cstno", sCstNo)
//	MessageBox("Ȯ ��","ä���� ����ȣ�� "+sCstNo+" �� �Դϴ�!!")
//ELSE
//	dw_insert.SetItem(1,"sabu",  gs_sabu)
//	sCstNo = Trim(dw_insert.GetItemString(1,"cstno"))
//END IF
//
//IF sCstNo = "" OR IsNull(sCstNo) THEN
//	rollback;
//	f_message_chk(51,'[����ȣ]')
//	Return
//End If
//
//SetPointer(HourGlass!)
//
///* �ѿ��� */
//dw_insert.SetItem(1, 'ttamt', dw_insert.GetItemNumber(1,'cal_ttamt'))
//
//If dw_insert.Update(True, False) <> 1 Then
//	RollBack;
//	f_message_chk(32,'')
//	Return
//End If
//
//If dw_list.Update(True, False) <> 1 Then
//	RollBack;
//	f_message_chk(32,'')
//	Return
//End If
//
//COMMIT;
//
//dw_insert.ResetUpdate()
//dw_list.ResetUpdate()
//
//rb_upd.Checked = True
//cb_search.Enabled = True
//
//sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'
//
//ib_any_typing = False
end event

type cb_ins from w_inherite`cb_ins within w_sal_01760
boolean visible = false
integer x = 704
integer y = 2740
integer width = 302
integer taborder = 80
string text = "�߰�(&I)"
end type

event cb_ins::clicked;call super::clicked;//String sCstNo, sCstSeq
//Long   nRow
//
//IF dw_insert.AcceptText() = -1 THEN RETURN
//IF dw_list.AcceptText() = -1 THEN RETURN
//
//If wf_req_chk('D') <> 1 Then Return
//
//sCstNo = dw_insert.GetItemString(1,"cstno")
//sCstSeq = dw_insert.GetItemString(1,"cstseq")
//
//IF rb_new.Checked = False THEN
//  IF sCstNo = "" OR IsNull(sCstNo) THEN
//	  messagebox('Ȯ ��','�ڷ� ��ȸ�� �߰��ϼ���.!!')
//	  Return
//  End If
//Else
//  messagebox('Ȯ ��','�ڷ� ������ �߰��ϼ���.!!')
//  Return
//END IF
//
//nRow = dw_list.InsertRow(0)
//
//dw_list.SetItem(nRow, "sabu",  gs_sabu)
//dw_list.SetItem(nRow, "cstno", sCstNo)
//dw_list.SetItem(nRow, "cstseq", sCstSeq)
//
//dw_list.ScrollToRow(nRow)
//	
//dw_list.SetFocus()
//dw_list.SetItemStatus(nRow,0, Primary!, NotModified!)
//dw_list.SetItemStatus(nRow,0, Primary!, New!)
//
end event

type cb_del from w_inherite`cb_del within w_sal_01760
boolean visible = false
integer x = 1015
integer y = 2740
integer width = 274
integer taborder = 100
end type

event cb_del::clicked;call super::clicked;//String sItnbr
//Integer nRow
//
//nRow = dw_list.GetRow()
//IF nRow <=0 THEN
//	f_message_chk(36,'')
//	Return
//END IF
//
//sItnbr  = Trim(dw_list.GetItemString(nRow, 'itnbr'))
//
//IF F_Msg_Delete() = -1 THEN Return
//
//IF rb_new.Checked = False THEN
//	If wf_delete_detail(nRow, sItnbr) <> 1 Then
//		f_message_chk(31,'')
//		ROLLBACK;
//		Return
//	END IF
//
//	dw_list.DeleteRow(nRow)
//	IF dw_list.Update() <> 1 THEN
//		f_message_chk(31,'')
//		ROLLBACK;
//		Return
//	END IF
//	
//	COMMIT;
//Else
//	dw_list.DeleteRow(nRow)
//END IF
//
//dw_list.SetColumn("itnbr")
//dw_list.SetFocus()
//
//sle_msg.text = '�ڷḦ �����Ͽ����ϴ�!!'
//
end event

type cb_inq from w_inherite`cb_inq within w_sal_01760
boolean visible = false
integer x = 215
integer y = 2740
integer width = 297
integer taborder = 110
end type

event cb_inq::clicked;call super::clicked;//String sCstNo, sCstSeq, sCfmdate
//
//If rb_new.Checked = True Then Return
//
//If dw_insert.AcceptText() <> 1 Then Return
//
//sCstNo  = Trim(dw_insert.GetItemString(1,'cstno'))
//sCstSeq = Trim(dw_insert.GetItemString(1,'cstseq'))
//
//If IsNull(sCstNo) Or sCstNo = '' Then
//	f_message_chk(30,'[����ȣ]')
//	Return
//End If
//
//If IsNull(sCstSeq) Or sCstSeq = '' Then
//	f_message_chk(30,'[�׹�]')
//	Return
//End If
//
///* �׹��߰� �ϰ�� �ִ������ ���Ѵ� */
//If rb_ins.Checked = True Then
//	SELECT MAX("CSTSEQ")  INTO :sCstSeq
//	  FROM "CALCSTH"  
//	 WHERE ( "SABU" = :gs_sabu ) AND
//			 ( "CSTNO" = :sCstNo);
//
//	If IsNull(sCstSeq) Then sCstSeq = '00'
//	
//	sCstSeq = String(Long(sCstSeq) + 1,'00')
//	
//	dw_insert.SetItem(1, 'cstseq', sCstSeq)
//	
//	dw_insert.SetItemStatus(1,0, Primary!, NewModified!)
//	
//	/* �׹��߰��� ������ ���� ��������� �����ؾ��� */
//	ib_any_typing = True
//Else
//	/* ��ȸ */
//	If dw_insert.Retrieve(gs_sabu, sCstNo, sCstSeq) <= 0 Then
//		f_message_chk(50,'')
//		dw_insert.SetColumn("cstno")
//		dw_insert.SetFocus()
//		wf_init('U')
//		Return
//	Else
//		dw_insert.Modify('cstdat.protect = 1')
//		dw_insert.Modify("cstdat.background.color = 80859087")
//	
//		/* �������� ��ȸ */
//		dw_list.Retrieve(gs_sabu, sCstNo, sCstSeq)
//	END IF
//End If
//
//dw_insert.Modify('cstno.protect = 1')
//dw_insert.Modify("cstno.background.color = 80859087")
//dw_insert.Modify('cstseq.protect = 1')
//dw_insert.Modify("cstseq.background.color = 80859087")
//	
///* �������� */
//sCfmdate = dw_insert.GetItemString(1, 'cfmdate')
//If Not IsNull(sCfmDate) Then
//	cb_search.Enabled = False
//	cb_alldel.Enabled = False
//	cb_del.Enabled = False
//	cb_ins.Enabled = False
//	cb_mod.Enabled = False
//Else
//	cb_search.Enabled = True
//	cb_alldel.Enabled = True
//	cb_del.Enabled = True
//	cb_ins.Enabled = True
//	cb_mod.Enabled = True
//End If
//
////If dw_list.RowCount() > 0 Then
////	dw_list.SetFocus()
////	dw_list.ScrollToRow(1)
////	dw_list.SetRow(1)
////End If
end event

type cb_print from w_inherite`cb_print within w_sal_01760
boolean visible = false
integer x = 3483
integer y = 3156
integer width = 411
integer taborder = 120
string text = "����ȸ(&P)"
end type

event cb_print::clicked;call super::clicked;//String sCstNo, sCstSeq, sItnbr
//Long   nRow
//Dec    dPrsCost, dRtnCost
//
//If dw_list.AcceptText() <> 1 Then Return
//
//If wf_req_chk('H') <> 1 Then Return
//
//nRow = dw_list.GetRow()
//If nRow <= 0 Then Return
//
//Choose Case dw_list.GetItemStatus(nRow,0, Primary!)
//	Case New!, NewModified!
//		MessageBox('Ȯ ��','������ �����Է��� �����մϴ�.!!')
//		Return
//End Choose
//
//sCstNo	= Trim(dw_insert.GetItemString(1, 'cstno'))
//sCstSeq	= Trim(dw_insert.GetItemString(1, 'cstseq'))
//
//sItnbr   = dw_list.GetItemString(nRow, 'itnbr')
//dPrsCost = dw_list.GetItemNumber(nRow, 'prscost')	/* ������ */
//
//gs_code = sCstNo
//gs_gubun = sItnbr
//gs_codename = sCstSeq
//
//OpenWithParm(w_sal_01760_gon_popup, dPrsCost)
//dRtnCost = Message.DoubleParm
//
//If gs_code = 'A' Then
//	/* ������� */
//	wf_calc_cst(sCstNo, sCstSeq, '2')
//ElseIf gs_code = 'Y' Then
//	p_inq.TriggerEvent(Clicked!)
//End If
end event

type st_1 from w_inherite`st_1 within w_sal_01760
end type

type cb_can from w_inherite`cb_can within w_sal_01760
boolean visible = false
integer x = 2990
integer taborder = 130
end type

event cb_can::clicked;call super::clicked;
//rb_new.Checked = True
//rb_new.TriggerEvent(Clicked!)
end event

type cb_search from w_inherite`cb_search within w_sal_01760
boolean visible = false
integer x = 3909
integer y = 3156
integer width = 411
integer taborder = 140
string text = "��ü���(&W)"
end type

event cb_search::clicked;call super::clicked;//String sCstNo, sCstSeq, sGubun, sItnbr
//Int    ii
//
//If rb_new.Checked = True Then Return
//
//If dw_insert.AcceptText() <> 1 Then Return
//If dw_list.AcceptText() <> 1 Then Return
//
//If ib_any_typing = True Then
//	MessageBox('Ȯ ��','����� ������ �����ϼ���')
//	Return
//End If
//
//sCstNo  = Trim(dw_insert.GetItemString(1,'cstno'))
//sCstSeq = Trim(dw_insert.GetItemString(1,'cstseq'))
//sItnbr  = Trim(dw_insert.GetItemString(1,'stitnbr'))
//
//If IsNull(sCstNo) Or sCstNo = '' Then
//	f_message_chk(30,'[����ȣ]')
//	Return
//End If
//
//If IsNull(sCstSeq) Or sCstSeq = '' Then
//	f_message_chk(30,'[�׹�]')
//	Return
//End If
//
//setpointer(hourglass!)
//
//sGubun = '1'
//
//If dw_list.RowCount() >= 0 Then
//	/* ����ǰ���� ���� ��� */
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		sGubun = '2'
//	Else
//		ii = MessageBox("Ȯ ��","���������� ������ �ٽ� ����Ͻðڽ��ϱ�?" +"~n~n" +&
//							"YES : ǥ�ذ��� ������  ������� ����" +"~n~n" + &
//							"NO  : ��������������� ������� ����",Question!, YesNoCancel!, 1)
//	
//		If ii = 1 Then
//			sGubun = '1'
//		ElseIf ii = 2 Then
//			sGubun = '2'
//		Else
//			Return
//		End If
//	End If
//	If sGubun = '2' And dw_list.RowCount() <= 0 Then
//		MessageBox('Ȯ ��','���������� ����ϼ���.!!')
//		Return
//	End If
//Else
//	If IsNull(sItnbr) Or sItnbr = '' Then
//		MessageBox('Ȯ ��','���������� ����ϼ���.!!')
//		Return
//	End If
//End If
//
//If sGubun = '1' Then
//	IF MessageBox("Ȯ ��","ǥ�ذ��� ������  ����� �����մϴ�.!!" +"~n~n" +&
//								 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
//Else
//	IF MessageBox("Ȯ ��","��������������� ����� �����մϴ�.!!" +"~n~n" +&
//								 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
//End If
//
///* ������� */
//wf_calc_cst(sCstNo, sCstSeq, sGubun)
end event







type gb_button1 from w_inherite`gb_button1 within w_sal_01760
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01760
end type

type rb_new from radiobutton within w_sal_01760
integer x = 3346
integer y = 248
integer width = 261
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "�ű�"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init('I')
end event

type rb_ins from radiobutton within w_sal_01760
integer x = 3346
integer y = 324
integer width = 315
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "�׹��߰�"
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init('H')
end event

type rb_upd from radiobutton within w_sal_01760
integer x = 3346
integer y = 400
integer width = 261
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "����"
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init('U')
end event

type dw_list from u_key_enter within w_sal_01760
event ue_key pbm_dwnkey
integer x = 114
integer y = 1192
integer width = 4411
integer height = 1104
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_017602"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event constructor;call super::constructor;//Modify("ispec_t.text = '" + f_change_name('2') + "'" )
//Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

event itemerror;call super::itemerror;REturn 1
end event

event rowfocuschanged;call super::rowfocuschanged;Long nRow

nRow = GetRow()
If nRow <= 0 Then Return

If GetItemString(nRow, 'gubun') = '2' Then
	p_print.Enabled = True
	p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
Else
	p_print.Enabled = False
	p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
End If
end event

event itemchanged;Long nRow, nfind

String sItnbr, sItdsc, sIspec, sJiJil, sNull, sItgu, sIspecCode
String sCvcod, sOpseq, sCvnas, sCurr, sDate, sGubun, sBalYn, sBalOp
Dec 	 dShrat, dPrice, dcnvfat
Int    ireturn


nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* ǰ�� */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)

		If Not IsNull(sItnbr) Then
			nFind = Find("itnbr = '" + sItnbr + "'", 1, RowCount())
			If nFind > 0 And ( nFind <> nRow) Then
				f_message_chk(49,'')
				Return 2
			End If
			
			 SELECT "ITGU", "SHRAT"
				INTO :sItgu, :dShrat
				FROM "ITEMAS"
			  WHERE "ITEMAS"."ITNBR" = :sItnbr ;
			  
			If sItgu = '5' then
				sItgu = '2' 
			ElseIf sItgu = '6' then
				sItgu = '3'
			Else
				sItgu = '1'
			End If
			SetItem(nrow,"gubun", sItgu)
			SetItem(nrow,"shrat", dShrat)
		Else
			/* �������� */
			sItnbr = GetItemString(nRow, 'itnbr')
			If wf_delete_detail(nRow, sItnbr) <> 1 Then
				SetItem(nRow, "itnbr", sitnbr)
				Return 1
			End If
		End If

		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		/* ����ǰ�� ��� ����ȸ ���� */
		If sItgu = '2' Then
			p_print.Enabled = True
			p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
		Else
			p_print.Enabled = False
			p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
		End If
		RETURN ireturn
	/* ǰ�� */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If Not IsNull(sItnbr) Then
			nFind = Find("itnbr = '" + sItnbr + "'", 1, RowCount())
			If nFind > 0 And ( nFind <> nRow) Then
				f_message_chk(49,'')
				Return 2
			End If
			
			 SELECT "ITGU", "SHRAT"
				INTO :sItgu, :dShrat
				FROM "ITEMAS"
			  WHERE "ITEMAS"."ITNBR" = :sItnbr ;
			  
			If sItgu = '5' then
				sItgu = '2' 
			ElseIf sItgu = '6' then
				sItgu = '3'
			Else
				sItgu = '1'
			End If
			SetItem(nrow,"gubun", sItgu)
			SetItem(nrow,"shrat", dShrat)
		Else
			/* �������� */
			sItnbr = GetItemString(nRow, 'itnbr')
			If wf_delete_detail(nRow, sItnbr) <> 1 Then
				SetItem(nRow, "itnbr", sitnbr)
				Return 1
			End If
		End If
		
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		/* ����ǰ�� ��� ����ȸ ���� */
		If sItgu = '2' Then
			p_print.Enabled = True
			p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
		Else
			p_print.Enabled = False
			p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
		End If
		RETURN ireturn
	/* �԰� */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If Not IsNull(sItnbr) Then
			nFind = Find("itnbr = '" + sItnbr + "'", 1, RowCount())
			If nFind > 0 And ( nFind <> nRow) Then
				f_message_chk(49,'')
				Return 2
			End If
			
			 SELECT "ITGU", "SHRAT"
				INTO :sItgu, :dShrat
				FROM "ITEMAS"
			  WHERE "ITEMAS"."ITNBR" = :sItnbr ;
			  
			If sItgu = '5' then
				sItgu = '2' 
			ElseIf sItgu = '6' then
				sItgu = '3'
			Else
				sItgu = '1'
			End If
			SetItem(nrow,"gubun", sItgu)
			SetItem(nrow,"shrat", dShrat)
		Else
			/* �������� */
			sItnbr = GetItemString(nRow, 'itnbr')
			If wf_delete_detail(nRow, sItnbr) <> 1 Then
				SetItem(nRow, "itnbr", sitnbr)
				Return 1
			End If
		End If
		
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		/* ����ǰ�� ��� ����ȸ ���� */
		If sItgu = '2' Then
			p_print.Enabled = True
			p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
		Else
			p_print.Enabled = False
			p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
		End If
		
		RETURN ireturn
	/* ���� */
	Case "jijil"
		sJijil = trim(GetText())
	
		ireturn = f_get_name4('����', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If Not IsNull(sItnbr) Then
			nFind = Find("itnbr = '" + sItnbr + "'", 1, RowCount())
			If nFind > 0 And ( nFind <> nRow) Then
				f_message_chk(49,'')
				Return 2
			End If
			
			 SELECT "ITGU", "SHRAT"
				INTO :sItgu, :dShrat
				FROM "ITEMAS"
			  WHERE "ITEMAS"."ITNBR" = :sItnbr ;
			  
			If sItgu = '5' then
				sItgu = '2' 
			ElseIf sItgu = '6' then
				sItgu = '3'
			Else
				sItgu = '1'
			End If
			SetItem(nrow,"gubun", sItgu)
			SetItem(nrow,"shrat", dShrat)
		Else
			/* �������� */
			sItnbr = GetItemString(nRow, 'itnbr')
			If wf_delete_detail(nRow, sItnbr) <> 1 Then
				SetItem(nRow, "itnbr", sitnbr)
				Return 1
			End If
		End If
		
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		/* ����ǰ�� ��� ����ȸ ���� */
		If sItgu = '2' Then
			p_print.Enabled = True
			p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
		Else
			p_print.Enabled = False
			p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
		End If
		
		RETURN ireturn
	/* �԰��ڵ� */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If Not IsNull(sItnbr) Then
			nFind = Find("itnbr = '" + sItnbr + "'", 1, RowCount())
			If nFind > 0 And ( nFind <> nRow) Then
				f_message_chk(49,'')
				Return 2
			End If
			
			 SELECT "ITGU", "SHRAT"
				INTO :sItgu, :dShrat
				FROM "ITEMAS"
			  WHERE "ITEMAS"."ITNBR" = :sItnbr ;
			  
			If sItgu = '5' then
				sItgu = '2' 
			ElseIf sItgu = '6' then
				sItgu = '3'
			Else
				sItgu = '1'
			End If
			SetItem(nrow,"gubun", sItgu)
			SetItem(nrow,"shrat", dShrat)
		Else
			/* �������� */
			sItnbr = GetItemString(nRow, 'itnbr')
			If wf_delete_detail(nRow, sItnbr) <> 1 Then
				SetItem(nRow, "itnbr", sitnbr)
				Return 1
			End If
		End If
		
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		
		/* ����ǰ�� ��� ����ȸ ���� */
		If sItgu = '2' Then
			p_print.Enabled = True
			p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
		Else
			p_print.Enabled = False
			p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
		End If
		
		RETURN ireturn
	Case 'gubun'
		sGubun  = Trim(GetText())
		If sGubun = '2' Then
			SetItem(nRow, 'cvcod', sNull)
			SetItem(nRow, 'cvnas2', sNull)
			
			p_print.Enabled = True
			p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
		Else
			p_print.Enabled = False
			p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
		End If
	/* �ܰ� �ŷ�ó */
	Case "cvcod"
		sCvcod  = Trim(GetText())
		sItnbr  = GetItemString(nRow, "itnbr")
		sOpseq  = '9999'
		
		If IsNull(sItnbr) Or sItnbr = '' Then
			MessageBox('Ȯ ��','ǰ���� ���� ����ϼ���.!!')
			SetColumn('itnbr')
			Return 1
		End If
		
		If sCvcod = "" Or isnull(sCvcod) Then
			SetItem(nRow, "CVCOD", SNULL)
			SetItem(nRow, "CVNAS2", SNULL)
			SetItem(nRow, "cstamt", 0)
			Return 
		End If
			
		/* �ŷ�ó Ȯ�� */
		SELECT A.CVNAS  INTO :sCvnas
		  FROM "VNDMST" A
		 WHERE A.CVCOD = :sCvcod
			AND A.CVGU IN ('1','2','9'); 
			 
		IF SQLCA.SQLCODE <> 0 THEN
			SetItem(nRow, "CVCOD",  SNULL)
			SetItem(nRow, "CVNAS2", SNULL)
			SetItem(nRow, "cstamt",  0)
			F_MESSAGE_CHK(33, '[�ŷ�ó]')
			RETURN 1
		END IF
		
		SetItem(nRow, "CVNAS2", sCvnas)
	
		/* �ܰ����� Ȯ�� */
		SELECT NVL(B.UNPRC, 0), cunit
		  INTO :dPrice, :sCurr
		  FROM DANMST B
		 WHERE B.ITNBR	   = :sItnbr 
			AND B.OPSEQ    = :SOPSEQ
			AND B.CVCOD 	= :sCvcod; 

		If IsNull(dPrice) Then dPrice = 0
		If IsNull(sCurr)  Then sCurr = 'WON'

		If sCurr <> 'WON' Then
			sDate = Left(is_today,6)
			dPrice = sqlca.erp000000090_1(sDate, sItnbr, sCurr, dPrice, '2')
			If IsNull(dPrice) Then dPrice = 0
		End If
		
		/* ���� : ���Ŀ� ��ȯ��� ����Ұ� */
		select substr(dataname,1,1) into :sbalyn from syscnfg
		 where sysgu = 'Y' and
				 serial = 12 and
				 lineno = '3';

		select substr(dataname,1,1) into :sbalop from syscnfg
		 where sysgu = 'Y' and
				 serial = 12 and
				 lineno = '4';

		/* ���Ŵܰ� : ��ȯ��� ��� */
		If sbalyn = 'Y' then
			select nvl(cnvfat,1) into :dcnvfat
           from itemas
          where itnbr = sItnbr;

			If IsNull(dCnvFat) or dcnvfat = 0 then 
				dcnvfat = 1
		   end if

			If sbalop = '*' then
				dPrice = truncate(dPrice * dcnvfat, 2)
			else
				dPrice = truncate(dPrice / dcnvfat, 2)
			End If
		else
			dPrice = truncate(dPrice, 2)
		end if
		
		SetItem(nRow, "matcost", dPrice)
		
		Post wf_set_cost(nRow)
	/* �ҷ���, ����, ���� ����� �ݾ� ��� */
	Case 'shrat', 'cstqty', 'matcost'
		Post wf_set_cost(nRow)

End Choose

ib_any_typing = True
end event

event rbuttondown;Long nRow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

choose case getcolumnname()
   case "itnbr"
		open(w_itemas_popup)	
		if gs_code="" or isnull(gs_code) then return
		
		setitem(nRow, "itnbr", gs_code)
	
		setfocus()
		setcolumn('itnbr')
		postevent(itemchanged!)
	Case 'cvcod'
		w_mdi_frame.sle_msg.text = '�Ϲ� �ŷ�ó ��ȸ�� F2 KEY �� ��������!'
		
		gs_code 		= getitemstring(nRow, "itnbr")
		gs_codename = '9999'	
		Open(w_danmst_popup)
	
		IF gs_code = '' or isnull(gs_code) then return 
	
		SetItem(nRow,"cvcod",  gs_code)
//		SetItem(nRow,"cstamt", Dec(gs_codename))
		
		setnull(gs_code)
		setnull(gs_codename)
	
		this.TriggerEvent("itemchanged")
end choose

end event

event clicked;call super::clicked;Long nRow

nRow = GetRow()
If nRow <= 0 Then Return

If GetItemString(nRow, 'gubun') = '2' Then
	p_print.Enabled = True
	p_print.PictureName = 'C:\erpman\image\����ȸ_up.gif'
Else
	p_print.Enabled = False
	p_print.PictureName = 'C:\erpman\image\����ȸ_d.gif'
End If
end event

type gb_4 from groupbox within w_sal_01760
boolean visible = false
integer x = 2953
integer y = 2688
integer width = 759
integer height = 196
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_sal_01760
integer x = 1522
integer y = 2912
integer width = 1330
integer height = 196
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_sal_01760
boolean visible = false
integer x = 681
integer y = 2688
integer width = 919
integer height = 196
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_sal_01760
boolean visible = false
integer x = 187
integer y = 2688
integer width = 352
integer height = 196
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type cb_alldel from commandbutton within w_sal_01760
boolean visible = false
integer x = 3049
integer y = 3156
integer width = 411
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ü����(&A)"
end type

event cb_alldel::clicked;call super::clicked;//call super::clicked;String sCstNo, sCstSeq
//
//sCstNo  = Trim(dw_insert.GetItemString(1,'cstno'))
//sCstSeq = Trim(dw_insert.GetItemString(1,'cstseq'))
//
//IF F_Msg_Delete() = -1 THEN Return
//
///* �����ڷ� ���� */
//DELETE FROM CALCSTH WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
//If Sqlca.sqlcode<> 0 Then
//	RollBack;
//	f_message_chk(160,'')
//End If
//
//DELETE FROM CALCSTD WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
//If Sqlca.sqlcode<> 0 Then
//	RollBack;
//	f_message_chk(160,'')
//End If
//
//DELETE FROM CALCSTU WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
//If Sqlca.sqlcode<> 0 Then
//	RollBack;
//	f_message_chk(160,'')
//End If
//
//DELETE FROM CALCSTP WHERE SABU = :gs_sabu AND CSTNO = :sCstNo AND CSTSEQ = :sCstSeq;
//If Sqlca.sqlcode<> 0 Then
//	RollBack;
//	f_message_chk(160,'')
//End If
//
//COMMIT;
//
//p_can.TriggerEvent(Clicked!)
//
//w_mdi_frame.sle_msg.Text = '�ڷḦ �����Ͽ����ϴ�.!!'
end event

type st_2 from statictext within w_sal_01760
integer x = 114
integer y = 1140
integer width = 1111
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[��������]    * �ݾ��� ��������ݾ� ǥ��"
boolean focusrectangle = false
end type

type rb_copy from radiobutton within w_sal_01760
integer x = 3346
integer y = 476
integer width = 261
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "����"
borderstyle borderstyle = stylelowered!
end type

event clicked;Post wf_copy_calcst()
end event

type rr_1 from roundrectangle within w_sal_01760
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 1124
integer width = 4457
integer height = 1180
integer cornerheight = 40
integer cornerwidth = 55
end type

