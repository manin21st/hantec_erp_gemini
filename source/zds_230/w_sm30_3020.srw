$PBExportHeader$w_sm30_3020.srw
$PBExportComments$�ְ� �ǸŰ�ȹ Ȯ��
forward
global type w_sm30_3020 from w_inherite
end type
type dw_1 from u_key_enter within w_sm30_3020
end type
type rr_1 from roundrectangle within w_sm30_3020
end type
type hpb_1 from hprogressbar within w_sm30_3020
end type
type pb_1 from u_pb_cal within w_sm30_3020
end type
type pb_2 from u_pb_cal within w_sm30_3020
end type
type dw_excel from datawindow within w_sm30_3020
end type
type p_excel from uo_picture within w_sm30_3020
end type
type sle_confirm_ilsu from singlelineedit within w_sm30_3020
end type
end forward

global type w_sm30_3020 from w_inherite
integer width = 4677
integer height = 2804
string title = "�ְ� �ǸŰ�ȹ Ȯ��"
dw_1 dw_1
rr_1 rr_1
hpb_1 hpb_1
pb_1 pb_1
pb_2 pb_2
dw_excel dw_excel
p_excel p_excel
sle_confirm_ilsu sle_confirm_ilsu
end type
global w_sm30_3020 w_sm30_3020

forward prototypes
public function integer wf_danga (integer nrow)
public function long wf_cnf_chk ()
public subroutine wf_excel_down (datawindow adw_excel)
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

public function long wf_cnf_chk ();Long ll_cnt 
String ls_saupj , ls_ymd ,ls_factory , ls_empno
ll_cnt = 0 

If dw_1.AcceptText() < 1 Then Return -1
If dw_1.RowCount() < 1 Then Return -1

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_1.Object.sdate[1])
ls_factory = Trim(dw_1.Object.plant[1])

ls_empno = Trim(dw_1.object.empno[1])

ll_cnt = 0 

If ls_empno = '' or isNull(ls_empno) then ls_empno = '%' 

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item_sale a
 where a.saupj = :ls_saupj
	and a.yymmdd = :ls_ymd 
	AND cnfirm is not null ;
//	and exists (select 'x' from reffpf x where x.rfcod = '2A' 
//				                              and x.rfgub = a.gate
//													   and nvl(x.rfna5,' ') like :ls_empno )  ;
	
If ll_cnt > 0 Then
	dw_1.Object.confirm[1] = '3'
	p_search.Enabled = True
	p_mod.Enabled = False
	
   p_search.PictureName = 'C:\erpman\image\Ȯ�����_up.gif'
	p_mod.PictureName = 'C:\erpman\image\Ȯ��_d.gif'

	return -1
Else
	
	dw_1.Object.confirm[1] = '2'
	p_search.Enabled = false
	p_mod.Enabled = True
	
	p_search.PictureName = 'C:\erpman\image\Ȯ�����_d.gif'
	p_mod.PictureName = 'C:\erpman\image\Ȯ��_up.gif'

	return 1
	
End iF

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

on w_sm30_3020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.hpb_1=create hpb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_excel=create dw_excel
this.p_excel=create p_excel
this.sle_confirm_ilsu=create sle_confirm_ilsu
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.hpb_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.dw_excel
this.Control[iCurrent+7]=this.p_excel
this.Control[iCurrent+8]=this.sle_confirm_ilsu
end on

on w_sm30_3020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.hpb_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_excel)
destroy(this.p_excel)
destroy(this.sle_confirm_ilsu)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

dw_excel.SetTransObject(SQLCA)

dw_1.InsertRow(0)

//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//   End if
//End If

//20181029 ���� ��û ���� ����� ������ ������� ����Ʈ�� ������û HYKANG 20181029
//dw_1.SetItem(1, 'saupj', gs_saupj)
dw_1.SetItem(1, 'saupj', '20')

dw_1.Object.sdate[1] = is_today
dw_1.Object.confirm_dt[1] = is_today

wf_cnf_chk()

if gs_userid = 'ADMIN' then
	sle_confirm_ilsu.Visible = true
end if
end event

type dw_insert from w_inherite`dw_insert within w_sm30_3020
integer x = 27
integer y = 304
integer width = 4576
integer height = 1996
integer taborder = 150
string dataobject = "d_sm30_3020_a"
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

type p_delrow from w_inherite`p_delrow within w_sm30_3020
boolean visible = false
integer x = 4101
integer y = 176
integer taborder = 60
end type

type p_addrow from w_inherite`p_addrow within w_sm30_3020
boolean visible = false
integer x = 3927
integer y = 176
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_sm30_3020
integer x = 3922
integer taborder = 130
string picturename = "C:\erpman\image\Ȯ�����_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\Ȯ�����_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\Ȯ�����_up.gif"
end event

event p_search::clicked;call super::clicked;If dw_1.acceptText() < 1 Then return

If dw_insert.Rowcount() < 1 Then Return

String ls_yymm , ls_saupj  ,ls_confirm_dt , ls_empno
Long   ll_cnt

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yymm = Trim(dw_1.Object.sdate[1])
ls_confirm_dt= Trim(dw_1.Object.confirm_dt[1])

ls_empno = Trim(dw_1.Object.empno[1])

If ls_empno = '' or isNull(ls_empno) Then ls_empno = '%'

ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item_sale
 where saupj = :ls_saupj
   and yymmdd = :ls_yymm ;
//	and nvl(empno, 'N') like :ls_empno   ;
	
If ll_cnt < 1 Then
	MessageBox('Ȯ��','�ش� ���ڿ��� ���� �ǸŰ�ȹ�� �������� �ʾҽ��ϴ�.')
	Return
END If

ll_cnt = 0 

/****************************************************************************************************************************/
/* �ް��� ���޵����� ���� ��ȹ�� 2�ֵ� �ڷ�� ���� ���� ��� Ȯ����� �� SM03_WEEKPLAN_ITEM�� �ڷḦ ã�̸��� �������� ���� */
/* �� Ȯ�� �� �ߺ����� �߻� ��                                                                                              */
String  ls_newym
String  ls_ilsu
Integer li_ilsu
ls_ilsu = sle_confirm_ilsu.Text
li_ilsu = Integer(ls_ilsu)
/* �Էµ� �ϼ��� 5�� �̸��̸� ���� ������ �ڷḦ ��������, 5�� �̻��̸� �Էµ� �ϼ��� ��¥�� ����Ͽ� ������ ���θ� ���� */
If li_ilsu <= 5 Then
	/* ���� �����ȹ �ڷ� Ȯ�� ���η� �Ǵ� - 2009.02.10 by shingoon */
	SELECT TO_CHAR(NEXT_DAY(TO_DATE(:ls_yymm, 'YYYYMMDD'), 2), 'YYYYMMDD')
			 //���� ������ ���ڸ� ������. 1:�Ͽ���, 2:������, 3:ȭ����...
	  INTO :ls_newym
	  FROM DUAL ;
Else
	Date    ld_newym
	Integer li_ins
	String  ls_dayname
	ld_newym   = RelativeDate(Date(LEFT(ls_yymm, 4) + '-' + MID(ls_yymm, 5, 2) + '-' + RIGHT(ls_yymm, 2)), li_ilsu)
	li_ins     = DayNumber(ld_newym) //�Ͽ����� 1, �������� 2...
	ls_dayname = DayName(ld_newym)
	If li_ins <> 2 Then
		MessageBox('���� ���� Ȯ��', ls_ilsu + '�� �� ���۵Ǵ� ������ ' + ls_dayname + ' �Դϴ�.~r~nMonday�� ���� �Ͻʽÿ�.')
		Return
	End If
	ls_newym = String(ld_newym, 'yyyymmdd')
End If
/*************************************************************************************************** 2013.07.25 BY SHINGOON */

SELECT COUNT(*) INTO :ll_cnt 
 FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu 
   AND A.YYMMDD = :ls_newym 
	AND A.MOSEQ = 0 ;

If ll_cnt > 0 Then
	MessageBox('Ȯ��','�ش� ������ �ǸŰ�ȹ�� �̹� �����ȹ�� �ݿ��Ǿ� ���������Դϴ�.  ��� �Ұ����մϴ�.')
	Return
Else
	ll_cnt = 0 

	SELECT COUNT(*) INTO :ll_cnt
	 FROM PM02_WEEKPLAN_SUM A
	 WHERE A.SABU = :gs_sabu 
		AND A.YYMMDD = :ls_newym 
		AND A.MOSEQ != 0 ;
		
	If ll_cnt > 0 Then
		MessageBox('Ȯ��','�ش� ������ �ǸŰ�ȹ�� �̹� �����ȹ�� �ݿ��� �����Դϴ�.  ��� �Ұ����մϴ�.')
	   Return
	End If
	
End If

If MessageBox("Ȯ��", String(ls_yymm , '@@@@.@@.@@')+ " ���� �ǸŰ�ȹ�� ��� �Ͻðڽ��ϱ�?    ", Exclamation!, OKCancel!, 2) = 2 Then
	Return
End if

SetNull(ls_confirm_dt)

Update sm03_weekplan_item_sale Set cnfirm = :ls_confirm_dt
                    where saupj = :ls_saupj
						    and yymmdd = :ls_yymm  ;
//							 and nvl(empno, 'N') like :ls_empno   ;
							 
If sqlca.sqlcode <> 0 Then
	Rollback;
	MessageBox('Ȯ��','�������')
	Return
Else
	Commit;
	wf_cnf_chk()
	MessageBox('Ȯ��','�ϰ����� �Ǹ� ��ȹ�� ���� ��� �Ǿ����ϴ�.        ')
End If


/* �ְ��ǸŰ�ȹ Ȯ����� - ����� �Ѹ��̶� ����ϸ� ��ü Ȯ����� */  
// ���� Ȯ��/��Ҵ� ����� ����, �ְ��ڷ� ��ü�� Ȯ��/��� ���� - 2009.07.30
/* ���� Ȯ���� �߰������ڰ� ���� Ȯ�� �� Ȯ��(����ڴ� ���ǰ�ȹ �ۼ��� ó��) -2009.07.30 */
Select Count(*) Into :ll_cnt
  from sm03_weekplan_item
 where saupj = :ls_saupj
   and yymmdd = :ls_newym ;
//   and yymmdd = :ls_yymm ;
	
If ll_cnt > 0 Then
	Delete From sm03_weekplan_item
	 where saupj = :ls_saupj
		and yymmdd = :ls_newym ;
//		and yymmdd = :ls_yymm ;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('Ȯ��',sqlca.sqlerrText)
		Rollback;
		MessageBox('Ȯ��','�������')
		Return
	Else
		Commit;
	End If
End If


wf_cnf_chk()
	

end event

type p_ins from w_inherite`p_ins within w_sm30_3020
boolean visible = false
integer x = 4448
integer y = 220
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm30_3020
integer taborder = 120
end type

type p_can from w_inherite`p_can within w_sm30_3020
integer x = 4096
integer taborder = 100
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()
dw_1.SetItem(1, 'plant', '.')
end event

type p_print from w_inherite`p_print within w_sm30_3020
boolean visible = false
integer x = 1861
integer y = 80
integer taborder = 140
string picturename = "C:\erpman\image\�ҿ䷮���_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\�ҿ䷮���_dn.gif"
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ҿ䷮���_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sm30_3020
integer x = 3575
end type

event p_inq::clicked;String ls_saupj , ls_factory , ls_ymd , ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
Long i
String ls_empno
If dw_1.AcceptText() < 1 Then Return

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_1.Object.sdate[1])
ls_factory = Trim(dw_1.Object.plant[1])
ls_empno = Trim(dw_1.Object.empno[1])

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'

//If ls_empno = '' Or isNull(ls_empno)  Then 
//	MessageBox('Ȯ��','����ڸ� �����Ͻʽÿ�!!!')
//	Return -1
//End If
If Trim(ls_empno) = '' Or IsNull(ls_empno) Then ls_empno = '%'

//If ls_empno = '' Or isNull(ls_empno)  Then ls_empno = '%'

ls_itnbr_from = trim(dw_1.getitemstring(1, 'tx_itnbr_f'))
ls_itnbr_to   = trim(dw_1.getitemstring(1, 'tx_itnbr_t'))

IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
IF isNull(ls_itnbr_to) THEN ls_itnbr_to = '' 

// ǰ�� ��ü�� �˻� �� ���� ITEMAS�� �ּ�, �ְ� ǰ���� ��ȸ�Ѵ�.	
IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
	SELECT MIN(ITNBR), MAX(ITNBR) 
	INTO   :ls_from, :ls_to
	FROM   ITEMAS ;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('����','ǰ�������͸� ��ȸ�� �� �����ϴ�.~n����ǿ� ���� �ٶ��ϴ�.')
		Return -1
	End If
ELSE
	ls_from = ls_itnbr_from
	ls_to = ls_itnbr_to
END IF 

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[��ȹ������]')
	Return
End If

/* ����� üũ */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

wf_cnf_chk()

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
	If f_holiday_chk( f_afterday(ls_ymd,i)) = 'Y' Then
		dw_insert.Modify("t_d"+string(i)+".Background.Color = '255'")
		dw_insert.Modify("itm_qty"+string(i)+"_t.Background.Color = '255'")
	Else
		dw_insert.Modify("t_d"+string(i)+".Background.Color = '28144969'")
		dw_insert.Modify("itm_qty"+string(i)+"_t.Background.Color = '28144969'")
		
	End If
Next

If dw_insert.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to , ls_empno) <= 0 Then
	
	f_message_chk(50,'')
Else
	
End If

end event

type p_del from w_inherite`p_del within w_sm30_3020
boolean visible = false
integer x = 4274
integer y = 216
integer taborder = 80
end type

type p_mod from w_inherite`p_mod within w_sm30_3020
integer x = 3749
integer taborder = 70
string picturename = "C:\erpman\image\Ȯ��_up.gif"
end type

event p_mod::clicked;If dw_1.acceptText() < 1 Then return
If dw_insert.acceptText() < 1 Then Return
If dw_insert.Rowcount() < 1 Then Return

String ls_yymm , ls_saupj  ,ls_confirm_dt , ls_empno
Long   ll_cnt , i, ll_ilsu

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yymm  = Trim(dw_1.Object.sdate[1])

ls_empno = Trim(dw_1.Object.empno[1])

ls_confirm_dt= Trim(dw_1.Object.confirm_dt[1])

If isNull(ls_confirm_dt) or ls_confirm_dt = '' Then
	f_message_chk(35 , "[Ȯ������]")
	dw_1.SetFocus()
	dw_1.SetColumn("confirm_dt")
	Return
End If
ll_cnt = 0 

If ls_empno = '' or isNull(ls_empno) Then ls_empno = '%'

Select Count(*) Into :ll_cnt
  from sm03_weekplan_item_sale
 where saupj = :ls_saupj
   and yymmdd = :ls_yymm ;
//	and empno like :ls_empno   ;
	
If ll_cnt < 1 Then
	MessageBox('Ȯ��','�ش� ���ڿ��� ���� �ǸŰ�ȹ�� �������� �ʾҽ��ϴ�.')
	Return
Else
	ll_cnt = 0 

	Select Count(*) Into :ll_cnt
	  from sm03_weekplan_item_sale 
	 where saupj = :ls_saupj
		and yymmdd = :ls_yymm
		and cnfirm is not null ;
//		and empno like :ls_empno   ;
		
		
	If ll_cnt > 0 Then
		MessageBox('Ȯ��','�ش� ���ڿ��� �̹� �ǸŰ�ȹ�� Ȯ�� ���� �Դϴ�. ��� �� ��Ȯ�� �ϼ���.')
		Return
	End If
	
End If

If MessageBox("Ȯ��",String(ls_yymm,'@@@@.@@.@@') +" ���� �ǸŰ�ȹ�� Ȯ���Ͻðڽ��ϱ�?    ", Exclamation!, OKCancel!, 2) = 2 Then
	Return
End if

Update sm03_weekplan_item_sale Set cnfirm = :ls_confirm_dt
						           where saupj = :ls_saupj
							          and yymmdd = :ls_yymm ;
//										 and ( empno like :ls_empno or empno is null )  ; 
If sqlca.sqlcode <> 0 Then
	MessageBox('Ȯ��',sqlca.sqlerrText)
	Rollback;
	MessageBox('Ȯ��','�������')
	dw_insert.SetRedraw(True)
	Return
Else
	Commit;
	dw_insert.SetRedraw(True)
	wf_cnf_chk()
	
	MessageBox('Ȯ��','�ϰ����� �Ǹ� ��ȹ�� �����Ǿ����ϴ�.        ')
End If



/* �ְ��ǸŰ�ȹ Ȯ�� - ��ü Ȯ���� �������� ���� - D+5(��) ���� ���� */
Select Count(*) Into :ll_cnt
  from sm03_weekplan_item_sale
 where saupj = :ls_saupj
   and yymmdd = :ls_yymm
	and cnfirm is null   ;
	
If ll_cnt < 1 Then
	/* ������ Ȯ������ ���� - 2008.11.24 by shingoon */
//	insert into sm03_weekplan_item
//	(	saupj,         yymmdd,         gubun,         cvcod,         itnbr,         itm_prc,
//		 itm_qty1,      itm_qty2,       itm_qty3,      itm_qty4,      itm_qty5,      itm_qty6,
//		 itm_qty7,      cnfirm,         sangyn,        qty1,          qty2,          qty3,
//		 qty4,          qty5,           qty6,          qty7,          packqty,       janqty,
//		 jqty1,         jqty2,          jqty3,         jqty4,         jqty5,         jqty6,
//		 jqty7,         jaego,          so_weekqty,    gate,          plnt	)
//	select
//		saupj,         to_char(to_date(yymmdd,'yyyymmdd')+4,'yyyymmdd'),         gubun,         cvcod,         itnbr,         max(itm_prc),
//		 sum(itm_qty4), sum(itm_qty5),  sum(itm_qty6), sum(itm_qty7), sum(itm_qty8), sum(itm_qty9),
//		 sum(itm_qty10),max(cnfirm),    max(sangyn),   sum(qty4),     sum(qty5),     sum(qty6),
//		 sum(qty7),     sum(qty8),      sum(qty9),     sum(qty10),    max(packqty),  max(janqty),
//		 sum(jqty4),    sum(jqty5),     sum(jqty6),    sum(jqty7),    sum(jqty8),    sum(jqty9),
//		 sum(jqty10),   max(jaego),     max(so_weekqty),    plnt,     plnt
//	  from sm03_weekplan_item_sale
//	 where saupj = :ls_saupj and yymmdd = :ls_yymm
//	group by saupj,    yymmdd,         gubun,         cvcod,         itnbr, 		plnt ;

	// ���ǰ�ȹ Ȯ�� �� ���� ��ȹ ���ڴ� �⺻ + 5 ��
	// ID : ADMIN�� �� ���� �����ϸ�, �ʿ� ���� �ϼ��� �Է��Ͽ� ���� ��Ų��
	// by shjeon 20110728 to_char(to_date(yymmdd,'yyyymmdd')+5,'yyyymmdd') �� ������ ����
	ll_ilsu = Long(sle_confirm_ilsu.text)

	insert into sm03_weekplan_item
	(	saupj,         yymmdd,         gubun,         cvcod,         itnbr,         itm_prc,
		 itm_qty1,      itm_qty2,       itm_qty3,      itm_qty4,      itm_qty5,      itm_qty6,
		 itm_qty7,      cnfirm,         sangyn,        qty1,          qty2,          qty3,
		 qty4,          qty5,           qty6,          qty7,          packqty,       janqty,
		 jqty1,         jqty2,          jqty3,         jqty4,         jqty5,         jqty6,
		 jqty7,         jaego,          so_weekqty,    gate,          plnt	)
	select
		saupj,         to_char(to_date(yymmdd,'yyyymmdd')+:ll_ilsu,'yyyymmdd'),         gubun,         cvcod,         itnbr,         max(itm_prc),
		 sum(itm_qty5), sum(itm_qty6),  sum(itm_qty7), sum(itm_qty8), sum(itm_qty9), sum(itm_qty10),
		 sum(itm_qty11),max(cnfirm),    max(sangyn),   sum(qty5),     sum(qty6),     sum(qty7),
		 sum(qty8),     sum(qty9),      sum(qty10),     sum(qty11),    max(packqty),  max(janqty),
		 sum(jqty5),    sum(jqty6),     sum(jqty7),    sum(jqty8),    sum(jqty9),    sum(jqty10),
		 sum(jqty11),   max(jaego),     max(so_weekqty),    plnt,     plnt
	  from sm03_weekplan_item_sale
	 where saupj = :ls_saupj and yymmdd = :ls_yymm
	group by saupj,    yymmdd,         gubun,         cvcod,         itnbr, 		plnt ;
	If sqlca.sqlcode <> 0 Then
		MessageBox('Ȯ��',sqlca.sqlerrText)
		Rollback;
		MessageBox('Ȯ��','�������')
		Return
	Else
		Commit;
	End If
End If


wf_cnf_chk()
end event

event p_mod::ue_lbuttondown;//
end event

event p_mod::ue_lbuttonup;//
end event

type cb_exit from w_inherite`cb_exit within w_sm30_3020
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm30_3020
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm30_3020
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm30_3020
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm30_3020
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm30_3020
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm30_3020
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm30_3020
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm30_3020
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm30_3020
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm30_3020
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm30_3020
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm30_3020
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm30_3020
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm30_3020
integer x = 27
integer y = 24
integer width = 3506
integer height = 252
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm30_3020_1"
boolean border = false
end type

event itemchanged;String sDate, sNull, s_cvcod,get_nm, sSaupj, ls_itnbr_t, ls_itnbr_f, ls_value
Long   nCnt

ls_value = Trim(GetText())
SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
		
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('Ȯ ��','�ְ� �ǸŰ�ȹ�� �����Ϻ��� ���������մϴ�.!!')
			Return 1
			Return
		End If
		
		/* ����� üũ */
		sSaupj= Trim(GetItemString(1, 'saupj'))
		If IsNull(sSaupj) Or sSaupj = '' Then
			f_message_chk(1400, '[�����]')
			SetFocus()
			SetColumn('saupj')
			Return 1
		End If

		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			wf_cnf_chk()
			
		End If

	Case "tx_itnbr_f"
		ls_itnbr_t = Trim(This.GetItemString(row, 'tx_itnbr_t'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'tx_itnbr_t', ls_value)
	   end if
	Case "tx_itnbr_t"
		ls_itnbr_f = Trim(This.GetItemString(row, 'tx_itnbr_f'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'tx_itnbr_f', ls_value)
	   end if
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

type rr_1 from roundrectangle within w_sm30_3020
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

type hpb_1 from hprogressbar within w_sm30_3020
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

type pb_1 from u_pb_cal within w_sm30_3020
integer x = 2126
integer y = 68
integer width = 91
integer height = 80
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('sdate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'sdate', gs_code)

wf_cnf_chk()

end event

type pb_2 from u_pb_cal within w_sm30_3020
integer x = 3337
integer y = 68
integer width = 91
integer height = 80
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('confirm_dt')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'confirm_dt', gs_code)

end event

type dw_excel from datawindow within w_sm30_3020
boolean visible = false
integer x = 3552
integer y = 304
integer width = 686
integer height = 400
integer taborder = 160
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm30_3010_a_excel"
boolean border = false
boolean livescroll = true
end type

type p_excel from uo_picture within w_sm30_3020
integer x = 4270
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\������ȯ_up.gif"
end type

event clicked;call super::clicked;If this.Enabled Then wf_excel_down(dw_insert)

//String	ls_quota_no
//integer	li_rc
//string	ls_filepath, ls_filename
//boolean	lb_fileexist
//
//String ls_saupj , ls_factory , ls_ymd , ls_itnbr, ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
//String ls_empno
//Long i
//If dw_1.AcceptText() < 1 Then Return
//
//
//li_rc = GetFileSaveName("������ ���ϸ��� �����ϼ���." , ls_filepath , &
//											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
//IF li_rc = 1 THEN
//	IF lb_fileexist THEN
//		li_rc = MessageBox("��������" , ls_filepath + " ������ �̹� �����մϴ�.~r~n" + &
//												 "������ ������ ����ðڽ��ϱ�?" , Question! , YesNo! , 1)
//		IF li_rc = 2 THEN 
//			w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"			
//			RETURN
//		END IF
//	END IF
//	
//	Setpointer(HourGlass!)
//	
//	ls_saupj = Trim(dw_1.Object.saupj[1])
//	ls_ymd = Trim(dw_1.Object.sdate[1])
//	ls_factory = Trim(dw_1.Object.plant[1])
//	ls_empno = Trim(dw_1.Object.empno[1])
//	
//	If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
//	If ls_empno = '' Or isNull(ls_empno)  Then ls_empno = '%'
//	
//	ls_itnbr_from = trim(dw_1.getitemstring(1, 'tx_itnbr_f'))
//	ls_itnbr_to   = trim(dw_1.getitemstring(1, 'tx_itnbr_t'))
//	
//	IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
//	IF isNull(ls_itnbr_to) THEN ls_itnbr_to = '' 
//	
//	// ǰ�� ��ü�� �˻� �� ���� ITEMAS�� �ּ�, �ְ� ǰ���� ��ȸ�Ѵ�.	
//	IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
//		SELECT MIN(ITNBR), MAX(ITNBR) 
//		INTO   :ls_from, :ls_to
//		FROM   ITEMAS ;
//		
//		If sqlca.sqlcode <> 0 Then
//			MessageBox('����','ǰ�������͸� ��ȸ�� �� �����ϴ�.~n����ǿ� ���� �ٶ��ϴ�.')
//			Return -1
//		End If
//	ELSE
//		ls_from = ls_itnbr_from
//		ls_to = ls_itnbr_to
//	END IF 
//	
//	If IsNull(ls_ymd) Or ls_ymd = '' Then
//		f_message_chk(1400,'[��ȹ������]')
//		Return
//	End If
//	
//	/* ����� üũ */
//	ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
//	
//	If dw_excel.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_from, ls_to ,ls_empno) <= 0 Then
//		f_message_chk(50,'')
//		Return
//	End If
//	
// 	If dw_excel.SaveAsAscii(ls_filepath) <> 1 Then
//		w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"
//		return
//	End If
//
//END IF
//
//w_mdi_frame.sle_msg.text = "�ڷ�ٿ�Ϸ�!!!"
end event

type sle_confirm_ilsu from singlelineedit within w_sm30_3020
string tag = "Ȯ�� �� �����ȹ �ϼ� + 5"
boolean visible = false
integer x = 3589
integer y = 180
integer width = 151
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 134217857
string text = "5"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

