$PBExportHeader$w_pm01_02010.srw
$PBExportComments$�ְ� �ǸŰ�ȹ ����
forward
global type w_pm01_02010 from w_inherite
end type
type dw_1 from u_key_enter within w_pm01_02010
end type
type pb_1 from u_pb_cal within w_pm01_02010
end type
type p_xls from picture within w_pm01_02010
end type
type rr_1 from roundrectangle within w_pm01_02010
end type
end forward

global type w_pm01_02010 from w_inherite
integer width = 4590
string title = "�ְ� �����ȹ ����"
dw_1 dw_1
pb_1 pb_1
p_xls p_xls
rr_1 rr_1
end type
global w_pm01_02010 w_pm01_02010

forward prototypes
public function integer wf_protect (string arg_date)
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public subroutine wf_setnull ()
public subroutine wf_jego (string arg_itnbr)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function integer wf_protect (string arg_date);Long lcount
String sJocod

sJocod = Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(sJocod) Then sJocod = ''

SELECT COUNT(*) INTO :lcount FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :arg_date AND A.MOSEQ = 0
	AND A.JOCOD LIKE :sJocod||'%';
 	
if lcount > 0 then 
	messagebox("Ȯ ��", "�ְ� �����ȹ�� Ȯ���Ǿ� �����Ƿ� ���� �� ���� �� �� �����ϴ�.")
	p_addrow.picturename = 'C:\erpman\image\���߰�_d.gif'
	p_delrow.picturename = 'C:\erpman\image\�����_d.gif'
	p_mod.picturename = 'C:\erpman\image\����_d.gif'
	p_search.picturename = 'C:\erpman\image\����_d.gif'
	p_del.picturename = 'C:\erpman\image\����_d.gif'
	p_delrow.enabled = false
	p_addrow.enabled = false
	p_mod.enabled = false
	p_search.enabled = false
	p_del.enabled = false
else
	dw_insert.SetFocus()
	p_search.picturename = 'C:\erpman\image\����_d.gif'
	p_search.enabled = false
	ib_any_typing = FALSE
	p_addrow.picturename = 'C:\erpman\image\���߰�_up.gif'
	p_delrow.picturename = 'C:\erpman\image\�����_up.gif'
	p_mod.picturename = 'C:\erpman\image\����_up.gif'
	p_search.picturename = 'C:\erpman\image\����_up.gif'
	p_del.picturename = 'C:\erpman\image\����_up.gif'
	p_addrow.enabled = true
	p_delrow.enabled = true
	p_mod.enabled = true
	p_search.enabled = true
	p_del.enabled = true
end if	

return 0
end function

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

on w_pm01_02010.create
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

on w_pm01_02010.destroy
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

select max(yymmdd) into :sDate from SM03_WEEKPLAN_ITEM WHERE CNFIRM IS NOT NULL;
dw_1.SetItem(1, 'syymm', sdate)
dw_1.SetItem(1, 'steam', '1')

w_mdi_frame.sle_msg.Text = '������ ���� �ְ���ȹ �������ڴ� ' + STRING(SDATE,'@@@@.@@.@@') + '�Դϴ�'

Post wf_protect(sdate)
end event

type dw_insert from w_inherite`dw_insert within w_pm01_02010
integer x = 69
integer y = 232
integer width = 4448
integer height = 2028
string dataobject = "d_pm01_02010_2"
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
				  FROM "ITEMAS" 
				 WHERE "ITEMAS"."ITNBR" = :sitnbr AND  
						 "ITEMAS"."JOCOD" = :steam;
	
				IF SQLCA.SQLCODE <> 0 THEN 
					messagebox('Ȯ��', '������/���� Ȯ���ϼ���.!!' ) 
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

event dw_insert::buttonclicked;String syymm, sItnbr, sMogub, sJocod
Int    nJucha
Long   lcount

if dw_1.AcceptText() = -1 then return 

syymm = trim(dw_1.GetItemString(1,'syymm'))
sJocod = Trim(dw_1.GetItemString(1, 'steam'))
If IsNull(sJocod) Then sJocod = ''

SELECT COUNT(*) INTO :lcount FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :syymm AND A.MOSEQ = 0
	AND A.JOCOD LIKE :sJocod||'%';

If lcount > 0 then 
	messagebox("Ȯ ��", "�ְ� �����ȹ�� Ȯ���Ǿ� �����Ƿ� ���� �� ���� �� �� �����ϴ�.")
	Return
End If

If dwo.name = 'b_mod' Then
	gs_code = GetItemString(row, 'itnbr')
	gs_gubun = GetItemString(row, 'mogub')
	gs_codename = syymm
	OpenWithParm(w_pm01_02010_2,'MOD')
End If

If dwo.name = 'b_del' Then
	if messagebox("Ȯ ��", '�ڷḦ �����Ͻðڽ��ϱ�?', Question!, YesNo!, 2) = 2 then return
	
	sItnbr = GetItemString(row, 'itnbr')
	sMogub = GetItemString(row, 'mogub')
	
	SELECT MON_JUCHA INTO :nJucha FROM PDTWEEK WHERE WEEK_SDATE = :syymm;
	
	DELETE FROM PM01_MONPLAN_DTL  
	 WHERE SABU = :gs_sabu AND MONYYMM = SUBSTR(:syymm,1,6) AND MOGUB = :sMogub AND ITNBR = :sItnbr AND JUCHA = :nJucha;
	if SQLCA.SQLCODE = 0 then
		commit ;
		sle_msg.text = "�ڷᰡ �����Ǿ����ϴ�!!"
		ib_any_typing= FALSE
	Else
		rollback ;
		messagebox("PM01_MONPLAN_DTL��������", "������ �����Ͽ����ϴ�")
		return 
	End If
	
	// �ְ������ȹ�ڷᵵ ���� ����ó�� - 2010.04.30 - �ۺ�ȣ
	DELETE FROM PM02_WEEKPLAN_SUM  
	 WHERE SABU = :gs_sabu AND YYMMDD = :syymm AND ITNBR = :sItnbr;
	if SQLCA.SQLCODE = 0 then
		commit ;
		sle_msg.text = "�ڷᰡ �����Ǿ����ϴ�!!"
		ib_any_typing= FALSE
	Else
		rollback ;
		messagebox("PM02_WEEKPLAN_SUM��������", "������ �����Ͽ����ϴ�")
		return 
	End If

	p_inq.PostEvent(Clicked!)
End If
end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_pm01_02010
boolean visible = false
integer x = 5175
integer y = 192
boolean enabled = false
string picturename = "C:\erpman\image\�����_d.gif"
end type

event p_delrow::clicked;call super::clicked;//Integer i, irow, irow2
//string s_yymm, s_toym
//
//if dw_1.AcceptText() = -1 then return 
//
//IF dw_insert.AcceptText() = -1 THEN RETURN 
//
//if dw_insert.rowcount() <= 0 then return 	
//
//
//s_yymm = trim(dw_1.GetItemString(1,'syymm'))
//
//if isnull(s_yymm) or s_yymm = "" then
//	f_message_chk(30,'[���س��]')
//	dw_1.Setcolumn('syymm')
//	dw_1.SetFocus()
//	return
//end if	
//
////s_toym = left(f_today(), 6) 
////if s_yymm < s_toym then
////	messagebox("Ȯ��", "���� ���� ��� �ڷ�� ������ �� �����ϴ�!!")
////	dw_1.setcolumn('syymm')
////	dw_1.setfocus()
////	return 
////end if		
//
//irow = dw_insert.getrow() - 1
//irow2 = dw_insert.getrow() + 1
//if irow > 0 then   
//	FOR i = 1 TO irow
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//end if	
//
//FOR i = irow2 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT
//
//if f_msg_delete() = -1 then return
//
//dw_insert.SetRedraw(FALSE)
//
//dw_insert.DeleteRow(0)
//
//if dw_insert.Update() = 1 then
//	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
//	ib_any_typing = false
//	commit ;
//else
//	rollback ;
//   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
//end if	
//dw_insert.SetRedraw(TRUE)
//
//
end event

type p_addrow from w_inherite`p_addrow within w_pm01_02010
integer x = 3351
integer y = 40
end type

event p_addrow::clicked;string s_team, s_yymm, s_toym
Int    i_seq
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[������/��]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	
if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[��������]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

SetNull(gs_code)

Message.StringParm = 'NEW'	//�ű԰�ȹ
gs_gubun = '1'		// �ʵ�ǰ
gs_codename = s_yymm
OpenWithParm(w_pm01_02010_2,'NEW')

p_inq.triggerevent(clicked!)
end event

event p_addrow::ue_lbuttondown;PictureName = 'C:\erpman\image\���߰�_dn.gif'
end event

event p_addrow::ue_lbuttonup;PictureName = 'C:\erpman\image\���߰�_up.gif'
end event

type p_search from w_inherite`p_search within w_pm01_02010
integer x = 2994
integer y = 40
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::ue_lbuttondown;p_search.picturename = 'C:\erpman\image\����_dn.gif'
end event

event p_search::ue_lbuttonup;p_search.picturename = 'C:\erpman\image\����_up.gif'
end event

event p_search::clicked;call super::clicked;string s_yymm, s_toym, s_team, smsgtxt, syymm, sMagam
int    i_seq, ijucha
Long	 lcount, lRtnValue

if dw_1.AcceptText() = -1 then return 
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
s_team = trim(dw_1.GetItemString(1,'steam'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[��������]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

/* ������ ���о��� �ϰ� ���� - by shingoon 2015.10.05 */
//if isnull(s_team) or s_team = "" then
//	f_message_chk(30,'[������/��]')
//	dw_1.Setcolumn('steam')
//	dw_1.SetFocus()
//	return
//end if

// ������������ Ȯ��
/*SELECT MAX(CNFIRM) INTO :sMagam FROM SM03_WEEKPLAN_ITEM WHERE /*SAUPJ = :gs_saupj AND*/ YYMMDD = :s_yymm;*/
SELECT MAX(CNFIRM) INTO :sMagam FROM SM03_WEEKPLAN_ITEM WHERE YYMMDD = :s_yymm;
If IsNull(sMagam) Or Trim(sMagam) = '' Then
	MessageBox('Ȯ ��','���� �ְ���ȹ�� �������� �ʾҽ��ϴ�.!!')
	Return
End If


// ��,���� select
syymm = Left(s_yymm,6)
SELECT MON_JUCHA INTO :ijucha FROM PDTWEEK WHERE WEEK_SDATE = :s_yymm;


i_seq = 1	//�������� �ڷ�

SELECT COUNT(*) INTO :lcount
  FROM PM01_MONPLAN_DTL A
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :syymm
   AND A.JUCHA = :ijucha ;
/*	AND A.JOCOD = :s_team;*/

if lcount > 0 then 
	smsgtxt = left(s_yymm, 4) + '�� ' + mid(s_yymm, 5, 2) + '�� ' + right(s_yymm,2)+'�� ' + &
				 ' �ְ� �����ȹ�ڷᰡ �����մϴ�. ' + "~n~n" +&
				  '�������� �ְ� �����ȹ�� �����Ͻð� ���� �Ͻʽÿ�.!!'
	messagebox("Ȯ ��", smsgtxt)
	return 
end if

SetPointer(HourGlass!)
dw_insert.Reset()

/* �ֹ����� ���� - �ְ���ȹ������ �ֹ����泻���� üũ���� */
//String sDate, eDate
//Long   nCnt
//
//SELECT MIN(WEEK_SDATE), MAX(WEEK_LDATE) INTO :SDATE, :EDATE
//  FROM PDTWEEK 
// WHERE WEEK_SDATE = :S_YYMM;
		  
//SELECT COUNT(*) INTO :nCnt
//  FROM SORDER A
// WHERE A.SABU = :gs_sabu
//   AND A.CUST_NAPGI BETWEEN :sdate AND :edate
//   AND A.SPECIAL_YN <> 'Y'
//	AND A.WEB = 'Y'
//	AND A.SAUPJ = :gs_saupj;
//If nCnt > 0 Then
//	MessageBox('Ȯ��','�ֹ������� ����� ������ �����մϴ�.!!~r~n�����ȹ ������ ���� ó���ϼ���.!!')
//	Return
//End If

//If MessageBox("Ȯ��", '�ְ� �ǰ�ȹ�� �����մϴ�.!!~r~n���� �ڷ�� ��� �����˴ϴ�.!!', Exclamation!, OKCancel!, 2) = 2 Then Return

/* ����� ���о��� �ǸŰ�ȹ���� - BY SHINGOON 2015.08.24 */
//lRtnValue = sqlca.FUN_PM02_WEEKPLAN_SUM(gs_sabu, syymm, ijucha, s_team)
lRtnValue = sqlca.FUN_PM02_WEEKPLAN_SUM_ALLSAUPJ(gs_sabu, syymm, ijucha, s_team)

IF lRtnValue < 0 THEN
	MESSAGEBOX(STRING(lRtnValue),SQLCA.SQLERRTEXT)
	ROLLBACK;
	f_message_chk(41,'')
	Return
ELSE
	commit ;
	MessageBox('Ȯ ��', '�ڷᰡ ����ó�� �Ǿ����ϴ�!!')
END IF

//p_inq.TriggerEvent(Clicked!)
end event

type p_ins from w_inherite`p_ins within w_pm01_02010
boolean visible = false
integer x = 5001
integer y = 188
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pm01_02010
integer x = 4352
integer y = 40
end type

type p_can from w_inherite`p_can within w_pm01_02010
integer x = 4178
integer y = 40
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

type p_print from w_inherite`p_print within w_pm01_02010
boolean visible = false
integer x = 4818
integer y = 188
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pm01_02010
integer x = 3831
integer y = 40
end type

event p_inq::clicked;string s_gub, s_team, s_yymm, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, &
       s_gub2
Int    i_seq
long   lcount

if dw_1.AcceptText() = -1 then return 
SetPointer(HourGlass!)

s_gub  = dw_1.GetItemString(1,'sgub')
s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_gub2 = dw_1.GetItemString(1,'gubun')

if isnull(s_team) or s_team = "" then s_team = '%'
//	f_message_chk(30,'[������]')
//	dw_1.Setcolumn('steam')
//	dw_1.SetFocus()
//	return
//end if	

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

String  ls_saupj
SELECT RFNA2 INTO :ls_saupj FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFGUB = :s_team ;
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '10'
	
if dw_insert.Retrieve(gs_sabu,s_yymm, s_team, ls_saupj, s_gub2) <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
//	p_addrow.picturename = 'C:\erpman\image\���߰�_d.gif'
//	p_delrow.picturename = 'C:\erpman\image\�����_d.gif'
//	p_mod.picturename = 'C:\erpman\image\����_d.gif'		
//	p_addrow.enabled = false
//	p_delrow.enabled = false
//	p_mod.enabled = false
	return
Else
//	p_addrow.picturename = 'C:\erpman\image\���߰�_up.gif'
//	p_delrow.picturename = 'C:\erpman\image\�����_up.gif'
//	p_mod.picturename = 'C:\erpman\image\����_up.gif'		
//	p_addrow.enabled = true
//	p_delrow.enabled = true
//	p_mod.enabled = true
	return	
end if	
end event

type p_del from w_inherite`p_del within w_pm01_02010
integer x = 3173
integer y = 40
end type

event p_del::clicked;call super::clicked;string s_yymm, smsgtxt, stext, s_team, get_nm, s_toym, syymm
int    i_seq, ijucha
long   lcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
syymm = left(s_yymm,6)
i_seq  = dw_1.GetItemNumber(1,'jjcha')

SetPointer(HourGlass!)

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[������/��]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
else
  SELECT "JONAM"  
    INTO :get_nm  
    FROM "JOMAST"  
   WHERE "JOCOD" = :s_team;
end if	

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[��������]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
	

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[Ȯ��/���� ����]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
else
	if i_seq = 1 then 
		stext = 'Ȯ����'
	else
		stext = '������'
	end if	
end if	

	
smsgtxt = get_nm + '�� ' + left(s_yymm, 4) + '�� ' + mid(s_yymm, 5, 2) + '�� ' + right(s_yymm, 2) + '�� ' &
          + stext + ' �ְ� �����ȹ�� ���� �Ͻðڽ��ϱ�?'
if messagebox("Ȯ ��", smsgtxt, Question!, YesNo!, 2) = 2 then return   

i_seq = 1

// ����
SELECT MON_JUCHA INTO :ijucha FROM PDTWEEK WHERE WEEK_SDATE = :s_yymm;

DELETE FROM PM01_MONPLAN_DTL A
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :syymm
   AND A.JUCHA = :ijucha
	AND A.JOCOD = :s_team ;

if SQLCA.SQLCODE = 0 then
else
	rollback ;
   messagebox("��������", "������/�ݺ� ������ �����Ͽ����ϴ�")
	return 
end if

SELECT COUNT(*) INTO :lcount
  FROM PM01_MONPLAN_DTL A
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :syymm
   AND A.JUCHA = :ijucha
	AND A.JOCOD = :s_team;
	
  DELETE FROM PM02_WEEKPLAN_SUM  
   WHERE SABU = :gs_sabu AND YYMMDD = :s_yymm AND MOSEQ = :i_seq AND JOCOD = :s_team;

if SQLCA.SQLCODE = 0 then
	commit ;
	sle_msg.text = "�ڷᰡ �����Ǿ����ϴ�!!"
	ib_any_typing= FALSE
else
	rollback ;
   messagebox("��������", "������/�ݺ� ������ �����Ͽ����ϴ�")
	return 
end if	
		
p_can.TriggerEvent(clicked!)

end event

type p_mod from w_inherite`p_mod within w_pm01_02010
boolean visible = false
integer x = 5358
integer y = 188
boolean enabled = false
end type

event p_mod::clicked;call super::clicked;string s_yymm, s_toym
long   i

if dw_1.AcceptText() = -1 then return 

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
//if s_yymm < s_toym then
//	messagebox("Ȯ��", "���� ���� ��� �ڷ�� ������ �� �����ϴ�!!")
//	dw_1.setcolumn('syymm')
//	dw_1.setfocus()
//	return 
//end if		

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	commit ;
	sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
	ib_any_typing= FALSE
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
	return 
end if	
		
p_inq.TriggerEvent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pm01_02010
end type

type cb_mod from w_inherite`cb_mod within w_pm01_02010
end type

type cb_ins from w_inherite`cb_ins within w_pm01_02010
end type

type cb_del from w_inherite`cb_del within w_pm01_02010
end type

type cb_inq from w_inherite`cb_inq within w_pm01_02010
end type

type cb_print from w_inherite`cb_print within w_pm01_02010
end type

type st_1 from w_inherite`st_1 within w_pm01_02010
end type

type cb_can from w_inherite`cb_can within w_pm01_02010
end type

type cb_search from w_inherite`cb_search within w_pm01_02010
end type







type gb_button1 from w_inherite`gb_button1 within w_pm01_02010
end type

type gb_button2 from w_inherite`gb_button2 within w_pm01_02010
end type

type dw_1 from u_key_enter within w_pm01_02010
integer x = 69
integer y = 48
integer width = 2021
integer height = 140
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pm01_02010_1"
boolean border = false
end type

event itemchanged;String syymm, sNull

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
			Return
		End If
		
		Post wf_protect(syymm)
	Case 'steam'
		syymm = Trim(GetItemString(1, 'syymm'))
		
		Post wf_protect(syymm)
End Choose

dw_insert.Reset()
end event

event itemerror;call super::itemerror;Return 1
end event

type pb_1 from u_pb_cal within w_pm01_02010
integer x = 800
integer y = 64
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('syymm')
IF IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'syymm', gs_code)
end event

type p_xls from picture within w_pm01_02010
integer x = 4005
integer y = 40
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\������ȯ_up.gif"
boolean focusrectangle = false
end type

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type rr_1 from roundrectangle within w_pm01_02010
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

