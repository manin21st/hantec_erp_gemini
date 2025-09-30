$PBExportHeader$w_silsa.srw
forward
global type w_silsa from w_inherite
end type
type cb_2 from commandbutton within w_silsa
end type
type em_1 from editmask within w_silsa
end type
type st_2 from statictext within w_silsa
end type
type dw_1 from datawindow within w_silsa
end type
type dw_2 from datawindow within w_silsa
end type
type cb_1 from commandbutton within w_silsa
end type
end forward

global type w_silsa from w_inherite
string title = "w_silsa"
cb_2 cb_2
em_1 em_1
st_2 st_2
dw_1 dw_1
dw_2 dw_2
cb_1 cb_1
end type
global w_silsa w_silsa

type variables
String is_depot,is_sicdat,is_frdat,is_todat,is_sts,is_jegogb,is_lotsno
Long   ii_siseq
end variables

forward prototypes
public subroutine wf_sijqty ()
end prototypes

public subroutine wf_sijqty ();Decimal dgap, dqty

Long   i
For i = 1 To dw_insert.RowCount()
		
	dgap = dw_insert.getitemdecimal(i, 'dgap')
	
	String siogbn
	if 	dgap <> 0 then 
		IF dgap > 0 then
			siogbn    = 'I14'
		ELSE	
			siogbn    = 'O08'
		END IF	
		
		if isnull(dw_insert.getitemstring(i, 'itmcyc_bigo')) or &
			trim(dw_insert.getitemstring(i, 'itmcyc_bigo')) = '' then
			dw_insert.setitem(i, 'itmcyc_bigo', '���డ�� ���ǻ�')
		end if
		dw_insert.setitem(i, 'itmcyc_crtgub', 'Y')
		dw_insert.setitem(i, 'itmcyc_scheck', 'Y')
		dw_insert.setitem(i, 'itmcyc_iogbn', siogbn)
	end if
	
Next
end subroutine

on w_silsa.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.em_1=create em_1
this.st_2=create st_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.cb_1
end on

on w_silsa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.em_1)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_1)
end on

type dw_insert from w_inherite`dw_insert within w_silsa
integer x = 37
integer y = 176
integer width = 4576
integer height = 2080
string dataobject = "d_silsa_001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_silsa
boolean visible = false
integer x = 2373
end type

type p_addrow from w_inherite`p_addrow within w_silsa
boolean visible = false
integer x = 2199
end type

event p_addrow::clicked;call super::clicked;
Int    	il_currow,il_RowCount, d_siseq
string	ls_depot, ls_sicdat, ls_frdat, ls_todat, ls_sts, ls_jegogb

IF 	dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow 		= dw_insert.GetRow()
	il_RowCount 	= dw_insert.RowCount()
	
	IF 	il_currow <=0 THEN
		il_currow = il_rowCount
	END IF
END IF

il_currow 	= il_rowCount + 1

//ls_depot	 = dw_1.GetItemString(1,"depot") //â��
//ls_sicdat = dw_1.GetItemString(1,"cr_date") //�ǻ������
//d_siseq	 = dw_1.GetItemNumber(1,"seq") //�ǻ�����
//ls_frdat  = dw_1.GetItemString(1,"fr_date") //�ǻ�Ⱓ
//ls_todat  = dw_1.GetItemString(1,"to_date") //�ǻ�Ⱓ
//ls_sts    = dw_1.GetItemString(1,"cycsts") //����
//ls_jegogb = dw_1.GetItemString(1,"jego_gub") //�����

dw_insert.InsertRow(il_currow)

dw_insert.SetItem(il_currow, "itmcyc_sabu", gs_sabu)
dw_insert.SetItem(il_currow, "itmcyc_depot", is_depot)
dw_insert.SetItem(il_currow, "itmcyc_sicdat", is_sicdat)
dw_insert.SetItem(il_currow, "itmcyc_siseq", ii_siseq) 
dw_insert.SetItem(il_currow, "itmcyc_sisdat", is_frdat)
dw_insert.SetItem(il_currow, "itmcyc_siedat", is_todat)
dw_insert.SetItem(il_currow, "itmcyc_cycsts", is_sts)
dw_insert.SetItem(il_currow, "itmcyc_jego_gub", is_jegogb)
dw_insert.SetItem(il_currow, "itmcyc_pspec" , '.')
dw_insert.SetItem(il_currow, "itmcyc_lotsno" , is_lotsno)
dw_insert.SetItem(il_currow, "itmcyc_cujqty" , 0)
dw_insert.SetItem(il_currow, "jego", 0)
dw_insert.SetItem(il_currow, "itmcyc_sijqty", 0)
dw_insert.SetItem(il_currow, "dgap"  , 0)

dw_insert.SetItem(il_currow, "chk", 'N')
dw_INSERT.ScrollToRow (il_currow)
dw_insert.SetColumn("itmcyc_itnbr")
dw_insert.SetFocus()

dw_insert.Modify("DataWindow.HorizontalScrollPosition = '0'")


end event

type p_search from w_inherite`p_search within w_silsa
integer x = 3685
string picturename = "C:\erpman\image\�ǻ�Ϸ�_up.gif"
end type

event p_search::clicked;call super::clicked;String  s_date, s_depot, s_crdate, get_status, s_cycsts, sjpno
long    lrtnvalue
Integer iMaxOrderNo, iseq

s_date = em_1.Text

SELECT REPLACE(:s_date, '.', '')
  INTO :s_date
  FROM DUAL;

IF Messagebox('Ȯ ��','�Ϸ� ó�� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) <> 1 THEN RETURN 

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "��ǥ ä�� �� ........."

dw_1.Retrieve()

Long   i
For i = 1 To dw_1.RowCount()
	s_cycsts = dw_1.GetItemString(i, 'cycsts')
	s_depot  = dw_1.GetItemString(i, 'depot')
	s_crdate = trim(dw_1.GetItemString(i, 'sicdat'))
//	s_date   = trim(dw_1.GetItemString(1, 'wan_date'))
	iseq     = dw_1.GetItemNumber(i, 'siseq')
	
	if s_cycsts <> '1' then 
//		ROLLBACK;
		messagebox("Ȯ��", "�ǻ�Ϸ�ó���� �� �� ���� �ڷ��Դϴ�.")
		return 
	end if	
	
	if isnull(s_depot) or s_depot = "" then
//		ROLLBACK;
		f_message_chk(30,'[â��]')
//		dw_1.SetColumn('depot')
//		dw_1.SetFocus()
		return
	end if	
	
	if isnull(s_crdate) or s_crdate = "" then
//		ROLLBACK;
		f_message_chk(30,'[��������]')
//		dw_1.SetColumn('cr_date')
//		dw_1.SetFocus()
		return
	end if	
	
	if isnull(iseq) or iseq = 0 then
//		ROLLBACK;
		f_message_chk(30,'[����]')
//		dw_1.SetColumn('seq')
//		dw_1.SetFocus()
		return
	end if	
	
	if isnull(s_date) or s_date = "" then
//		ROLLBACK;
		f_message_chk(30,'[�Ϸ�����]')
//		dw_1.SetColumn('wan_date')
//		dw_1.SetFocus()
		return
	end if		
	
	iMaxOrderNo = sqlca.fun_junpyo(gs_sabu, s_Date, 'C0')
	IF iMaxOrderNo <= 0 THEN
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(51,'')
		ROLLBACK;
	END IF
	
	sjpno = s_Date + String(iMaxOrderNo,'0000')
	
	Commit;
	
	w_mdi_frame.sle_msg.text = "�ǻ� ���̿� ���� ��ǥ ���� �� ........."
	
	lRtnValue = sqlca.erp000000210(gs_sabu, s_depot, s_crdate, iseq, s_date, sjpno )
	
	IF lRtnValue = -1 THEN	
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(89,'[��ǥ���� ����]')
		Return
	ELSEIF lRtnValue = -3 THEN	
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(32,'[�Ϸ�ó�� ����]')
		Return
	ELSEIF lRtnValue = -9 THEN	
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(89,'[�۾� ����]')
		Return
	ELSEIF lRtnValue = -6 THEN	
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(89,'[���� ����]')
		Return
	ElseIf lRtnValue = -111 Then
		ROLLBACK;
		MessageBox('-111', '-111')
		Return
	END IF
	
	commit;
	if lrtnvalue = 0 then 	
		w_mdi_frame.sle_msg.text = "�ֱ� �ǻ� �ڷ� �Ϸ� ó���Ǿ����ϴ�."
//		messagebox("�Ϸ�Ȯ��", "�ֱ�ǻ� �Ϸ� ó�� �Ǿ����ϴ�.")
	elseif lrtnvalue = 1 then 
		w_mdi_frame.sle_msg.text = "�ֱ� �ǻ� �ڷ� �Ϸ� ó���Ǿ����ϴ�. (" + &
							string(lRtnValue) + '�ǿ� ��ǥ�� ����ó��)'
//		messagebox("�Ϸ�Ȯ��", sjpno + '001' + " ��ǥ ����")
	elseif lrtnvalue > 1 then 
		w_mdi_frame.sle_msg.text = "�ֱ� �ǻ� �ڷ� �Ϸ� ó���Ǿ����ϴ�. (" + &
							string(lRtnValue) + '�ǿ� ��ǥ�� ����ó��)'
//		messagebox("�Ϸ�Ȯ��", sjpno + '-001 ����' + sjpno + '-' + string(lRtnValue, '000') + " ���� ��ǥ ����")
	end if
Next

//Commit;
	
SetPointer(Arrow!)
//p_can.TriggerEvent(Clicked!)
end event

event p_search::ue_lbuttondown;//
//C:\erpman\image\�ǻ�Ϸ�_dn.gif
PictureName = "C:\erpman\image\�ǻ�Ϸ�_dn.gif"
end event

event p_search::ue_lbuttonup;//
//C:\erpman\image\�ǻ�Ϸ�_up.gif
PictureName = "C:\erpman\image\�ǻ�Ϸ�_up.gif"
end event

type p_ins from w_inherite`p_ins within w_silsa
boolean visible = false
integer x = 2775
integer y = 16
end type

type p_exit from w_inherite`p_exit within w_silsa
integer x = 4393
end type

type p_can from w_inherite`p_can within w_silsa
integer x = 4219
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()

end event

type p_print from w_inherite`p_print within w_silsa
integer x = 3863
string picturename = "C:\erpman\image\�Ϸ����_up.gif"
end type

event p_print::ue_lbuttondown;//
//C:\erpman\image\�Ϸ����_dn.gif
PictureName = "C:\erpman\image\�Ϸ����_dn.gif"
end event

event p_print::ue_lbuttonup;//
//C:\erpman\image\�Ϸ����_up.gif
PictureName = "C:\erpman\image\�Ϸ����_up.gif"
end event

event p_print::clicked;call super::clicked;String  s_date, s_depot, s_crdate, s_cycsts
int     iseq, lRtnValue	
	
IF Messagebox('Ȯ ��','��� ó�� �Ͻðڽ��ϱ�?',Question!,YesNo!,1) <> 1 THEN RETURN 

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "�ֱ� �ǻ� �Ϸ� ��� ó�� �� ........."

String ls_wan
ls_wan = em_1.Text
SELECT REPLACE(:ls_wan, '.', '')
  INTO :ls_wan
  FROM DUAL ;
  
dw_2.Retrieve(ls_wan)

Long    i
For i = 1 To dw_2.RowCount()
	
	s_cycsts = dw_2.GetItemString(i, 'cycsts')
	s_depot  = dw_2.GetItemString(i, 'depot')
	s_crdate = trim(dw_2.GetItemString(i, 'sicdat'))
	s_date = trim(dw_2.GetItemString(i, 'wandat'))
	iseq     = dw_2.GetItemNumber(i, 'siseq')
	
	if s_cycsts <> '2' then 
//		ROLLBACK;
		messagebox("Ȯ��", "�Ϸ���� ó���� �� �� ���� �ڷ��Դϴ�.")
		return 
	end if	
	
	if isnull(s_depot) or s_depot = "" then
//		ROLLBACK;
		f_message_chk(30,'[â��]')
//		dw_1.SetColumn('depot')
//		dw_1.SetFocus()
		return
	end if	
	
	if isnull(s_crdate) or s_crdate = "" then
//		ROLLBACK;
		f_message_chk(30,'[��������]')
//		dw_1.SetColumn('cr_date')
//		dw_1.SetFocus()
		return
	end if	
	
	if isnull(s_date) or s_date = "" then
//		ROLLBACK;
		f_message_chk(30,'[�Ϸ�����]')
//		dw_1.SetColumn('wan_date')
//		dw_1.SetFocus()
		return
	end if
	
	lRtnValue = sqlca.erp000000210_1(gs_sabu, s_depot, s_crdate, iseq)
	
	IF lRtnValue < 0 THEN	
		ROLLBACK;
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(32,'[�Ϸ� ��ҽ���] ' + string(lRtnValue) )
		Return
	Else
		commit;
		w_mdi_frame.sle_msg.text = "�ֱ� �ǻ� �ڷ� �Ϸ���� ó���Ǿ����ϴ�."
	end if	
Next
		
SetPointer(Arrow!)
//p_can.TriggerEvent(Clicked!)

end event

type p_inq from w_inherite`p_inq within w_silsa
integer x = 3506
end type

event p_inq::clicked;call super::clicked;dw_insert.SetRedraw(False)
dw_insert.Retrieve()
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_silsa
boolean visible = false
integer x = 2958
integer y = 20
end type

type p_mod from w_inherite`p_mod within w_silsa
integer x = 4041
end type

event p_mod::clicked;call super::clicked;If f_msg_update() <> 1 Then Return

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('����', '���� ����')
	Return
End If

MessageBox('����', '���� �Ϸ�')
end event

type cb_exit from w_inherite`cb_exit within w_silsa
end type

type cb_mod from w_inherite`cb_mod within w_silsa
end type

type cb_ins from w_inherite`cb_ins within w_silsa
end type

type cb_del from w_inherite`cb_del within w_silsa
end type

type cb_inq from w_inherite`cb_inq within w_silsa
end type

type cb_print from w_inherite`cb_print within w_silsa
end type

type st_1 from w_inherite`st_1 within w_silsa
end type

type cb_can from w_inherite`cb_can within w_silsa
end type

type cb_search from w_inherite`cb_search within w_silsa
end type







type gb_button1 from w_inherite`gb_button1 within w_silsa
end type

type gb_button2 from w_inherite`gb_button2 within w_silsa
end type

type cb_2 from commandbutton within w_silsa
integer x = 3168
integer y = 48
integer width = 311
integer height = 104
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "UPLOAD"
end type

event clicked;Long		lXlrow, lValue, lCnt, lQty[], lTotal, lRow
String		sDocname, sNamed, sPspec, sdepot, slotsno
String		sWcdsc,  sItemnum, sItemname, sIspec, sOpdsc, sKumno, sQty, sTotal, sayu		// ȣ��-ǰ��-ǰ��-����-����-����...
uo_xlobject 		uo_xl
Integer 	i, j, k, iNotNullCnt
Decimal{3} dQty
string s_depot, s_crdate
int    iseq

//if dw_1.AcceptText() = -1 then return 
//if dw_insert.rowcount() <= 0 then
//	messagebox('Ȯ��','�ڷḦ ��ȸ�� �� ó���Ͻʽÿ�!!!')
//	return
//end if

//s_depot   = trim(dw_1.GetItemString(1,'depot'))
//s_crdate  = trim(dw_1.GetItemString(1,'cr_date'))
//iseq      = dw_1.GetItemNumber(1,'seq')

//if isnull(s_depot) or s_depot = "" then
//	f_message_chk(30,'[â��]')
//	dw_1.SetColumn('depot')
//	dw_1.SetFocus()
//	return
//end if	
//
//if isnull(s_crdate) or s_crdate = "" then
//	f_message_chk(30,'[��������]')
//	dw_1.SetColumn('cr_date')
//	dw_1.SetFocus()
//	return
//end if	
//
//if isnull(iseq) or iseq = 0 then
//	f_message_chk(30,'[����]')
//	dw_1.SetColumn('seq')
//	dw_1.SetFocus()
//	return
//end if	
//
//// ��ü ����ڷ� ��ȸ�� ó��
//select count(*) into :lCnt from itmcyc
// where sabu = :gs_sabu and depot = :s_depot and sicdat = :s_crdate and siseq = :iseq
//   and itnbr >= '.' and itnbr <= 'ZZZZZZZZZZZZZZZZZZZZ' ;
//
//if dw_insert.rowcount() <> lCnt then
//	messagebox('Ȯ��','��ü �ڷḦ ��ȸ�� �� ó���Ͻʽÿ�!!!')
//	return
//end if

// �׼� IMPORT ***************************************************************

lValue = GetFileOpenName("���ǻ� ��������", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS,")
If lValue <> 1 Then Return -1

Setpointer(Hourglass!)

//���� < 0 �̸� Reset --------------------------------------------------------------------------------//
For i = 1 To dw_insert.RowCount()
	If dw_insert.GetItemNumber(i, 'itmcyc_sijqty') < 0 Then
		dw_insert.SetItem(i, 'itmcyc_sijqty', 0)
	End If
Next	

////===========================================================================================
////UserObject ����
w_mdi_frame.sle_msg.text = "�׼� ���ε� �غ���..."
uo_xl = create uo_xlobject

//������ ����
uo_xl.uf_excel_connect(sDocname, false , 3)
uo_xl.uf_selectsheet(1)

//Data ���� Row Setting (��)
// Excel ���� A: 1 , B :2 �� ���� 

lXlrow = 2		// ù��带 �����ϰ� �ι�°����� ����
lCnt = 0 

String ls_sic
ls_sic = em_1.Text
SELECT REPLACE(:ls_sic, '.', '')
  INTO :ls_sic
  FROM DUAL ;
  
//dw_insert.SetRedraw(False)

Long    ll_ins
Do While(True)
	
	// ����� ID(A,1)
	// Data�� ���� ��� �ش��ϴ� �������� �����ؾ߸� ���ڰ� ������ ����....������ �𸣰���....
	// �� 36�� ���� ����
	For i =1 To 15
		uo_xl.uf_set_format(lXlrow,i, '@' + space(50))
	Next
	
	iNotNullCnt = 0		// ǰ������ NULL �̸� ����Ʈ ����
	
	sdepot   = trim(uo_xl.uf_gettext(lXlrow,2))              // â��
	sItemnum = trim(uo_xl.uf_gettext(lXlrow,3))					// ǰ��
	slotsno  = trim(uo_xl.uf_gettext(lXlrow,12))             // ����
	
	if sItemnum > '.' then 
		iNotNullCnt++

		select itdsc, ispec into :sItemname, :sIspec from itemas where itnbr = :sItemnum ;
		if sqlca.sqlcode <> 0 then
			messagebox('Ȯ��',sItemnum+' �� ��ϵ��� ���� ǰ���Դϴ�!!!')
			return
		end if
		
		w_mdi_frame.sle_msg.text = "�׼� ���ε� ������ ("+String(lCnt)+") ..."+sItemnum+"  "+sItemname

		sPspec = trim(uo_xl.uf_gettext(lXlrow,6))					// ���걸��
		if isnull(sPspec) or trim(sPspec) = '' then sPspec = '.'
		
		sQty = trim(uo_xl.uf_gettext(lXlrow,9))						// �ǻ����
		if not IsNumber(sQty) then
			messagebox('Ȯ��','�ٿ�ε� ����� �����Ǿ� ���ε尡 �Ұ����մϴ�!!!')
			return
		end if
		
		dQty = Dec(sQty)
		
		sayu = trim(uo_xl.uf_gettext(lXlrow,13))					// ����
		
		lRow = dw_insert.Find("itmcyc_depot='"+sdepot+"' and itmcyc_itnbr='"+sItemnum+"' and itmcyc_pspec='"+sPspec+"' and itmcyc_lotsno='"+slotsno+"'",1,dw_insert.RowCount())
		if lRow <= 0 then
			If dQty > 0 Then
				dw_insert.SetRow(dw_insert.rowcount())
				
				SELECT SISEQ
				  INTO :ii_siseq
				  FROM ITMCYC
				 WHERE DEPOT = :sdepot AND SICDAT = :ls_sic AND LOTSNO = :slotsno AND WANDAT IS NULL ;
				
				is_depot	 = sdepot //â��
				is_sicdat = ls_sic //�ǻ������
				ii_siseq	 = ii_siseq //�ǻ�����
				is_frdat  = ls_sic //�ǻ�Ⱓ
				is_todat  = ls_sic //�ǻ�Ⱓ
				is_sts    = '1' //����
				is_jegogb = '2' //�����
				is_lotsno = slotsno
				
				p_addrow.triggerevent(clicked!)
				lRow = dw_insert.rowcount()
				dw_insert.object.itmcyc_itnbr[lRow] = sItemnum 
				dw_insert.object.itemas_itdsc[lRow] = sItemname
				dw_insert.object.itemas_ispec[lRow] = sIspec
				dw_insert.object.itmcyc_pspec[lRow] = sPspec
			Else
				lRow = 0
			End If
		end if
		
		If lRow > 0 Then
			dw_insert.object.itmcyc_sijqty[lRow] = dQty
			dw_insert.object.itmcyc_bigo[lRow] = sayu
			dw_insert.Scrolltorow(lRow)	
			
			dw_insert.triggerevent(itemchanged!)
		End If
		
		lCnt++
	end if
	
	// �ش� ���� � ������ ���� �������� �ʾҴٸ� ���� ������ �ν��ؼ� ����Ʈ ����
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop

//dw_insert.SetRedraw(True)

uo_xl.uf_excel_Disconnect()


//// ���� IMPORT  END ***************************************************************
dw_insert.AcceptText()

wf_sijqty()
//dw_insert.Sort()

MessageBox('Ȯ��',String(lCnt)+' ���� ��� DATA IMPORT �� �Ϸ��Ͽ����ϴ�.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl
end event

type em_1 from editmask within w_silsa
integer x = 443
integer y = 48
integer width = 402
integer height = 84
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "####.##.##"
end type

type st_2 from statictext within w_silsa
integer x = 197
integer y = 64
integer width = 242
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�ǻ�Ϸ�"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_silsa
boolean visible = false
integer x = 187
integer y = 912
integer width = 1865
integer height = 1208
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_silsa_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_2 from datawindow within w_silsa
boolean visible = false
integer x = 2263
integer y = 1056
integer width = 686
integer height = 400
integer taborder = 140
boolean bringtotop = true
string title = "none"
string dataobject = "d_silsa_003"
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_1 from commandbutton within w_silsa
integer x = 1353
integer y = 60
integer width = 402
integer height = 84
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "none"
end type

event clicked;dw_insert.SetFilter("if ( isnull(itmcyc_bigo), '.', itmcyc_bigo) <> '������ ���� �����'")
dw_insert.Filter()
end event

