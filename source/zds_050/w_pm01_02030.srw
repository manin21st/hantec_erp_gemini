$PBExportHeader$w_pm01_02030.srw
$PBExportComments$�ְ� ����
forward
global type w_pm01_02030 from w_inherite
end type
type dw_1 from u_key_enter within w_pm01_02030
end type
type pb_1 from u_pb_cal within w_pm01_02030
end type
type p_xls from picture within w_pm01_02030
end type
type rr_1 from roundrectangle within w_pm01_02030
end type
end forward

global type w_pm01_02030 from w_inherite
string title = "�ְ� �����ȹ Ȯ��"
dw_1 dw_1
pb_1 pb_1
p_xls p_xls
rr_1 rr_1
end type
global w_pm01_02030 w_pm01_02030

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_setnull ()
public subroutine wf_reset ()
public subroutine wf_jego (string arg_itnbr)
public function integer wf_nagam (string arg_sdate)
public subroutine wf_excel_down (datawindow adw_excel)
public function integer wf_trans_pop ()
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

//if isnull(dw_insert.GetItemNumber(i,'monqty1')) or &
//	dw_insert.GetItemNumber(i,'monqty1') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  M ��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('monqty1')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//if isnull(dw_insert.GetItemNumber(i,'monqty2')) or &  
//	dw_insert.GetItemNumber(i,'monqty2') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  M+1 ��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('monqty2')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//if isnull(dw_insert.GetItemNumber(i,'monqty3')) or &  
//	dw_insert.GetItemNumber(i,'monqty3') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  M+2 ��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('monqty3')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//if isnull(dw_insert.GetItemNumber(i,'weekqty1')) or &  
//	dw_insert.GetItemNumber(i,'weekqty1') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  1��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('weekqty1')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//
//if isnull(dw_insert.GetItemNumber(i,'weekqty2')) or &  
//	dw_insert.GetItemNumber(i,'weekqty2') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  2��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('weekqty2')
//	dw_insert.SetFocus()
//	return -1		
//end if
//
//if isnull(dw_insert.GetItemNumber(i,'weekqty3')) or &  
//	dw_insert.GetItemNumber(i,'weekqty3') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  3��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('weekqty3')
//	dw_insert.SetFocus()
//	return -1		
//end if
//if isnull(dw_insert.GetItemNumber(i,'weekqty4')) or &  
//	dw_insert.GetItemNumber(i,'weekqty4') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  4��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('weekqty4')
//	dw_insert.SetFocus()
//	return -1		
//end if
//if isnull(dw_insert.GetItemNumber(i,'weekqty5')) or &  
//	dw_insert.GetItemNumber(i,'weekqty5') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' ��  5��]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('weekqty5')
//	dw_insert.SetFocus()
//	return -1		
//end if

Return 1
end function

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
dw_insert.setitem(lrow, "midsaf", inull)
end subroutine

public subroutine wf_reset ();string syymm
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)

syymm = left(is_today,6)

//dw_1.setitem(1, 'syymm', syymm )

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

public subroutine wf_jego (string arg_itnbr);////////////////////////////////////////////
/* ǰ�񺰷� ������ ������ �����´�.     */
/* �������(MAX), ���, �Ҵ��ó��, ������   */  
////////////////////////////////////////////
String get_itnbr
Dec{3} get_minqt, sum_jego_qty, get_shrat, get_midsaf
long   lrow

SELECT "ITEMAS"."ITNBR",    "ITEMAS"."MINQT",  "ITEMAS"."SHRAT", "ITEMAS"."MIDSAF",SUM(NVL("STOCK"."JEGO_QTY" , 0))
		 SUM(NVL("STOCK"."VALID_QTY" , 0))   
  INTO :get_itnbr,          :get_minqt,     	:get_shrat, :get_midsaf, :sum_jego_qty
  FROM "ITEMAS", "STOCK"  
 WHERE ( "ITEMAS"."ITNBR" = "STOCK"."ITNBR" ) and  
		 ( "ITEMAS"."ITNBR" = :arg_itnbr )  
GROUP BY	 "ITEMAS"."ITNBR",    "ITEMAS"."MINQT",  "ITEMAS"."SHRAT", "ITEMAS"."MIDSAF";
		
if isnull(get_itnbr) then get_itnbr = ''
		
lrow = dw_insert.getrow()

IF arg_itnbr = get_itnbr then 
	if isnull(get_minqt) then get_minqt = 0
	if isnull(sum_jego_qty) then sum_jego_qty = 0
	if isnull(get_shrat) then get_shrat = 0
	if isnull(get_midsaf) then get_midsaf = 0
	
	dw_insert.setitem(lrow, 'minqty',    get_minqt)    //�������
	dw_insert.setitem(lrow, 'jaego' ,    sum_jego_qty)  //���
	dw_insert.setitem(lrow, 'shrat',     get_shrat)    //�������
	dw_insert.setitem(lrow, 'midsaf',    get_midsaf)
ELSE
	dw_insert.setitem(lrow, 'minqty',    0)    //�������
	dw_insert.setitem(lrow, 'jaego' ,    0)  //���
	dw_insert.setitem(lrow, 'shrat',     0)    //�������
	dw_insert.setitem(lrow, 'midsaf',     0) 
END IF	

end subroutine

public function integer wf_nagam (string arg_sdate);Long lcount
String sPdtgu, sJocod

sPdtgu	= Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(sPdtgu) Then sPdtgu = ''

//sJocod	= Trim(dw_1.GetItemString(1, 'jocod'))
//If IsNull(sJocod) Then sJocod = ''

SELECT COUNT(*) INTO :lcount FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :arg_sdate AND A.MOSEQ = 0
   AND A.JOCOD LIKE :sPdtgu||'%';

// ������ ���
If lcount > 0 Then
//	MessageBox('Ȯ ��','�ְ� �����ȹ�� Ȯ���Ǿ����ϴ�.!!')
	p_search.Enabled = False
	p_search.PictureName = 'C:\erpman\image\Ȯ��_d.gif'
	p_del.Enabled = True
	p_del.PictureName = 'C:\erpman\image\Ȯ�����_up.gif'
Else
	p_search.Enabled = True
	p_search.PictureName = 'C:\erpman\image\Ȯ��_up.gif'
	p_del.Enabled = False
	p_del.PictureName = 'C:\erpman\image\Ȯ�����_d.gif'
End If

Return 0
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("������ ���ϸ��� �����ϼ���." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("��������" , ls_filepath + " ������ �̹� �����մϴ�.~r~n" + &
												 "������ ������ ����ðڽ��ϱ�?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "�ڷ�ٿ�Ϸ�!!!"
end subroutine

public function integer wf_trans_pop ();If dw_1.acceptText() < 1 Then return -1

String ls_yymm
Long   ireturn

ls_yymm = Trim(dw_1.Object.syymm[1])

/* �ְ� �����ȹ Ȯ���� ��ü Ȯ���Ǿ��� ��� pop���� ó�� - by shingoon 2015.10.16 */
/* Ȯ��ó���� �������� Ȯ�� �� ��Ȼ����� Ȯ�� ó�� �� */
Integer li_cnt
SELECT COUNT('X')
  INTO :li_cnt
  FROM PM02_WEEKPLAN_SUM
 WHERE SABU   = :gs_sabu
   AND YYMMDD = :ls_yymm
	AND MOSEQ  = 1 ; /* 0:Ȯ��, 1:��Ȯ�� */
If li_cnt > 0 Then Return 0

SetPointer(HourGlass!)

ireturn = sqlca.ERP_WEEKPLAN_POP(gs_sabu, ls_yymm, '1') ;
If ireturn = -1 Then
	Messagebox('Ȯ��','�ְ������ȹ ���� ����!!! [ERP->POP]')
	return -1
End If

return 1

//Messagebox('Ȯ��','�ְ������ȹ ���� ����!!! [ERP->POP]')
end function

on w_pm01_02030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.p_xls=create p_xls
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.p_xls
this.Control[iCurrent+4]=this.rr_1
end on

on w_pm01_02030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.p_xls)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_insert.SetTransObject(sqlca)

string sdate

SELECT MAX(YYMMDD) INTO :sDate FROM PM02_WEEKPLAN_SUM;

dw_1.SetItem(1, 'syymm', sdate)

f_mod_saupj(dw_1, 'saupj')

Post wf_nagam(sdate)
//w_mdi_frame.sle_msg.Text = '������ ���� �ְ���ȹ �������ڴ� ' + STRING(SDATE,'@@@@.@@.@@') + '�Դϴ�'
end event

type dw_insert from w_inherite`dw_insert within w_pm01_02030
integer x = 69
integer y = 232
integer width = 4448
integer height = 2028
string dataobject = "d_pm01_02030_2"
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
	  SELECT "PM02_WEEKPLAN_SUM"."ITNBR"  
		 INTO :get_itnbr  
		 FROM "PM02_WEEKPLAN_SUM"  
		WHERE ( "PM02_WEEKPLAN_SUM"."SABU" = :gs_sabu ) AND  
				( "PM02_WEEKPLAN_SUM"."YYMMDD" = :syymm ) AND  
				( "PM02_WEEKPLAN_SUM"."ITNBR" = :sitnbr ) AND  
				( "PM02_WEEKPLAN_SUM"."MOSEQ" = :iseq )   ;
	
		if sqlca.sqlcode <> 0 then 
			ireturn = f_get_name4_sale('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1�̸� ����, 0�� ����		
			if ireturn = 1 then ireturn = 0 else ireturn = 1		
			this.setitem(lrow, "itnbr", sitnbr)	
			this.setitem(lrow, "itdsc", sitdsc)	
	
			IF ireturn = 0 then
				//�������� ��ϵǿ����� üũ
				SELECT "ITEMAS"."ITNBR"  
				  INTO :get_itnbr  
				  FROM "ITEMAS", "ITNCT"  
				 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
						 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
						 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
						 ( "ITNCT"."PDTGU" = :steam ) )   ;
	
				IF SQLCA.SQLCODE <> 0 THEN 
					messagebox('Ȯ��', '�������� Ȯ���ϼ���.!!' ) 
					wf_setnull()
					RETURN 1
				END IF
				
				wf_jego(sitnbr)                //������� ����
	//			wf_avg_saleqty(sitnbr, syymm)  //����Ǹŷ��� ����
	//			wf_plan_janqty(sitnbr, syymm)  //��ȹ�ܷ��� ����
	
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
	Case 'ddqty1', 'ddqty2', 'ddqty3', 'ddqty4', 'ddqty5', 'ddqty6', 'ddqty7'
		dQty = Dec(GetText())
		
		dMinQt = GetItemNumber(lrow, 'minqty')
		dMulQt = GetItemNumber(lrow, 'minqty')
		
		If IsNull(dMinQt) then dMinQt = 0
		If IsNull(dMulQt) Or dMulqt = 0 then dMulQt = 1
		
		dLot = dMinQt + (Ceiling((dQty        - dMinQt   )/dMulQt   ) * dMulQt   )
		
		SetItem(lRow, 'lotqty'+right(GetColumnName(),1), dLot)
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

type p_delrow from w_inherite`p_delrow within w_pm01_02030
boolean visible = false
integer x = 2944
integer y = 40
boolean enabled = false
string picturename = "C:\erpman\image\�����_d.gif"
end type

event p_delrow::clicked;call super::clicked;Integer i, irow, irow2
string s_yymm, s_toym

if dw_1.AcceptText() = -1 then return 

IF dw_insert.AcceptText() = -1 THEN RETURN 

if dw_insert.rowcount() <= 0 then return 	


s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

//s_toym = left(f_today(), 6) 
//if s_yymm < s_toym then
//	messagebox("Ȯ��", "���� ���� ��� �ڷ�� ������ �� �����ϴ�!!")
//	dw_1.setcolumn('syymm')
//	dw_1.setfocus()
//	return 
//end if		

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_pm01_02030
boolean visible = false
integer x = 2770
integer y = 40
boolean enabled = false
string picturename = "C:\erpman\image\���߰�_d.gif"
end type

event p_addrow::clicked;string s_team, s_yymm, s_toym
Int    i_seq
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

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

//s_toym = f_today()
//if s_yymm < s_toym then
//	messagebox("Ȯ��", "���� ���� ��� �ڷ�� �߰��� �� �����ϴ�!!")
//	dw_1.setcolumn('syymm')
//	dw_1.setfocus()
//	return 
//end if		

//if isnull(i_seq) or i_seq = 0 then
//	f_message_chk(30,'[��������]')
//	dw_1.Setcolumn('jjcha')
//	dw_1.SetFocus()
//	return
//end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'yymmdd', s_yymm )
dw_insert.setitem(il_currow, 'moseq', i_seq )
dw_insert.setitem(il_currow, 'mogub', '1' )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_1.enabled = false
p_search.picturename = 'C:\erpman\image\����_d.gif'
p_search.enabled = false

ib_any_typing =True

end event

type p_search from w_inherite`p_search within w_pm01_02030
integer x = 3205
integer y = 40
string picturename = "C:\erpman\image\Ȯ��_up.gif"
end type

event p_search::ue_lbuttondown;picturename = 'C:\erpman\image\Ȯ��_dn.gif'
end event

event p_search::ue_lbuttonup;picturename = 'C:\erpman\image\Ȯ��_up.gif'
end event

event p_search::clicked;String sYymm, sError
Int	 iMaxno
Long   lcount
String sSaupj, sPdtgu, sJocod

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

sPdtgu	= Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(sPdtgu) Or sPdtgu = '' Then
	f_message_chk(1400, '[������]')
	dw_1.SetFocus()
	dw_1.SetColumn('steam')
	Return -1
End If

//sJocod	= Trim(dw_1.GetItemString(1, 'jocod'))
//If IsNull(sJocod) Or sJocod = '' Then
//	f_message_chk(1400, '[��]')
//	dw_1.SetFocus()
//	dw_1.SetColumn('jocod')
//	Return -1
//End If

SELECT COUNT(*) INTO :lcount FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :sYymm AND A.MOSEQ = 0
	AND A.JOCOD LIKE :sPdtgu||'%';
 	
If lcount > 0 then 
	messagebox("Ȯ ��", "�̹� �ְ� �����ȹ�� Ȯ���Ǿ� �ֽ��ϴ�.")
	Return
End If

If  MessageBox("����", '�ְ� �����ȹ�� Ȯ�� �մϴ�', Exclamation!, OKCancel!, 1) = 2 Then Return

SetPointer(HourGlass!)

UPDATE PM02_WEEKPLAN_SUM A
   SET A.MOSEQ = 0
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :syymm AND A.MOSEQ = 1 AND JOCOD LIKE :sPdtgu||'%';
 
//   AND EXISTS ( SELECT * FROM ITEMAS B WHERE B.ITNBR = A.ITNBR AND B.PDTGU = :spdtgu AND B.JOCOD LIKE :sJocod||'%' ) ;

If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

// POP ��ȹ����
if wf_trans_pop() = -1 then return

////���Ű�ȹ ����
//// ��������� ���۱����� �˻��Ͽ� �� ���۵� �����̸� ���� ���
//Select max(actno) into :iMaxNo from mrpsys where mrpdata = 3;
//
//serror = 'X'
//Sqlca.erp000000050_7_leewon(sSaupj, iMaxNo, syymm, 1, '3', sPdtgu, 'Y', serror)
//				
//IF serror <> 'N' THEN
//	messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//	ROLLBACK;
//	messagebox("Ȯ ��", "��ȹORDER Ȯ���� �����Ͽ����ϴ�.!!")
//	Return
//else
//	Commit;
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

Post wf_nagam(syymm)

ib_any_typing = FALSE
end event

type p_ins from w_inherite`p_ins within w_pm01_02030
boolean visible = false
integer x = 2665
integer y = 16
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pm01_02030
end type

type p_can from w_inherite`p_can within w_pm01_02030
end type

event p_can::clicked;wf_reset()

dw_1.enabled = true

p_search.picturename = 'C:\erpman\image\����_up.gif'
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

type p_print from w_inherite`p_print within w_pm01_02030
boolean visible = false
integer x = 2427
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pm01_02030
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string s_gub, s_team, s_yymm, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, &
       s_gub2, sjocod, sSaupj
Int    i_seq
long   lcount

if dw_1.AcceptText() = -1 then return 
SetPointer(HourGlass!)

s_gub  = dw_1.GetItemString(1,'sgub')
s_team = dw_1.GetItemString(1,'steam')
sjocod = Trim(dw_1.GetItemString(1,'jocod'))
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_gub2 = dw_1.GetItemString(1,'gubun')
sSaupj = dw_1.GetItemString(1,'saupj')

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
If IsNull(sJocod) Then sJocod = ''

if dw_insert.Retrieve(gs_sabu,s_yymm, s_team, sSaupj, s_team+'%') <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

end event

type p_del from w_inherite`p_del within w_pm01_02030
integer x = 3387
integer y = 40
string picturename = "C:\erpman\image\Ȯ�����_up.gif"
end type

event p_del::clicked;call super::clicked;String sYymm
Long	 nCnt
String sSaupj, sPdtgu

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

sPdtgu	= Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(sPdtgu) Or sPdtgu = '' Then
	f_message_chk(1400, '[������]')
	dw_1.SetFocus()
	dw_1.SetColumn('steam')
	Return -1
End If

//sJocod	= Trim(dw_1.GetItemString(1, 'jocod'))
//If IsNull(sJocod) Or sJocod = '' Then
//	f_message_chk(1400, '[��]')
//	dw_1.SetFocus()
//	dw_1.SetColumn('jocod')
//	Return -1
//End If

// ���Ű�ȹ �ڷ� Ȯ������ üũ
//SELECT COUNT(*) INTO :nCnt FROM PU03_WEEKPLAN
// WHERE SABU = :sSaupj
//   AND YYMMDD = :syymm
//	AND CNFTIME IS NOT NULL;
//If nCnt > 0 Then
//	MessageBox("���ŸŰ�ȹ", '���Ű�ȹ �ڷᰡ �����մϴ�.!!')
//	Return
//End If

If  MessageBox("����", '�ְ� �����ȹ�� ������� ó�� �մϴ�', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE PM02_WEEKPLAN_SUM A
   SET A.MOSEQ = 1
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :syymm AND A.MOSEQ = 0 AND JOCOD LIKE :sPdtgu||'%';
//   AND EXISTS ( SELECT * FROM ITEMAS B WHERE B.ITNBR = A.ITNBR AND B.PDTGU = :sPdtgu AND B.JOCOD LIKE :sJocod||'%' );
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

//DELETE FROM PU03_WEEKPLAN_SUM A
// WHERE A.SABU = :sSaupj
//   AND A.YYMMDD = :syymm
//	AND A.JOCOD = :sPdtgu;
//If SQLCA.SQLCODE <> 0 Then
//	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//	Rollback;
//	Return
//End If

COMMIT;

MessageBox('Ȯ��','���������� ���ó���Ǿ����ϴ�.!!')

ib_any_typing = FALSE

Post wf_nagam(syymm)
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\Ȯ�����_dn.gif"
end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\Ȯ�����_up.gif"
end event

type p_mod from w_inherite`p_mod within w_pm01_02030
boolean visible = false
integer x = 2990
integer y = 20
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_pm01_02030
end type

type cb_mod from w_inherite`cb_mod within w_pm01_02030
end type

type cb_ins from w_inherite`cb_ins within w_pm01_02030
end type

type cb_del from w_inherite`cb_del within w_pm01_02030
end type

type cb_inq from w_inherite`cb_inq within w_pm01_02030
end type

type cb_print from w_inherite`cb_print within w_pm01_02030
end type

type st_1 from w_inherite`st_1 within w_pm01_02030
end type

type cb_can from w_inherite`cb_can within w_pm01_02030
end type

type cb_search from w_inherite`cb_search within w_pm01_02030
end type







type gb_button1 from w_inherite`gb_button1 within w_pm01_02030
end type

type gb_button2 from w_inherite`gb_button2 within w_pm01_02030
end type

type dw_1 from u_key_enter within w_pm01_02030
integer x = 69
integer y = 48
integer width = 3049
integer height = 140
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pm01_02030_1"
boolean border = false
end type

event itemchanged;String syymm, sNull, sPdtgu, sSaupj

SetNull(sNull)

Choose Case GetColumnName() 
	Case "syymm"
		syymm = trim(this.GetText())
		
		IF f_datechk(syymm) = -1	then
			f_message_chk(35, '[��������]')
			setitem(1, "syymm", sNull)
			setitem(1, 'jjcha', 1)
			return 1
		END IF
	
		If DayNumber(Date( Left(syymm,4)+'-'+Mid(syymm,5,2) +'-'+Right(syymm,2) )) <> 2 Then
			MessageBox('Ȯ ��','�ְ� ��ȹ�� �����Ϻ��� ���������մϴ�.!!')
			Return 1
		End If
		
		Post wf_nagam(syymm)
	Case 'steam'
		sYymm  = GetItemString(1, 'syymm')
		sPdtgu = trim(this.GetText())
		
		SELECT RFNA2 INTO :sSaupj FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFGUB = :sPdtgu ;
		This.SetItem(1, 'saupj', sSaupj)
		
		Post wf_nagam(syymm)
	Case Else
		sYymm = GetItemString(1, 'syymm')
		
		Post wf_nagam(syymm)
End Choose


end event

event itemerror;call super::itemerror;Return 1
end event

type pb_1 from u_pb_cal within w_pm01_02030
integer x = 741
integer y = 68
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('syymm')
IF IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'syymm', gs_code)
end event

type p_xls from picture within w_pm01_02030
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\������ȯ_up.gif"
boolean focusrectangle = false
end type

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type rr_1 from roundrectangle within w_pm01_02030
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

