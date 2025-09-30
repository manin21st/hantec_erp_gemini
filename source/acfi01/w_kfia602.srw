$PBExportHeader$w_kfia602.srw
$PBExportComments$�������,�������к� �����ѵ� ���
forward
global type w_kfia602 from w_inherite
end type
type dw_ip from datawindow within w_kfia602
end type
type dw_list from datawindow within w_kfia602
end type
type gb_2 from groupbox within w_kfia602
end type
type cb_1 from commandbutton within w_kfia602
end type
type rr_1 from roundrectangle within w_kfia602
end type
end forward

global type w_kfia602 from w_inherite
string title = "�������,�������к� �����ѵ� ���"
dw_ip dw_ip
dw_list dw_list
gb_2 gb_2
cb_1 cb_1
rr_1 rr_1
end type
global w_kfia602 w_kfia602

forward prototypes
public subroutine wf_init ()
public function integer wf_requiredchk ()
public subroutine wf_setting_retrievemode (string mode)
public subroutine wf_change_flag ()
end prototypes

public subroutine wf_init ();dw_ip.SetRedraw(false)
dw_list.SetRedraw(false)

dw_ip.reset()
dw_list.reset()

dw_ip.insertrow(0)

dw_ip.SetRedraw(true)
dw_list.SetRedraw(true)


end subroutine

public function integer wf_requiredchk ();String sBnkCd, sSaupNo, sLimSdate, sLimEdate, sGetCode, sGetName
Double dLimAmt

IF dw_ip.AcceptText() = -1 THEN return -1

sBnkCd = trim(dw_ip.GetItemString(1, 'bnk_cd'))
sSaupNo = trim(dw_ip.GetItemString(1, 'saup_no'))
dLimAmt = dw_ip.GetItemNumber(1, 'lim_amt')
sLimSdate = trim(dw_ip.GetItemString(1, 'lim_sdate'))
sLimEdate = trim(dw_ip.GetItemString(1, 'lim_edate'))

// ������� �ڵ�
IF trim(sBnkCd) = '' OR isnull(sBnkCd) THEN 
	F_MessageChk(1, "[�������]")
	Return -1
ELSE
	SELECT person_cd, person_nm
	 INTO :sGetCode, :sGetName
	FROM kfz04om0_v2
	WHERE person_cd = :sBnkCd ; 

	IF sqlca.sqlcode <> 0 THEN
		MessageBox("Ȯ ��", "������� �ڵ带 Ȯ���Ͻʽÿ�.!!")
      dw_ip.SetColumn('bnk_cd')
      Return -1
	 END IF
END IF

// ��������
IF trim(sSaupNo) = '' OR Isnull(sSaupNo) THEN
	F_MessageChk(1, "[��������]")
	Return -1
END if

// �ѵ� �����ݾ�
IF isnull(dLimAmt) OR dLimAmt <= 0 THEN
	MessageBox("Ȯ ��", "[�ѵ������ݾ�]�� ~'0~' �̻��̾�� �մϴ�.!!")
	Return -1
END IF

// �ѵ������� 
IF sLimSdate = '' OR isnull(sLimSdate) THEN
	
ELSE
	IF f_datechk(sLimSdate) = -1 THEN 
		f_Messagechk(21, "[�ѵ�������]")
		Return -1
	END IF
END IF

// �ѵ�������
IF sLimEdate = '' OR isnull(sLimEdate) THEN
	
ELSE
	IF f_datechk(sLimEdate) = -1 THEN 
		f_Messagechk(21, "[�ѵ�������]")
		Return -1
	END IF
END IF

Return 1
end function

public subroutine wf_setting_retrievemode (string mode);
dw_ip.SetRedraw(False)
p_addrow.Enabled =True
p_mod.Enabled = True

IF mode ="M" THEN	
	dw_ip.SetTabOrder("bnk_cd",0)
	dw_ip.SetTabOrder("saup_no",0)
	dw_ip.SetColumn("lim_amt")
	p_del.Enabled = True
ELSE	
	dw_ip.SetTabOrder("bnk_cd", 10)
	dw_ip.SetTabOrder("saup_no",11)
	dw_ip.SetColumn("bnk_cd")
	p_del.Enabled = false
END IF
dw_ip.SetFocus()
dw_ip.SetRedraw(True)
end subroutine

public subroutine wf_change_flag ();long k, ll_Count

ll_Count = dw_list.RowCount()

FOR k = 1 TO ll_Count
	dw_list.SetItem(k,"flag",'0')
NEXT
end subroutine

on w_kfia602.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.gb_2=create gb_2
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_kfia602.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_ip.reset()
dw_list.reset()

dw_ip.insertrow(0)

p_del.enabled = false
end event

type dw_insert from w_inherite`dw_insert within w_kfia602
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia602
integer x = 3689
integer taborder = 50
end type

event p_delrow::clicked;call super::clicked;Integer iCurrow

w_mdi_frame.sle_msg.text =""

iCurrow = dw_list.GetRow()
IF iCurrow <=0 Then Return

dw_list.DeleteRow(iCurrow)

IF iCurrow = 1 OR iCurrow <= dw_list.RowCount() THEN
	dw_list.ScrollToRow(iCurrow - 1)
	dw_list.SetColumn('bal_date')				
	dw_list.SetFocus()		
END IF
end event

type p_addrow from w_inherite`p_addrow within w_kfia602
integer x = 3515
integer taborder = 40
end type

event p_addrow::clicked;call super::clicked;String sBnkCd,sSaupNo
Int iCurrow

IF dw_ip.AcceptText() = -1 THEN Return

sBnkCd = trim(dw_ip.GetItemString(1, 'bnk_cd'))
sSaupNo = trim(dw_ip.GetItemString(1, 'saup_no'))

IF sBnkCd = "" OR Isnull(sBnkCd) THEN
	MessageBox("Ȯ ��", "[�������]�� �ʼ��Է��׸��Դϴ�.!!")
	Return
END IF

IF sSaupNo = "" OR Isnull(sSaupNo) THEN
	MessageBox("Ȯ ��", "[��������]�� �ʼ��Է��׸��Դϴ�.!!")
	Return
END IF

IF dw_list.RowCount() <= 0 THEN
	iCurrow = 0
ELSE
	iCurrow = dw_list.GetRow() 
END IF

iCurrow = iCurrow + 1  

dw_list.InsertRow(iCurrow)
dw_list.Setitem(iCurrow, "bnk_cd", sBnkCd) 	
dw_list.Setitem(iCurrow, "flag", "1")
dw_list.ScrollToRow(iCurrow)
dw_list.selectrow(0, False)

dw_list.setcolumn('bal_date')
dw_list.SetFocus()

w_mdi_frame.sle_msg.text = "���ο� �ڷḦ �Է��Ͻʽÿ�!!"
end event

type p_search from w_inherite`p_search within w_kfia602
boolean visible = false
integer x = 3237
integer y = 3188
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia602
boolean visible = false
integer x = 3758
integer y = 3188
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfia602
integer x = 4416
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_kfia602
integer x = 4242
integer taborder = 80
end type

event p_can::clicked;call super::clicked;Rollback;

wf_init()

ib_any_typing = False
smodstatus = 'I'

WF_SETTING_RETRIEVEMODE(smodstatus)
end event

type p_print from w_inherite`p_print within w_kfia602
boolean visible = false
integer x = 3410
integer y = 3188
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia602
integer x = 3342
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sBnkCd, sGetCode, sGetName, sNull, sSaupNo
Long lRow, lRtvRow

SetNull(sNull)

IF dw_ip.AcceptText() = -1 THEN Return 

lRow = dw_ip.GetRow()

IF lRow <= 0 THEN Return 

sBnkCd = dw_ip.GetItemString(1, 'bnk_cd')
sSaupNo = dw_ip.GetItemString(1, 'saup_no')

IF trim(sBnkCd) = '' OR isNull(sBnkCd) THEN 
	F_MessageChk(1, "[�������]")
	dw_ip.SetColumn("bnk_cd")
	dw_ip.SetFocus()
	Return 
ELSE
	SELECT person_cd, person_nm
	 INTO :sGetCode, :sGetName
	FROM kfz04om0_v2
	WHERE person_cd = :sBnkCd ; 
	
	IF sqlca.sqlcode <> 0 THEN
		MessageBox("Ȯ ��", "������� �ڵ带 Ȯ���Ͻʽÿ�.!!")
		dw_ip.SetItem(lRow, 'bnk_cd', sNull)
		dw_ip.SetItem(lRow, 'kfz04om0_v2_person_nm', sNull)		 
		Return 
	ELSE
		dw_ip.SetItem(lRow, 'kfz04om0_v2_person_nm', sGetName)		 			
	END IF
END IF

IF trim(sSaupNo) = '' OR isnull(sSaupNo) THEN
	F_MessageChk(1, "[��������]")
	dw_ip.SetColumn("saup_no")
	dw_ip.SetFocus()
	Return
END IF

lRtvRow = dw_list.retrieve(sBnkCd,sSaupNo)

dw_list.SetRedraw(false)
IF lRtvRow < 1 THEN 
	f_MessageChk(14, "")
	dw_list.reset()
   dw_list.SetRedraw(true)	
	Return 
END IF
dw_list.SetRedraw(true)	
dw_list.SetFocus()
end event

type p_del from w_inherite`p_del within w_kfia602
integer x = 4069
integer taborder = 70
end type

event p_del::clicked;call super::clicked;Long lRowCnt, i

IF dw_ip.AcceptText() = -1 THEN Return 
IF dw_list.AcceptText() = -1 THEN Return 

IF f_dbConFirm('����') = 2 THEN RETURN

dw_ip.SetRedraw(false)

lRowCnt = dw_list.RowCount()

IF lRowCnt > 0 THEN
   FOR i = lRowCnt TO 1 STEP -1 
		dw_list.deleterow(i)
   NEXT
END IF

dw_ip.deleterow(0)

IF lRowCnt > 0 THEN
	IF dw_list.Update() = 1 THEN 
		Commit;
	ELSE
	   Rollback;
   	w_mdi_frame.sle_msg.text = " �ڷḦ ���� ���� ������ �߻��Ͽ����ϴ�.!!"		
      dw_ip.SetRedraw(true)				
		Return 
	END IF
END IF

IF dw_ip.Update() = 1 THEN 
	Commit;
	w_mdi_frame.sle_msg.text = " �ڷḦ �����Ͽ����ϴ�.!!"
ELSE
	Rollback;
	w_mdi_frame.sle_msg.text = " �ڷḦ ���� ���� ������ �߻��Ͽ����ϴ�.!!"	
	dw_ip.SetRedraw(true)
	Return 
END IF

wf_init()

dw_ip.SetRedraw(true)

smodstatus = 'I'

WF_SETTING_RETRIEVEMODE(smodstatus)

ib_any_typing =False
p_del.enabled = false
end event

type p_mod from w_inherite`p_mod within w_kfia602
integer x = 3895
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;Long   lRowCnt, i
Double dPamt, dMamt, dTmpPamt, dTmpMamt, dAmt

IF dw_ip.AcceptText() = -1 THEN Return 
IF dw_list.AcceptText() = -1 THEN Return 

IF dw_ip.GetRow() < 1 THEN Return 

IF wf_requiredchk() = -1 THEN Return 

IF f_dbConFirm('����') = 2 THEN Return

lRowCnt = dw_list.RowCount()

dAmt = dw_ip.GetItemNumber(1, 'lim_amt')


IF lRowCnt > 0 THEN
	FOR i = 1 TO lRowCnt
		dPamt = dw_list.GetItemNumber(i, 'pamt')
		dMamt = dw_list.GetItemNumber(i, 'mamt')	
		
	   IF Isnull(dPamt) THEN dPamt = 0
	   IF Isnull(dMamt) THEN dMamt = 0
		
		dTmpPamt = dTmpPamt + dPamt
		dTmpMamt = dTmpMamt + dMamt		
		
	NEXT
END IF
	
dw_ip.SetItem(1, 'lim_camt', dAmt + dTmpPamt - dTmpMamt)

IF dw_ip.Update() = 1 THEN 
	Commit;
   smodstatus = 'M'		                    // I : ���, M : ����
   WF_SETTING_RETRIEVEMODE(smodstatus)      // ���� ���
	w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�.!!" 
ELSE 
	Rollback;
	w_mdi_frame.sle_msg.text = "�ڷ� ���� ���� ������ �߻��Ͽ����ϴ�."
	Return 
END IF

IF lRowCnt > 0 THEN 
	IF dw_list.Update() = 1 THEN 
	   Commit;
    	w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�.!!" 		
      Wf_Change_Flag()
	ELSE
		Rollback;
    	w_mdi_frame.sle_msg.text = "�ڷ� ���� ���� ������ �߻��Ͽ����ϴ�."		
		Return 
	END IF
END IF

ib_any_typing = False

p_del.enabled = true

p_inq.PostEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_kfia602
boolean visible = false
integer x = 3648
integer y = 2764
end type

type cb_mod from w_inherite`cb_mod within w_kfia602
boolean visible = false
integer x = 2592
integer y = 2764
end type

type cb_ins from w_inherite`cb_ins within w_kfia602
boolean visible = false
integer x = 3150
integer y = 2960
integer width = 375
string text = "���߰�(&I)"
end type

type cb_del from w_inherite`cb_del within w_kfia602
boolean visible = false
integer x = 2944
integer y = 2764
end type

type cb_inq from w_inherite`cb_inq within w_kfia602
boolean visible = false
integer x = 2798
integer y = 2960
end type

type cb_print from w_inherite`cb_print within w_kfia602
boolean visible = false
integer x = 2299
integer y = 2796
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfia602
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfia602
boolean visible = false
integer x = 3296
integer y = 2764
end type

type cb_search from w_inherite`cb_search within w_kfia602
boolean visible = false
integer x = 1458
integer y = 2792
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia602
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfia602
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfia602
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia602
boolean visible = false
integer x = 64
integer y = 1868
integer width = 1202
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia602
boolean visible = false
integer x = 2135
integer y = 1868
integer width = 1454
integer height = 196
end type

type dw_ip from datawindow within w_kfia602
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer width = 3200
integer height = 416
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfia602_01"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9, 0)
return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event rbuttondown;this.accepttext()

SetNUll(lstr_custom.code)
SetNUll(lstr_custom.name)

IF this.GetColumnName() = 'bnk_cd' THEN
	
	lstr_custom.code = this.GetItemString(this.GetRow(),"bnk_cd")
	
	OpenWithParm(w_kfz04om0_popup, '2')
	
   this.SetItem(1, 'bnk_cd', lstr_custom.code)
   this.SetItem(1, 'kfz04om0_v2_person_nm', lstr_custom.name)

END IF
end event

event itemchanged;string sBnkCd, sNull, sGetCode, sGetName, sLimSdate, sLimEdate, sSaupNo, sSql
long   lRetreve
double dLimAmt

SetNull(sNull)

IF this.GetColumnName() = 'bnk_cd' THEN 
	
   sBnkCd = this.GetText()
	
	IF trim(sBnkCd) = '' or isNull(sBnkCd) THEN Return

	SELECT person_cd, person_nm
		INTO :sGetCode, :sGetName
		FROM kfz04om0_v2
		WHERE person_cd = :sBnkCd ; 
	
	IF sqlca.sqlcode <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		Return 1
	ELSE
		this.SetItem(this.GetRow(), 'kfz04om0_v2_person_nm', sGetName)		 			
	 END IF
	
END IF

IF this.GetColumnName() ="saup_no" THEN
	sSaupNo = this.GetText()
	
	IF sSaupNo = '' or IsNull(sSaupNo) THEN Return

	IF sSaupNo <> "1" AND sSaupNo <> "2" AND sSaupNo <> "3" THEN
		f_messagechk(20,"��������")
		this.setitem(this.GetRow(), "saup_no", sNull)
		Return 1
	END IF

	sBnkCd = this.getitemstring(this.GetRow(), 'bnk_cd')
	sGetName = this.getitemstring(this.GetRow(), 'kfz04om0_v2_person_nm')
	
   this.SetRedraw(false)
	
	IF this.Retrieve(sBnkCd, sSaupNo) < 1 THEN 
		wf_init()
		this.SetItem(this.GetRow(), 'bnk_cd', sBnkCd)
		this.SetItem(this.GetRow(), 'kfz04om0_v2_person_nm', sGetName)
		this.SetItem(this.GetRow(), 'saup_no', sSaupNo)
		smodstatus = 'I'       // ���
	ELSE 
		smodstatus = 'M'       // ����
	END IF
	
   this.SetRedraw(true)	
	
	WF_SETTING_RETRIEVEMODE(smodstatus)	// MODE ����
	
END IF

IF this.GetColumnName() = 'lim_amt' THEN dLimAmt = Double(trim(this.GetText()))

// �ѵ� ������
IF this.GetColumnName() = 'lim_sdate' THEN
	sLimSdate = trim(this.GetText())
	
	IF sLimSdate = '' or isNull(sLimSdate) THEN
		Return 
	ELSE 
		IF f_datechk(sLimSdate) = -1 THEN 
			f_Messagechk(21, "[�ѵ�������]")
			Return 1
		END IF
	END IF
END IF

// �ѵ�������
IF this.GetColumnName() = 'lim_edate' THEN
	sLimEdate = trim(this.GetText())
	sLimSdate = trim(this.GetItemString(this.Getrow(), 'lim_sdate'))
	IF sLimEdate = '' or isNull(sLimEdate) THEN
		Return 
	ELSE 
		IF f_datechk(sLimEdate) = -1 THEN 
			f_Messagechk(21, "[�ѵ�������]")
			Return 1
		END IF
	END IF
END IF
end event

event editchanged;ib_any_typing = True
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

f_toggle_eng(wnd)

end event

event getfocus;this.AcceptText()
end event

type dw_list from datawindow within w_kfia602
event ue_enterkey pbm_dwnprocessenter
integer x = 91
integer y = 528
integer width = 4453
integer height = 1652
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kfia602_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9, 0)
return 1
end event

event itemerror;return 1
end event

event itemchanged;string ls_bal_date, ls_acc_date
long ll_bjun_no, ll_jun_no, ll_lin_no, lRow, lReturnRow

// ��������
if this.GetColumnName() = 'bal_date' then
	ls_bal_date = (this.GetText())
	if ls_bal_date = '' or isnull(ls_bal_date) then
		f_Messagechk(1, "[��������]")
		return 1
	else
		if f_datechk(ls_bal_date) = -1 then
			f_Messagechk(21, "[��������]")
			return 1
		else
			this.SetItem(this.GetRow(),"acc_date", ls_bal_date)
		end if
	end if
end if

// �����ȣ

if this.GetColumnName() = 'bjun_no' then
	ll_bjun_no = long(this.GetText())
	
	if isnull(ll_bjun_no) or ll_bjun_no <= 0 then
		MessageBox("Ȯ ��", "�����ȣ�� 1 �̻��̾�� �մϴ�.!!")
		return 1
	else
		this.SetItem(this.GetRow(),"jun_no", ll_bjun_no)
	end if
end if

// ȸ������
if this.GetColumnName() = 'acc_date' then
	ls_acc_date = (this.GetText())
	if ls_acc_date = '' or isnull(ls_acc_date) then
		f_Messagechk(1, "[ȸ������]")
		return 1
	else
		if f_datechk(ls_acc_date) = -1 then
			f_Messagechk(21, "[ȸ������]")
			return 1
		end if
	end if
end if

// ȸ���ȣ
if this.GetColumnName() = 'jun_no' then
	ll_jun_no = long(this.GetText())
	
	if isnull(ll_jun_no) or ll_jun_no <= 0 then
		MessageBox("Ȯ ��", "ȸ���ȣ�� 1 �̻��̾�� �մϴ�.!!")
		return 1
	end if
end if

// ���ι�ȣ
if this.GetColumnName() = 'lin_no' then
	lRow = this.GetRow()		
	ll_lin_no = long(this.GetText())
	ls_bal_date = this.GetItemString(row, 'bal_date')
	ll_bjun_no = this.GetItemNumber(row, 'bjun_no')
   ls_acc_date = this.GetItemString(row, 'acc_date')
	ll_jun_no = this.GetItemNumber(row, 'jun_no')
	
	if isnull(ll_lin_no) or ll_lin_no <= 0 then
		MessageBox("Ȯ ��", "���ι�ȣ�� 1 �̻��̾�� �մϴ�.!!")
		return 1
	end if
	
	lReturnRow = dw_list.find("bal_date = ~"" + lower(ls_bal_date) + "~" and &
	             bjun_no = " + string(ll_bjun_no) + " and &
					 acc_date = ~'" + ls_acc_date + "~' and &
					 jun_no = " + string(ll_jun_no) + "", &
                1, dw_list.rowcount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("Ȯ��","��ϵ� �ڵ��Դϴ�.~r����� �� �����ϴ�.")
//		this.SetItem(lRow, 1, sNull)
//		this.SetItem(lRow, 2, sNull)
//		dw_main.setredraw(True)
		RETURN  1
	END IF	
end if



end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="bigo" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type gb_2 from groupbox within w_kfia602
integer x = 82
integer y = 468
integer width = 4480
integer height = 1724
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "�ѵ� ��� ����"
end type

type cb_1 from commandbutton within w_kfia602
boolean visible = false
integer x = 3543
integer y = 2960
integer width = 375
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����(&L)"
end type

type rr_1 from roundrectangle within w_kfia602
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 444
integer width = 4535
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

