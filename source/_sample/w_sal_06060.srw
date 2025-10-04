$PBExportHeader$w_sal_06060.srw
$PBExportComments$��������
forward
global type w_sal_06060 from w_inherite
end type
type dw_key from datawindow within w_sal_06060
end type
type dw_1 from datawindow within w_sal_06060
end type
type p_1 from uo_picture within w_sal_06060
end type
type p_2 from uo_picture within w_sal_06060
end type
type pb_1 from u_pb_cal within w_sal_06060
end type
type pb_2 from u_pb_cal within w_sal_06060
end type
type rr_1 from roundrectangle within w_sal_06060
end type
type rr_2 from roundrectangle within w_sal_06060
end type
type rr_3 from roundrectangle within w_sal_06060
end type
end forward

global type w_sal_06060 from w_inherite
string title = "������ ���"
dw_key dw_key
dw_1 dw_1
p_1 p_1
p_2 p_2
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_06060 w_sal_06060

type variables

end variables

forward prototypes
public function string wf_get_junpyo_no (string pidate)
public function integer wf_select_blno (integer row, string blno)
public function integer wf_select_ngno (integer row, string ngno)
public function string wf_select_pino (integer row, string arg_pino)
public function double wf_get_piamt (string arg_cino, string arg_pino)
public function integer wf_setting_cipi (integer nrow, string scino)
public function integer wf_select_explcno (integer row, string arg_explcno)
public function integer wf_set_default (string sSaupj)
public function integer wf_check_cvcod (string scvcod)
public subroutine wf_init ()
public subroutine wf_protect_key (integer gubun)
end prototypes

public function string wf_get_junpyo_no (string pidate);String  sOrderNo,sOrderGbn
string  sMaxOrderNo

sOrderGbn = 'X5'     // ä�� 

sMaxOrderNo = String(sqlca.fun_junpyo(gs_sabu,pidate,sOrderGbn),'000')

IF double(sMaxOrderNo) <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF

sOrderNo = pidate + sMaxOrderNo

COMMIT;

Return sOrderNo
end function

public function integer wf_select_blno (integer row, string blno);string s_blno,s_blvndnm,s_blvssl
 
SELECT "EXPBL"."BLNO",   
       FUN_GET_CVNAS("EXPBL"."BLVND"),   
       "EXPBL"."BLVSSL"  
  INTO :s_blno,   
       :s_blvndnm,   
       :s_blvssl  
  FROM "EXPBL"  
 WHERE "EXPBL"."BLNO" = :blno   ;

If sqlca.sqlcode <> 0 Then Return 1
If Len(Trim(s_blno)) <= 0 Or IsNull(s_blno) Then    REturn 1

dw_insert.SetItem(row,'blno',s_blno)

Return 0

end function

public function integer wf_select_ngno (integer row, string ngno);string s_ngno,s_ngbanknm,s_refno
dec    d_ngamt
  
  SELECT "EXPNEGOH"."NGNO",   
         FUN_GET_CVNAS("EXPNEGOH"."NGBANK"),
         "EXPNEGOH"."REFNO",   
         "EXPNEGOH"."NGAMT"  
    INTO :s_ngno,   
         :s_ngbanknm,   
         :s_refno,   
         :d_ngamt  
    FROM "EXPNEGOH"  
   WHERE ( "EXPNEGOH"."SABU" = :gs_sabu ) AND  
         ( "EXPNEGOH"."NGNO" = :ngno )   ;

If sqlca.sqlcode <> 0 Then Return 1
If Len(Trim(s_ngno)) <= 0 Or IsNull(s_ngno) Then  REturn 1

If IsNull(s_ngno)    Then s_ngno = ''
If IsNull(s_ngbanknm) Then s_ngbanknm = ''
If IsNull(s_refno)  Then s_refno = ''
If IsNull(d_ngamt)  Then d_ngamt = 0.0

dw_insert.SetItem(row,'ngno',s_ngno)

Return 0
end function

public function string wf_select_pino (integer row, string arg_pino);//-----------------------------------------------------------//
// ci detail�� pino�� �����ϴ��� Ȯ��                        //
//-----------------------------------------------------------//
String sCino

SetNull(sCino)

SELECT CINO
  INTO :sCino
  FROM "EXPCID"  
 WHERE ( "EXPCID"."SABU" = :gs_sabu ) AND  
       ( "EXPCID"."PINO" = :arg_pino );

If IsNull(sCino) Or Trim(sCino) = '' then Return sCino

Return sCino

end function

public function double wf_get_piamt (string arg_cino, string arg_pino);/* ------------------------------------------------------- */
/* ����ݾ��� �����´�.(CI �� ���� ��� PI�ݾ�)�� �����´� */
/* ------------------------------------------------------- */
Double dPiamt,dChargeAmt

/* Pi �ݾ׸� ������ ��� */
If IsNull(arg_cino) or Trim(arg_cino) = '' Then 
  SELECT NVL(SUM(NVL("EXPPID"."PIAMT",0)),0)
    INTO :dPiamt  
    FROM "EXPPID"  
   WHERE ( "EXPPID"."SABU" = :gs_sabu ) AND  
         ( "EXPPID"."PINO" = :arg_pino );
Else
	If IsNull(arg_pino) Then
		SELECT NVL(SUM(NVL(CIAMT,0)),0)
		  INTO :dPiamt
		  FROM EXPCID
		 WHERE SABU = :gs_sabu AND
				 CINO = :arg_cino ;
	Else
		SELECT NVL(SUM(NVL(CIAMT,0)),0)
		  INTO :dPiamt
		  FROM EXPCID
		 WHERE SABU = :gs_sabu AND
				 CINO = :arg_cino AND
				 PINO = :arg_pino ;
				 
		SELECT NVL(SUM(NVL(CHRAMT,0)),0)
		  INTO :dChargeAmt
		  FROM EXPCICH
		 WHERE SABU = :gs_sabu AND
				 CINO = :arg_cino AND
				 PINO = :arg_pino ;
	   dPiamt += dChargeAmt
	End If
End If
		
Return dPiamt

end function

public function integer wf_setting_cipi (integer nrow, string scino);/* ------------------------------------------------ */
/* ci,pi no�� setting                               */
/* ------------------------------------------------ */
Long   nMax,ix,itemp, Pos, nCnt, Lrow
string s_ngno,s_cino,s_pino

		
datastore ds
ds = create datastore
ds.dataobject = "d_sal_06060_ds"
ds.settransobject(sqlca)

// �ִ� costseq ����
nMax = 0
For ix = 1 To dw_insert.RowCount()
    itemp = dw_insert.GetItemNumber(ix,'costseq')
    nMax = Max(nMax,itemp)
Next

nCnt = 0
s_ngno = Trim(dw_key.GetItemString(dw_key.GetRow(),'costno'))

Do
	Pos = Pos(sCino,'#')
	If Pos > 0 Then
		s_cino = Left(sCino,pos - 1)
		sCino = Mid(sCino,pos + 1)
	Else
		s_cino = sCino
		sCino = ''
	End If

 	If IsNull(s_cino) or Trim(s_cino) = '' Then Exit

	ds.retrieve(gs_sabu, s_cino)
	For Lrow = 1 to ds.rowcount()
		 s_cino = ds.getitemstring(Lrow, "cino")
		 s_pino = ds.getitemstring(Lrow, "pino")

		If nCnt > 0 Then
			nRow = dw_insert.InsertRow(0)
			nMax = nMax + 1
			dw_insert.SetItem(nRow,'sabu',gs_sabu)
			dw_insert.SetItem(nRow,'costno',s_ngno)
			dw_insert.SetItem(nRow,'costseq',nMax)
		End If
		
		nCnt += 1
		dw_insert.SetItem(nRow,'cino',s_cino)
		dw_insert.SetItem(nRow,'pino',s_pino)
	  	dw_insert.SetItem(nRow,'piamt',wf_get_piamt(s_cino,s_pino))
		  
	Next

	
Loop While Len(sCino) > 1 and Trim(sCino) > ''

destroy ds

Return nCnt
end function

public function integer wf_select_explcno (integer row, string arg_explcno);String sExplcno

  SELECT "EXPLC"."EXPLCNO"  
    INTO :sExplcno  
    FROM "EXPLC"  
   WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
         ( "EXPLC"."EXPLCNO" = :arg_explcno )   ;

If sqlca.sqlcode <> 0 Then Return 1
If Len(Trim(sExplcno)) <= 0 Or IsNull(sExplcno) Then    REturn 1

dw_insert.SetItem(row,'explcno',sExplcno)

Return 0

end function

public function integer wf_set_default (string sSaupj);String sDataName, sDeptName

If dw_key.RowCount() <= 0 Then Return 0

dw_key.SetFocus()

/* �ڻ��ڵ� */
select rfna2 into :sDataName
  from reffpf
 where rfcod = '6B' and
       rfna4 = 1 and
		 rfna3 = :sSaupj;
		 
dw_key.SetItem(1,'jacod',sDataName)

/* ����μ� */
select rfna2 into :sDataName
  from reffpf
 where rfcod = '6B' and
       rfna4 = 2 and
		 rfna3 = :sSaupj;

dw_key.SetColumn('cdept_cd')
dw_key.SetItem(1,'cdept_cd',sDataName)

SELECT "P0_DEPT"."DEPTNAME2"
  INTO :sDeptName
  FROM "P0_DEPT"  
WHERE "P0_DEPT"."DEPTCODE" = :sDataName AND "P0_DEPT"."USETAG" ='1';

dw_key.SetItem(1,"p0_dept_deptname2",sDeptName)


/* �����ι� */
select rfna2 into :sDataName
  from reffpf
 where rfcod = '6B' and
       rfna4 = 3 and
		 rfna3 = :sSaupj;

dw_key.SetColumn('edept_cd')
dw_key.SetItem(1,'edept_cd',sDataName)

SELECT "CIA02M"."COST_NM"
  INTO :sDeptName
  FROM "CIA02M"  
WHERE "CIA02M"."COST_CD" = :sDataName AND "CIA02M"."USEGBN" ='1';

dw_key.SetItem(1,"cost_nm",sDeptName)

Return 0
end function

public function integer wf_check_cvcod (string scvcod);String sCustName, sCustSano, sCustUpTae, sCustUpjong, sCustOwner,	sCustResident
String sCustAddr,	sCustGbn,  sTaxGu
			 
	SELECT "VNDMST"."CVNAS",         "VNDMST"."SANO", 		 		"VNDMST"."UPTAE",   
			 "VNDMST"."JONGK",  		   "VNDMST"."OWNAM",				"VNDMST"."RESIDENT",   
			 NVL("VNDMST"."ADDR1",' ')||NVL("VNDMST"."ADDR2",' '),"VNDMST"."CVGU",
			 "VNDMST"."TAX_GU"
	  INTO :sCustName,   			  :sCustSano,   					:sCustUpTae,
		 	 :sCustUpjong,   			  :sCustOwner,   					:sCustResident,
			 :sCustAddr,   													:sCustGbn,
			 :sTaxGu
	  FROM "VNDMST"  
	 WHERE "VNDMST"."CVCOD" = :sCvcod;

							
/* ���ݰ�꼭�� �ŷ�ó���� �̵�Ͻ� ���� */
If ( IsNull(sCustSano) or Trim(sCustSano) = '' ) and & 
	( IsNull(sCustResident) or Trim(sCustResident) = '' ) Then
	MessageBox('Ȯ��','�ŷ�ó�� �⺻������ �̺��մϴ�~r~r' + &
							'[����ڵ�Ϲ�ȣ,��ǥ�ڸ�,����,����,�ּҵ��� Ȯ���Ͻʽÿ�]')
	Return 2
End If
	
/* �ŷ�ó��,����,����,�ּ� */
If ( IsNull(sCustName)   or Trim(sCustName)   = '' )   Or &
	( IsNull(sCustUpTae)  or Trim(sCustUpTae)  = ''  )  Or &
	( IsNull(sCustUpjong) or Trim(sCustUpjong) = ''  )  Or &
	( IsNull(sCustAddr)   or Trim(sCustAddr)   = ''  )  Then 
	MessageBox('Ȯ��','�ŷ�ó�� �⺻������ �̺��մϴ�~r~r' + &
							'[����ڵ�Ϲ�ȣ,��ǥ�ڸ�,����,����,�ּҵ��� Ȯ���Ͻʽÿ�]')
	Return 2
End If

Return 0
end function

public subroutine wf_init ();String sDataName

p_inq.Enabled    = True
p_ins.Enabled    = True
p_mod.Enabled    = True
p_search.Enabled = True
p_del.Enabled    = True

p_inq.PictureName  	= "C:\erpman\image\��ȸ_up.gif"
p_ins.PictureName    = "C:\erpman\image\�߰�_up.gif"
p_mod.PictureName    = "C:\erpman\image\����_up.gif"
p_search.PictureName = "C:\erpman\image\����_up.gif"
p_del.PictureName    = "C:\erpman\image\�����_up.gif"

dw_key.enabled	   = True
dw_insert.enabled = True

dw_1.reset()
dw_key.reset()
dw_insert.reset()
dw_key.insertrow(0)
dw_key.setitem(1, "sabu", gs_sabu)
dW_key.object.ab_dpno.visible = '0'
dW_key.object.ab_name.visible = '0'					
dW_key.object.t_13.visible = '0'	

wf_protect_key(0)
  
ib_any_typing = False

dw_key.setcolumn("costno")
dw_key.setfocus()


// �ΰ��� ����� ����
f_mod_saupj(dw_key, 'saupj')

end subroutine

public subroutine wf_protect_key (integer gubun);if gubun = 1 then  /* �����׸� ���� �Է����� */
	dw_key.object.costno.protect 		= 1
	dw_key.object.iseq.protect   		= 1	
	dw_key.object.costdt.protect   	= 1	
	dw_key.object.saupj.protect   	= 1	
	dw_key.object.cdept_cd.protect   = 1	
	dw_key.object.edept_cd.protect    = 1	
	dw_key.object.costvnd.protect   	= 1		
	dw_key.object.jacod.protect   	= 1		
Else
	dw_key.object.costno.protect 		= 0
	dw_key.object.iseq.protect   		= 0	
	dw_key.object.costdt.protect   	= 0	
	dw_key.object.saupj.protect   	= 0	
	dw_key.object.cdept_cd.protect   = 0	
	dw_key.object.edept_cd.protect   	= 0	
	dw_key.object.costvnd.protect   	= 0		
	dw_key.object.jacod.protect   	= 0		
End if
end subroutine

on w_sal_06060.create
int iCurrent
call super::create
this.dw_key=create dw_key
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_key
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
end on

on w_sal_06060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_key)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_key.SetTransObject(sqlca)
dw_key.InsertRow(0)

dw_insert.SetTransObject(sqlca)
dw_1.settransobject(sqlca)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_sal_06060
integer x = 50
integer y = 1636
integer width = 4530
integer height = 680
integer taborder = 20
string dataobject = "d_sal_06060_d"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;String sData,sCino
int    nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'cino'
		gs_code = 'A'
		gs_gubun = 'A'
		Open(w_expci_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 1

//      /* ���õ� ������ 1���� ��� */
//		If gs_gubun = '1' Then
//		   SetItem(nrow,'cino',gs_code)
//		   SetItem(nrow,'pino',gs_codename)
//			SetItem(nrow,'piamt',wf_get_piamt(gs_code,gs_codename))
//		Else
			wf_setting_cipi(nRow, gs_code)
//		End If
	Case 'pino'
      open(w_exppih_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 1
		
		SetItem(nRow,'pino',gs_code)
		
		sCino = wf_select_pino(nRow,gs_code)
		SetItem(nRow,'cino',sCino)
		SetItem(nRow,'piamt',wf_get_piamt(sCino,gs_code))
   /* bl ������ȣ ���� popup */
   Case "blno"
   	Open(w_expbl_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"blno",gs_code)
   /* nego ������ȣ ���� popup */
	Case "ngno"
   	Open(w_expnego_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"ngno",gs_code)
   /* lc ������ȣ ���� popup */
	Case "explcno"
   	Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"explcno",gs_code)
End Choose

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sCino,sPino, sData
Long   nRow

nRow  = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'cino'
		sCino = Trim(GetText())
		If IsNull(sCino) Or sCino = '' Then 
			MessageBox('Ȯ ��','������ư���� �����Ͻñ� �ٶ��ϴ�')
			p_del.SetFocus()
			Return 2
		End If
		
		/* CI No�� Invoice�ݾ� ���� */
		If wf_setting_cipi(nRow, sCino) <= 0 Then		Return 2
	Case 'pino'
		sPino = Trim(GetText())
		If IsNull(sPino) Or sPino = '' Then 
			MessageBox('Ȯ ��','������ư���� �����Ͻñ� �ٶ��ϴ�')
			p_del.SetFocus()
			Return 2
		End If
		
		sCino = wf_select_pino(nRow,sPino)
		SetItem(nRow,'cino',sCino)
		If IsNull(sCino) or sCino = '' Then
			SELECT PINO Into :sPino FROM EXPPIH WHERE PINO = :sPino;
			If sqlca.sqlcode <> 0 Then
  			  f_message_chk(98,'[P/I NO]')
			  Return 1
		   End If
		End If

		SetItem(nRow,'piamt',wf_get_piamt(sCino,sPino))
	Case 'blno'  // bl������ȣ
		sData = Trim(GetText())
		If IsNull(sData) or sData = '' Then Return
			
		If wf_select_blno(nRow,Trim(GetText())) <> 0 Then
			f_message_chk(33,'[B/L No.]')
			Return 1
		End If
	Case 'ngno'  // nego ������ȣ
		sData = Trim(GetText())
		If IsNull(sData) or sData = '' Then Return
		
		If wf_select_ngno(nRow,Trim(GetText())) <> 0 Then
			f_message_chk(33,'[Nego No.]')
			Return 1
		End If
	Case 'explcno'  // explcno ������ȣ
		sData = Trim(GetText())
		If IsNull(sData) or sData = '' Then Return
		
		If wf_select_explcno(nRow,Trim(GetText())) <> 0 Then
			f_message_chk(33,'[L/C No.]')
			Return 1
		End If
End Choose

end event

type p_delrow from w_inherite`p_delrow within w_sal_06060
boolean visible = false
integer x = 2167
integer y = 4
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_06060
boolean visible = false
integer x = 1993
integer y = 4
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_06060
integer x = 3899
integer y = 12
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::clicked;call super::clicked;string s_costno,pi_seq
Long   nRow

nRow  = dw_key.GetRow()
If nRow <=0 Then Return
	  
s_costno = Trim(dw_key.GetItemString(nRow,'costno'))
If IsNull(s_costno) Or s_costno = '' Then Return

IF MessageBox("�� ��",s_costno + "�� ��� �ڷᰡ �����˴ϴ�." +"~n~n" +&
  	        	  "���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_key.DeleteRow(0) = 1 Then
	nRow = dw_insert.RowCount()
	dw_insert.RowsMove(1, nRow,  Primary!,dw_insert,1,Delete!)
	IF dw_key.Update() <> 1 THEN
		ROLLBACK;
		Return
	End If
	IF dw_insert.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF		  
END IF
	 
COMMIT;

sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'

wf_init()
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06060
integer x = 3205
integer y = 12
end type

event p_ins::clicked;call super::clicked;string s_cino,s_costno,s_costdt,s_pino
int    nRow,nMax,ix,itemp

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 then Return
If  dw_key.GetRow() <= 0 Then Return

/* ���� */
s_costdt = Trim(dw_key.GetItemString(1,'costdt'))
If f_datechk(s_costdt) <> 1 Then
  f_message_chk(40,'[�߻�����]')
  dw_key.Setfocus()
  dw_key.Setcolumn('costdt')
  Return
End If

nRow = dw_insert.RowCount()
If nRow > 0 Then
  s_cino = Trim(dw_insert.GetItemString(1,'cino'))
  s_pino = Trim(dw_insert.GetItemString(1,'pino'))
  If ( IsNull(s_cino) Or s_cino = '' ) and (  IsNull(s_pino) Or s_pino = '' ) Then
   f_message_chk(1400,'[C/I No.]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.SetColumn('cino')
	Return 1
  End If
End If

// �ִ� costseq ����
nMax = 0
For ix = 1 To nRow
    itemp = dw_insert.GetItemNumber(ix,'costseq')
    nMax = Max(nMax,itemp)
Next
nMax += 1

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow,'sabu',gs_sabu) 
dw_insert.SetItem(nRow,'costseq',nMax)
dw_insert.SetItemStatus(nRow, 0, Primary!, NotModified!)
dw_insert.SetItemStatus(nRow, 0, Primary!, New!)
dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetRow(nRow)
dw_insert.SetColumn('cino')

end event

type p_exit from w_inherite`p_exit within w_sal_06060
integer x = 4421
integer y = 12
end type

type p_can from w_inherite`p_can within w_sal_06060
integer x = 4247
integer y = 12
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_sal_06060
boolean visible = false
integer x = 1755
integer y = 4
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_06060
integer x = 3031
integer y = 12
end type

event p_inq::clicked;call super::clicked;string sCostNo,sCino,sPino
Long   nRow,ix,nCnt, liseq

If dw_key.AcceptText() <> 1 Then return 

nRow  = dw_key.GetRow()
If nRow <=0 Then Return
	  
sCostNo = Trim(dw_key.GetItemString(nRow,'costno'))
If IsNull(sCostNo) Or sCostNo = '' Then
   f_message_chk(1400,'[��������ǥ]')
	Return 1
End If

liseq   = dw_key.GetItemDecimal(nRow,'iseq')
If IsNull(liseq) Or liseq = 0 Then
   f_message_chk(1400,'[��������ǥ]')
	Return 1
End If

If dw_key.Retrieve(gs_sabu,sCostNo,liseq) <= 0 Then
   sle_msg.Text = '��ȸ�� �ڷᰡ �����ϴ�.!!'
	return 
End If

/* ������ �󼼳��� ��ȸ */
ncnt = 0
nCnt = dw_insert.Retrieve(gs_sabu,sCostNo,liseq)
For ix = 1 To nCnt
	sCino = dw_insert.GetItemString(ix,'cino')
	sPino = dw_insert.GetItemString(ix,'pino')
   dw_insert.SetItem(ix,'piamt',wf_get_piamt(sCino,sPino))

Next

/* ȸ��ý��� �̿� Ȯ�� */
ncnt = 0
SELECT COUNT(*)
  INTO :nCnt
  FROM EXPCOSTH 
 WHERE SABU   		= :gs_sabu And
 		 COSTNO	 	= :sCostNo  and
       AC_MOVE		= 'Y';

If nCnt > 0 Then
  sle_msg.Text = '���� ó���� �ڷ��Դϴ�.!!'
//  p_transfer.text  = 'ȸ�����'
  p_inq.Enabled    = False
  p_ins.Enabled    = False
  p_mod.Enabled    = False
  p_search.Enabled = False
  p_del.Enabled    = False
  
  p_inq.PictureName    = "C:\erpman\image\��ȸ_d.gif"
  p_ins.PictureName    = "C:\erpman\image\�߰�_d.gif"
  p_mod.PictureName    = "C:\erpman\image\����_d.gif"
  p_search.PictureName = "C:\erpman\image\����_d.gif"
  p_del.PictureName    = "C:\erpman\image\�����_d.gif"

  dw_key.enabled	  = False
  dw_insert.enabled = False
  return
End If

//p_transfer.text  = 'ȸ������'

dw_1.retrieve(gs_sabu, scostno)

wf_protect_key(1)
dw_key.setfocus()
end event

type p_del from w_inherite`p_del within w_sal_06060
integer x = 4073
integer y = 12
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\�����_up.gif"
boolean focusrectangle = true
end type

event p_del::clicked;call super::clicked;String sCostNo
Long   nRow,nCostSeq

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return

nCostSeq = dw_insert.GetItemNumber(nRow,'costseq')
sCostNo = Trim(dw_insert.GetItemString(nRow,'costno'))
Choose Case dw_insert.GetItemStatus(nRow,0,Primary!)
	Case New!,NewModified!
		dw_insert.DeleteRow(nRow)
	Case Else
		IF MessageBox("�� ��","SEQ : " + String(nRow) + "��°  �ڷᰡ �����˴ϴ�." +"~n~n" +&
							"���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
		
		If dw_insert.DeleteRow(nRow) = 1 Then
			IF dw_insert.Update() <> 1 THEN
				ROLLBACK;
				Return
			END IF
			COMMIT;
		End If	  
End Choose

sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'

end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

type p_mod from w_inherite`p_mod within w_sal_06060
integer x = 3726
integer y = 12
end type

event p_mod::clicked;call super::clicked;String sCostNo,sCostDt,sCurr, sCostGu, sNull, sCdeptCd, sEdeptCd, sSaupj, sCostCd, sGbn1, staxgu, scostjgu 
string svisible
Long   nRow,ix, ncnt
Double dCostAmt,dPiamt

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

/* ������ ��� ���� */
nRow  = dw_key.GetRow()
If nRow <=0 Then Return

SetNull(sNull)

dw_key.Setfocus()

/* �������ڵ� */
svisible = dw_key.object.ab_dpno.visible
if svisible = '1' then
	sgbn1 = Trim(dw_key.GetItemString(nRow,'ab_dpno'))
	If IsNull(sgbn1) Or sgbn1 = '' Then
		f_message_chk(1400,'[�������ڵ�]')
		dw_key.Setcolumn('ab_dpno')
		Return
	End If
end if

/* ���� */
sCostDt = Trim(dw_key.GetItemString(nRow,'costdt'))
If f_datechk(sCostDt) <> 1 Then
	f_message_chk(40,'[�߻�����]')
	dw_key.Setcolumn('costdt')
	Return
End If

/* �ΰ������ */
sSaupj = Trim(dw_key.GetItemString(nRow,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[�ΰ������]')
	dw_key.Setcolumn('saupj')
	Return
End If

/* ��ȭ���� */
sCurr = Trim(dw_key.GetItemstring(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(40,'[��ȭ����]')
	dw_key.Setcolumn('curr')
	Return
End If

/* ����μ� */
sCdeptCd = Trim(dw_key.GetItemstring(1,'cdept_cd'))
If IsNull(sCdeptCd) Or sCdeptCd = '' Then
	f_message_chk(40,'[����μ�]')
	dw_key.Setcolumn('cdept_cd')
	Return
End If

/* �����μ� */
sEdeptCd = Trim(dw_key.GetItemstring(1,'edept_cd'))
If IsNull(sEdeptCd) Or sEdeptCd = '' Then
	f_message_chk(40,'[�����ι�]')
	dw_key.Setcolumn('edept_cd')
	Return
End If

/* ���ݾ� */
If sCurr = 'WON' Then
	dCostAmt = dw_key.GetItemNumber(1,'costamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[���ݾ�]')
		dw_key.Setcolumn('costamt')
		Return
   End If
Else
	dCostAmt = dw_key.GetItemNumber(1,'costforamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[����ȭ�ݾ�]')
		dw_key.Setcolumn('costforamt')
		Return
   End If
End If

/* ��뱸�� */
sCostGu = Trim(dw_key.GetItemString(1,'costgu'))
If IsNull(sCostGu) Or sCostGu = '' Then
	f_message_chk(40,'[��뱸��]')
	dw_key.Setcolumn('costgu')
	Return
End If

/* ����ڵ� */
sCostcd = Trim(dw_key.GetItemString(1,'costcd'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[����ڵ�]')
	dw_key.Setcolumn('costcd')
	Return
End If

/* ��꼭���� */
staxgu = Trim(dw_key.GetItemString(1,'taxgu'))
If IsNull(staxGu) Or staxGu = '' Then
	f_message_chk(40,'[��꼭����]')
	dw_key.Setcolumn('taxgu')
	Return
End If

/* �������� */
scostjgu = Trim(dw_key.GetItemString(1,'costjgu'))
If IsNull(scostjGu) Or scostjGu = '' Then
	f_message_chk(40,'[��������]')
	dw_key.Setcolumn('costjgu')
	Return
End If

/* �������ڵ� */
sCostcd = Trim(dw_key.GetItemString(1,'scodgu'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[�������ڵ�]')
	dw_key.Setcolumn('scodgu')
	Return
End If


/* ��ǥ��ȣ ä�� */
sCostNo = Trim(dw_key.GetItemString(nrow,'costno'))
if IsNull(sCostNo) or trim(sCostNo) = '' then
   sCostNo = wf_get_junpyo_no(sCostDt)
   dw_key.SetItem(nRow,'sabu',gs_sabu)
   dw_key.SetItem(nRow,'costno',sCostNo)
	dw_key.SetItem(nRow,'iseq',1)
	dw_key.SetItem(nRow,'crtgu','1')
	ncnt = 1
Else
	Select Max(iseq) into :nCnt
	  From expcosth  
	 Where sabu = :gs_sabu and costno = :sCostNo;
	If isnull(ncnt) then ncnt = 0
	
	If ncnt = 0 then
		MessageBox("������ ��ǥ��ȣ", "������ ��ǥ��ȣ�� �����ϴ�" + '~n' + &
												  "�űԷ� ����� ��쿡�� ��ǥ��ȣ�� Clear�Ͻʽÿ�", information!)
		Return
	End if
	
	ncnt++
	
	dw_key.setitem(nrow, 'iseq', ncnt)
End If

IF dw_key.Update() <> 1 THEN
	f_message_chk(32,'')
   ROLLBACK;
   Return
END IF

/* ------------------------------------------------ */
/* ������ Detail ����                             */
/* ------------------------------------------------ */
dw_insert.SetFocus()
nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	/* ����ݾ��� ������ ���� */
	dPiamt = dw_insert.GetItemNumber(ix,'piamt')
	If dPiamt = 0 Or IsNull(dPiamt) Then
      dw_insert.DeleteRow(ix)
		Continue
	End If

   /* ���ݾ� */
   If sCurr = 'WON' Then
	   dCostAmt = dw_insert.GetItemNumber(ix,'costamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[���ݾ�]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costamt')
			Return
      End If
   Else
	   dCostAmt = dw_insert.GetItemNumber(ix,'costforamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[���ݾ�]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costforamt')
			Return
      End If
   End If

	dw_insert.SetItem(ix,'costno',sCostNo)
	dw_insert.Setitem(ix,'iseq',ncnt)
Next

IF dw_insert.Update() <> 1 THEN
	f_message_chk(32,'')	
   ROLLBACK;
   Return
END IF

COMMIT;

/* ������ �ű��Է»��·� ���� */
dw_key.SetItemStatus(1, 0, Primary!, New!)
dw_key.SetItem(1, 'costno', sCostNo)
dw_key.setitem(1, 'iseq',   0)
dw_key.SetItem(1, 'costcd', snull)
dw_key.SetItem(1, 'costamt', 0)
dw_key.SetItem(1, 'costvat', 0)
dw_key.SetItem(1, 'costforamt', 0)

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItemStatus(ix, 0, Primary!, New!)
	dw_insert.SetItem(ix, 'costamt', 0)
	dw_insert.SetItem(ix, 'costforamt', 0)
Next

f_message_chk(202,'')
sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'

dw_1.retrieve(gs_sabu, scostno)

wf_protect_key(1)
ib_any_typing = False

dw_key.setfocus()
end event

type cb_exit from w_inherite`cb_exit within w_sal_06060
end type

type cb_mod from w_inherite`cb_mod within w_sal_06060
end type

type cb_ins from w_inherite`cb_ins within w_sal_06060
end type

type cb_del from w_inherite`cb_del within w_sal_06060
end type

type cb_inq from w_inherite`cb_inq within w_sal_06060
end type

type cb_print from w_inherite`cb_print within w_sal_06060
integer x = 1947
integer y = 2548
integer taborder = 110
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_06060
end type

type cb_can from w_inherite`cb_can within w_sal_06060
end type

type cb_search from w_inherite`cb_search within w_sal_06060
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06060
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06060
end type

type dw_key from datawindow within w_sal_06060
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 101
integer y = 204
integer width = 4430
integer height = 784
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06060_h"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string sdate, sdata, sNull, sCostNo, sCostGu, sScodgu, sAcc, sac_move, sgbn1, SACC1, SACC2 
Long   nRow,nCnt, ix, liseq
dec    wrate,urate,weigh, dCostAmt, diseq 
String sIoCust, sIoCustName, sCvBank, sCvdpNo, sDpName
String sDept, sDeptName, scostdt, ssaupj, scdept_cd, sedept_cd, scostvnd, sjacod, staxgu

SetNull(sNull)
sData = Trim(GetText())
nRow = GetRow()
Choose Case GetColumnName()
	/* �ΰ������ */
	Case 'saupj'
		wf_set_default(GetText())
	/* ���Ժ����ǥ��ȣ */
	Case 'costno'
	  sCostNo = Trim(GetText())
	  IF sCostNo = "" OR IsNull(sCostNo) THEN RETURN
		
     SELECT a.costno, a.costdt, a.saupj, a.cdept_cd, a.edept_cd, a.costvnd,
	  			a.jacod, a.taxgu,  count(*) 
		 into :scostno, :scostdt, :ssaupj, :scdept_cd, :sedept_cd, :scostvnd,
		 		:sjacod, :staxgu, :ncnt 
       FROM expcosth a
      WHERE ( a.sabu  	= :gs_sabu ) AND  
            ( a.costno 	= :sCostNo )
      group by a.costno, a.costdt, a.saupj, a.cdept_cd, a.edept_cd, a.costvnd,
	  			a.jacod, a.taxgu;	

	  IF isnull(ncnt) or ncnt = 0 THEN
		  f_message_chk(33,'[�����ǥ��ȣ]')
        SetItem(nRow,'costno',sNull)
		  setitem(1,"costno",	sNull)
		  setitem(1,"iseq",		sNull)
		  setitem(1,"costdt",	sNull)
		  setitem(1,"saupj",		sNull)
		  setitem(1,"cdept_cd",	sNull)
		  setitem(1,"edept_cd",	sNull)
		  setitem(1,"costvnd",	sNull)
		  setitem(1,"jacod",		sNull)
		  setitem(1,"taxgu",	sNull)
		  SetItem(1,"costvndnm",  sNull)
		  SetItem(1,"send_bank",  sNull)
		  SetItem(1,"send_dep",   sNull)
		  SetItem(1,"send_nm",    sNull)
		  SetItem(1,"p0_dept_deptname2",sNull)
		  SetItem(1,"cost_nm",	  sNull)
		  dw_1.reset()
		  wf_protect_key(0)
		  Return 1
	  End If
	  
	  setitem(1,"costno",	scostno)
	  setitem(1,"iseq",		0)
	  setitem(1,"costdt",	scostdt)
	  setitem(1,"saupj",		ssaupj)
	  setitem(1,"cdept_cd",	scdept_cd)
	  setitem(1,"edept_cd",	sedept_cd)	  
	  setitem(1,"costvnd",	scostvnd)
	  setitem(1,"jacod",		sjacod)
	  setitem(1,"taxgu",	staxgu)
	  
		SELECT "VNDMST"."CVNAS2", "VNDMST"."CVBANK", "VNDMST"."CVDPNO", "VNDMST"."DPNAME"
		  INTO :sIoCustName, :sCvBank, :sCvdpNo, :sDpName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :scostvnd;
		 	
		SetItem(1,"costvndnm",  sIoCustName)
		SetItem(1,"send_bank",  sCvBank)
		SetItem(1,"send_dep",   sCvdpno)
		SetItem(1,"send_nm",    sDpName)
		
		SetNull(sdeptname)		
		SELECT "P0_DEPT"."DEPTNAME2"
		  INTO :sDeptName
		  FROM "P0_DEPT"  
		WHERE "P0_DEPT"."DEPTCODE" = :scdept_cd AND "P0_DEPT"."USETAG" ='1';
		SetItem(1,"p0_dept_deptname2",sDeptName)

		SetNull(sdeptname)
		SELECT "CIA02M"."COST_NM"
		  INTO :sDeptName
		  FROM "CIA02M"  
		WHERE "CIA02M"."COST_CD" = :seDept_cd AND "CIA02M"."USEGBN" ='1';
		SetItem(1,"cost_nm",sDeptName)
		
	   dw_1.retrieve(gs_sabu, scostno)
		
	   wf_protect_key(1)		
	  
	/* ���Ժ����ǥ���� */
	Case 'iseq'
	  liseq = Dec(GetText())
	  IF liseq = 0 THEN RETURN

     SELECT ac_move into :sac_move
       FROM "EXPCOSTH"  
      WHERE ( "EXPCOSTH"."SABU"   = :gs_sabu ) AND  
            ( "EXPCOSTH"."COSTNO" = :sCostNo  ) AND
				( "EXPCOSTH"."ISEQ"   = :liseq    ) ;

	  IF sqlca.sqlcode  <> 0 THEN
		 f_message_chk(33,'[�����ǥ��ȣ]')
       SetItem(nRow,'iseq', 0)
		 Return 1
	  End If
	  
	  IF sac_move = 'Y' THEN
		 messagebox("ȸ������", "�̹� ȸ�����۵� ��ǥ�Դϴ�", stopsign!)
       SetItem(nRow,'iseq', 0)
		 Return 1
	  End If	  	  

 	  p_inq.PostEvent(Clicked!)		
	/* �������� */
	Case 'costdt'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'costdt',sNull)
	      Return 1
      END IF

      sdata = GetItemString(row,'curr')
		select rstan,usdrat
		  into :wrate,:urate
		  from ratemt
		 where rdate = :sdate and
		       rcurr = :sdata;

      If IsNull(wrate) Or wrate = 0 Then wrate = 0.0
      If IsNull(urate) Or urate = 0 Then urate = 0.0
		 
		If sqlca.sqlcode = 0 Then
			SetItem(row,'exchrate',wrate)
		Else
			SetItem(row,'exchrate',0)
		End If
		
		Post SetItem(nRow,'costdt',sDate)
	/* ��뱸�� : ��뱸�п� ���� bl,nego,lc number�� �Է¹޴´� */
	Case 'costgu'
		dw_insert.Object.blno.visible = 0
		dw_insert.Object.ngno.visible = 0
		dw_insert.Object.explcno.visible = 0
		dw_insert.Object.stext.text = ''
		Choose Case Trim(GetText())
			Case '2'
				dw_insert.Object.blno.visible = 1
				dw_insert.Object.stext.text = 'B/L No.'
			Case '3'
				dw_insert.Object.ngno.visible = 1
				dw_insert.Object.stext.text = 'Nego No.'
			Case '4'
				dw_insert.Object.explcno.visible = 1
				dw_insert.Object.stext.text = 'L/C No.'
		End Choose
		
		For ix = 1 To dw_insert.RowCount()
			dw_insert.SetItem(ix,'blno',sNull)
			dw_insert.SetItem(ix,'ngno',sNull)
			dw_insert.SetItem(ix,'explcno',sNull)
		Next
		Return 0 
		
	/* �������ó */
	Case 'costvnd'
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"costvndnm",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2", "VNDMST"."CVBANK", "VNDMST"."CVDPNO", "VNDMST"."DPNAME"
		  INTO :sIoCustName, :sCvBank, :sCvdpNo, :sDpName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust;
		 
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			If wf_check_cvcod(sIoCust) <> 0 Then Return 2
			
			SetItem(1,"costvndnm",  sIoCustName)
			SetItem(1,"send_bank",  sCvBank)
			SetItem(1,"send_dep",   sCvdpno)
			SetItem(1,"send_nm",    sDpName)
		END IF
	Case 'curr'
		sDate = dw_key.GetItemString(dw_key.GetRow(),'costdt')

      select x.rstan,x.usdrat, y.rfna2
        into :wrate,:urate, :weigh
        from ratemt x, reffpf y
       where x.rcurr = y.rfgub(+) and
             y.rfcod = '10' and
             x.rdate = :sdate and
             x.rcurr = :sdata;

		If IsNull(wrate) Then wrate = 0.0
		If IsNull(urate) Then urate = 0.0
		If IsNull(weigh) Then weigh = 0.0
		 
		If sqlca.sqlcode = 0 Then
			SetItem(row,'exchrate',wrate)
		Else
			SetItem(row,'exchrate',0)
		End If
	/* ���������� */
	Case 'gyul_date'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'[����������]')
      	SetItem(nRow,'gyul_date',sNull)
	      Return 1
      END IF
	/* ����μ� */
	Case 'cdept_cd'
		sDept = Trim(GetText())
		IF sDept ="" OR IsNull(sDept) THEN
			SetItem(1,"p0_dept_deptname2",sNull)
			Return
		END IF
		
		SELECT "P0_DEPT"."DEPTNAME2"
		  INTO :sDeptName
		  FROM "P0_DEPT"  
		WHERE "P0_DEPT"."DEPTCODE" = :sDept AND "P0_DEPT"."USETAG" ='1';
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"p0_dept_deptname2",sDeptName)
		END IF
	/* �����μ� */
	Case 'edept_cd'
		sDept = Trim(GetText())
		IF sDept ="" OR IsNull(sDept) THEN
			SetItem(1,"cost_nm",sNull)
			Return
		END IF
		
		SELECT "CIA02M"."COST_NM"
		  INTO :sDeptName
		  FROM "CIA02M"  
		WHERE "CIA02M"."COST_CD" = :sDept AND "CIA02M"."USEGBN" ='1';
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"cost_nm",sDeptName)
		END IF
	/* ������ */
	Case 'scodgu'
		sScodgu = Trim(GetText())
		
		SELECT RFNA2 INTO :sAcc
		  FROM REFFPF 
		 WHERE RFCOD = 'EA' AND 
		       RFGUB = :sScodgu;

		If Len(sAcc) > 0 Then
			SetItem(1,'sacc1_cd',Left(sAcc,5))
			SetItem(1,'sacc2_cd',Mid(sAcc,6,2))
			SACC1 = Left(sAcc,5)
			SACC2 = Mid(sAcc,6,2)
		Else
			SetItem(1,'sacc1_cd', sNull )
			SetItem(1,'sacc2_cd', sNull )
			SACC1 = sNull
			SACC2 = sNull
		End If
		
		setitem(1, "ab_dpno", sNull)
		setitem(1, "ab_name", sNull)
		
		SetNull( sGbn1)
		SELECT GBN1 INTO :SGBN1 FROM KFZ01OM0
		 WHERE ACC1_CD = :sacc1 AND ACC2_CD = :sacc2;
		if sgbn1 = '5' then
			object.ab_dpno.visible = '1'		
			object.ab_name.visible = '1'					
			object.t_13.visible = '1'					
		Else
			object.ab_dpno.visible = '0'
			object.ab_name.visible = '0'					
			object.t_13.visible = '0'					
		End if
	/* �������ڵ� */
	Case 'ab_dpno'
		sScodgu = Trim(GetText())
		
		SELECT ab_name INTO :sAcc
		  FROM kfm04ot0
		 WHERE ab_dpno = :sscodgu;

		if sqlca.sqlcode = 0 then
			SetItem(1,'ab_name',sAcc)
		Else
			SetItem(1,'ab_dpno', sNull )
			SetItem(1,'ab_name', sNull )
			MessageBox("�������ڵ�", "�������ڵ尡 ����Ȯ�մϴ�", stopsign!)
			return 1
		End If
		
	/* ����ȭ�ݾ� */
	Case 'costamt'
		dCostAmt = Dec(GetText())
		
		SetItem(1, 'costvat', TrunCate(dcostAmt * 0.1,0))
End Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string s_colnm,sIoCustName, sCvBank, sCvdpNo, sDpName
Double dCostAmt, dCostVat

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

s_colnm = GetColumnName() 
Choose Case s_colnm
	Case "costno"                            // cost ������ȣ ���� popup 
   	Open(w_expcost_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"costno",gs_code)
		SetItem(1,"iseq",  Dec(gs_codename))
	   dw_1.retrieve(gs_sabu, gs_code)		
      p_inq.triggerevent(clicked!)
	/* �������ó */
	Case "costvnd"
		gs_gubun = '2'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		If wf_check_cvcod(gs_code) <> 0 Then Return 2
		
		SetItem(1,"costvnd",gs_code)
		
		SELECT "VNDMST"."CVNAS2", "VNDMST"."CVBANK", "VNDMST"."CVDPNO", "VNDMST"."DPNAME"
		  INTO :sIoCustName, :sCvBank, :sCvdpNo, :sDpName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		 
		IF SQLCA.SQLCODE <> 0 THEN
			Return 2
		ELSE
			SetItem(1,"costvndnm",  sIoCustName)
			SetItem(1,"send_bank",  sCvBank)
			SetItem(1,"send_dep",   sCvdpno)
			SetItem(1,"send_nm",    sDpName)
		END IF
	/* ����μ� */
	Case 'cdept_cd'
		Open(w_dept_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"cdept_cd",gs_code)
		SetItem(1,"p0_dept_deptname2",gs_codename)
	/* �����ι� */
	Case 'edept_cd'
		Open(w_cia02m_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"edept_cd",gs_code)
		SetItem(1,"cost_nm",gs_codename)
	/* ������ ��ǥ*/
	Case 'crossno'
		//��ȸ���� - ��������, ��������, ���Ժμ�
		//           (gs_gubun, gs_codename, gs_code)
		gs_code     = this.getitemstring(1, 'costvnd')
		gs_codename = this.getitemstring(1, 'scodgu')
		gs_gubun    = this.getitemstring(1, 'costdt')
		
		//�ѱݾ�(�ΰ��� + ���ް���) <= �̹����ݾ� �� �ڷḸ ����
		dCostAmt = GetItemNumber(1,'costamt')
		dCostVat = GetItemNumber(1,'costvat')
		If IsNull(dCostAmt) Then dCostAmt = 0
		If IsNull(dCostVat) Then dCostVat = 0
		
		dCostAmt += dCostVat
		
		if gs_code = '' or isnull(gs_code) then 
			messagebox("Ȯ ��", "�������ó�� ���� �����ϼ���!")
			return 
		end if	
		if gs_codename = '' or isnull(gs_codename) then 
			messagebox("Ȯ ��", "�������� ���� �����ϼ���!")
			return 
		end if	
		
		openwithparm(w_kfz19ot0_popup, dCostAmt)
		
		if gs_code = '' or isnull(gs_code) then return 
		
		setitem(1, 'crossno', gs_code)
	/* �������ڵ� */
	Case 'ab_dpno'
		Open(w_kfm04ot0_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"ab_dpno",gs_code)
		SetItem(1,"ab_name",gs_codename)		
END Choose

end event

event dw_key::buttonclicked;call super::buttonclicked;String sCostNo,sCostDt,sCurr, sCostGu, sNull, sCdeptCd, sEdeptCd, sSaupj, sCostCd, sGbn1
string svisible
Long   nRow,ix, ncnt
Double dCostAmt,dPiamt

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

/* ������ ��� ���� */
nRow  = dw_key.GetRow()
If nRow <=0 Then Return

SetNull(sNull)

dw_key.Setfocus()

/* �������ڵ� */
svisible = dw_key.object.ab_dpno.visible
if svisible = '1' then
	sgbn1 = Trim(dw_key.GetItemString(nRow,'ab_dpno'))
	If IsNull(sgbn1) Or sgbn1 = '' Then
		f_message_chk(1400,'[�������ڵ�]')
		dw_key.Setcolumn('ab_dpno')
		Return
	End If
end if

/* ���� */
sCostDt = Trim(dw_key.GetItemString(nRow,'costdt'))
If f_datechk(sCostDt) <> 1 Then
	f_message_chk(40,'[�߻�����]')
	dw_key.Setcolumn('costdt')
	Return
End If

/* �ΰ������ */
sSaupj = Trim(dw_key.GetItemString(nRow,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[�ΰ������]')
	dw_key.Setcolumn('saupj')
	Return
End If

/* ��ȭ���� */
sCurr = Trim(dw_key.GetItemstring(1,'curr'))
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(40,'[��ȭ����]')
	dw_key.Setcolumn('curr')
	Return
End If

/* ����μ� */
sCdeptCd = Trim(dw_key.GetItemstring(1,'cdept_cd'))
If IsNull(sCdeptCd) Or sCdeptCd = '' Then
	f_message_chk(40,'[����μ�]')
	dw_key.Setcolumn('cdept_cd')
	Return
End If

/* �����μ� */
sEdeptCd = Trim(dw_key.GetItemstring(1,'edept_cd'))
If IsNull(sEdeptCd) Or sEdeptCd = '' Then
	f_message_chk(40,'[�����ι�]')
	dw_key.Setcolumn('edept_cd')
	Return
End If

/* ���ݾ� */
If sCurr = 'WON' Then
	dCostAmt = dw_key.GetItemNumber(1,'costamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[���ݾ�]')
		dw_key.Setcolumn('costamt')
		Return
   End If
Else
	dCostAmt = dw_key.GetItemNumber(1,'costforamt')
	If IsNull(dCostAmt) or dCostAmt = 0 Then
		f_message_chk(40,'[����ȭ�ݾ�]')
		dw_key.Setcolumn('costforamt')
		Return
   End If
End If

/* ��뱸�� */
sCostGu = Trim(dw_key.GetItemString(1,'costgu'))
If IsNull(sCostGu) Or sCostGu = '' Then
	f_message_chk(40,'[��뱸��]')
	dw_key.Setcolumn('costgu')
	Return
End If

/* ����ڵ� */
sCostcd = Trim(dw_key.GetItemString(1,'costcd'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[����ڵ�]')
	dw_key.Setcolumn('costcd')
	Return
End If

/* �������ڵ� */
sCostcd = Trim(dw_key.GetItemString(1,'scodgu'))
If IsNull(sCostCd) Or sCostcd = '' Then
	f_message_chk(40,'[�������ڵ�]')
	dw_key.Setcolumn('scodgu')
	Return
End If


/* ��ǥ��ȣ ä�� */
sCostNo = Trim(dw_key.GetItemString(nrow,'costno'))
if IsNull(sCostNo) or trim(sCostNo) = '' then
   sCostNo = wf_get_junpyo_no(sCostDt)
   dw_key.SetItem(nRow,'sabu',gs_sabu)
   dw_key.SetItem(nRow,'costno',sCostNo)
	dw_key.SetItem(nRow,'iseq',1)
	dw_key.SetItem(nRow,'crtgu','1')
	ncnt = 1
Else
	Select Max(iseq) into :nCnt
	  From expcosth  
	 Where sabu = :gs_sabu and costno = :sCostNo;
	If isnull(ncnt) then ncnt = 0
	
	If ncnt = 0 then
		MessageBox("������ ��ǥ��ȣ", "������ ��ǥ��ȣ�� �����ϴ�" + '~n' + &
												  "�űԷ� ����� ��쿡�� ��ǥ��ȣ�� Clear�Ͻʽÿ�", information!)
		Return
	End if
	
	ncnt++
	
	dw_key.setitem(nrow, 'iseq', ncnt)
End If

IF dw_key.Update() <> 1 THEN
	f_message_chk(32,'')
   ROLLBACK;
   Return
END IF

/* ------------------------------------------------ */
/* ������ Detail ����                             */
/* ------------------------------------------------ */
dw_insert.SetFocus()
nRow = dw_insert.RowCount()
For ix = nRow To 1 Step -1
	/* ����ݾ��� ������ ���� */
	dPiamt = dw_insert.GetItemNumber(ix,'piamt')
	If dPiamt = 0 Or IsNull(dPiamt) Then
      dw_insert.DeleteRow(ix)
		Continue
	End If

   /* ���ݾ� */
   If sCurr = 'WON' Then
	   dCostAmt = dw_insert.GetItemNumber(ix,'costamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[���ݾ�]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costamt')
			Return
      End If
   Else
	   dCostAmt = dw_insert.GetItemNumber(ix,'costforamt')
	   If IsNull(dCostAmt) or dCostAmt = 0 Then
			f_message_chk(40,'[���ݾ�]')
			dw_insert.ScrollToRow(ix)
			dw_insert.Setcolumn('costforamt')
			Return
      End If
   End If

	dw_insert.SetItem(ix,'costno',sCostNo)
	dw_insert.Setitem(ix,'iseq',ncnt)
Next

IF dw_insert.Update() <> 1 THEN
	f_message_chk(32,'')	
   ROLLBACK;
   Return
END IF

COMMIT;

/* ������ �ű��Է»��·� ���� */
dw_key.SetItemStatus(1, 0, Primary!, New!)
dw_key.SetItem(1, 'costno', sCostNo)
dw_key.setitem(1, 'iseq',   0)
dw_key.SetItem(1, 'costcd', snull)
dw_key.SetItem(1, 'costamt', 0)
dw_key.SetItem(1, 'costvat', 0)
dw_key.SetItem(1, 'costforamt', 0)

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItemStatus(ix, 0, Primary!, New!)
	dw_insert.SetItem(ix, 'costamt', 0)
	dw_insert.SetItem(ix, 'costforamt', 0)
Next

f_message_chk(202,'')
sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'

dw_1.retrieve(gs_sabu, scostno)

wf_protect_key(1)
ib_any_typing = False

dw_key.setfocus()
end event

type dw_1 from datawindow within w_sal_06060
integer x = 50
integer y = 1072
integer width = 4535
integer height = 528
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06060_hist"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;String scostno
decimal diseq

if row > 0 then
	scostno = getitemstring(row, "costno")
	diseq   = getitemdecimal(row, "iseq")
	dw_key.setitem(1, "costno", scostno)
	dw_key.setitem(1, "iseq",   diseq)

	p_inq.triggerevent(clicked!)
end if
end event

type p_1 from uo_picture within w_sal_06060
integer x = 3378
integer y = 12
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\ȸ������_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\ȸ������_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\ȸ������_up.gif'
end event

event clicked;call super::clicked;Open(w_sal_06060_trs)
end event

type p_2 from uo_picture within w_sal_06060
integer x = 3552
integer y = 12
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\�ڵ����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\�ڵ����_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\�ڵ����_up.gif'
end event

event clicked;call super::clicked;/* ---------------------------------------------------- */
/* �������� CI,PI �ݾ׿� ���� ����Ѵ�                */
/* EXPCOSTH -> EXPCOSTD                                 */
/* ---------------------------------------------------- */
Long nCnt,ix
Double dCostAmt,dCostForAmt,dSumAmtd,dSumForAmtd
Double dPiamt,dDivRate,dCostAmtd,dCostForAmtd, dCostVat
Double dSumTotAmt
String sCurr

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
If dw_key.RowCount() <= 0 Then Return

nCnt = dw_insert.RowCount()
If nCnt <= 0 Then
	f_message_chk(161,'')
	Return
End If

dw_key.SetFocus()
/* ��ȭ������ ���� ����ϴ� ������ ���� */
sCurr = dw_key.GetItemString(1,'curr')
If IsNull(sCurr) Or sCurr = '' Then
	f_message_chk(40,'[��ȭ]')
	dw_key.SetColumn('curr')
	Return
End If

/* ����� ���ݾ� */
dCostAmt = dw_key.GetItemNumber(1,'costamt')
dCostVat = dw_key.GetItemNumber(1,'costvat')
dCostForAmt = dw_key.GetItemNumber(1,'costforamt')
If sCurr = 'WON' Then
  If IsNull(dCostAmt) Or dCostAmt = 0 Then
	 f_message_chk(40,'[���ݾ�]')
	 dw_key.SetColumn('costamt')
	 Return
  End If
  
  If IsNull(dCostVat) Then dCostVat = 0
  dCostAmt += dCostVat
Else
  If IsNull(dCostForAmt) Or dCostForAmt = 0 Then
	 f_message_chk(40,'[����ȭ�ݾ�]')
	 dw_key.SetColumn('costforamt')
	 Return
  End If
End If

dSumAmtd = 0
dSumForAmtd = 0
dSumTotAmt = dw_insert.GetItemNumber(1,'sum_piamt')
For ix = 1 To nCnt
	dPiAmt = dw_insert.GetItemNumber(ix,'piamt')
	If IsNull(dPiamt) or dPiamt = 0 Then Return
	
	/* ������ ����� ��� */
	dDivRate  = dPiAmt / dSumTotAmt
	
	/*��е� �ݾ� */
	dCostAmtd = TrunCate(dCostAmt * dDivRate,0)
	dSumAmtd += dCostAmtd
	
	dCostForAmtd = TrunCate(dCostForAmt * dDivRate,2)
	dSumForAmtd += dCostForAmtd
	
	/* ���� ó�� */
	If ix = nCnt Then  
		dCostAmtd += Round( dCostAmt - dSumAmtd ,2)
		dCostForAmtd += Round( dCostForAmt - dSumForAmtd ,2)
	End If
	
	dw_insert.SetItem(ix,'costamt',    dCostAmtd)
	dw_insert.SetItem(ix,'costforamt', dCostForAmtd)
Next

end event

type pb_1 from u_pb_cal within w_sal_06060
integer x = 827
integer y = 752
integer width = 78
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_key.SetColumn('gyul_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_key.SetItem(1, 'gyul_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06060
integer x = 2405
integer y = 212
integer width = 78
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_key.SetColumn('costdt')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_key.SetItem(1, 'costdt', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 172
integer width = 4549
integer height = 864
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_06060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 1064
integer width = 4549
integer height = 544
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_06060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 1624
integer width = 4549
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

