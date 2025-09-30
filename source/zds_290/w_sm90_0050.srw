$PBExportHeader$w_sm90_0050.srw
$PBExportComments$�ְ� �ǸŰ�ȹ ��Ȳ
forward
global type w_sm90_0050 from w_inherite
end type
type dw_1 from u_key_enter within w_sm90_0050
end type
type rr_1 from roundrectangle within w_sm90_0050
end type
type cbx_1 from checkbox within w_sm90_0050
end type
type hpb_1 from hprogressbar within w_sm90_0050
end type
type pb_1 from u_pb_cal within w_sm90_0050
end type
type p_preview from picture within w_sm90_0050
end type
type dw_print from datawindow within w_sm90_0050
end type
type p_1 from uo_excel_down within w_sm90_0050
end type
type dw_prt from datawindow within w_sm90_0050
end type
type dw_prt2 from datawindow within w_sm90_0050
end type
type dw_excel from datawindow within w_sm90_0050
end type
end forward

global type w_sm90_0050 from w_inherite
integer width = 4667
integer height = 2648
string title = "�ְ� �Ǹ� ��ȹ ��Ȳ"
dw_1 dw_1
rr_1 rr_1
cbx_1 cbx_1
hpb_1 hpb_1
pb_1 pb_1
p_preview p_preview
dw_print dw_print
p_1 p_1
dw_prt dw_prt
dw_prt2 dw_prt2
dw_excel dw_excel
end type
global w_sm90_0050 w_sm90_0050

forward prototypes
public function integer wf_danga (integer nrow)
end prototypes

public function integer wf_danga (integer nrow);String sToday, sCvcod, sItnbr, sSpec
Double dItemPrice, dDcRate
Int    iRtnValue

sToday = f_today()

sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
sSpec  = '.'

iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sToday, sCvcod, sItnbr, sSpec, 'WON','1', dItemPrice, dDcRate)
If IsNull(dItemPrice) Then dItemPrice = 0

dw_insert.SetItem(nRow, 'itm_prc', dItemPrice)

return 1
end function

on w_sm90_0050.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.cbx_1=create cbx_1
this.hpb_1=create hpb_1
this.pb_1=create pb_1
this.p_preview=create p_preview
this.dw_print=create dw_print
this.p_1=create p_1
this.dw_prt=create dw_prt
this.dw_prt2=create dw_prt2
this.dw_excel=create dw_excel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.hpb_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.p_preview
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.p_1
this.Control[iCurrent+9]=this.dw_prt
this.Control[iCurrent+10]=this.dw_prt2
this.Control[iCurrent+11]=this.dw_excel
end on

on w_sm90_0050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.cbx_1)
destroy(this.hpb_1)
destroy(this.pb_1)
destroy(this.p_preview)
destroy(this.dw_print)
destroy(this.p_1)
destroy(this.dw_prt)
destroy(this.dw_prt2)
destroy(this.dw_excel)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_excel.SetTransObject(SQLCA)

dw_1.InsertRow(0)

//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_1.SetItem(1, 'saupj', gs_code)
////   if gs_code <> '%' then
////   	dw_1.Modify("saupj.protect=1")
////   End if
//End If

dw_1.Object.sdate[1] = is_today

Long ll_cnt
ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item
 where saupj = :gs_code
	and yymmdd = :is_today 
	and cnfirm is not null;
If ll_cnt < 1 Then
	dw_1.Object.confirm[1] = '1'
Else
	dw_1.Object.confirm[1] = '2'
End If
end event

event key;//Not Extend Ancestor Script

Choose Case key
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyV!
		p_preview.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
//	Case KeyT!
//		p_ins.TriggerEvent(Clicked!)
//	Case KeyA!
//		p_addrow.TriggerEvent(Clicked!)
//	Case KeyE!
//		p_delrow.TriggerEvent(Clicked!)
//	Case KeyS!
//		p_mod.TriggerEvent(Clicked!)
//	Case KeyD!
//		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_sm90_0050
integer x = 27
integer y = 304
integer width = 4576
integer height = 1996
integer taborder = 140
string dataobject = "d_sm90_0050_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Dec  dmmqty, davg
Long nJucha, ix, nRow
Int  ireturn
String sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, snull, get_nm

setnull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itemas_itdsc", sitdsc)
		
		RETURN ireturn
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nrow, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS2"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nrow, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
		
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(lrow,"itnbr",gs_code)
		this.SetItem(lrow,"itemas_itdsc",gs_codename)
		
		
		Return 1
	Case 'cvcod'
		
		gs_gubun = '1'

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(lrow, "cvcod", gs_Code)
		this.SetItem(lrow, "cvnas", gs_Codename)
		
End Choose
end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm90_0050
boolean visible = false
integer x = 3776
integer y = 152
integer taborder = 70
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm90_0050
boolean visible = false
integer x = 3598
integer y = 156
integer taborder = 60
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm90_0050
boolean visible = false
integer x = 4096
integer taborder = 120
boolean enabled = false
string picturename = "C:\erpman\image\Ȯ�����_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\Ȯ�����_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\Ȯ�����_up.gif"
end event

event p_search::clicked;call super::clicked;If dw_1.acceptText() < 1 Then return

If dw_insert.Rowcount() < 1 Then Return

String ls_yymm , ls_saupj  ,ls_confirm_dt
Long   ll_cnt

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yymm = Trim(dw_1.Object.sdate[1])
ls_confirm_dt= Trim(dw_1.Object.confirm_dt[1])

ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item
 where saupj = :ls_saupj
   and yymmdd = :ls_yymm
	 ;
If ll_cnt < 1 Then
	MessageBox('Ȯ��','�ش� ���ڿ��� ���� �ǸŰ�ȹ�� �������� �ʾҽ��ϴ�.')
	Return
END If

ll_cnt = 0 

SELECT COUNT(*) INTO :ll_cnt 
 FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu 
   AND A.YYMMDD = :ls_yymm 
	AND A.MOSEQ = 0
	AND A.SAUPJ LIKE :ls_saupj||'%';

If ll_cnt > 0 Then
	MessageBox('Ȯ��','�ش� ������ �ǸŰ�ȹ�� �̹� �����ȹ�� �ݿ��Ǿ� ���������Դϴ�.  ��� �Ұ����մϴ�.')
	Return
Else
	ll_cnt = 0 

	SELECT COUNT(*) INTO :ll_cnt 
	 FROM PM02_WEEKPLAN_SUM A
	 WHERE A.SABU = :gs_sabu 
		AND A.YYMMDD = :ls_yymm 
		AND A.MOSEQ != 0
		AND A.SAUPJ LIKE :ls_saupj||'%';
		
	If ll_cnt > 0 Then
		MessageBox('Ȯ��','�ش� ������ �ǸŰ�ȹ�� �����ȹ�� �ݿ��� ����(��Ȯ��)�Դϴ�. ��� �� �������� ���뺸 �ʿ��մϴ�.')
	
	End If
	
End If


If MessageBox("Ȯ��", String(ls_yymm , '@@@@.@@.@@')+ " ���� �ǸŰ�ȹ�� ��� �Ͻðڽ��ϱ�?    ", Exclamation!, OKCancel!, 2) = 2 Then
	Return
End if

SetNull(ls_confirm_dt)

Update sm03_weekplan_item Set cnfirm = :ls_confirm_dt
                    where saupj = :ls_saupj
						    and yymmdd = :ls_yymm ;
							 
If sqlca.sqlcode <> 0 Then
	Rollback;
	MessageBox('Ȯ��','�������')
	Return
Else
	Commit;
	dw_1.Object.confirm[1]='1'
	MessageBox('Ȯ��','�ϰ����� �Ǹ� ��ȹ�� ���� ��� �Ǿ����ϴ�.        ')
End If
	

	




	
	
	
end event

type p_ins from w_inherite`p_ins within w_sm90_0050
boolean visible = false
integer x = 4425
integer y = 220
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm90_0050
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_sm90_0050
integer taborder = 100
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()
dw_1.SetItem(1, 'plant', '.')
end event

type p_print from w_inherite`p_print within w_sm90_0050
boolean visible = false
integer x = 3552
integer y = 28
integer taborder = 130
boolean enabled = false
string picturename = "C:\erpman\image\�μ�_d.gif"
end type

event p_print::clicked;call super::clicked;IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_inq from w_inherite`p_inq within w_sm90_0050
integer x = 3749
end type

event p_inq::clicked;String ls_saupj , ls_factory , ls_ymd , ls_itnbr_from, ls_itnbr_to, ls_from, ls_to, tx_saupj , ls_empno

If dw_1.AcceptText() < 1 Then Return

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_1.Object.sdate[1])
ls_factory = Trim(dw_1.Object.plant[1])
//ls_itnbr = Trim(dw_1.Object.itnbr[1]) 

ls_itnbr_from = trim(dw_1.getitemstring(1, 'tx_itnbr_f'))
ls_itnbr_to   = trim(dw_1.getitemstring(1, 'tx_itnbr_t'))

ls_empno = trim(dw_1.getitemstring(1, 'empno'))

IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
IF isNull(ls_itnbr_to) THEN ls_itnbr_to = '' 

// ǰ�� ��ü�� �˻� �� ���� ITEMAS�� �ּ�, �ְ� ǰ���� ��ȸ�Ѵ�.	
IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
	SELECT MIN(ITNBR), MAX(ITNBR) 
	  INTO :ls_from, :ls_to
	  FROM ITEMAS ;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('����','ǰ�������͸� ��ȸ�� �� �����ϴ�.~n����ǿ� ���� �ٶ��ϴ�.')
		Return -1
	End If
ELSE
	ls_from = ls_itnbr_from
	ls_to = ls_itnbr_to
END IF 

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
If ls_empno = '' Or isNull(ls_empno)  Then ls_empno = '%'

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[��������]')
	Return
End If


/* ����� üũ */
//ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
//If IsNull(ls_saupj) Or ls_saupj = '' Then
//	f_message_chk(1400, '[�����]')
//	dw_1.SetFocus()
//	dw_1.SetColumn('saupj')
//	Return -1
//End If
If IsNull(ls_saupj) Or ls_saupj = '' Then ls_saupj = '%'

Long ll_cnt , i
ll_cnt = 0 

Select Count(*) Into :ll_cnt 
  from sm03_weekplan_item_sale
 where saupj = :ls_saupj
	and yymmdd = :ls_ymd 
	and cnfirm is not null;
If ll_cnt > 0 Then	
	dw_1.Object.confirm[1] = '2'	
Else
	dw_1.Object.confirm[1] = '1'
End If

dw_insert.Object.t_d1.Text = String(Right(f_afterday(ls_ymd , 1) , 4) ,'@@/@@')
dw_insert.Object.t_d2.Text = String(Right(f_afterday(ls_ymd , 2) , 4) ,'@@/@@')
dw_insert.Object.t_d3.Text = String(Right(f_afterday(ls_ymd , 3) , 4) ,'@@/@@')
dw_insert.Object.t_d4.Text = String(Right(f_afterday(ls_ymd , 4) , 4) ,'@@/@@')
dw_insert.Object.t_d5.Text = String(Right(f_afterday(ls_ymd , 5) , 4) ,'@@/@@')
dw_insert.Object.t_d6.Text = String(Right(f_afterday(ls_ymd , 6) , 4) ,'@@/@@')
dw_insert.Object.t_d7.Text = String(Right(f_afterday(ls_ymd , 7) , 4) ,'@@/@@')
dw_insert.Object.t_d8.Text = String(Right(f_afterday(ls_ymd , 8) , 4) ,'@@/@@')
dw_insert.Object.t_d9.Text = String(Right(f_afterday(ls_ymd , 9) , 4) ,'@@/@@')
dw_insert.Object.t_d10.Text = String(Right(f_afterday(ls_ymd , 10) , 4) ,'@@/@@')
dw_insert.Object.t_d11.Text = String(Right(f_afterday(ls_ymd , 11) , 4) ,'@@/@@')

for i = 1 To 11
	If f_holiday_chk(f_afterday(ls_ymd,i)) = 'Y' Then
		dw_insert.Modify("t_d"+string(i)+".Background.Color = '255'")
		dw_insert.Modify("itm_qty"+string(i)+"_t.Background.Color = '255'")
	Else
		dw_insert.Modify("t_d"+string(i)+".Background.Color = '28144969'")
		dw_insert.Modify("itm_qty"+string(i)+"_t.Background.Color = '28144969'")
		
	End If
Next



If dw_insert.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to ,ls_empno ) <= 0 Then	
	f_message_chk(50,'')
Else
	dw_print.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to ,ls_empno )
	
	//Report   �˻����� �� Display
	dw_print.Modify("tx_ymd.text = '"+String(f_afterday(ls_ymd,1),'@@@@.@@.@@')+"'")
	
	tx_saupj = Trim(dw_1.Describe("Evaluate('LookUpDisplay(saupj)', 1)"))
	If IsNull(tx_saupj) Or tx_saupj = '' Then tx_saupj = '��ü'
	dw_print.Modify("tx_saupj.text = '"+tx_saupj+"'")
	dw_print.Modify("tx_itnbr_from.text = '"+ls_itnbr_from+"'")
	dw_print.Modify("tx_itnbr_to.text = '"+ls_itnbr_to+"'")
	
	dw_print.Modify("t_empname.text = '"+Trim(dw_1.Describe("Evaluate('LookUpDisplay(empno)', 1)"))+"'")
	
	//��� ���� - by shingoon 2009.06.30 ********************************************************/
	//dw_prt.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to, ls_empno)
	dw_prt2.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to, ls_empno)
	
//	//Report   �˻����� �� Display
//	dw_prt.Modify("tx_ymd.text = '"+String(f_afterday(ls_ymd,0),'@@@@.@@.@@')+"'")
//	
//	tx_saupj = Trim(dw_1.Describe("Evaluate('LookUpDisplay(saupj)', 1)"))
//	If IsNull(tx_saupj) Or tx_saupj = '' Then tx_saupj = '��ü'
//	dw_prt.Modify("tx_saupj.text = '"+tx_saupj+"'")
//	dw_prt.Modify("tx_itnbr_from.text = '"+ls_itnbr_from+"'")
//	dw_prt.Modify("tx_itnbr_to.text = '"+ls_itnbr_to+"'")
//
//	dw_prt.Object.t_d1.Text = String(Right(f_afterday(ls_ymd , 1) , 4) ,'@@/@@')
//	dw_prt.Object.t_d2.Text = String(Right(f_afterday(ls_ymd , 2) , 4) ,'@@/@@')
//	dw_prt.Object.t_d3.Text = String(Right(f_afterday(ls_ymd , 3) , 4) ,'@@/@@')
//	dw_prt.Object.t_d4.Text = String(Right(f_afterday(ls_ymd , 4) , 4) ,'@@/@@')
//	dw_prt.Object.t_d5.Text = String(Right(f_afterday(ls_ymd , 5) , 4) ,'@@/@@')
//	dw_prt.Object.t_d6.Text = String(Right(f_afterday(ls_ymd , 6) , 4) ,'@@/@@')
//	dw_prt.Object.t_d7.Text = String(Right(f_afterday(ls_ymd , 7) , 4) ,'@@/@@')
//	dw_prt.Object.t_d8.Text = String(Right(f_afterday(ls_ymd , 8) , 4) ,'@@/@@')
//	dw_prt.Object.t_d9.Text = String(Right(f_afterday(ls_ymd , 9) , 4) ,'@@/@@')
//	dw_prt.Object.t_d10.Text = String(Right(f_afterday(ls_ymd , 10) , 4) ,'@@/@@')
//	dw_prt.Object.t_d11.Text = String(Right(f_afterday(ls_ymd , 11) , 4) ,'@@/@@')
	/******************************************************************************************/

	if ls_factory = '%' then 
		dw_print.Modify("tx_factory.text = '��ü'")
	else
		dw_print.Modify("tx_factory.text = '"+ls_factory+"'")
	end if
	
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\�μ�_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\�̸�����_up.gif'
	
	if dw_1.getItemString(1, "prtgu") = '1' then
		dw_excel.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to ,ls_empno )	
	end if
End If

end event

type p_del from w_inherite`p_del within w_sm90_0050
boolean visible = false
integer x = 4247
integer y = 216
integer taborder = 90
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm90_0050
boolean visible = false
integer x = 3488
integer y = 136
integer taborder = 80
boolean enabled = false
string picturename = "C:\erpman\image\Ȯ��_up.gif"
end type

event p_mod::clicked;If dw_1.acceptText() < 1 Then return

If dw_insert.Rowcount() < 1 Then Return

String ls_yymm , ls_saupj  ,ls_confirm_dt
Long   ll_cnt

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yymm = Trim(dw_1.Object.sdate[1])
ls_confirm_dt= Trim(dw_1.Object.confirm_dt[1])

If isNull(ls_confirm_dt) or ls_confirm_dt = '' Then
	f_message_chk(35 , "[Ȯ������]")
	dw_1.SetFocus()
	dw_1.SetColumn("confirm_dt")
	Return
End If
ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item
 where saupj = :ls_saupj
   and yymmdd = :ls_yymm
	 ;
If ll_cnt < 1 Then
	MessageBox('Ȯ��','�ش� ���ڿ��� ���� �ǸŰ�ȹ�� �������� �ʾҽ��ϴ�.')
	Return
Else
	ll_cnt = 0 

	Select Count(*) Into :ll_cnt
	  from sm03_weekplan_item
	 where saupj = :ls_saupj
		and yymmdd = :ls_yymm
		and cnfirm is not null;
	If ll_cnt > 0 Then
		MessageBox('Ȯ��','�ش� ���ڿ��� �̹� �ǸŰ�ȹ�� Ȯ�� ���� �Դϴ�. ��� �� ��Ȯ�� �ϼ���.')
		Return
	End If
	
End If

If MessageBox("Ȯ��",String(ls_yymm,'@@@@.@@.@@') +" ���� �ǸŰ�ȹ�� Ȯ���Ͻðڽ��ϱ�?    ", Exclamation!, OKCancel!, 2) = 2 Then
	Return
End if

Update sm03_weekplan_item Set cnfirm = :ls_confirm_dt
                    where saupj = :ls_saupj
						    and yymmdd = :ls_yymm ;
If sqlca.sqlcode <> 0 Then
	Rollback;
	MessageBox('Ȯ��','�������')
	Return
Else
	Commit;
	dw_1.Object.confirm[1]='2'
	
	MessageBox('Ȯ��','�ϰ����� �Ǹ� ��ȹ�� �����Ǿ����ϴ�.        ')
End If
	


	
	
end event

event p_mod::ue_lbuttondown;//
end event

event p_mod::ue_lbuttonup;//
end event

type cb_exit from w_inherite`cb_exit within w_sm90_0050
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm90_0050
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm90_0050
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm90_0050
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm90_0050
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm90_0050
integer x = 3246
integer y = 116
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sm90_0050
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm90_0050
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm90_0050
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm90_0050
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm90_0050
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm90_0050
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm90_0050
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm90_0050
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm90_0050
integer x = 27
integer y = 24
integer width = 3410
integer height = 252
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm90_0050_1"
boolean border = false
end type

event itemchanged;String sDate, sNull
String ls_value, ls_itnbr_t, ls_itnbr_f

ls_value = Trim(GetText())
SetNull(sNull)

Choose Case GetColumnName()
	Case "tx_itnbr_f"
		ls_itnbr_t = Trim(This.GetItemString(row, 'tx_itnbr_t'))
		//if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then /* ���� ������쿡�� ���� �Է½ÿ��� �ڿ��� ���� �Էµǵ��� ��û - 2024.04.19  */
			This.SetItem(row, 'tx_itnbr_t', ls_value)
	   //end if
	Case "tx_itnbr_t"
		ls_itnbr_f = Trim(This.GetItemString(row, 'tx_itnbr_f'))
		//if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
		//	This.SetItem(row, 'tx_itnbr_f', ls_value)
	   //end if
	Case "prtgu"
		ls_value = GetText()
		if ls_value = '1' then //�ְ��ǸŰ�ȹ��Ȳ
			dw_insert.dataobject = 'd_sm90_0050_b'
		else
			dw_insert.dataobject = 'd_sm90_0050_a'
		end if
		dw_insert.settransobject(sqlca)
End Choose
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

If lrow < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'itnbr'
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr', gs_code)
		This.SetItem(row, 'itdsc', f_get_name5('13', gs_code, ''))
End Choose

If This.GetColumnName() = 'tx_itnbr_f' Then
	Open(w_itemas_popup)
	
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(lrow, 'tx_itnbr_f', gs_code)
ElseIf This.GetColumnName() = 'tx_itnbr_t' Then
	Open(w_itemas_popup)
	
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetITem(lrow, 'tx_itnbr_t', gs_code)
End If

//IF this.GetColumnName() = "cvcod" THEN
//	gs_code = this.GetText()
//	IF Gs_code ="" OR IsNull(gs_code) THEN 
//		gs_code =""
//	END IF
//	
////	gs_gubun = '2'
//	Open(w_vndmst_popup)
//	
//	IF isnull(gs_Code)  or  gs_Code = ''	then  
//		this.SetItem(lrow, "cvcod", snull)
//		this.SetItem(lrow, "cvnas", snull)
//   	return
//   ELSE
//		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
//		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
//			f_message_chk(37,'[�ŷ�ó]') 
//			this.SetItem(lRow, "cvcod", sNull)
//		   this.SetItem(lRow, "cvnas", sNull)
//			RETURN  1
//		END IF
//   END IF	
//
//	this.SetItem(lrow, "cvcod", gs_Code)
//	this.SetItem(lrow, "cvnas", gs_Codename)
//END IF
//
end event

type rr_1 from roundrectangle within w_sm90_0050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 296
integer width = 4599
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_1 from checkbox within w_sm90_0050
boolean visible = false
integer x = 3703
integer y = 400
integer width = 795
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "ǰ�� �ְ���ȹ(����) Ȯ��"
end type

event clicked;String syymm, sCust, sDate, eDate, sCvcod, sSaupj

syymm  = trim(dw_1.getitemstring(1, 'yymm'))
sCust  = trim(dw_1.getitemstring(1, 'cust'))
sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
If IsNull(sCvcod) Then sCvcod = ''

If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[��ȹ������]')
	Return
End If

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

If This.Checked = false Then
	dw_insert.DataObject = 'd_sm01_03010_3'
	dw_insert.SetTransObject(sqlca)
	
	If dw_insert.Retrieve(sSaupj, syymm, sCust, sCvcod+'%') <= 0 Then
		f_message_chk(50,'')
	End If	
Else
	dw_insert.DataObject = 'd_sm01_03010_lg_1'
	dw_insert.SetTransObject(sqlca)
	
	select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;
	
	If dw_insert.Retrieve(sSaupj, sDate, eDate) <= 0 Then
		f_message_chk(50,'')
	End If
End If
end event

type hpb_1 from hprogressbar within w_sm90_0050
boolean visible = false
integer x = 1819
integer y = 892
integer width = 1262
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type pb_1 from u_pb_cal within w_sm90_0050
integer x = 1765
integer y = 68
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('sdate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'sdate', gs_code)

end event

type p_preview from picture within w_sm90_0050
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\preview.cur"
boolean enabled = false
string picturename = "C:\erpman\image\�̸�����_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;IF This.Enabled = True THEN
	PictureName =  'C:\erpman\image\�̸�����_up.gif'
END IF
end event

event ue_lbuttondown;IF This.Enabled = True THEN
	PictureName = 'C:\erpman\image\�̸�����_dn.gif'
END IF

end event

event clicked;If dw_1.GetItemString(1, 'prtgu') = '2' Then
	OpenWithParm(w_print_preview, dw_print)
Else
	//OpenWithParm(w_print_preview, dw_prt)
	OpenWithParm(w_print_preview, dw_prt2)
End If
end event

type dw_print from datawindow within w_sm90_0050
boolean visible = false
integer x = 3982
integer y = 172
integer width = 178
integer height = 120
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm90_0050_p_new"
boolean border = false
boolean livescroll = true
end type

type p_1 from uo_excel_down within w_sm90_0050
integer x = 3922
integer y = 24
boolean bringtotop = true
end type

event clicked;call super::clicked;if dw_1.getItemString(1, "prtgu") = '1' then
	If this.Enabled Then uf_excel_down(dw_excel) /* �ְ��ǸŰ�ȹ ���� ��ȯ�� ����׸����� ����  Ȯ�� �ڷ�� ���͸� �� ��� ǰ���� Ȯ���� �� ��� ����� ǰ���� ��ȸ�ǵ��� ���� - 2024.04.19*/
else
	If this.Enabled Then uf_excel_down(dw_insert)
end if
end event

type dw_prt from datawindow within w_sm90_0050
boolean visible = false
integer x = 3488
integer y = 164
integer width = 233
integer height = 188
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sm90_0050_p1-1"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_prt2 from datawindow within w_sm90_0050
boolean visible = false
integer x = 3141
integer y = 164
integer width = 233
integer height = 188
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sm90_0050_p1-2"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_excel from datawindow within w_sm90_0050
boolean visible = false
integer x = 6000
integer y = 880
integer width = 686
integer height = 400
integer taborder = 150
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm90_0050_b_excel"
boolean border = false
boolean livescroll = true
end type

