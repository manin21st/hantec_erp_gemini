$PBExportHeader$w_imt_04630_dev.srw
$PBExportComments$��������Ÿ ��� - ����
forward
global type w_imt_04630_dev from w_inherite
end type
type p_1 from uo_picture within w_imt_04630_dev
end type
type p_2 from uo_picture within w_imt_04630_dev
end type
type tab_1 from tab within w_imt_04630_dev
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
rr_1 rr_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type rr_2 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
rr_2 rr_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type rr_3 from roundrectangle within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
rr_3 rr_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_4
end type
type rr_4 from roundrectangle within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
rr_4 rr_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_5
end type
type rr_5 from roundrectangle within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
rr_5 rr_5
end type
type tab_1 from tab within w_imt_04630_dev
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type pb_1 from u_pb_cal within w_imt_04630_dev
end type
type dw_6 from datawindow within w_imt_04630_dev
end type
type st_2 from statictext within w_imt_04630_dev
end type
type p_img from picture within w_imt_04630_dev
end type
type p_img_in from picture within w_imt_04630_dev
end type
type cb_1 from commandbutton within w_imt_04630_dev
end type
type rr_6 from roundrectangle within w_imt_04630_dev
end type
type rr_7 from roundrectangle within w_imt_04630_dev
end type
end forward

shared variables

end variables

global type w_imt_04630_dev from w_inherite
integer height = 3772
string title = "���� ����Ÿ ����"
p_1 p_1
p_2 p_2
tab_1 tab_1
pb_1 pb_1
dw_6 dw_6
st_2 st_2
p_img p_img
p_img_in p_img_in
cb_1 cb_1
rr_6 rr_6
rr_7 rr_7
end type
global w_imt_04630_dev w_imt_04630_dev

type variables
char ic_status = '1'   //'1'�ű�, '2' ����

blob	iblobBMP
end variables

forward prototypes
public function integer wf_init ()
public function integer wf_chk ()
public function integer wf_delete_chk (string skumno)
public function integer wf_set_kumno ()
public function integer wf_auto_kumno ()
public function integer wf_save_image ()
public function integer wf_load_image ()
public subroutine wf_calc_weight (long al_row)
end prototypes

public function integer wf_init ();dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

//tab_1.tabpage_1.dw_1.Reset()
//tab_1.tabpage_2.dw_2.Reset()
//tab_1.tabpage_3.dw_3.Reset()
//tab_1.tabpage_4.dw_4.Reset()
//tab_1.tabpage_5.dw_5.Reset()
dw_6.ReSet()

dw_insert.Modify('kumno.protect = 0')
//dw_insert.Modify("kumno.background.color = 65535")
dw_insert.Modify('gubun.protect = 0')
//dw_insert.Modify("gubun.background.color = 12639424")

//dw_insert.setitem(1,"kumno",'M') 
dw_insert.SetColumn('kumno')
dw_insert.SetFocus()

p_1.enabled = false
p_img.Visible = False
p_1.PictureName = "c:\erpman\image\�����̷�_d.gif"

ib_any_typing = False

ic_status = '1'
///////////////////////////////////
Return 0
end function

public function integer wf_chk ();String sKumno, sKumName, sBocvcod, sKumGubn, sPedat, sPesay, sKsts, ls_dumno
Long   ix, lUnitNo
String sHisdat, sNaermk, sabu
Double dNaamt, dClean, dCltim

If dw_insert.AcceptText() <> 1 Then Return -1
//If tab_1.tabpage_1.dw_1.AcceptText() <> 1 Then Return -1
//If tab_1.tabpage_2.dw_2.AcceptText() <> 1 Then Return -1
//If tab_1.tabpage_3.dw_3.AcceptText() <> 1 Then Return -1
//If tab_1.tabpage_4.dw_4.AcceptText() <> 1 Then Return -1
//If tab_1.tabpage_5.dw_5.AcceptText() <> 1 Then Return -1

sKumno	= Trim(dw_insert.GetItemString(1,'kumno'))
sKumName = Trim(dw_insert.GetItemString(1,'kumname'))
sBocvcod = Trim(dw_insert.GetItemString(1,'bocvcod'))
sKumGubn = Trim(dw_insert.GetItemString(1,'kumgubn'))
//sKsts		= Trim(dw_insert.GetItemString(1,'kstat'))
sKsts    = Trim(dw_insert.GetItemString(1,'pegbn'))   //��� ����
sPedat	= Trim(dw_insert.GetItemString(1,'pedat'))
sPesay	= Trim(dw_insert.GetItemString(1,'pesay'))
dClean	= dw_insert.GetItemNumber(1,'std_clean')
dCltim	= dw_insert.GetItemNumber(1,'std_cltim')

If sKsts = 'Y' Then
	//����(1:����,2:������,3:������,4:���)
	dw_insert.SetItem(1, 'kstat', '4')  //��� ����
End If

If IsNull(sKumName) or sKumName = '' Then
	f_message_chk(40,'[ǰ��]')
	dw_insert.SetColumn('kumname')
	dw_insert.SetFocus()
	Return -1
End If

//If IsNull(sBocvcod) or sBocvcod = '' Then
//	f_message_chk(40,'[����ó]')
//	dw_insert.SetColumn('bocvcod')
//	dw_insert.SetFocus()
//	Return -1
//End If

If IsNull(sKumGubn) or sKumGubn = '' Then
	f_message_chk(40,'[�з��ڵ�]')
	dw_insert.SetColumn('kumgubn')
	dw_insert.SetFocus()
	Return -1
End If

If IsNull(dClean) or dClean <= 0 Then
	f_message_chk(40,'[û���ֱ�]')
	dw_insert.SetColumn('std_clean')
	dw_insert.SetFocus()
	Return -1
End If

If IsNull(dCltim) or dCltim <= 0 Then
	f_message_chk(40,'[û�Ҽҿ�ð�]')
	dw_insert.SetColumn('std_cltim')
	dw_insert.SetFocus()
	Return -1
End If

/* ���°� ����� ��� */
//If sKsts = '4' Then
If sKsts = 'Y' Then
	If f_datechk(sPedat) <> 1 Then
		f_message_chk(40,'[�������]')
		dw_insert.SetColumn('pedat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	If IsNull(sPesay) or sPesay = '' Then
		f_message_chk(40,'[������]')
		dw_insert.SetColumn('pesay')
		dw_insert.SetFocus()
		Return -1
	End If
End If

String ls_kum
String ls_bit
String ls_nam
String ls_itn

Long   ll_usa

Long   ll_find1, ll_find2
Long   ll_cnt
Long   ll_chk

ll_cnt = dw_6.RowCount()
//If ll_cnt < 1 Then Return 0


For ix = 1 To ll_cnt
	
	ls_kum = dw_6.GetItemString(ix, 'mchno' )  //�����ڵ�
	ls_bit = dw_6.GetItemString(ix, 'bitnbr')  //��ǰ�ڵ�
	ls_nam = dw_6.GetItemString(ix, 'bitdsc')  //��ǰ��
	ls_itn = dw_6.GetItemString(ix, 'itnbr' )  //����ǰ��
	ll_usa = dw_6.GetItemNumber(ix, 'qtypr' )  //usage
	
	If Trim(ls_kum) = '' Or IsNull(ls_kum) Then
		f_message_chk(40, '[�����ڵ�]')
//		dw_6.ScrollToRow(ix)
//		dw_6.SetColumn('mchno')
//		dw_6.SetFocus()
		Return -1
	End If
	
	If Trim(ls_bit) = '' OR IsNull(ls_bit) Then
		f_message_chk(40, '[��ǰ�ڵ�]')
		dw_6.ScrollToRow(ix)
		dw_6.SetColumn('bitnbr')
		dw_6.SetFocus()
		Return -1
	End If
	
	If Trim(ls_nam) = '' Or IsNull(ls_nam) Then
		f_message_chk(40, '[��ǰ��]')
		dw_6.ScrollToRow(ix)
		dw_6.SetColumn('bitdsc')
		dw_6.SetFocus()
		Return -1
	End If
	
//	If Trim(ls_itn) = '' Or IsNull(ls_itn) Then
//		f_message_chk(40, '[����ǰ��]')
//		dw_6.ScrollToRow(ix)
//		dw_6.SetColumn('itnbr')
//		dw_6.SetFocus()
//		Return -1
//	End If
	
	If Trim(String(ll_usa)) = '' Or IsNull(ll_usa) Then
		f_message_chk(40, '[USAGE]')
		dw_6.ScrollToRow(ix)
		dw_6.SetColumn('qtypr')
		dw_6.SetFocus()
		Return -1
	End If
	
	If (ix + 1) <= ll_cnt Then
		//�Է��ߺ�Check
		ll_find1 = dw_6.FIND("bitnbr = '" + ls_bit + "'", ix + 1, ll_cnt)
		If ll_find1 > 0 Then
			MessageBox('SPARE PART ��ǰ�ڵ� �ߺ�', String(ll_find1) + ' ��° Row�� ��ǰ�ڵ尡 �ߺ��Դϴ�! (��� �Ұ���!)')
			dw_6.ScrollToRow(ll_find1)
			dw_6.SetColumn('bitnbr')
			dw_6.SetFocus()
			Return -1
		End If
		
//		ll_find2 = dw_6.FIND("itnbr = '" + ls_itn + "'", ix + 1, ll_cnt)
//		If ll_find2 > 0 Then
//			MessageBox('SPARE PART ǰ���ڵ� �ߺ�', String(ll_find2) + ' ��° Row�� ǰ���ڵ尡 �ߺ��Դϴ�! (��� �Ұ���!)')
//			dw_6.ScrollToRow(ll_find2)
//			dw_6.SetColumn('itnbr')
//			dw_6.SetFocus()
//			Return -1
//		End If
	End If
	
//	//���� �Էµ� Row�� Check
//	If dw_6.GetNextModified(ix, Primary!) <> 0 Then
//		//DataBase �ߺ� Check
//		SELECT COUNT(MCHNO)
//		  INTO :ll_chk
//		  FROM KUMMST_KUM
//		 WHERE MCHNO  = :ls_kum
//			AND BITNBR = :ls_bit ;
//		If ll_chk > 0 Then
//			MessageBox('SPARE PART ��ǰ�ڵ� �ߺ�(DB)', String(ix) + ' ��° Row�� ��ǰ�ڵ尡 �ߺ��Դϴ�! (��� �Ұ���!)')
//			dw_6.ScrollToRow(ix)
//			dw_6.SetColumn('bitnbr')
//			dw_6.SetFocus()
//			Return -1
//		End If
//	End If
Next

Return 1

/*-----------------------------------------------------------------------------------------------------
tab_1.tabpage_1.dw_1.SetFocus()
For ix = 1 To tab_1.tabpage_1.dw_1.RowCount()
	lUnitNo  = tab_1.tabpage_1.dw_1.GetItemNumber(ix, 'untno')
	sNaermk  = Trim(tab_1.tabpage_1.dw_1.GetItemString(ix, 'untnm'))
	
	If IsNull(lUnitNo) or lUnitNo < 0 Then
		f_message_chk(40,'[UNIT-NO]')
      tab_1.SelectTab(1)
		tab_1.tabpage_1.dw_1.ScrollToRow(ix)
		tab_1.tabpage_1.dw_1.SetColumn('untno')
		tab_1.tabpage_1.dw_1.SetFocus()
		Return -1
	End If

	If IsNull(sNaermk) or sNaermk = '' Then
		f_message_chk(40,'[UNIT ��]')
      tab_1.SelectTab(1)
		tab_1.tabpage_1.dw_1.ScrollToRow(ix)
		tab_1.tabpage_1.dw_1.SetColumn('untnm')
		tab_1.tabpage_1.dw_1.SetFocus()
		Return -1
	End If
Next

tab_1.tabpage_3.dw_3.SetFocus()
For ix = 1 To tab_1.tabpage_3.dw_3.RowCount()
	sNaermk  = Trim(tab_1.tabpage_3.dw_3.GetItemString(ix, 'itnbr'))
	
	If IsNull(sNaermk) or sNaermk = '' Then
		f_message_chk(40,'[ǰ��]')
      tab_1.SelectTab(3)
		tab_1.tabpage_3.dw_3.ScrollToRow(ix)
		tab_1.tabpage_3.dw_3.SetColumn('itnbr')
		tab_1.tabpage_3.dw_3.SetFocus()
		Return -1
	End If
Next

tab_1.tabpage_4.dw_4.SetFocus()
For ix = 1 To tab_1.tabpage_4.dw_4.RowCount()
	sHisdat = Trim(tab_1.tabpage_4.dw_4.GetItemString(ix, 'hisdat'))
	lUnitNo  = tab_1.tabpage_4.dw_4.GetItemNumber(ix, 'untno')
	sNaermk = Trim(tab_1.tabpage_4.dw_4.GetItemString(ix, 'naermk'))
	
	If f_datechk(sHisdat) <> 1 Then
		f_message_chk(40,'[����]')
      tab_1.SelectTab(4)
		tab_1.tabpage_4.dw_4.ScrollToRow(ix)
		tab_1.tabpage_4.dw_4.SetColumn('hisdat')
		tab_1.tabpage_4.dw_4.SetFocus()
		Return -1
	End If
	If IsNull(lUnitNo) or lUnitNo < 0 Then
		f_message_chk(40,'[UNIT-NO]')
      tab_1.SelectTab(4)
		tab_1.tabpage_4.dw_4.ScrollToRow(ix)
		tab_1.tabpage_4.dw_4.SetColumn('untno')
		tab_1.tabpage_4.dw_4.SetFocus()
		Return -1
	End If

	If IsNull(sNaermk) or sNaermk = '' Then
		f_message_chk(40,'[����]')
      tab_1.SelectTab(4)
		tab_1.tabpage_4.dw_4.ScrollToRow(ix)
		tab_1.tabpage_4.dw_4.SetColumn('naermk')
		tab_1.tabpage_4.dw_4.SetFocus()
		Return -1
	End If
Next

tab_1.tabpage_5.dw_5.SetFocus()
For ix = 1 To tab_1.tabpage_5.dw_5.RowCount()
	ls_dumno = Trim(tab_1.tabpage_5.dw_5.GetItemString(ix, 'dumno'))
	
	If IsNull(ls_dumno) or ls_dumno = '' Then
		f_message_chk(40,'[��ü ������ȣ]')
      tab_1.SelectTab(5)
		tab_1.tabpage_5.dw_5.ScrollToRow(ix)
		tab_1.tabpage_5.dw_5.SetColumn('dumno')
		tab_1.tabpage_5.dw_5.SetFocus()
		Return -1
	End If
next

Return 1
------------------------------------------------------------------------------------------------------*/

end function

public function integer wf_delete_chk (string skumno);Long icnt = 0

//  SELECT COUNT(*)
//    INTO :icnt  
//    FROM ROUTNG_TOOL
//   WHERE KUMNO  = :sKumno 
//	  AND ROWNUM = 1  ;
//
//if sqlca.sqlcode <> 0 or icnt >= 1 then
//	f_message_chk(38,'[����/ġ���� ǥ�ذ��� ���]')
//	return -1
//end if
//
//  SELECT COUNT(*)
//    INTO :icnt  
//    FROM "KUMEST"  
//   WHERE ( "KUMEST"."SABU"  = :gs_sabu ) AND  
//         ( "KUMEST"."KUMNO" = :sKumno )  AND ROWNUM = 1  ;
//
//if sqlca.sqlcode <> 0 or icnt >= 1 then
//	f_message_chk(38,'[����/ġ���� ���� ���� �Ƿ�]')
//	return -1
//end if
//
//  SELECT COUNT(*)
//    INTO :icnt  
//    FROM "SHPACT_KUMHIST"  
//   WHERE ( "SHPACT_KUMHIST"."SABU"  = :gs_sabu ) AND  
//         ( "SHPACT_KUMHIST"."KUMNO" = :sKumno ) AND ROWNUM = 1   ;
//
//if sqlca.sqlcode <> 0 or icnt >= 1 then
//	f_message_chk(38,'[�۾����� ����/ġ���� ����̷�]')
//	return -1
//end if
//
//  SELECT COUNT(*)
//    INTO :icnt  
//    FROM "IMHIST"  
//   WHERE ( "SABU"  = :gs_sabu ) AND  
//         ( "YEBI3" = :sKumno ) AND ROWNUM = 1  ;
//
//if sqlca.sqlcode <> 0 or icnt >= 1 then
//	f_message_chk(38,'[�԰���� ����/ġ���� ����̷�]')
//	return -1
//end if
//
//  SELECT COUNT(*)
//    INTO :icnt  
//    FROM "KUMMST_SEND"  
//   WHERE ( "SABU"  = :gs_sabu ) AND  
//         ( "KUMNO" = :sKumno ) AND ROWNUM = 1  ;
//
//if sqlca.sqlcode <> 0 or icnt >= 1 then
//	f_message_chk(38,'[����/ġ���� �����̷�]')
//	return -1
//end if


return 1
end function

public function integer wf_set_kumno ();String sSabu, sKumno
Long   nRow, lCount

If dw_insert.AcceptText() <> 1 Then Return -1

sKumno = dw_insert.GetItemString(1,'kumno')

lCount = tab_1.tabpage_1.dw_1.RowCount()
For nRow = 1 To lCount
	sSabu  = tab_1.tabpage_1.dw_1.GetItemString(nRow, 'sabu')
	
	If IsNull(sSabu) or sSabu = '' Then
		tab_1.tabpage_1.dw_1.SetItem(nRow, 'sabu',  gs_sabu)
		tab_1.tabpage_1.dw_1.SetItem(nRow, 'kumno', sKumNo)
	End If
Next

lCount = tab_1.tabpage_3.dw_3.RowCount()
For nRow = 1 To lCount
	sSabu  = tab_1.tabpage_3.dw_3.GetItemString(nRow, 'sabu')
	
	If IsNull(sSabu) or sSabu = '' Then
		tab_1.tabpage_3.dw_3.SetItem(nRow, 'sabu',  gs_sabu)
		tab_1.tabpage_3.dw_3.SetItem(nRow, 'kumno', sKumNo)
	End If
Next

lCount = tab_1.tabpage_4.dw_4.RowCount()
For nRow = 1 To lCount
	sSabu  = tab_1.tabpage_4.dw_4.GetItemString(nRow, 'sabu')
	
	If IsNull(sSabu) or sSabu = '' Then
		tab_1.tabpage_4.dw_4.SetItem(nRow, 'sabu',  gs_sabu)
		tab_1.tabpage_4.dw_4.SetItem(nRow, 'kumno', sKumNo)
	End If
Next

lCount = tab_1.tabpage_5.dw_5.RowCount()
For nRow = 1 To lCount
	sSabu  = tab_1.tabpage_5.dw_5.GetItemString(nRow, 'sabu')
	
	If IsNull(sSabu) or sSabu = '' Then
		tab_1.tabpage_5.dw_5.SetItem(nRow, 'sabu',  gs_sabu)
		tab_1.tabpage_5.dw_5.SetItem(nRow, 'kumno', sKumNo)
	End If
Next

Return 1

end function

public function integer wf_auto_kumno ();/////////////////////////////////  �ڵ�ä�� /////////////////////////////////////////
//Long   ll_kumno
//String ls_gubun, ls_kumno, ls_max
//
//ls_Kumno = trim(dw_insert.Getitemstring(1, 'kumno'))
//ls_Gubun = dw_insert.Getitemstring(1, 'gubun')
//
//////////////////* �ڵ� ä�� ��ȿ�� üũ *////////////////
//if ls_kumno = 'M' or ls_kumno = 'J' or isnull(ls_kumno) or ls_kumno = '' then
//	if ls_gubun = 'M' then 
//		SELECT MAX(SUBSTR("KUMMST"."KUMNO", 2, 6))
//		  INTO :ls_max    
//		  FROM "KUMMST"
//		 WHERE "KUMMST"."SABU"  = :gs_sabu 
//			AND "KUMMST"."KUMNO" LIKE 'M%'
//			AND SUBSTR("KUMMST"."KUMNO", 2, 6) BETWEEN '000000' AND '999999' ;
//	elseif ls_gubun = 'J' then 
//		 SELECT MAX(SUBSTR("KUMMST"."KUMNO", 2, 6))
//		  INTO :ls_max    
//		  FROM "KUMMST"
//		 WHERE "KUMMST"."SABU"  = :gs_sabu 
//			AND "KUMMST"."KUMNO" LIKE 'J%' 
//			AND SUBSTR("KUMMST"."KUMNO", 2, 6) BETWEEN '000000' AND '999999' ;
//	end if
//	
//	IF  IsNull(ls_max) or IsNumber(ls_max) = false  THEN
//		 ls_max = '000000'
//	end if 
//
//	ll_kumno = long(ls_max) + 1
//	
//	if ll_kumno > 999999 then 
//		messagebox('Ȯ ��', 'ä���� ��ȣ�� ��ȿ���� ������ �Ѿ����ϴ�. �ڷḦ Ȯ���ϼ���!')
//		return -1
//	end if
//	dw_insert.setitem(1, "kumno", ls_Gubun + string(ll_kumno, '000000'))
//
//end if
//dw_insert.setitem(1, "sabu", gs_sabu)

return 1


end function

public function integer wf_save_image ();String	sMchNo

If Not p_img.Visible Then Return 0
if len(iblobBMP) = 0 then return 0

sMchNo = dw_insert.getitemstring(1,"kumno")

sqlca.autocommit = TRUE

//////////////////////////////////////////////////////////////////////////////////////////////
// ������ �̹��� ����
Updateblob lw_mchmes_image
   Set image = :iblobBMP
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo ;

If SQLCA.SQLCode = -1 Then
	MessageBox("Save Image SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

Commit;

sqlca.autocommit = FALSE

Return 1
end function

public function integer wf_load_image ();string	sMchNo
int 		iCnt
blob		lblobBMP

p_img.Visible = False

sMchNo = dw_insert.getitemstring(1,"kumno")
///////////////////////////////////////////////////////////////////////////////////////////////
Select count(*) Into :iCnt From lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo   ;

If iCnt = 0 Then Return -1

SELECTBLOB image into :lblobBMP from lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo ;
 
If sqlca.sqlcode = -1 Then
	MessageBox("SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

// Instance ������ ����
iblobBMP = lblobBMP

If p_img.SetPicture(iblobBMP) = 1 Then
	p_img.Visible = True
End if

Return 1
end function

public subroutine wf_calc_weight (long al_row);If al_row < 1 Then Return

dw_insert.AcceptText()

String ls_typ

ls_typ = dw_insert.GetItemString(al_row, 'kumgubn')
If trim(ls_typ) = '' Or IsNull(ls_typ) Then 
	MessageBox('�����з�Ȯ��', '�����з��� Ȯ���Ͻʽÿ�!!!')
	Return
End If

Long   ll_gshot  //�����߷�
Long   ll_sshot  //S/R�߷�
Long   ll_jshot  //��ǰ�߷�
Long   ll_gram   //�������
Long   ll_scrap  //S/R����
Long   ll_jewt   //��ǰ����

Long   ll_cav    //CAV��
Long   ll_pit    //Pitch��

ll_gshot = dw_insert.GetItemNumber(al_row, 'std_gram_shot')
If ll_gshot < 1 OR IsNull(ll_gshot) Then ll_gshot = 0

ll_sshot = dw_insert.GetItemNumber(al_row, 'std_scrap_shot')
If ll_sshot < 1 OR IsNull(ll_sshot) Then ll_sshot = 0

ll_jshot = dw_insert.GetItemNumber(al_row, 'std_jewt_shot')
If ll_jshot < 1 OR IsNull(ll_jshot) Then ll_jshot = 0

ll_cav = dw_insert.GetItemNumber(al_row, 'cvqty')
If ll_cav < 1 OR IsNull(ll_cav) Then ll_cav = 0

ll_pit = dw_insert.GetItemNumber(al_row, 'pitch')
If ll_pit < 1 OR IsNull(ll_pit) Then ll_pit = 0

Choose Case LEFT(ls_typ, 1)
	Case 'M'       //����
		//�����߷� = ��ǰ�߷� + S/R�߷�
		ll_gshot = ll_jshot + ll_sshot
		If ll_gshot < 1 OR IsNull(ll_gshot) Then ll_gshot = 0
		
		dw_insert.SetItem(al_row, 'std_gram_shot', ll_gshot)
		
		//���߰���Է�
		If ll_cav < 1 OR IsNull(ll_cav) Then
			dw_insert.SetItem(al_row, 'std_gram' , 0)
			dw_insert.SetItem(al_row, 'std_scrap', 0)
			dw_insert.SetItem(al_row, 'std_jewt' , 0)
		Else
			dw_insert.SetItem(al_row, 'std_gram' , Round(ll_gshot / ll_cav, 1))  //�������
			dw_insert.SetItem(al_row, 'std_scrap', Round(ll_sshot / ll_cav, 1))  //S/R����
			dw_insert.SetItem(al_row, 'std_jewt' , Round(ll_jshot / ll_cav, 1))  //��ǰ����
		End If
	Case 'R'  //��
		//S/R�߷� = �����߷� - ��ǰ�߷�
		ll_sshot = ll_gshot - ll_jshot 
		If ll_sshot < 1 OR IsNull(ll_sshot) Then ll_sshot = 0
		
		dw_insert.SetItem(al_row, 'std_scrap_shot', ll_sshot)
		
		//���߰���Է�
		If ll_cav < 1 OR IsNull(ll_cav) Then
			dw_insert.SetItem(al_row, 'std_gram' , 0)
			dw_insert.SetItem(al_row, 'std_scrap', 0)
			dw_insert.SetItem(al_row, 'std_jewt' , 0)
		Else
			dw_insert.SetItem(al_row, 'std_gram' , Round(ll_gshot / ll_cav, 1))  //�������
			dw_insert.SetItem(al_row, 'std_scrap', Round(ll_sshot / ll_cav, 1))  //S/R����
			dw_insert.SetItem(al_row, 'std_jewt' , Round(ll_jshot / ll_cav, 1))  //��ǰ����
		End If
		
	Case 'P'  //����
		//S/R�߷� = �����߷� - ��ǰ�߷�
		ll_sshot = ll_gshot - ll_jshot 
		If ll_sshot < 1 OR IsNull(ll_sshot) Then ll_sshot = 0
		
		dw_insert.SetItem(al_row, 'std_scrap_shot', ll_sshot)
		
		//���߰���Է� (���ڴ� PITCH�� ���߰��)
		If ll_cav < 1 OR IsNull(ll_pit) Then
			dw_insert.SetItem(al_row, 'std_gram' , 0)
			dw_insert.SetItem(al_row, 'std_scrap', 0)
			dw_insert.SetItem(al_row, 'std_jewt' , 0)
		Else
			dw_insert.SetItem(al_row, 'std_gram' , Round(ll_gshot / ll_pit, 1))  //�������
			dw_insert.SetItem(al_row, 'std_scrap', Round(ll_sshot / ll_pit, 1))  //S/R����
			dw_insert.SetItem(al_row, 'std_jewt' , Round(ll_jshot / ll_pit, 1))  //��ǰ����
		End If
		
End Choose


end subroutine

on w_imt_04630_dev.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_2=create p_2
this.tab_1=create tab_1
this.pb_1=create pb_1
this.dw_6=create dw_6
this.st_2=create st_2
this.p_img=create p_img
this.p_img_in=create p_img_in
this.cb_1=create cb_1
this.rr_6=create rr_6
this.rr_7=create rr_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_6
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.p_img
this.Control[iCurrent+8]=this.p_img_in
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.rr_6
this.Control[iCurrent+11]=this.rr_7
end on

on w_imt_04630_dev.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.tab_1)
destroy(this.pb_1)
destroy(this.dw_6)
destroy(this.st_2)
destroy(this.p_img)
destroy(this.p_img_in)
destroy(this.cb_1)
destroy(this.rr_6)
destroy(this.rr_7)
end on

event open;call super::open;
dw_insert.SetTransObject(sqlca)
dw_6.SetTransObject(SQLCA)

//tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
//tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
//tab_1.tabpage_3.dw_3.SetTransObject(sqlca)
//tab_1.tabpage_4.dw_4.SetTransObject(sqlca)
//tab_1.tabpage_5.dw_5.SetTransObject(sqlca)

/* �԰�,���� Text ���� */
//If f_change_name('1') = 'Y' Then
//	String sIspecText, sJijilText
//	
//	sIspecText = f_change_name('2')
//	sJijilText = f_change_name('3')
//	
//	tab_1.tabpage_2.dw_2.Object.ispec_t.text =  sIspecText 
//	tab_1.tabpage_2.dw_2.Object.jijil_t.text =  sJijilText
//	tab_1.tabpage_3.dw_3.Object.ispec_t.text =  sIspecText 
//	tab_1.tabpage_3.dw_3.Object.jijil_t.text =  sJijilText
//End If

wf_init()
//tab_1.tabpage_2.enabled = false
end event

type dw_insert from w_inherite`dw_insert within w_imt_04630_dev
integer x = 27
integer y = 160
integer width = 2619
integer height = 1268
integer taborder = 150
string dataobject = "d_imt_04630"
boolean border = false
end type

event dw_insert::itemchanged;String sKsts, sNull, sCvcod, sCvcodNm, sItnbr, sItdsc, sKumNo, ls_gubun 
long   ll_cvqty, ll_cumqty, ll_tabcnt 

SetNull(sNull)

Choose Case GetColumnName()
	Case 'kumno'
		sKumNo = Trim(GetText())
		IF sKumNo ="" OR IsNull(sKumNo) THEN  Return
		
		SELECT "KUMNO"  INTO :sKumNo
		  FROM "KUMMST"
		 WHERE "SABU" = :gs_sabu AND "KUMNO" = :sKumNo;
		
		IF SQLCA.SQLCODE = 0 THEN
			p_inq.TriggerEvent(Clicked!)
		Else
			MessageBox('�̵�� �����ڵ�', '��ϵ� �����ڵ尡 �ƴմϴ�!!')
		End If
				
	/* ���� */
	Case 'kstat'
		sKsts = Trim(GetText())
		
		/* ��� */
		If sKsts = '4' Then
			SetItem(1,'pegbn','Y')
		Else
			SetItem(1,'pegbn','N')
			SetItem(1,'pedat',sNull)
			SetItem(1,'pesay',sNull)
		End If
	/* �������� */
	Case 'makdat'
		sKumNo = Trim(GetText())
		IF sKumNo ="" OR IsNull(sKumNo) THEN  Return
		
		If f_DateChk(sKumNo) = -1 then
			SetItem(1, "makdat", sNull)
			f_Message_Chk(35, '[��������]')
			Return 1
		End If
	/* ������� */
	Case 'pedat'
		sKumNo = Trim(GetText())
		IF sKumNo ="" OR IsNull(sKumNo) THEN  Return
		
		If f_DateChk(sKumNo) = -1 then
			SetItem(1, "pedat", sNull)
			f_Message_Chk(35, '[�������]')
			Return 1
		End If
	/* ����ó */
	Case "bocvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"bocvcodnm",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sCvcodNm
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sCvcod;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"bocvcodnm",  sCvcodNm)
		END IF
	/* ����ó */
	Case "jecvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"jecvcodnm",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sCvcodNm
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sCvcod;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"jecvcodnm",  sCvcodNm)
		END IF
	
	/* �ֹ�ó */
	Case "ordcvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"ordcvcodnm",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sCvcodNm
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sCvcod;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"ordcvcodnm",  sCvcodNm)
		END IF
		
	/* ���ó */
	Case "usecvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"usecvcodnm",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sCvcodNm
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sCvcod;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"usecvcodnm",  sCvcodNm)
		END IF	
/////////////////////////////////////////////////////////////////////
   
  Case "gubun"
//		ls_gubun = trim(gettext())
//				if  ls_gubun = 'M' then
//					setitem(1,'kumno','M')
//					setcolumn('kumno')
//				else
//					setitem(1,'kumno','J')
//					setcolumn('kumno')
//				end if
			
  Case "cvqty"
	   
       dw_insert.Accepttext()
	    ll_cvqty = long(Getitemnumber(1,"cvqty"))
		 ll_cumqty = long(Getitemnumber(1,"cumqty")) 
		 
		 if not IsNull(ll_cvqty) and  not IsNull(ll_cumqty) and ll_cvqty <> 0 and ll_cumqty <>0 then
			 ll_tabcnt = ll_cumqty / ll_cvqty
          ll_tabcnt = round(ll_tabcnt,0)		
			 setItem(1,"tabcnt",ll_tabcnt)
			 dw_insert.Modify('tabcnt.protect = 1')
		 else
			return
		 end if
		
	Case "cumqty"
						
       dw_insert.Accepttext()
	    ll_cvqty = long(Getitemnumber(1,"cvqty"))
		 ll_cumqty = long(Getitemnumber(1,"cumqty"))
		 
				 		 		  
		 if not IsNull(ll_cvqty) and  not IsNull(ll_cumqty) and ll_cvqty <> 0 and ll_cumqty <>0 then
			 ll_tabcnt = ll_cumqty / ll_cvqty  
          ll_tabcnt = round(ll_tabcnt,0)	   	
			 setItem(1,"tabcnt",ll_tabcnt)
			 dw_insert.Modify('tabcnt.protect = 1')
		 else
			return
		 end if
		
   
	/* ǰ�� */
	Case	"citnbr" 
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(1,'itdsc',sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITDSC"
		  INTO :sItdsc
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		SetItem(1,"itdsc", sItdsc)
End Choose

//wf_calc_weight(1)
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;String sCvcodNm, sKumNo

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* ������ȣ */
	Case "kumno"
		gs_gubun = this.getitemstring(1, 'gubun')
		OPEN(w_imt_04630_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(1,'kumno', gs_code)
		p_inq.TriggerEvent(Clicked!)
	/* ����ó */
	Case "bocvcod"
		If This.GetItemString(row, 'kummst_kum_inout') = 'I' Then
			//�系-�μ�
			gs_gubun = '4'
		Else
			//���-�ŷ�ó
			gs_gubun = '1'
		End If
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'bocvcod', gs_code)
		
		If gs_gubun = '4' Then
			//�系-�μ�
			This.SetItem(row, 'bocvcodnm', f_get_name5('01', gs_code, ''))
		ElseIf gs_gubun = '1' Then
			//���-�ŷ�ó
			This.SetItem(row, 'bocvcodnm', f_get_name5('11', gs_code, ''))
		End If
		SetNull(gs_gubun)	
	/* ����ó */
	Case "jecvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"jecvcod",gs_code)
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sCvcodNm
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
		  SetItem(1,"jecvcodnm",  sCvcodNm)
		END IF
	/* ǰ�� */
	Case "citnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"citnbr",gs_code)
		SetColumn('citnbr')
		PostEvent(ItemChanged!)
		
   /* ����ó */
	Case "ordcvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"ordcvcod",gs_code)
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sCvcodNm
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
		  SetItem(1,"ordcvcodnm",  sCvcodNm)
		END IF
		
	/* ���ó */
	Case "usecvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"usecvcod",gs_code)
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sCvcodNm
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
		  SetItem(1,"usecvcodnm",  sCvcodNm)
		END IF
	Case 'klocation'
		//Address�� ��� 2005.11.07
		open(w_workplace_popup)
		If 	IsNull(gs_code) Or gs_code = '' Then Return
		this.SetItem(1, "klocation", gs_code)
		this.SetItem(1, "locnm", gs_codename)	
End Choose
end event

event dw_insert::buttonclicked;//string pathname, filename
//integer value
//
//if dwo.name <> "btn1" then return
//
////���񸶽�Ÿ �̹��� ��� ������ Call
//pathname = this.getitemstring(1, 'imgpath')
//
//OpenWithParm(w_imt_04630_1, pathname)
//pathname = Message.StringParm
//
//if not (IsNull(pathname) or pathname = "") then
//   dw_insert.SetItem(1,'imgpath',Trim(pathname))
//end if
end event

event dw_insert::ue_pressenter;//
Choose Case This.GetColumnName()
	Case 'rmks'
		Return
End Choose

Send(Handle(this),256,9,0)
Return 1
end event

type p_delrow from w_inherite`p_delrow within w_imt_04630_dev
integer x = 4338
integer y = 5000
integer taborder = 60
end type

type p_addrow from w_inherite`p_addrow within w_imt_04630_dev
integer x = 4165
integer y = 5000
integer taborder = 40
end type

type p_search from w_inherite`p_search within w_imt_04630_dev
boolean visible = false
integer x = 3922
integer y = 2476
integer taborder = 110
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::clicked;call super::clicked;String sKumno

sKumno	= Trim(dw_insert.GetItemString(1,'kumno'))

If f_msg_delete() = -1 then return

//���� ���ɿ��� üũ�� �־�� �� 
if wf_delete_chk(sKumno) = -1 then return 

//DELETE FROM KUMMST_HIST WHERE SABU = :gs_sabu AND KUMNO = :sKumno;
//If sqlca.sqlcode <> 0 Then
//	RollBack;
//	f_message_chk(31,'KUMMST_HIST')
//	wf_init()
//	Return
//End If
//
//DELETE FROM KUMMST_ITEM WHERE SABU = :gs_sabu AND KUMNO = :sKumno;
//If sqlca.sqlcode <> 0 Then
//	RollBack;
//	f_message_chk(31,'KUMMST_ITEM')
//	wf_init()
//	Return
//End If
//
//DELETE FROM KUMMST_SET WHERE SABU = :gs_sabu AND KUMNO = :sKumno;
//If sqlca.sqlcode <> 0 Then
//	RollBack;
//	f_message_chk(31,'KUMMST_SET')
//	wf_init()
//	Return
//End If
//
//DELETE FROM KUMMST_DAC WHERE SABU = :gs_sabu AND KUMNO = :sKumno;
//If sqlca.sqlcode <> 0 Then
//	RollBack;
//	f_message_chk(31,'KUMMST_DAC')
//	wf_init()
//	Return
//End If

//S'Part ����
DELETE FROM KUMMST_KUM WHERE MCHNO = :sKumno ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	f_message_chk(31, 'KUMMST_KUM')
	wf_init()
	Return
End If

//IMAGE ����
DELETE FROM  LW_MCHMES_IMAGE
 WHERE SABU = :gs_sabu AND MCHGB = '2' AND MCHNO = :sKumno;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	f_message_chk(31, 'LW_MCHMES_IMAGE')
	wf_init()
	Return
End If

//Master ����
DELETE FROM KUMMST WHERE SABU = :gs_sabu AND KUMNO = :sKumno;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'KUMMST')
	wf_init()
	Return
End If

COMMIT;
wf_init()

w_mdi_frame.sle_msg.text = '�ڷḦ �����Ͽ����ϴ�!!'
end event

event p_search::ue_lbuttondown;pictureName = "C:\erpman\image\����_dn.gif"
end event

event p_search::ue_lbuttonup;pictureName = "C:\erpman\image\����_up.gif"
end event

type p_ins from w_inherite`p_ins within w_imt_04630_dev
boolean visible = false
integer x = 4110
integer y = 2472
string picturename = "C:\erpman\image\���߰�_up.gif"
end type

event p_ins::clicked;call super::clicked;String sKumno
Long	 nRow

If dw_insert.AcceptText() <> 1 Then Return -1

sKumno	= Trim(dw_insert.GetItemString(1,'kumno'))

If IsNull(sKumno) or sKumno = '' Then
	f_message_chk(40,'[������ȣ]')
	dw_insert.SetColumn('kumno')
	dw_insert.SetFocus()
	Return -1
End If

Long ll_in
ll_in = dw_6.InsertRow(0)

dw_6.SetItem(ll_in, 'mchno', sKumno)
dw_6.ScrollToRow(ll_in)
dw_6.SetRow(ll_in)
dw_6.SetColumn('bitnbr')
dw_6.SetFocus()


//Choose Case tab_1.SelectedTab
//	/* �������� */
//	Case 1
//		nRow = tab_1.tabpage_1.dw_1.InsertRow(0)
//		tab_1.tabpage_1.dw_1.ScrollToRow(nRow)
//		tab_1.tabpage_1.dw_1.SetRow(nRow)
//		tab_1.tabpage_1.dw_1.setColumn('untno')
//		tab_1.tabpage_1.dw_1.SetFocus()
//	Case 2
//		messagebox('Ȯ ��', '�� �߰��� �ڷᰡ �ƴմϴ�. ǥ�ذ������� �ڷᰡ �Էµ˴ϴ�.')
//	/* ǰ�� */
//	Case 3
//		nRow = tab_1.tabpage_3.dw_3.InsertRow(0)
//		tab_1.tabpage_3.dw_3.ScrollToRow(nRow)
//		tab_1.tabpage_3.dw_3.SetRow(nRow)
//		tab_1.tabpage_3.dw_3.setColumn('itnbr')
//		tab_1.tabpage_3.dw_3.SetFocus()
//	/* �̷� */
//	Case 4
//		nRow = tab_1.tabpage_4.dw_4.InsertRow(0)
//		tab_1.tabpage_4.dw_4.ScrollToRow(nRow)
//		tab_1.tabpage_4.dw_4.SetRow(nRow)
//		tab_1.tabpage_4.dw_4.setColumn('hisdat')
//		tab_1.tabpage_4.dw_4.SetFocus()
//	/* ��ü���� */	
//	Case 5
//		nRow = tab_1.tabpage_5.dw_5.InsertRow(0)
//		tab_1.tabpage_5.dw_5.ScrollToRow(nRow)
//		tab_1.tabpage_5.dw_5.SetRow(nRow)
//		tab_1.tabpage_5.dw_5.setColumn('gubun')
//		tab_1.tabpage_5.dw_5.SetFocus()
//End Choose

ib_any_typing = TRUE

end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\���߰�_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\���߰�_up.gif"
end event

type p_exit from w_inherite`p_exit within w_imt_04630_dev
integer x = 4315
integer y = 0
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_imt_04630_dev
integer x = 4142
integer y = 0
integer taborder = 90
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_imt_04630_dev
boolean visible = false
integer x = 3735
integer y = 2480
integer taborder = 130
boolean enabled = false
string picturename = "C:\erpman\image\�����ڷ���ȸ_up.gif"
end type

event p_print::clicked;call super::clicked;//if dw_insert.AcceptText() = -1 then return 
//
//gs_code     = dw_insert.getitemstring(1, 'kumno')
//
//open(w_imt_04630_popup2) 
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\�����ڷ���ȸ_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\�����ڷ���ȸ_up.gif"
end event

type p_inq from w_inherite`p_inq within w_imt_04630_dev
integer x = 3794
integer y = 0
end type

event p_inq::clicked;call super::clicked;String sKumNo, ls_sql, ls_gubun
Long ll_qty

If dw_insert.AcceptText() <> 1 Then Return

sKumNo = Trim(dw_insert.GetItemString(1,'kumno'))

ls_gubun = Trim(dw_insert.GetItemString(1,'gubun'))

IF IsNull(sKumNo)	 or  sKumNo = ''	THEN
	f_message_chk(30,'[�����ڵ�]')
	dw_insert.SetColumn("kumno")
	dw_insert.SetFocus()
	RETURN
END IF


If dw_insert.Retrieve(gs_sabu, sKumNo) <= 0 Then
	f_message_chk(50,'')
	dw_insert.InsertRow(0)
	dw_6.ReSet()
	ic_status = '1'
	p_1.enabled = false 
	p_1.Picturename = "c:\erpman\image\�����̷�_d.gif"
Else
	
	dw_6.SetRedraw(False)

	dw_6.Retrieve(sKumno)

   dw_6.SetRedraw(True)
	
   dw_insert.Modify('kumno.protect = 1')
// dw_insert.Modify("kumno.background.color = 79741120")
   dw_insert.Modify('gubun.protect = 1')
// dw_insert.Modify("gubun.background.color = 79741120")
	ic_status = '2'
	p_1.enabled = true
	p_1.Picturename = "c:\erpman\image\�����̷�_up.gif"
	
	ll_qty = dw_insert.GetItemNumber(1, 'limqty')
	
	If IsNull(ll_qty) OR ll_qty < 1 Then	
		If LEFT(sKumNo, 1)  = 'M' Then
			dw_insert.SetItem(1, 'limqty', 1000000)
		ElseIf LEFT(sKumNo, 1) = 'P' Then
			dw_insert.SetItem(1, 'limqty', 30000000)
		ElseIf LEFT(sKumNo, 1) = 'R' Then
			dw_insert.SetItem(1, 'limqty', 300000)
		End If
	End If
	
	wf_load_image()
End If

ib_any_typing = False

end event

type p_del from w_inherite`p_del within w_imt_04630_dev
boolean visible = false
integer x = 4283
integer y = 2472
integer taborder = 80
string picturename = "C:\erpman\image\�����_up.gif"
end type

event p_del::clicked;call super::clicked;//Choose Case tab_1.selectedtab
//	Case 1
//		tab_1.tabpage_1.dw_1.deleterow(0)
//	Case 2
//		messagebox('Ȯ ��', '�� ������ �ڷᰡ �ƴմϴ�. ǥ�ذ������� �ڷḦ �����ϼ���.')
//	/* ǰ�� */
//	Case 3
//		tab_1.tabpage_3.dw_3.deleterow(0)
//	/* �̷� */
//	Case 4
//		tab_1.tabpage_4.dw_4.deleterow(0)
//    /* ��ü ���� */
//  Case 5
//	   tab_1.tabpage_5.dw_5.deleterow(0)
//End Choose

long lcRow
//Boolean fg

lcRow = dw_6.GetRow()

if lcRow < 1 then 
	messagebox('Ȯ ��', '������ �ڷḦ �����ϼ���!')
	return 
end if

if f_msg_delete() = -1 then return

//if IsNull(dw_6.object.sabu[lcRow]) or dw_6.object.sabu[lcRow] = "" then
//	fg = False
//else
//	fg = True
//end if	
dw_6.DeleteRow(lcRow)

//if fg = True then
   if dw_6.Update(false, true) <> 1 then
      ROLLBACK;
	   f_message_chk(31,'[�������� : �������� ���]') 
	   w_mdi_frame.sle_msg.text = "���� �۾� ����!"
	   Return
   else
      COMMIT;		
		dw_6.ResetUpdate()
   end if
//end if

w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"

ib_any_typing = TRUE

end event

event p_del::ue_lbuttondown;pictureName = "C:\erpman\image\�����_dn.gif"
end event

event p_del::ue_lbuttonup;pictureName = "C:\erpman\image\�����_up.gif"
end event

type p_mod from w_inherite`p_mod within w_imt_04630_dev
integer x = 3968
integer y = 0
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;If wf_chk() <> 1 Then Return 

IF MessageBox("Ȯ��", "�����Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN

//// �ڵ� ä�� 
//IF ic_status = '1' THEN 
//	IF wf_auto_kumno() = -1 then return 
//END IF

//// ������ȣ�� �ǿ� ����
//If wf_set_kumno() <> 1 Then Return 
//
//IF tab_1.tabpage_1.dw_1.Update() <> 1	THEN
//	ROLLBACK USING sqlca;
//	f_message_chk(32,'[��������]')
//	Return
//END IF

//IF tab_1.tabpage_2.dw_2.Update() <> 1	THEN
//	ROLLBACK USING sqlca;
//	f_message_chk(32,'[������]')
//	Return
//END IF

//IF tab_1.tabpage_3.dw_3.Update() <> 1	THEN
//	ROLLBACK USING sqlca;
//	f_message_chk(32,'[ǰ��]')
//	Return
//END IF
//
///* �̷� ���� */
//IF tab_1.tabpage_4.dw_4.Update() <> 1	THEN
//	ROLLBACK USING sqlca;
//	f_message_chk(32,'[�̷�]')
//	Return
//END IF
//			
///* ��ü���� */
//IF tab_1.tabpage_5.dw_5.Update() <> 1	THEN
//	ROLLBACK USING sqlca;
//	f_message_chk(32,'[��ü]')
//	Return
//END IF

String smchno
Long   icnt

dw_insert.SetItem(1, 'sabu', gs_sabu)

/* ����Ÿ ���� *////////////////////////////////////////////////////
IF dw_insert.Update() = 1	THEN
	//S'Part ����
	If dw_6.UPDATE() = 1 Then	
		///////////////////////////////////////////////////////////////////////////////////////////////
		smchno = trim(dw_insert.getitemstring(1,'kumno'))
		
		Select count(*) Into :iCnt From lw_mchmes_image
		 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo   ;
		 
		If iCnt = 0 Then
			Insert Into lw_mchmes_image
			( sabu,				mchgb,		mchno )
			Values
			( :gs_sabu,			'2',			:smchno ) ;
						
			if sqlca.sqlcode <> 0 then
				rollback ;
				messagebox("�̹��� �������", "���� �̹��� ���� ����!!!")
				return
			end if
		End If
		///////////////////////////////////////////////////////////////////////////////////////////////
	Else
		ROLLBACK USING SQLCA;
		f_message_chk(32, '[SPARE PART]')
		Return
	End If
		
	COMMIT USING sqlca;
	wf_save_image()
	
	p_inq.triggerevent(clicked!)
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"		
ELSE
	ROLLBACK USING sqlca;
	f_message_chk(32,'')
	Return
END IF

p_inq.triggerevent(clicked!)









end event

type cb_exit from w_inherite`cb_exit within w_imt_04630_dev
integer x = 5714
integer y = 988
integer width = 297
integer taborder = 170
integer textsize = -9
end type

type cb_mod from w_inherite`cb_mod within w_imt_04630_dev
integer x = 4782
integer y = 988
integer width = 297
integer taborder = 120
integer textsize = -9
end type

type cb_ins from w_inherite`cb_ins within w_imt_04630_dev
end type

type cb_del from w_inherite`cb_del within w_imt_04630_dev
end type

type cb_inq from w_inherite`cb_inq within w_imt_04630_dev
end type

type cb_print from w_inherite`cb_print within w_imt_04630_dev
end type

type st_1 from w_inherite`st_1 within w_imt_04630_dev
end type

type cb_can from w_inherite`cb_can within w_imt_04630_dev
integer x = 5403
integer y = 988
integer width = 297
integer taborder = 160
integer textsize = -9
end type

type cb_search from w_inherite`cb_search within w_imt_04630_dev
integer x = 5093
integer y = 988
integer width = 297
integer taborder = 140
integer textsize = -9
string text = "����(&D)"
end type





type gb_10 from w_inherite`gb_10 within w_imt_04630_dev
integer x = 9
integer y = 2484
integer height = 136
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_04630_dev
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_04630_dev
end type

type p_1 from uo_picture within w_imt_04630_dev
boolean visible = false
integer x = 242
integer y = 2656
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "c:\erpman\image\�����̷�_d.gif"
end type

event clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if	ic_status <> '2' then 
	messagebox('Ȯ ��', '�ڷḦ ���� �� ó���ϼ���!')
	return 
end if

gs_code = dw_insert.getitemstring(1, "kumno")
open(w_imt_04630_01)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\�����̷�_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\�����̷�_dn.gif"
end event

type p_2 from uo_picture within w_imt_04630_dev
boolean visible = false
integer x = 64
integer y = 2656
integer width = 178
boolean bringtotop = true
string picturename = "c:\erpman\image\�����԰���ȸ_up.gif"
end type

event clicked;call super::clicked;//if dw_insert.AcceptText() = -1 then return 
//
//gs_code     = dw_insert.getitemstring(1, 'kumno')
//
//open(w_imt_04630_popup3) 
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\�����԰���ȸ_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\�����԰���ȸ_dn.gif"
end event

type tab_1 from tab within w_imt_04630_dev
boolean visible = false
integer x = 50
integer y = 2804
integer width = 4521
integer height = 1248
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4485
integer height = 1136
long backcolor = 32106727
string text = "��������"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_1 dw_1
rr_1 rr_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_1,&
this.rr_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
destroy(this.rr_1)
end on

type dw_1 from datawindow within tabpage_1
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 8
integer width = 4462
integer height = 1108
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_046301"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

long nRow
nRow = GetRow()
If nRow <= 0 Then Return

if getcolumnname() = "untpre" then
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(nRow,"untpre",gs_code)
end if
end event

event itemerror;return 1
end event

event itemchanged;Long   nRow, ireturn, lReturnRow, lNull 
String sItnbr, sItdsc, sispec, sjijil, sIspec_code, sNull

nRow = GetRow()
If nRow <= 0 then Return

SetNull(sNull)
SetNull(lNull)

Choose Case GetColumnName()
	Case	"untno" 
		sItnbr = GetText()
		IF IsNull(sItnbr) THEN Return
		
		lReturnRow = This.Find("sfind = '"+sitnbr+"' ", 1, This.RowCount())
		IF (nRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[UNIT-NO]') 
			this.SetItem(nRow, "untno", lNull)
			RETURN  1
		END IF
	
	Case	"untcd" 
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN Return

		Select rfna1 into :sItdsc
		  From reffpf where rfcod = '7F' And rfgub = :sItnbr;
		  
		if sqlca.sqlcode <> 0 then
			f_message_chk(33,'[Unit �з�]')		
			setitem(nRow, "untcd", snull)
			return 1		
		else
			setitem(nRow, "untnm", sItdsc)
		End if 
	/* ǰ�� */
	Case	"untpre" 
		sItnbr = Trim(GetText())
 	   ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sIspec_code)  
		this.setitem(nRow, "untpre", sItnbr)	
		RETURN ireturn
End Choose

end event

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 4
integer width = 4480
integer height = 1120
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4485
integer height = 1136
long backcolor = 32106727
string text = "������"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_2 dw_2
rr_2 rr_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.rr_2=create rr_2
this.Control[]={this.dw_2,&
this.rr_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
destroy(this.rr_2)
end on

type dw_2 from datawindow within tabpage_2
event ue_pressenter pbm_dwnprocessenter
integer x = 9
integer y = 8
integer width = 4457
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_imt_046302"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 4
integer width = 4471
integer height = 1120
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4485
integer height = 1136
long backcolor = 32106727
string text = "ǰ��"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_3 dw_3
rr_3 rr_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.rr_3=create rr_3
this.Control[]={this.dw_3,&
this.rr_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
destroy(this.rr_3)
end on

type dw_3 from datawindow within tabpage_3
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 20
integer width = 4434
integer height = 1084
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_imt_046303"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;Long   nRow, ireturn, lReturnRow
String sItnbr, sItdsc, sIspec, sJijil, sNull, sIspec_code

nRow = GetRow()
If nRow <= 0 then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* ǰ�� */
	Case	"itnbr" 
		sItnbr = Trim(GetText())
		IF IsNull(sItnbr) or sItnbr = '' THEN
			this.SetItem(nRow, "itdsc", sNull)
			this.SetItem(nRow, "ispec", sNull)
			this.SetItem(nRow, "ispec_code", sNull)
			this.SetItem(nRow, "jijil", sNull)
			Return
		End if

		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (nRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[ǰ��]') 
			this.SetItem(nRow, "itnbr", sNull)
			this.SetItem(nRow, "itdsc", sNull)
			this.SetItem(nRow, "ispec", sNull)
			this.SetItem(nRow, "ispec_code", sNull)
			this.SetItem(nRow, "jijil", sNull)
			RETURN  1
		END IF
		
 	   ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sIspec_code)  
		setitem(nRow, "itnbr", sItnbr)	
		SetItem(nRow, "itdsc", sItdsc)
		SetItem(nRow, "ispec", sIspec)
		SetItem(nRow, "ispec_code", sIspec_code)
		SetItem(nRow, "jijil", sJijil)
		RETURN ireturn
		
	Case  "itdsc"	
		sitdsc = trim(this.GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		this.setitem(nrow, "itnbr", sitnbr)	
		this.setitem(nrow, "itdsc", sitdsc)	
		this.setitem(nrow, "ispec", sispec)
		this.setitem(nrow, "ispec_code", sispec_code)
		this.setitem(nrow, "jijil", sjijil)
		
		IF sitnbr > '.' THEN 
			lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
			IF (nRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[ǰ��]') 
				this.SetItem(nRow, "itnbr", sNull)
				this.SetItem(nRow, "itdsc", sNull)
				this.SetItem(nRow, "ispec", sNull)
				this.SetItem(nRow, "ispec_code", sNull)
				this.SetItem(nRow, "jijil", sNull)
				RETURN  1
			END IF
		END IF	
		RETURN ireturn
	Case "ispec"	
		sispec = trim(this.GetText())
	
		ireturn = f_get_name4('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		this.setitem(nrow, "itnbr", sitnbr)	
		this.setitem(nrow, "itdsc", sitdsc)	
		this.setitem(nrow, "ispec", sispec)
		this.setitem(nrow, "ispec_code", sispec_code)
		this.setitem(nrow, "jijil", sjijil)

		IF sitnbr > '.' THEN 
			lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
			IF (nRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[ǰ��]') 
				this.SetItem(nRow, "itnbr", sNull)
				this.SetItem(nRow, "itdsc", sNull)
				this.SetItem(nRow, "ispec", sNull)
				this.SetItem(nRow, "ispec_code", sNull)
				this.SetItem(nRow, "jijil", sNull)
				RETURN  1
			END IF
		END IF	
		RETURN ireturn
  Case "jijil"	
		sjijil = trim(this.GetText())
	
		ireturn = f_get_name4('����', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		this.setitem(nrow, "itnbr", sitnbr)	
		this.setitem(nrow, "itdsc", sitdsc)	
		this.setitem(nrow, "ispec", sispec)
		this.setitem(nrow, "ispec_code", sispec_code)
		this.setitem(nrow, "jijil", sjijil)
		IF sitnbr > '.' THEN 
			lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
			IF (nRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[ǰ��]') 
				this.SetItem(nRow, "itnbr", sNull)
				this.SetItem(nRow, "itdsc", sNull)
				this.SetItem(nRow, "ispec", sNull)
				this.SetItem(nRow, "ispec_code", sNull)
				this.SetItem(nRow, "jijil", sNull)
				RETURN  1
			END IF
		END IF	
		RETURN ireturn
  Case "ispec_code"	
		sispec_code = trim(this.GetText())
	
		ireturn = f_get_name4('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		this.setitem(nrow, "itnbr", sitnbr)	
		this.setitem(nrow, "itdsc", sitdsc)	
		this.setitem(nrow, "ispec", sispec)
		this.setitem(nrow, "ispec_code", sispec_code)
		this.setitem(nrow, "jijil", sjijil)
		
		IF sitnbr > '.' THEN 
			lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
			IF (nRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[ǰ��]') 
				this.SetItem(nRow, "itnbr", sNull)
				this.SetItem(nRow, "itdsc", sNull)
				this.SetItem(nRow, "ispec", sNull)
				this.SetItem(nRow, "ispec_code", sNull)
				this.SetItem(nRow, "jijil", sNull)
				RETURN  1
			END IF
		END IF	
		RETURN ireturn
		  
End Choose


	

end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Long nRow

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	/* ǰ�� */
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow, "itnbr", gs_code)
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
End Choose

end event

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 16
integer width = 4448
integer height = 1096
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4485
integer height = 1136
long backcolor = 32106727
string text = "�̷�"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_4 dw_4
rr_4 rr_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.rr_4=create rr_4
this.Control[]={this.dw_4,&
this.rr_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
destroy(this.rr_4)
end on

type dw_4 from datawindow within tabpage_4
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 24
integer width = 4430
integer height = 1080
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_imt_046304"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;Long nRow, lUntNo
String sNull, sUntNm, sKumNo

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)
Choose Case GetColumnName()
	/* ���� */
	Case 'hisdat','stdat','eddat', 'ipdat'
		If f_DateChk(Trim(getText())) = -1 then
			f_Message_Chk(35, '[����]')
			SetItem(nRow, GetColumnName(), sNull)
			Return 1
		End If
	Case 'untno'
		lUntNo = Long(Trim(GetText()))
		If IsNull(lUntNo)  Then 
			SetItem(nRow, 'untnm', sNull)
			Return 2
		End If
		
		sKumNo = Trim(GetItemString(nRow, 'kumno'))
		SELECT UNTNM INTO :sUntNm
		  FROM KUMMST_SET
		 WHERE SABU  = :gs_sabu AND
		       KUMNO = :sKumNo AND
				 UNTNO = :lUntNo;
		If sqlca.sqlcode = 0 Then
			SetItem(nRow, 'untnm', sUntNm)
		Else
			SetItem(nRow, 'untnm', sNull)
		End If
End Choose

end event

event itemerror;return 1
end event

type rr_4 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 12
integer width = 4453
integer height = 1104
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4485
integer height = 1136
long backcolor = 32106727
string text = "��ü"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_5 dw_5
rr_5 rr_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.rr_5=create rr_5
this.Control[]={this.dw_5,&
this.rr_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
destroy(this.rr_5)
end on

type dw_5 from datawindow within tabpage_5
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 20
integer width = 4430
integer height = 1092
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_imt_046305"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;Long   nRow, lReturnRow
String ls_dumno, ls_kumname, snull, ls_kumno, skbono

nRow = GetRow()
If nRow <= 0 then Return

SetNull(sNull)

if this.getcolumnname() = "dumno" then	 
	ls_dumno = Trim(GetText())
	
	IF ls_dumno ="" OR IsNull(ls_dumno) THEN
		this.setitem(nRow, "dumnam", sNull)	
		this.setitem(nRow, "kbono", sNull)	
		Return
	END IF
	
	ls_kumno = this.getitemstring(nRow, "kumno")
	
	If ls_dumno = ls_kumno Then
		messagebox ( "Ȯ��", "������ȣ�� ��ü�� ������ȣ�� �����ϴ�. �ڷḦ Ȯ���ϼ���!")
		setitem(nRow, "dumno", snull)
		setitem(nRow, "dumnam", snull)
		setitem(nRow, "kbono", snull)
		Return 1
	End If

	lReturnRow = This.Find("dumno = '"+ls_dumno+"' ", 1, This.RowCount())
	IF (nRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[��ü ������ȣ]') 
		setitem(nRow, "dumno", sNull)	
		setitem(nRow, "dumnam", sNull)	
		setitem(nRow, "kbono", sNull)	
		RETURN  1
	END IF
	
	SELECT kumname, kbono
	  INTO :ls_kumname, :skbono
	  FROM kummst
	 WHERE sabu = :gs_sabu and kumno= :ls_dumno ;
	
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33,'[��ü ������ȣ]')
		setitem(nRow, "dumno", sNull)	
		setitem(nRow, "dumnam", sNull)	
		setitem(nRow, "kbono", sNull)	
		RETURN 1
	END IF
	
	setitem(nRow, "dumnam", ls_kumname)
	setitem(nRow, "kbono", skbono)
end if
		

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "dumno" then
	OPEN(w_imt_04630_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
		
	SetItem(this.getrow(), 'dumno',  gs_code)
	this.triggerevent(itemchanged!)
end if
end event

event itemerror;return 1
end event

type rr_5 from roundrectangle within tabpage_5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 8
integer width = 4462
integer height = 1120
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_1 from u_pb_cal within w_imt_04630_dev
boolean visible = false
integer x = 1687
integer y = 2660
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('pedat')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'pedat', gs_code)



end event

type dw_6 from datawindow within w_imt_04630_dev
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 55
integer y = 1524
integer width = 4457
integer height = 784
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_imt_046301_dev"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;Long nRow, ireturn
String sItnbr, sItdsc, sIspec, sIspec_code, sJijil, sNull

nRow = GetRow()
If nRow <= 0 then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* ǰ�� */
	Case	"itnbr" 
		sItnbr  = Trim(GetText())
		ireturn = f_get_name4('ǰ��', 'Y', sItnbr, sItdsc, sIspec, sJijil, sIspec_code)
		SetItem(nRow, "itnbr", sItnbr)
		SetItem(nRow, "itdsc", sItdsc)
		RETURN ireturn
End Choose

end event

event itemerror;return 1
end event

event rbuttondown;Long nRow

nRow = GetRow()
If nRow <= 0 Then Return

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

Choose Case GetColumnName()
	/* ǰ�� */
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow, "itnbr", gs_code)
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
End Choose
end event

type st_2 from statictext within w_imt_04630_dev
integer x = 50
integer y = 1452
integer width = 722
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[SPARE PART LIST]"
boolean focusrectangle = false
end type

type p_img from picture within w_imt_04630_dev
integer x = 2725
integer y = 224
integer width = 1705
integer height = 1128
boolean bringtotop = true
string pointer = "HyperLink!"
boolean border = true
boolean focusrectangle = false
end type

event constructor;//This.Visible = False
end event

event clicked;p_img_in.PostEvent(Clicked!)
end event

type p_img_in from picture within w_imt_04630_dev
integer x = 3543
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\�׸����.gif"
boolean focusrectangle = false
string powertiptext = "Image���"
end type

event clicked;String	sPath, sFileName
Int 		iRtn, iFHandle, i
Long		lFileLen, lLoops, lReadBytes
Blob		blobTot, blobA


iRtn = GetFileOpenName("�̹��� ��������",sPath,sFileName,"IMAGE","Bitmap Files (*.BMP),*.BMP,JPEG Files (*.JPG),*.JPG")
If iRtn = 1 Then
	lFileLen = FileLength(sPath)
	iFHandle = FileOpen(sPath, StreamMode!, Read!, LockRead!)

	if iFHandle <> -1 then
		////////////////////////////////////////////////////////////////////////////////////////
		// ����size�� FileRead �ѵ��� �ʰ��ϴ� ��� ó��
		if lFileLen > 32765 then
			if Mod(lFileLen, 32765) = 0 then
				lLoops = lFileLen/32765
			else
				lLoops = (lFileLen/32765) + 1
			end if		
		else
			lLoops = 1		
		end if


		////////////////////////////////////////////////////////////////////////////////////////
		FOR i = 1 to lLoops
			lReadBytes = FileRead(iFHandle, blobA)
			blobTot    = blobTot + blobA
		NEXT

		FileClose(iFHandle)
		
		iblobBMP = blobTot
		p_img.SetPicture(blobTot)
		p_img.Visible = True
	end if
elseif iRtn = -1 Then
	p_img.Visible = False
	Return
End If
end event

type cb_1 from commandbutton within w_imt_04630_dev
boolean visible = false
integer x = 2926
integer y = 2628
integer width = 599
integer height = 124
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���ڱ����ڵ�����"
end type

event clicked;String ls_ipchk
String ls_bit
String ls_kum
String ls_cav

Long   ll_cnt
Long   i
Long   l
Long   ll_use
Long   ll_rtn
Long   ll_chk
Long   ll_ret

ll_cnt = dw_6.RowCount()
If ll_cnt < 1 Then Return

ls_kum = dw_insert.GetItemString(1, 'kumno')  //�����ڵ�
If Trim(ls_kum) = '' OR IsNull(ls_kum) Then Return

ll_ret = MessageBox('���ڱ��� �ڵ�����', '���� ������� �����ڷḦ �ڵ������մϴ�.~r~n��� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2)
If ll_ret <> 1 Then Return

//������ �ڷῩ�� Ȯ��
SELECT COUNT(KUMNO)
  INTO :ll_chk
  FROM KUMCAV_KUM
 WHERE KUMNO = :ls_kum ;
If ll_chk > 0 Then
	ll_rtn = MessageBox('���ڱ��� �ڵ�����', '�̹� ������ �ڷᰡ �ֽ��ϴ�!~r~n�����ڷ�� �����˴ϴ�! ����Ͻðڽ��ϱ�?', Question!, YesNo!, 2)
	If ll_rtn <> 1 Then 
		Return
	Else
		DELETE FROM KUMCAV_KUM
		 WHERE KUMNO = :ls_kum ;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox('Ȯ��', '�����ڷ� ������ �����߽��ϴ�!')
			ROLLBACK USING SQLCA;
			Return
		Else
			COMMIT USING SQLCA;
		End If
	End If
End If		

For i = 1 To ll_cnt
	ls_ipchk = dw_6.GetItemString(i, 'ipchk')   //���ڱ��� ���ÿ���
	
	If ls_ipchk = 'Y' Then		
		ls_bit = dw_6.GetItemString(i, 'bitnbr')  //��ǰ��ȣ
		
		ll_use = dw_6.GetItemNumber(i, 'qtypr' )  //Usage��
		
		//Usage����ŭ ���� ����//KUMCAV_KUM
		For l = 1 To ll_use
			ls_cav = String(l)
			
			INSERT INTO KUMCAV_KUM 
			( KUMNO  , ITNBR  , CAVNO   )			
			VALUES 
			( :ls_kum, :ls_bit, :ls_cav ) ;
			
			If SQLCA.SQLCODE <> 0 Then
				MessageBox('Ȯ��', '�������ڱ����� �����ϴ��� �����߽��ϴ�!')
				ROLLBACK USING SQLCA;
				Return
			End If
		Next
	End If
Next

COMMIT USING SQLCA;
MessageBox('Ȯ��', '������ �Ϸ�Ǿ����ϴ�.')

		

end event

type rr_6 from roundrectangle within w_imt_04630_dev
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 1516
integer width = 4480
integer height = 800
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_imt_04630_dev
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2670
integer y = 168
integer width = 1819
integer height = 1240
integer cornerheight = 40
integer cornerwidth = 55
end type

