$PBExportHeader$w_sal_03040.srw
$PBExportComments$BOX �߼۳��� ���(��ǰ)
forward
global type w_sal_03040 from w_inherite
end type
type gb_3 from groupbox within w_sal_03040
end type
type gb_2 from groupbox within w_sal_03040
end type
type dw_key from u_key_enter within w_sal_03040
end type
type rr_3 from roundrectangle within w_sal_03040
end type
type rr_1 from roundrectangle within w_sal_03040
end type
end forward

global type w_sal_03040 from w_inherite
integer height = 2404
string title = "BOX �߼۳��� ���(��ǰ)"
gb_3 gb_3
gb_2 gb_2
dw_key dw_key
rr_3 rr_3
rr_1 rr_1
end type
global w_sal_03040 w_sal_03040

type variables

end variables

forward prototypes
public function integer wf_key_protect (boolean gb)
public function integer wf_calc_no (string sdate, string arg_cvcod)
public function double wf_calc_danga (integer nrow, string scvcod, string sfrunit, string sfrarea, string stoarea)
public function integer wf_clear_items (integer row)
end prototypes

public function integer wf_key_protect (boolean gb);Choose Case gb
	Case True
		dw_key.Modify('frdate.protect = 1')
		dw_key.Modify('frno.protect = 1')
		dw_key.Modify('frvnd.protect = 1')
		dw_key.Modify('cvcod.protect = 1')
      dw_key.Modify("frdate.background.color = 80859087") // button face
      dw_key.Modify("frno.background.color = 80859087") // button face
	Case False
		dw_key.Modify('frdate.protect = 0')
		dw_key.Modify('frno.protect = 0')
		dw_key.Modify('frvnd.protect = 0')
		dw_key.Modify('cvcod.protect = 0')
      dw_key.Modify("frdate.background.color = '"+String(Rgb(195,225,184))+"'")	 // yellow
      dw_key.Modify("frno.background.color = '"+String(Rgb(195,225,184))+"'")
End Choose

Return 1
end function

public function integer wf_calc_no (string sdate, string arg_cvcod);integer	nMAXNO

SELECT NVL(SEQNO, 0)
  INTO :nMAXNO
  FROM PACLSTNO
 WHERE ( sabu = :gs_sabu ) AND
		 ( yymm = :sdate ) AND
		 ( cvcod = :arg_cvcod ) for update;
		
Choose Case sqlca.sqlcode 
  Case is < 0 
			return -1
  Case 100 
    nMAXNO = 1

    INSERT INTO PACLSTNO ( sabu, yymm, cvcod, SEQNO )
        VALUES ( :gs_sabu, :sDate, :arg_cvcod, :nMaxNo ) ;  
  Case 0
	 nMAXNO = nMAXNO + 1

	 UPDATE PACLSTNO
   	 SET SEQNO = :nMAXNO
	  WHERE ( sabu = :gs_sabu ) AND
			  ( yymm = :sDate ) AND
			  ( cvcod = :arg_cvcod );
END Choose

If sqlca.sqlcode <> 0 Then	Return -1

RETURN nMAXNO
end function

public function double wf_calc_danga (integer nrow, string scvcod, string sfrunit, string sfrarea, string stoarea);Double dFrPrice

SELECT frprice INTO :dFrPrice
  FROM fr_charges
 WHERE cvcod = :sCvcod AND
       frunit = :sFrUnit AND
		 frarea = :sFrarea AND
		 toarea = :sToarea;

If IsNull(dFrPrice) Then dFrPrice = 0

If dFrprice = 0 Then
	dw_insert.SetItem(nRow,'dan','X')
Else
  dw_insert.SetItem(nRow,'dan','O')
End If
		
Return dFrPrice
end function

public function integer wf_clear_items (integer row);string sNull

SetNull(sNull)

dw_insert.SetItem(row,'frqty',0)
dw_insert.SetItem(row,'frprice',0)
dw_insert.SetItem(row,'framt',0)

Return 1
end function

on w_sal_03040.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_key=create dw_key
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_key
this.Control[iCurrent+4]=this.rr_3
this.Control[iCurrent+5]=this.rr_1
end on

on w_sal_03040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_key)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

p_can.Post PostEvent(Clicked!)

end event

event open;call super::open;PostEvent("ue_open")
end event

type dw_insert from w_inherite`dw_insert within w_sal_03040
integer x = 69
integer y = 572
integer width = 3433
integer height = 1420
integer taborder = 20
string dataobject = "d_sal_03040"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;Long nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case "tovnd"
   	Open(w_vndmst_popup)
		If IsNull(gs_code) Then Return 1
		
		this.SetItem(nRow,'tovnd',gs_code)
		This.PostEvent(ItemChanged!)
END Choose
end event

event dw_insert::itemchanged;String sCvcodNm, sData, sCvcod,sFrUnit,sFrarea,sToarea,sNull,sFrUnitNam
long   l_frprice,l_frqty, nRow

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)
Choose Case GetColumnName()
/* �ŷ�ó */
	Case 'tovnd'
	  sData = Trim(Gettext())
	  
	  select cvnas2,exarea into :sCvcodNm,:sToarea from vndmst
		where cvcod = :sData;
		
	  If Trim(sCvcodNm) = '' Or IsNull(sCvcodNm) Then
	     This.SetItem(nRow,'tovnd',sNull)
	     This.SetItem(nRow,'tovndnam',sNull)
	     This.SetItem(nRow,'toarea',sNull)
 	     This.SetItem(nRow,'sarea',sNull)
		  wf_clear_items(nRow)
		  Return 1
	  Else
	     This.SetItem(nRow,'tovndnam',sCvcodNm)
	     This.SetItem(nRow,'toarea',  sToarea)
			 This.SetItem(nRow,'sarea',   sToarea)
		   wf_clear_items(nRow)
     End If
	  		  
	  /* BOX �ܰ� ��� */
	  sCvcod  = GetItemString(nRow,'cvcod')       /* ��۾�ü */
 	  sFrarea = dw_key.GetItemString(1,'exarea')  /* ������� */
	  sFrUnit = GetItemString(nRow,'frunit')

    l_frprice = wf_calc_danga( nRow, sCvcod, sFrUnit, sFrarea,sToarea )

		
	  If IsNull(l_frqty) then l_frqty = 0
		
	  This.SetItem(nRow,'frprice',l_frprice)
		
	  This.SetFocus()
	  This.SetColumn('frqty')
   /* ������� */
   Case 'toarea'
	  sToarea = Trim(GetText())
	  This.SetItem(nRow,'toarea',sToarea)
		
	  /* BOX �ܰ� ��� */
	  sCvcod  = GetItemString(nRow,'cvcod')       /* ��۾�ü */
 	  sFrarea = dw_key.GetItemString(1,'exarea')  /* ������� */
	  sFrUnit = GetItemString(nRow,'frunit')

    l_frprice = wf_calc_danga( nRow, sCvcod, sFrUnit, sFrarea, sToarea );

	  If IsNull(l_frqty) then l_frqty = 0
		
	  This.SetItem(nRow,'frprice',l_frprice)
   /* ��۴����� */
	Case 'frunitnam'
		sFrUnitNam = Trim(GetText())
		
    SELECT RTRIM("REFFPF"."RFGUB")  INTO :sFrUnit
      FROM "REFFPF"
     WHERE ( "REFFPF"."RFCOD" = '71' ) AND  
           ( "REFFPF"."RFGUB" <> '00' ) AND  
           ( "REFFPF"."SABU" = '1' )  AND
			 	   ( "REFFPF"."RFNA1" = :sFrUnitNam );

      /* �ܰ� ��� */
		sFrarea = dw_key.GetItemString(1,'exarea') /* ������� */
		sCvcod  = GetItemString(nRow,'cvcod')      /* ��۾�ü */
		sToarea = GetItemString(nRow,'toarea')     /* �������� */
		l_frqty = GetItemNumber(nRow,'frqty')
		
		l_frprice = wf_calc_danga(nRow, sCvcod, sFrunit, sFrarea, sToarea )
	
		If IsNull(l_frqty) then l_frqty = 0
		
		SetItem(nRow,'frprice', l_frprice)
		SetItem(nRow,'framt',   l_frprice * l_frqty)
		SetItem(nRow,'frunit',  sFrunit)
   /* ��ۼ��� */
	Case 'frqty'
		l_frprice = GetItemNumber(nRow,'frprice')
		l_frqty   = Long(GetText())
		
		This.SetItem(nRow,'framt',l_frprice * l_frqty)
   /* ��۴ܰ� */
	Case 'frprice'
		l_frprice = Long(GetText())
		l_frqty   = GetItemNumber(nRow,'frqty')
		
		This.SetItem(nRow,'framt',l_frprice * l_frqty)
End Choose

sle_msg.text = ''
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_03040
integer x = 3918
end type

event p_delrow::clicked;call super::clicked;int    row

if dw_insert.rowcount() < 1 then 
	messagebox('Ȯ��','��ȸ�� ����Ÿ�� �����ϴ�.')
	dw_key.setfocus()
	return
end if

If dw_insert.RowCount() > 0 Then
	row   = dw_insert.GetRow()
   IF MessageBox("�� ��",string(row) +"��°�� �����˴ϴ�." +"~n~n" +&
                     	 "���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.DeleteRow(row)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
	   Else
		   Rollback ;
			cb_can.TriggerEvent(Clicked!)
			sle_msg.text =	"�ڷ� ������ �����Ͽ����ϴ�!!"
			Return
	   End If		
	End If	
End If

If dw_insert.RowCount() <= 0 Then
	cb_can.TriggerEvent(Clicked!)
End If

sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
end event

type p_addrow from w_inherite`p_addrow within w_sal_03040
integer x = 3744
end type

event p_addrow::clicked;call super::clicked;Long   rcnt,nRow,rowcnt,ix,itemp,nMax,i_frno
String s_frdate,s_cvcod,s_frvnd, sFrUnit

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_key.RowCount()
If nRow <= 0 Then Return

/* --------------------------------------------- */
s_frdate = dw_key.GetItemString(nRow,'frdate')
i_frno   = dw_key.GetItemNumber(nRow,'frno')
s_frvnd  = dw_key.GetItemString(nRow,'frvnd')
s_cvcod  = dw_key.GetItemString(nRow,'cvcod')

dw_key.SetFocus()
If f_datechk(s_frdate) <> 1 Then
   f_message_chk(1400,'[�߼�����]'+s_frdate)
	dw_key.SetColumn('frdate')
	Return -1
End If

//If IsNull(i_frno)  Then
//   f_message_chk(1400,'[�߼۹�ȣ]')
//	dw_key.SetColumn('frno')
//	Return -1
//End If

If IsNull(s_frvnd) Or s_frvnd = '' Then
   f_message_chk(40,'[�߼�ó]')
	dw_key.SetColumn('frvnd')
	Return -1
End If

If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(40,'[��۾�ü]')
	dw_key.SetColumn('cvcod')
	Return -1
End If

/* ��۴��� */
select substr(x.dataname,1,6) into :sFrUnit
  from syscnfg x
 where x.sysgu = 'S' and
       x.serial = 9 and
       x.lineno = 11 ;
/* --------------------------------------------- */

/* �߼��׹� �ִ밪 */
nMax = 0
rowcnt = dw_insert.Rowcount()
For ix = 1 To rowcnt
   itemp = dw_insert.GetItemNumber(ix,'frseq')
   nMax = Max(nMax,itemp)
Next
nMax = nMax + 1

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow,'frdate',s_frdate)
dw_insert.SetItem(nRow,'frno',i_frno)
dw_insert.SetItem(nRow,'frseq',nMax)
dw_insert.SetItem(nRow,'frvnd',s_frvnd)
dw_insert.SetItem(nRow,'cvcod',s_cvcod)
dw_insert.SetItem(nRow,'frunit',sFrUnit)
dw_insert.SetItem(nRow,'frunitnam',Trim(dw_insert.Describe("Evaluate('LookUpDisplay(frunit)',1)")))

dw_insert.SetItemStatus(nRow, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(nRow, 0,Primary!, New!)
dw_insert.SetFocus()
dw_insert.SetRow(nRow)
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('tovnd')

If nRow =  1 Then wf_key_protect(true)

end event

type p_search from w_inherite`p_search within w_sal_03040
integer x = 2149
integer y = 368
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::clicked;call super::clicked;Long   nRow,i_frno,nMax,ix,itemp,nCnt=0, lrow
string s_frdate,s_cvcod,s_frvnd,s_tovnd, s_tovndnm, s_exarea, sArea

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_key.RowCount()
If nRow <= 0 Then Return

IF MessageBox("Ȯ ��","�����峻���� ���� �߼۳����� ��ϵ˴ϴ�." +"~n~n" +&
                    	 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 1) = 2 THEN RETURN
/* --------------------------------------------- */
s_frdate = dw_key.GetItemString(nRow,'frdate')
i_frno   = dw_key.GetItemNumber(nRow,'frno')
s_frvnd  = dw_key.GetItemString(nRow,'frvnd')
s_cvcod  = dw_key.GetItemString(nRow,'cvcod')

SetPointer(HourGlass!)

dw_key.SetFocus()
If f_datechk(s_frdate) <> 1 Then
   f_message_chk(1400,'[�߼�����]'+s_frdate)
	dw_key.SetColumn('frdate')
	Return -1
End If

If IsNull(s_frvnd) Or s_frvnd = '' Then
   f_message_chk(40,'[�߼�ó]')
	dw_key.SetColumn('frvnd')
	Return -1
End If

If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(40,'[��۾�ü]')
	dw_key.SetColumn('cvcod')
	Return -1
End If

/* �߼��׹� �ִ밪 */
nMax = 0
For ix = 1 To dw_insert.Rowcount()
   itemp = dw_insert.GetItemNumber(ix,'frseq')
   nMax = Max(nMax,itemp)
Next

/* ������� �߼����ڿ� ���� ����ŷ�ó�� ���� cursor */
datastore ds
ds = create datastore
ds.dataobject = "d_sal_03040_ds"
ds.settransobject(sqlca)
ds.retrieve(gs_sabu, s_frdate) 

For Lrow = 1 to ds.rowcount()
	 s_tovnd = ds.getitemstring(Lrow, "cvcod")
	 s_tovndnm = ds.getitemstring(Lrow, "cvnas2")
	 s_exarea = ds.getitemstring(Lrow, "exarea")
	 sarea = ds.getitemstring(Lrow, "sarea")	 
	
   nMax = nMax + 1

   /* �߼۳��� ��� */
   nRow = dw_insert.InsertRow(0)
	dw_insert.ScrollToRow(nRow)
   dw_insert.SetItem(nrow,'frdate',s_frdate)
   dw_insert.SetItem(nrow,'frno',i_frno)
   dw_insert.SetItem(nrow,'frseq',nMax)
   dw_insert.SetItem(nrow,'frvnd',s_frvnd)
   dw_insert.SetItem(nrow,'cvcod',s_cvcod)

   dw_insert.SetItem(nrow,'tovnd',s_tovnd)
	dw_insert.SetItem(nrow,'tovndnam',s_tovndnm)
	dw_insert.SetItem(nrow,'toarea',s_exarea)
	
	nCnt += 1
Next

destroy ds

If nCnt > 0 Then
	sle_msg.Text = '�߼۳��� ����� �Ϸ�Ǿ����ϴ�.'
	wf_key_protect(true)
Else
	f_message_chk(130,'[����� Ȯ��]')
End If

end event

type p_ins from w_inherite`p_ins within w_sal_03040
boolean visible = false
integer x = 3593
integer y = 232
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sal_03040
end type

type p_can from w_inherite`p_can within w_sal_03040
end type

event p_can::clicked;call super::clicked;string syymm,sCvcod, sCvcodNm, sExarea
Long   row

syymm = f_today()

dw_key.Reset()
dw_insert.Reset()

row = dw_key.InsertRow(0)
wf_key_protect(false)

dw_key.SetFocus()
dw_key.SetRow(row)

/* ��ۿ뿪��ü */
select y.cvcod, y.cvnas2 into :sCvcod, :sCvcodNm
  from syscnfg x, vndmst y
 where x.sysgu = 'S' and
       x.serial = 9 and
       x.lineno = 10 and
		 substr(x.dataname,1,6) = y.cvcod;
dw_key.SetItem(row,'cvcod',sCvcod)
dw_key.SetItem(row,'cvcodnm',sCvcodNm)

///* �߼�ó */
//SELECT CVCOD, CVNAS2, EXAREA INTO :sCvcod, :sCvcodnm, :sExarea
//  FROM VNDMST
// WHERE CVCOD = '000021';
//dw_key.SetItem(row,'frvnd',  sCvcod)
//dw_key.SetItem(row,'cvnas2', sCvcodNm)
//dw_key.SetItem(row,'exarea', sExarea)

dw_key.SetItem(row,'frdate', is_today)
dw_key.SetColumn('frdate')

ib_any_typing = false

end event

type p_print from w_inherite`p_print within w_sal_03040
boolean visible = false
integer x = 3799
integer y = 240
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_03040
integer x = 3570
end type

event p_inq::clicked;call super::clicked;int    nRow,i_frno
string s_frdate

If dw_key.AcceptText() <> 1 Then Return

nRow = dw_key.RowCount()
If nRow <= 0 Then Return

/* --------------------------------------------- */
s_frdate = dw_key.GetItemString(nRow,'frdate')
i_frno   = dw_key.GetItemNumber(nRow,'frno')

dw_key.SetFocus()
If f_datechk(s_frdate) <> 1 Then
   f_message_chk(1400,'[�߼�����]'+s_frdate)
	dw_key.SetColumn('frdate')
	Return -1
End If

If IsNull(i_frno)  Then
   f_message_chk(1400,'[�߼۹�ȣ]')
	dw_key.SetColumn('frno')
	Return -1
End If
/* --------------------------------------------- */
Parent.SetRedraw(False)
If dw_insert.Retrieve(s_frdate,i_frno) > 0 Then
	dw_key.Retrieve(s_frdate,i_frno)
   wf_key_protect(true)
Else
	sle_msg.Text = '��ȸ�� �Ǽ��� �����ϴ�.!!'
End If
Parent.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_sal_03040
boolean visible = false
integer y = 232
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sal_03040
integer x = 4091
end type

event p_mod::clicked;call super::clicked;Long   rcnt,nRow,rowcnt,ix,itemp,nMax,i_frno, nFrQty , iMaxCheckNo
String s_frdate,s_cvcod,s_frvnd,s_tovnd,s_tovndnam, sExarea, sFrUnit , sBoxno 

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_key.RowCount()
If nRow <= 0 Then Return

if dw_insert.rowcount() < 1 then 
	messagebox('Ȯ��','������ ����Ÿ�� �����ϴ�.')
	dw_key.setfocus()
	return
end if

/* --------------------------------------------- */
s_frdate = dw_key.GetItemString(nRow,'frdate')
i_frno   = dw_key.GetItemNumber(nRow,'frno')
s_frvnd  = dw_key.GetItemString(nRow,'frvnd')
s_cvcod  = dw_key.GetItemString(nRow,'cvcod')

dw_key.SetFocus()
If f_datechk(s_frdate) <> 1 Then
   f_message_chk(1400,'[�߼�����]'+s_frdate)
	dw_key.SetColumn('frdate')
	Return -1
End If

If IsNull(s_frvnd) Or s_frvnd = '' Then
   f_message_chk(40,'[�߼�ó]')
	dw_key.SetColumn('frvnd')
	Return -1
End If

If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(40,'[��۾�ü]')
	dw_key.SetColumn('cvcod')
	Return -1
End If

If IsNull(i_frno)  Then
	 /* �Ϸù�ȣ ä�� */
  iMaxCheckNo = wf_calc_no(s_frdate, '.')
  IF iMaxCheckNo <= 0 Or iMaxCheckNo > 999999 THEN
	 f_message_chk(51,'�Ϸù�ȣ')
	 Return 1
  END IF	
  sBoxno = Trim(String(iMaxCheckNo,'000000'))
  dw_key.setitem(1,'frno',long(sBoxno))
//  dw_insert.setitem(1,'frno',long(sBoxno))
End If

/* --------------------------------------------- */
nRow = dw_insert.RowCount()
If nRow <= 0 Then Return

dw_insert.SetFocus()
For ix = 1 To nRow
   dw_insert.setitem(ix,'frno',long(sBoxno))
   s_tovnd    = dw_insert.GetItemString(ix,'tovnd')
   s_tovndnam = dw_insert.GetItemString(ix,'tovndnam')
   If (IsNull(s_tovnd) Or s_tovnd = '' ) and ( IsNull(s_tovndnam) Or s_tovndnam = '' )Then
     f_message_chk(1400,'[�ŷ�ó]')
	  dw_insert.ScrollToRow(ix)
	  dw_insert.SetRow(ix)
	  dw_insert.SetColumn('tovnd')
	  Return
   End If

   nFrQty = dw_insert.GetItemNumber(ix,'frqty')
   If IsNull(nFrqty) or nFrQty = 0 Then
     f_message_chk(1400,'[����]')
	  dw_insert.ScrollToRow(ix)
	  dw_insert.SetRow(ix)
	  dw_insert.SetColumn('frqty')
	  Return
   End If
	

   sExarea = dw_insert.GetItemString(ix,'toarea')
   If IsNull(sExarea) Or sExarea = '' Then
     f_message_chk(1400,'[�������]')
	  dw_insert.ScrollToRow(ix)
	  dw_insert.SetRow(ix)
	  dw_insert.SetColumn('toarea')
	  Return
   End If

   sFrUnit = dw_insert.GetItemString(ix,'frunitnam')
   If IsNull(sFrUnit) Or sFrUnit = '' Then
     f_message_chk(1400,'[����]')
	  dw_insert.ScrollToRow(ix)
	  dw_insert.SetRow(ix)
	  dw_insert.SetColumn('frunitnam')
	  Return
   End If
Next

if dw_insert.Update() = 1 then
	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_exit from w_inherite`cb_exit within w_sal_03040
integer x = 3022
integer y = 1872
end type

type cb_mod from w_inherite`cb_mod within w_sal_03040
integer x = 1966
integer y = 1872
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_sal_03040
integer x = 197
integer y = 1872
integer taborder = 30
string text = "�߰�(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_03040
integer x = 2318
integer y = 1872
integer taborder = 60
end type

type cb_inq from w_inherite`cb_inq within w_sal_03040
integer x = 549
integer y = 1872
end type

type cb_print from w_inherite`cb_print within w_sal_03040
integer x = 2135
integer y = 448
integer width = 1239
integer textsize = -9
boolean enabled = false
string text = "���峻���� ���� �ڽ��߼۳��� ���(&P)"
end type

event cb_print::clicked;call super::clicked;Long   nRow,i_frno,nMax,ix,itemp,nCnt=0, lrow  , ll_baqty 
string s_frdate,s_cvcod,s_frvnd,s_tovnd, s_tovndnm, s_exarea, sArea , ls_lineno , ls_frunitnm

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_key.RowCount()
If nRow <= 0 Then Return

IF MessageBox("Ȯ ��","���峻���� ���� �߼۳����� ��ϵ˴ϴ�." +"~n~n" +&
                    	 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 1) = 2 THEN RETURN
/* --------------------------------------------- */
s_frdate = dw_key.GetItemString(nRow,'frdate')
i_frno   = dw_key.GetItemNumber(nRow,'frno')
s_frvnd  = dw_key.GetItemString(nRow,'frvnd')
s_cvcod  = dw_key.GetItemString(nRow,'cvcod')

SetPointer(HourGlass!)

dw_key.SetFocus()
If f_datechk(s_frdate) <> 1 Then
   f_message_chk(1400,'[�߼�����]'+s_frdate)
	dw_key.SetColumn('frdate')
	Return -1
End If

//If IsNull(i_frno)  Then
//   f_message_chk(1400,'[�߼۹�ȣ]')
//	dw_key.SetColumn('frno')
//	Return -1
//End If

If IsNull(s_frvnd) Or s_frvnd = '' Then
   f_message_chk(40,'[�߼�ó]')
	dw_key.SetColumn('frvnd')
	Return -1
End If

If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(40,'[��۾�ü]')
	dw_key.SetColumn('cvcod')
	Return -1
End If

/* �߼��׹� �ִ밪 */
nMax = 0
For ix = 1 To dw_insert.Rowcount()
   itemp = dw_insert.GetItemNumber(ix,'frseq')
   nMax = Max(nMax,itemp)
Next

/* ��۴��� */
select x.dataname into :ls_lineno
  from syscnfg x 
 where x.sysgu = 'S' and
       x.serial = 9 and
       x.lineno = 11 ;

SELECT RTRIM("REFFPF"."RFNA1")  INTO :ls_frunitnm
FROM "REFFPF"
WHERE ( "REFFPF"."RFCOD" = '71' ) AND  
	  ( "REFFPF"."RFGUB" <> '00' ) AND  
		( "REFFPF"."RFGUB" = :ls_lineno );
		
/* ������� �߼����ڿ� ���� ����ŷ�ó�� ���� cursor */
datastore ds
ds = create datastore
ds.dataobject = "d_sal_03041_ds"
ds.settransobject(sqlca)
ds.retrieve(gs_sabu, s_frdate) 

For Lrow = 1 to ds.rowcount()
	 s_tovnd =   ds.getitemstring(Lrow, "cvcod")   
	 s_tovndnm = ds.getitemstring(Lrow, "cvnas")
	 s_exarea =  ds.getitemstring(Lrow, "exarea") 
	 sarea =     ds.getitemstring(Lrow, "sarea")
	 ll_baqty =  ds.GetItemnumber(lRow,'baqty')
	
   nMax = nMax + 1

   /* �߼۳��� ��� */
   nRow = dw_insert.InsertRow(0)
	dw_insert.ScrollToRow(nRow)
   dw_insert.SetItem(nrow,'frdate',s_frdate)
   dw_insert.SetItem(nrow,'frno',i_frno)
   dw_insert.SetItem(nrow,'frseq',nMax)
   dw_insert.SetItem(nrow,'frvnd',s_frvnd)
   dw_insert.SetItem(nrow,'cvcod',s_cvcod)
	dw_insert.SetItem(nrow,'frqty',ll_baqty)
	dw_insert.SetItem(nrow,'frunitnam',ls_frunitnm)

   dw_insert.SetItem(nrow,'tovnd',s_tovnd)
	dw_insert.SetItem(nrow,'tovndnam',s_tovndnm)
	dw_insert.SetItem(nrow,'toarea',s_exarea)
	
	 /* �ܰ� ��� */
	 string sfrarea , scvcod , stoarea , sfrunit 
	 long  l_frqty , l_frprice 
		sFrarea = dw_key.GetItemString(1,'exarea') /* ������� */
		sCvcod  = dw_insert.GetItemString(nRow,'cvcod')      /* ��۾�ü */
		sToarea = dw_insert.GetItemString(nRow,'toarea')     /* �������� */
		l_frqty = dw_insert.GetItemNumber(nRow,'frqty')
		
		l_frprice = wf_calc_danga(nRow, s_Cvcod, ls_lineno, sfrarea, sToarea )
	
		If IsNull(l_frqty) then l_frqty = 0
		
		dw_insert.SetItem(nRow,'frprice', l_frprice)
		dw_insert.SetItem(nRow,'framt',   l_frprice * l_frqty)
		dw_insert.SetItem(nRow,'frunit',  sFrunit)
  
	nCnt += 1
Next

destroy ds

If nCnt > 0 Then
	sle_msg.Text = '�߼۳��� ����� �Ϸ�Ǿ����ϴ�.'
	wf_key_protect(true)
Else
	f_message_chk(130,'[����� Ȯ��]')
End If
end event

type st_1 from w_inherite`st_1 within w_sal_03040
end type

type cb_can from w_inherite`cb_can within w_sal_03040
integer x = 2670
integer y = 1872
end type

type cb_search from w_inherite`cb_search within w_sal_03040
integer x = 2135
integer y = 320
integer width = 1239
integer taborder = 90
integer textsize = -9
string text = "������� ���� �ڽ��߼۳��� ���(&W)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_03040
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_03040
end type

type gb_3 from groupbox within w_sal_03040
boolean visible = false
integer x = 1902
integer y = 1800
integer width = 1481
integer height = 236
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_sal_03040
boolean visible = false
integer x = 142
integer y = 1800
integer width = 823
integer height = 236
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_key from u_key_enter within w_sal_03040
integer x = 82
integer y = 96
integer width = 1509
integer height = 412
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_03040_01"
boolean border = false
end type

event itemchanged;String s_cvnas, sExArea, sdate, sData, sNull , ls_date
Long   nRow, nFrno , ll_count , ll_frno, lnull

SetNull(sNull)
SetNull(lnull)

nRow = GetRow()
If nRow <= 0 then Return

Choose Case GetColumnName()
	Case 'frdate'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
	      Return 1
      END IF
		
		nFrno = GetItemNumber(nRow,'frno')
		If Not IsNull(nFrno )  Then
		  cb_inq.TriggerEvent(Clicked!,1,0)
		End If
/*�߼۹�ȣ */
	Case 'frno'
		ll_frno = long(Trim(this.gettext()))
		
		if isnull(ll_frno) then return 1
		
		ls_date = this.getitemstring(1,'frdate')
		
		if ls_date = "" or isnull(ls_date) then
			messagebox('Ȯ��','�߼����ڸ� �Է��Ͻʽÿ�.')
			this.setfocus()
			this.setcolumn('frdate')
			return 1
		end if
		
		SELECT COUNT(*)  INTO :ll_count
		FROM   FRHIST
		WHERE  FRDATE  = :ls_date AND
		       FRNO    = :ll_frno ;
      
		if ll_count > 0 then
			cb_inq.triggerevent(clicked!)
		else
			messagebox('Ȯ��','����Ÿ�� ���� ���� �ʽ��ϴ�.')
			this.setitem(1,'frno', lNull)
			return 1
		end if
		
/* �߼�ó */
	Case 'frvnd'
		sData = Trim(GetText())
		select cvnas2,exarea into :s_cvnas,:sExArea from vndmst
		 where cvcod = :sData;

		If Trim(s_cvnas) = '' Or IsNull(s_cvnas) Then
         f_message_chk(33,'[�߼�ó]')
	      SetItem(row,'frvnd',sNull)
			SetItem(row,'cvnas2',sNull)
			Return 1
		End If
		
//		If IsNull(sExArea) or Trim(sExArea ) = '' Then
//			f_message_chk(165,'[�������]')
//		End If
		
      SetItem(1, 'cvnas2',s_cvnas)
      SetItem(1, 'exarea',sExArea)
/* ��ۿ뿪��ü */
	Case 'cvcod'
		sData = Trim(GetText())
		select cvnas2 into :s_cvnas from vndmst
		 where cvcod = :sData;
		 
		If Trim(s_cvnas) = '' Or IsNull(s_cvnas) Then
         f_message_chk(33,'[��ۿ뿪��ü]')
			Return 1
		Else
	      SetItem(row,GetColumnName()+'nm',s_cvnas)
      End If
End Choose

sle_msg.text = ''
end event

event rbuttondown;string sExArea

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "frvnd"
   	Open(w_vndmst_popup)
		If IsNull(gs_code) Then Return 1
		
		this.SetItem(row,'frvnd',gs_code)
		this.SetItem(row,'cvnas2',gs_codename)
		
		/* ������� ��ȸ */
		select exarea into :sExArea from vndmst
		 where cvcod = :gs_code;
		 
		If IsNull(sExArea) or Trim(sExArea ) = '' Then
			f_message_chk(165,'')
		End If
		
		this.SetItem(row,'exarea',sExArea)
	Case "cvcod"                              /* ��۾�ü */
   	Open(w_vndmst_popup)
		If IsNull(gs_code) Then Return 1
		
		this.SetItem(row,'cvcod',gs_code)
		this.SetItem(row,'cvcodnm',gs_codename)
END Choose
end event

event itemerror;return 1
end event

type rr_3 from roundrectangle within w_sal_03040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 48
integer width = 2034
integer height = 492
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sal_03040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 564
integer width = 3456
integer height = 1436
integer cornerheight = 40
integer cornerwidth = 55
end type

