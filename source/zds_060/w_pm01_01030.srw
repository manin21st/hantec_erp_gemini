$PBExportHeader$w_pm01_01030.srw
$PBExportComments$�� ����
forward
global type w_pm01_01030 from w_inherite
end type
type dw_1 from u_key_enter within w_pm01_01030
end type
type pb_1 from u_pb_cal within w_pm01_01030
end type
type p_2 from uo_excel_down within w_pm01_01030
end type
type rr_1 from roundrectangle within w_pm01_01030
end type
end forward

global type w_pm01_01030 from w_inherite
string title = "�� �����ȹ Ȯ��"
dw_1 dw_1
pb_1 pb_1
p_2 p_2
rr_1 rr_1
end type
global w_pm01_01030 w_pm01_01030

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public subroutine wf_setnull ()
public subroutine wf_jego (string arg_itnbr, integer arg_row)
end prototypes

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� ǰ��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'monqty1')) or &
	dw_insert.GetItemNumber(i,'monqty1') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  M ��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty1')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty2')) or &  
	dw_insert.GetItemNumber(i,'monqty2') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  M+1 ��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty2')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty3')) or &  
	dw_insert.GetItemNumber(i,'monqty3') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  M+2 ��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty3')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'weekqty1')) or &  
	dw_insert.GetItemNumber(i,'weekqty1') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  1��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty1')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'weekqty2')) or &  
	dw_insert.GetItemNumber(i,'weekqty2') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  2��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty2')
	dw_insert.SetFocus()
	return -1		
end if

if isnull(dw_insert.GetItemNumber(i,'weekqty3')) or &  
	dw_insert.GetItemNumber(i,'weekqty3') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  3��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty3')
	dw_insert.SetFocus()
	return -1		
end if
if isnull(dw_insert.GetItemNumber(i,'weekqty4')) or &  
	dw_insert.GetItemNumber(i,'weekqty4') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  4��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty4')
	dw_insert.SetFocus()
	return -1		
end if
if isnull(dw_insert.GetItemNumber(i,'weekqty5')) or &  
	dw_insert.GetItemNumber(i,'weekqty5') < 0 then
   f_message_chk(1400,'[ '+string(i)+' ��  5��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('weekqty5')
	dw_insert.SetFocus()
	return -1		
end if

Return 1
end function

public subroutine wf_reset ();string syymm
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)

syymm = left(is_today,6)

dw_1.setitem(1, 'syymm', syymm )

//������� �´� ���������� �����´�. Ȯ����ȹ�� ������ ������ȹ�� �������� ���ϰ� 
//   											 ������ȹ�� ������ Ȯ����ȹ�� ���ҿ��� ���Ѵ�.	
//SELECT MAX("MONPLN_SUM"."MOSEQ")  
//  INTO :get_yeacha  
//  FROM "MONPLN_SUM"  
// WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;
//
//if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1
get_yeacha = 1

dw_1.setitem(1, 'jjcha', get_yeacha )
dw_1.setfocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

public subroutine wf_setnull ();string snull
int    inull
long   lrow

setnull(snull)
setnull(inull)

lrow   = dw_insert.getrow()

dw_insert.setitem(lrow, "itnbr", snull)	
dw_insert.setitem(lrow, "itdsc", snull)	

dw_insert.setitem(lrow, "jaego", inull)
dw_insert.setitem(lrow, "shrat", inull)
dw_insert.setitem(lrow, "minqty", inull)

end subroutine

public subroutine wf_jego (string arg_itnbr, integer arg_row);////////////////////////////////////////////
/* ǰ�񺰷� ������ ������ �����´�.     */
/* �������(MAX), ���, �Ҵ��ó��, ������   */  
////////////////////////////////////////////
String get_itnbr
Dec{3} get_minqt, sum_jego_qty, get_shrat

SELECT "ITEMAS"."ITNBR",    "ITEMAS"."MINQT",  "ITEMAS"."SHRAT", SUM(NVL("STOCK"."JEGO_QTY" , 0))
  INTO :get_itnbr,          :get_minqt,     	  :get_shrat, 		  :sum_jego_qty
  FROM "ITEMAS", "STOCK"  
 WHERE ( "ITEMAS"."ITNBR" = "STOCK"."ITNBR"(+) ) and  
		 ( "ITEMAS"."ITNBR" = :arg_itnbr )  
GROUP BY	 "ITEMAS"."ITNBR", "ITEMAS"."MINQT", "ITEMAS"."SHRAT";
		
if isnull(get_itnbr) then get_itnbr = ''

MessageBox(arg_itnbr , get_itnbr)

if isnull(get_minqt) 	then get_minqt = 0
if isnull(sum_jego_qty) then sum_jego_qty = 0
if isnull(get_shrat) 	then get_shrat = 0

dw_insert.setitem(arg_row, 'minqty',    get_minqt)    //�������
dw_insert.setitem(arg_row, 'jaego' ,    sum_jego_qty)  //���
dw_insert.setitem(arg_row, 'shrat',     get_shrat)    //�������

end subroutine

on w_pm01_01030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.p_2=create p_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_pm01_01030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.rr_1)
end on

event open;call super::open;String syymm

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_insert.SetTransObject(sqlca)

/* ������ȹ��� */
SELECT MAX(MONYYMM) INTO :syymm FROM PM01_MONPLAN_SUM;
dw_1.SetItem(1, 'syymm', sYymm)
dw_1.SetItem(1, 'saupj', '10')
//f_mod_saupj(dw_1, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_pm01_01030
integer x = 69
integer y = 232
integer width = 4448
integer height = 2028
string dataobject = "d_pm01_01030_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, syymm, get_itnbr, steam, sjijil, sispeccode
integer  ireturn, iseq
long     lrow, lreturnrow
decimal  dItemPrice    //���ϴܰ�
Dec	   dQty, dMinQt, dMulqt, dLot

if dw_1.accepttext() = -1 then return 

setnull(snull)

lrow   = this.getrow()
syymm  = dw_1.getitemstring(1, 'syymm')
steam   = dw_1.getitemstring(1, 'steam')
iseq   = dw_1.getitemnumber(1, 'jjcha')

Choose Case GetColumnName()
	Case "itnbr"
		sItnbr = trim(this.GetText())
	
		if sitnbr = "" or isnull(sitnbr) then
			wf_setnull()
			return 
		end if	
		//��ü ����Ÿ �����쿡�� ���� ǰ���� üũ
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN  1
		END IF
		//��ϵ� �ڷῡ�� üũ
	  SELECT "PM01_MONPLAN_SUM"."ITNBR"  
		 INTO :get_itnbr  
		 FROM "PM01_MONPLAN_SUM"  
		WHERE ( "PM01_MONPLAN_SUM"."SABU" = :gs_sabu ) AND  
				( "PM01_MONPLAN_SUM"."MONYYMM" = :syymm ) AND  
				( "PM01_MONPLAN_SUM"."ITNBR" = :sitnbr ) AND  
				( "PM01_MONPLAN_SUM"."MOSEQ" = :iseq )   ;
	
		if sqlca.sqlcode <> 0 then 
			ireturn = f_get_name4_sale('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1�̸� ����, 0�� ����		
//			if ireturn = 1 then ireturn = 0 else ireturn = 1		
			this.setitem(lrow, "itnbr", sitnbr)	
			this.setitem(lrow, "itdsc", sitdsc)	
	
			IF ireturn = 0 then
				//�������� ��ϵǿ����� üũ
				SELECT "ITEMAS"."ITNBR"
				  INTO :get_itnbr
				  FROM "ITEMAS"
				 WHERE ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
						 ( "ITEMAS"."PDTGU" = :steam ) )   ;
	
				IF SQLCA.SQLCODE <> 0 THEN 
					messagebox('Ȯ��', '�������� Ȯ���ϼ���.!!' ) 
					wf_setnull()
					RETURN 1
				END IF
				
				If IsNull(dMinQt) Then dMinQt = 0
								
				wf_jego(sitnbr, lrow)                //������� ����
	
				dItemPrice = sqlca.Fun_Erp100000012(is_today, syymm, sItnbr)   //�ǸŴܰ��� ������
				this.SetItem(lRow,"mchdan", dItemPrice)
	
				this.Setfocus()
			END IF
			RETURN ireturn
		else
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN 1
		end if	
	Case 'monqty2', 'monqty3'
		dQty = Dec(GetText())
		
		dMinQt = GetItemNumber(lrow, 'minqty')
		dMulQt = GetItemNumber(lrow, 'minqty')
		
		If IsNull(dMinQt) then dMinQt = 0
		If IsNull(dMulQt) Or dMulqt = 0 then dMulQt = 1
		
		dLot = dMinQt + (Ceiling((dQty - dMinQt)/dMulQt) * dMulQt)

		SetItem(lRow, 'monlot'+right(GetColumnName(),1), dLot)
	Case 'weekqty1', 'weekqty2', 'weekqty3', 'weekqty4', 'weekqty5'
		dQty = Dec(GetText())
		
		dMinQt = GetItemNumber(lrow, 'minqty')
		dMulQt = GetItemNumber(lrow, 'minqty')
		
		If IsNull(dMinQt) then dMinQt = 0
		If IsNull(dMulQt) Or dMulqt = 0 then dMulQt = 1
		
		dLot = dMinQt + (Ceiling((dQty - dMinQt)/dMulQt) * dMulQt)

		SetItem(lRow, 'weeklot'+right(GetColumnName(),1), dLot)
END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Integer iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1

END IF
end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_pm01_01030
boolean visible = false
integer x = 3054
integer y = 40
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pm01_01030
boolean visible = false
integer x = 2880
integer y = 40
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pm01_01030
integer x = 3168
integer y = 44
string picturename = "C:\erpman\image\Ȯ��_up.gif"
end type

event p_search::ue_lbuttondown;picturename = 'C:\erpman\image\Ȯ��_dn.gif'
end event

event p_search::ue_lbuttonup;picturename = 'C:\erpman\image\Ȯ��_up.gif'
end event

event p_search::clicked;call super::clicked;String sYymm, serror
Long	 nCnt
Int	 iMaxNo
String sSaupj, sJocod, steam

If dw_1.AcceptText() <> 1 Then Return

sYymm = dw_1.GetItemString(1, 'syymm')
If IsNull(sYymm) Or sYymm = '' Then Return

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

/* ������ üũ */
steam= Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(steam) Or steam = '' Then
	f_message_chk(1400, '[������]')
	dw_1.SetFocus()
	dw_1.SetColumn('steam')
	Return -1
End If

//sJocod = trim(dw_1.GetItemString(1,'jocod'))
//If IsNull(sJocod) Or sJocod = '' Then
//	f_message_chk(1400, '[��]')
//	dw_1.SetFocus()
//	dw_1.SetColumn('jocod')
//	Return -1
//End If

SELECT COUNT(*) INTO :nCnt FROM PM01_MONPLAN_SUM A, ITEMAS B
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :syymm
	AND A.MOSEQ = 0 
	AND A.ITNBR = B.ITNBR
	AND B.PDTGU = :steam;
If nCnt > 0 Then
	MessageBox("����", '�̹� ����ó�� �Ǿ� �ֽ��ϴ�.!!')
	Return
End If


If  MessageBox("����", '�� �����ȹ�� ����ó�� �մϴ�', Exclamation!, OKCancel!, 1) = 2 Then Return

UPDATE PM01_MONPLAN_SUM A
   SET A.MOSEQ = 0
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :syymm
	AND EXISTS ( SELECT * FROM ITEMAS B WHERE B.ITNBR = A.ITNBR AND B.PDTGU = :steam);
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

//messagebox("Ȯ ��", "���Ű�ȹ ������ ���� �ʾҽ��ϴ�!!")

////���Ű�ȹ ����
//// ��������� ���۱����� �˻��Ͽ� �� ���۵� �����̸� ���� ���
//Select max(actno) into :iMaxNo from mrpsys where mrpdata = 2;
//
//serror = 'X'
//Sqlca.erp000000050_7_leewon(sSaupj, iMaxNo, syymm, 1, '2', steam, 'Y', serror)
////messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)				
//Commit;
//
//IF serror <> 'N' THEN
//	messagebox("Ȯ ��", "��ȹORDER Ȯ���� �����Ͽ����ϴ�.!!")
//	Return
//else
//	messagebox("Ȯ ��", "��ȹORDER Ȯ���� �Ǿ����ϴ�.!!")
//	
//	// ���Ű�ȹ ����(�Ѽҿ䷮ ����)�� ��� �����ڵ�(99-3)�� ��������� ����
//	Update reffpf
//		Set rfna2 = to_char(:iMaxNo)
//	 Where sabu = '1' and rfcod = '1A' and rfgub = '3';
//	if sqlca.sqlcode <> 0 then		 
//		Messagebox("�����ڵ����", sqlca.sqlerrtext)
//	end if		 
//	
//	Commit;	
//END IF

MessageBox('Ȯ��','���������� ���� ó���Ǿ����ϴ�.!!')

ib_any_typing = FALSE
end event

type p_ins from w_inherite`p_ins within w_pm01_01030
boolean visible = false
integer x = 3168
integer y = 32
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pm01_01030
end type

type p_can from w_inherite`p_can within w_pm01_01030
end type

event p_can::clicked;wf_reset()

dw_1.enabled = true

p_search.picturename = 'C:\erpman\image\Ȯ��_up.gif'
p_addrow.picturename = 'C:\erpman\image\���߰�_up.gif'
p_delrow.picturename = 'C:\erpman\image\�����_up.gif'
p_mod.picturename = 'C:\erpman\image\����_up.gif'

p_search.enabled = true
p_addrow.enabled = false
p_delrow.enabled = false
p_mod.enabled = false

ib_any_typing = FALSE

dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_pm01_01030
boolean visible = false
integer x = 2930
integer y = 40
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pm01_01030
integer x = 3913
end type

event p_inq::clicked;call super::clicked;string s_gub, s_team, s_yymm, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, &
       s_gub2, sjocod
Int    i_seq
long   lcount

if dw_1.AcceptText() = -1 then return 
SetPointer(HourGlass!)

s_gub  = dw_1.GetItemString(1,'sgub')
s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_gub2 = dw_1.GetItemString(1,'gubun')
sJocod = trim(dw_1.GetItemString(1,'jocod'))

If IsNull(sJocod) Then sJocod = ''

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[������]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

dw_insert.object.t_mm.text = string(s_yymm, '@@@@.@@')
dw_insert.object.t_mm1.text = string(f_aftermonth(s_yymm, 1), '@@@@.@@')
dw_insert.object.t_mm2.text = string(f_aftermonth(s_yymm, 2), '@@@@.@@')
	
if dw_insert.Retrieve(gs_sabu,s_yymm, s_team, sjocod+'%') <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

end event

type p_del from w_inherite`p_del within w_pm01_01030
integer x = 3346
integer y = 44
boolean originalsize = true
string picturename = "C:\erpman\image\Ȯ�����_up.gif"
end type

event p_del::clicked;call super::clicked;String sYymm
Long	 nCnt
String sSaupj, sJocod, steam

If dw_1.AcceptText() <> 1 Then Return

sYymm = dw_1.GetItemString(1, 'syymm')
If IsNull(sYymm) Or sYymm = '' Then Return

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

/* ������ üũ */
steam= Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(steam) Or steam = '' Then
	f_message_chk(1400, '[������]')
	dw_1.SetFocus()
	dw_1.SetColumn('steam')
	Return -1
End If

/* �� üũ */
//sJocod = trim(dw_1.GetItemString(1,'jocod'))
//If IsNull(sJocod) Or sJocod = '' Then
//	f_message_chk(1400, '[��]')
//	dw_1.SetFocus()
//	dw_1.SetColumn('jocod')
//	Return -1
//End If

//���Ű�ȹ �ڷ� Ȯ������ üũ
SELECT COUNT(*) INTO :nCnt FROM PU02_MONPLAN
 WHERE SABU = :sSaupj
   AND YYMM = :syymm
	AND CNFTIME IS NOT NULL;
If nCnt > 0 Then
	MessageBox("���Ű�ȹ", '���Ű�ȹ �ڷᰡ �����մϴ�.!!')
	Return
End If

If  MessageBox("����", '�� �����ȹ�� ������� ó�� �մϴ�', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE PM01_MONPLAN_SUM A
   SET A.MOSEQ = 1
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :syymm
	AND EXISTS ( SELECT * FROM ITEMAS B WHERE B.ITNBR = A.ITNBR AND B.PDTGU = :sTeam );
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

//// ���Ű�ȹ�ڷ�� ������ �����Ѵ�	2004.01.06 ljj
//DELETE FROM PU02_MONPLAN_SUM
// WHERE SABU = :sSaupj
//   AND YYMM = :syymm
//	AND JOCOD = :sJocod;
//If SQLCA.SQLCODE <> 0 Then
//	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//	Rollback;
//	Return
//End If

COMMIT;

MessageBox('Ȯ��','���������� ���ó���Ǿ����ϴ�.!!')

ib_any_typing = FALSE
end event

event p_del::ue_lbuttondown;picturename = 'C:\erpman\image\Ȯ�����_dn.gif'
end event

event p_del::ue_lbuttonup;picturename = 'C:\erpman\image\Ȯ�����_up.gif'
end event

type p_mod from w_inherite`p_mod within w_pm01_01030
boolean visible = false
integer x = 3227
integer y = 40
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_pm01_01030
end type

type cb_mod from w_inherite`cb_mod within w_pm01_01030
end type

type cb_ins from w_inherite`cb_ins within w_pm01_01030
end type

type cb_del from w_inherite`cb_del within w_pm01_01030
end type

type cb_inq from w_inherite`cb_inq within w_pm01_01030
end type

type cb_print from w_inherite`cb_print within w_pm01_01030
end type

type st_1 from w_inherite`st_1 within w_pm01_01030
end type

type cb_can from w_inherite`cb_can within w_pm01_01030
end type

type cb_search from w_inherite`cb_search within w_pm01_01030
end type







type gb_button1 from w_inherite`gb_button1 within w_pm01_01030
end type

type gb_button2 from w_inherite`gb_button2 within w_pm01_01030
end type

type dw_1 from u_key_enter within w_pm01_01030
integer x = 69
integer y = 48
integer width = 3077
integer height = 140
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pm01_01030_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;String syymm, sNull

SetNull(sNull)

Choose Case GetColumnName() 
	Case "syymm"
	syymm = trim(this.GetText())
	
  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[���س��]')
		setitem(1, "syymm", sNull)
  		setitem(1, 'jjcha', 1)
		return 1
	END IF
End Choose


end event

type pb_1 from u_pb_cal within w_pm01_01030
integer x = 709
integer y = 72
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('syymm')
IF IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'syymm', left(gs_code,6))
end event

type p_2 from uo_excel_down within w_pm01_01030
integer x = 4091
integer y = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;If this.Enabled Then uf_excel_down(dw_insert)
end event

type rr_1 from roundrectangle within w_pm01_01030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 224
integer width = 4471
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

