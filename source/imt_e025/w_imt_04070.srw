$PBExportHeader$w_imt_04070.srw
$PBExportComments$������ȯ���
forward
global type w_imt_04070 from window
end type
type pb_1 from u_pb_cal within w_imt_04070
end type
type p_delrow from uo_picture within w_imt_04070
end type
type p_addrow from uo_picture within w_imt_04070
end type
type p_exit from uo_picture within w_imt_04070
end type
type p_cancel from uo_picture within w_imt_04070
end type
type p_delete from uo_picture within w_imt_04070
end type
type p_save from uo_picture within w_imt_04070
end type
type p_inq from uo_picture within w_imt_04070
end type
type dw_1 from datawindow within w_imt_04070
end type
type dw_detail from datawindow within w_imt_04070
end type
type dw_list from datawindow within w_imt_04070
end type
type rr_1 from roundrectangle within w_imt_04070
end type
end forward

global type w_imt_04070 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "������ȯ ���"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_1 pb_1
p_delrow p_delrow
p_addrow p_addrow
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_inq p_inq
dw_1 dw_1
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
end type
global w_imt_04070 w_imt_04070

type variables
boolean ib_ItemError, ib_any_typing = False
char ic_status
string is_Date
int  ii_Last_Jpno

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_create ()
public function integer wf_delete ()
public subroutine wf_query ()
public subroutine wf_new ()
end prototypes

public function integer wf_checkrequiredfield ();string	sCode, sbank, sYeyn
dec{4}   damt, dusd, dwon
long		lcount, lrow

if dw_list.accepttext() = -1 then return -1
if dw_detail.accepttext() = -1 then return -1

sCode = dw_detail.getitemstring(1, "retdate")
if isnull(sCode) or trim(sCode) = '' then
	f_message_chk(30,'[��ȯ����]')		
	dw_detail.SetColumn("retdate")
	dw_detail.SetFocus()
	RETURN -1	
end if

sBAnk = dw_detail.getitemstring(1, "bankcd")
if isnull(sCode) or trim(sCode) = '' then
	f_message_chk(30,'[����]')		
	dw_detail.SetColumn("bankcd")
	dw_detail.SetFocus()
	RETURN -1	
end if

sYeyn = dw_detail.getitemstring(1, "gyeyn")
if isnull(sCode) or trim(sCode) = '' then
	f_message_chk(30,'[��ȯ����]')		
	dw_detail.SetColumn("Yeyn")
	dw_detail.SetFocus()
	RETURN -1	
end if

damt = dw_detail.getitemdecimal(1, "usdamt")
if isnull(damt) or dAmt = 0 then
	f_message_chk(30,'[��ȯ�ݾ�(USD)]')		
	dw_detail.SetColumn("usdamt")
	dw_detail.SetFocus()
	RETURN -1	
end if

damt = dw_detail.getitemdecimal(1, "wonamt")
if isnull(damt) or dAmt = 0 then
	f_message_chk(30,'[��ȯ�ݾ�(WON)]')		
	dw_detail.SetColumn("wonamt")
	dw_detail.SetFocus()
	RETURN -1	
end if

// ��ǥ��ȣ ä��
lcount = sqlca.fun_junpyo(gs_sabu, left(sCode, 6), "R1")
if lcount < 1 then
	rollback;
	Messagebox("������ȯ��ȣ", "��ȣä���� �����߻�", stopsign!)
	return -1
end if
commit;

sCode = dw_detail.getitemstring(1, "retdate")
dw_detail.setitem(1, "sabu", 		gs_sabu)
dw_detail.setitem(1, "retno", 	sCode + string(lcount, '0000'))

dusd = 0
dwon = 0

For Lrow = 1 to dw_list.rowcount()
	
	 dw_list.setitem(lrow, "sabu", gs_sabu)
	 dw_list.setitem(Lrow, "retno", sCode + string(lcount, '0000'))
	
	 if isnull(dw_list.getitemstring(Lrow, "setno")) or &
	    trim(dw_list.getitemstring(Lrow, "setno")) = '' then
		 Messagebox("������ȣ", "������ȣ�� �Է��Ͻʽÿ�", stopsign!)
		 dw_list.SetColumn("setno")
		 dw_list.ScrollToRow(lrow)
		 dw_list.SetFocus()
		 RETURN -1	
	 end if				 
	
	 dusd = dusd + dw_list.getitemdecimal(Lrow, "retusd")
	 if dw_list.getitemdecimal(Lrow, "retusd") > dw_list.getitemdecimal(Lrow, "kumusd") then
		 Messagebox("�����ݾ�", "��ȯ�ݾ��� ��ȯ�ܾ׺��� �����ϴ�", stopsign!)
		 dw_list.SetColumn("retusd")
		 dw_list.ScrollToRow(lrow)
		 dw_list.SetFocus()
		 RETURN -1	
	 end if		
	 
	 dwon = dwon + dw_list.getitemdecimal(Lrow, "retwon")	 
	 if dw_list.getitemdecimal(Lrow, "retwon") > dw_list.getitemdecimal(Lrow, "kumwon") then
		 Messagebox("�����ݾ�", "��ȯ�ݾ��� ��ȯ�ܾ׺��� �����ϴ�", stopsign!)
		 dw_list.SetColumn("retwon")
		 dw_list.ScrollToRow(lrow)
		 dw_list.SetFocus()
		 RETURN -1	
	 end if			 
	 
	 if sbank <> dw_list.getitemstring(Lrow, "poopbk") then
		 Messagebox("��������", "��������� ��ȯ������ Ʋ���ϴ�.", stopsign!)
		 dw_list.SetColumn("setno")
		 dw_list.ScrollToRow(lrow)
		 dw_list.SetFocus()
		 RETURN -1		
	 End if

	 if sYeyn <> dw_list.getitemstring(Lrow, "gyeyn") then
		 Messagebox("��ȯ����", "��ȯ���а� ������뱸���� Ʋ���ϴ�.", stopsign!)
		 dw_list.SetColumn("setno")
		 dw_list.ScrollToRow(lrow)
		 dw_list.SetFocus()
		 RETURN -1		
	 End if

NExt

if dw_detail.getitemdecimal(1, "usdamt") <> dusd then
	Messagebox("�����ݾ�(USD)" ,"�����ݾװ� ��ȯ�ݾ��� ���� �����ϴ�", stopsign!)
	return -1
end if

if dw_detail.getitemdecimal(1, "wonamt") <> dwon then
	Messagebox("�����ݾ�(WON)" ,"�����ݾװ� ��ȯ�ݾ��� ���� �����ϴ�", stopsign!)
	return -1
end if

return 1

end function

public function integer wf_create ();string sbank, ssetno, sgyeyn
decimal {4} dusd, dwon
long lrow

// ������ȯ�ݾ��� ���Ű����� update
For lrow = 1 to dw_list.rowcount()
	
	ssetno = dw_list.getitemstring(Lrow, "setno")
	dusd = dw_list.getitemdecimal(Lrow, "retusd")
	dwon = dw_list.getitemdecimal(Lrow, "retwon")	
	
	Update polcsethd
		set gisausd = nvl(gisausd, 0) + :dusd,
			 gisawon = nvl(gisawon, 0) + :dwon 
	 where sabu = :gs_sabu and setno = :ssetno;
	if sqlca.sqlcode <> 0 then
		Rollback ;
		Messagebox("������ȯ", "������ȯ ���� �ۼ��� �����߻�", stopsign!)
		return -1
	end if 
Next

sbank  = dw_detail.getitemstring(1, "bankcd")
sgyeyn = dw_detail.getitemstring(1, "gyeyn")
dusd   = dw_detail.getitemdecimal(1, "usdamt")
dwon   = dw_detail.getitemdecimal(1, "wonamt")

// ������ȯ�ݾ��� �����ѵ��� update
if sgyeyn = 'Y' then 
	Update pobank
		set blusdamt = nvl(blusdamt, 0) - :dusd,
			 blwonamt = nvl(blwonamt, 0) - :dwon 
	 where sabu = :gs_sabu and bankcd = :sbank;
else  // usance 
	Update pobank
		set usansamt = nvl(usansamt, 0) - :dusd,
			 usanswon = nvl(usanswon, 0) - :dwon 
	 where sabu = :gs_sabu and bankcd = :sbank;
end if
 
if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("�������", "������� ���� �ۼ��� �����߻�", stopsign!)
	return -1
end if 

return 1

end function

public function integer wf_delete ();string sbank, ssetno, sgyeyn
decimal {4} dusd, dwon
long lrow

// ������ȯ�ݾ��� ���Ű����� update
For lrow = 1 to dw_list.rowcount()
	
	ssetno = dw_list.getitemstring(Lrow, "setno")
	dusd = dw_list.getitemdecimal(Lrow, "retusd")
	dwon = dw_list.getitemdecimal(Lrow, "retwon")	
	
	Update polcsethd
		set gisausd = nvl(gisausd, 0) - :dusd,
			 gisawon = nvl(gisawon, 0) - :dwon 
	 where sabu = :gs_sabu and setno = :ssetno;
	 
	if sqlca.sqlcode <> 0 then
		Rollback ;
		Messagebox("������ȯ", "������ȯ ���� �ۼ��� �����߻�", stopsign!)
		return -1
	end if 
Next

sbank  = dw_detail.getitemstring(1, "bankcd")
sgyeyn = dw_detail.getitemstring(1, "gyeyn")
dusd   = dw_detail.getitemdecimal(1, "usdamt")
dwon   = dw_detail.getitemdecimal(1, "wonamt")

// ������ȯ�ݾ��� �����ѵ��� update
if sgyeyn = 'Y' then 
	Update pobank
		set blusdamt = nvl(blusdamt, 0) + :dusd,
			 blwonamt = nvl(blwonamt, 0) + :dwon 
	 where sabu = :gs_sabu and bankcd = :sbank;
else  // usance 
	Update pobank
		set usansamt = nvl(usansamt, 0) + :dusd,
			 usanswon = nvl(usanswon, 0) + :dwon 
	 where sabu = :gs_sabu and bankcd = :sbank;
end if

if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("�������", "������� ���� �ۼ��� �����߻�", stopsign!)
	return -1
end if 

return 1

end function

public subroutine wf_query ();
w_mdi_frame.sle_msg.text = "��ȸ"
ic_Status = '2'

dw_list.SetFocus()
	

// button
p_delete.enabled = true
//cb_insert.enabled = false

end subroutine

public subroutine wf_new ();
ic_status = '1'
w_mdi_frame.sle_msg.text = "���"

///////////////////////////////////////////////
dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setitem(1, "sabu", gs_sabu)
dw_detail.setitem(1, "retdate", is_today)
dw_detail.setredraw(true)
///////////////////////////////////////////////


dw_detail.enabled = true
dw_list.enabled = true

dw_detail.SetFocus()

p_save.enabled = true
p_delete.enabled = false
p_inq.enabled = true
p_addrow.enabled = true
p_addrow.picturename = 'C:\erpman\image\���߰�_up.gif'

p_delrow.enabled = true
p_delrow.picturename = 'C:\erpman\image\�����_up.gif'

ib_ItemError  = true
ib_any_typing = false


end subroutine

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

is_Date = f_Today()

p_cancel.TriggerEvent("clicked")
end event

on w_imt_04070.create
this.pb_1=create pb_1
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_inq=create p_inq
this.dw_1=create dw_1
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.pb_1,&
this.p_delrow,&
this.p_addrow,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_inq,&
this.dw_1,&
this.dw_detail,&
this.dw_list,&
this.rr_1}
end on

on w_imt_04070.destroy
destroy(this.pb_1)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type pb_1 from u_pb_cal within w_imt_04070
integer x = 2117
integer y = 36
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('retdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'retdate', gs_code)



end event

type p_delrow from uo_picture within w_imt_04070
integer x = 3881
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\�����_up.gif"
end type

event clicked;call super::clicked;long lrow

lrow = dw_list.getrow()

if lrow < 1 then return

dw_list.deleterow(lrow)
dw_list.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�����_up.gif"
end event

type p_addrow from uo_picture within w_imt_04070
integer x = 3707
integer y = 24
integer width = 178
integer taborder = 30
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\���߰�_up.gif"
end type

event clicked;call super::clicked;if dw_detail.accepttext() = -1 then return

if isnull(dw_detail.getitemstring(1, "bankcd")) or &
   trim(dw_detail.getitemstring(1, "bankcd")) = '' then
	Messagebox("��ȯ����" ,"��ȯ������ �Է��Ͻʽÿ�", stopsign!)
	return
end if

long lrow

lrow = dw_list.insertrow(0)
dw_list.setrow(Lrow)
dw_list.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���߰�_up.gif"
end event

type p_exit from uo_picture within w_imt_04070
integer x = 4402
integer y = 24
integer width = 178
integer taborder = 90
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)�� typing ����Ȯ��

	Beep(1)
	IF MessageBox("Ȯ�� : ����" , &
		 "�������� ���� ���� �ֽ��ϴ�. ~r��������� �����Ͻðڽ��ϱ�", &
		 question!, yesno!) = 1 THEN

		RETURN 									

	END IF

END IF

close(parent)

end event

type p_cancel from uo_picture within w_imt_04070
integer x = 4229
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)�� typing ����Ȯ��

	Beep(1)
	IF MessageBox("Ȯ�� : ���" , &
		 "�������� ���� ���� �ֽ��ϴ�. ~r��������� �����Ͻðڽ��ϱ�", &
		 question!, yesno!) = 1 THEN

		RETURN 									

	END IF

END IF

wf_New()

dw_list.Reset()
end event

type p_delete from uo_picture within w_imt_04070
integer x = 4055
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
String sretno

IF f_msg_delete() = -1 THEN	RETURN

sretno = dw_detail.getitemstring(1, "retno")
/////////////////////////////////////////////////////////////////
	
// HEAD����
DELETE POLCREHD
 WHERE SABU = :gs_sabu AND retno = :sretno   ;
 
IF SQLCA.SQLCODE <> 0 THEN
	rollback;
	MESSAGEBOX("������ȯ-HEAD", "������ȯ-HEAD������ ������ �߻�", stopsign!)
	return
END IF

// DETAIL����
DELETE POLCREDT
 WHERE SABU = :gs_sabu AND retno = :sretno   ;
 
IF SQLCA.SQLCODE <> 0 THEN
	rollback;
	MESSAGEBOX("������ȯ-DETAIL", "������ȯ-DETAIL������ ������ �߻�", stopsign!)
	return
END IF

if wf_delete() = -1 then
	return
END IF		

COMMIT;

Messagebox("����Ϸ�", "�ڷᰡ �����Ǿ����ϴ�", information!)	

wf_New()

dw_list.Reset()	
	
dw_detail.setredraw(true)


end event

type p_save from uo_picture within w_imt_04070
integer x = 3534
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

if dw_list.rowcount() < 1 then return
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate, sretno

IF	wf_CheckRequiredField() = -1	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
IF f_msg_update() = -1 		THEN	RETURN

IF dw_detail.Update() = 1	and dw_list.update() = 1 then
	if wf_create() = -1 then
		return
	END IF		
	COMMIT;
	sretno = dw_detail.getitemstring(1, "retno")
	Messagebox("����Ϸ�", "������ȣ -> " + sretno + " �� �ڷᰡ ����Ǿ����ϴ�", information!)
ELSE
	ROLLBACK;
	f_Rollback()
END IF

ib_any_typing = False

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_inq from uo_picture within w_imt_04070
integer x = 3360
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

event clicked;call super::clicked;
if dw_detail.Accepttext() = -1	then 	return

string  	sretno,		&
			sDate,		&
			sNull, slcno
int      get_count 
			
SetNull(sNull)

sretno	= dw_detail.getitemstring(1, "retno")

IF isnull(sretno) or sretno = "" 	THEN
	f_message_chk(30,'[������ȯ��ȣ]')
	dw_detail.SetColumn("retno")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.SetRedraw(False)

IF dw_detail.Retrieve(gs_Sabu, sretno) < 1	THEN
	f_message_chk(50, '[������ȯ��ȣ]')
	dw_detail.setcolumn("retno")
	dw_detail.setfocus()

	ib_any_typing = False
	p_cancel.TriggerEvent("clicked")
	RETURN
END IF

dw_detail.SetRedraw(True)

IF dw_list.Retrieve(gs_Sabu, sretno) < 1 THEN 
	f_message_chk(50, '[����-detail]')
	dw_detail.setcolumn("retno")
	dw_detail.setfocus()
	RETURN
END IF

wf_Query()

dw_detail.enabled = false
p_save.enabled = false
p_inq.enabled = false
p_delete.enabled = true
p_addrow.enabled = false
p_addrow.picturename = 'C:\erpman\image\���߰�_d.gif'

p_delrow.enabled = false
p_delrow.picturename = 'C:\erpman\image\�����_d.gif'

ib_any_typing = False

end event

type dw_1 from datawindow within w_imt_04070
boolean visible = false
integer x = 18
integer y = 2340
integer width = 983
integer height = 112
boolean titlebar = true
string dataobject = "d_lc_detail_popup1"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type dw_detail from datawindow within w_imt_04070
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 55
integer y = 16
integer width = 3273
integer height = 372
integer taborder = 10
string dataobject = "d_imt_04070"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	scode, sNull
SetNull(sNull)

IF this.GetColumnName() = 'retdate' THEN
	sCode = trim(gettext())
	
	if scode ='' or isnull(scode) then return 
	if f_datechk(sCode) = -1 then
		f_message_chk(30,'[��ȯ����]')		
		dw_detail.setitem(1, "rcadat", snull)
		RETURN 1
	end if
end if


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

IF this.GetColumnName() = 'retno'	THEN
	  
	Open(w_polcrehd_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "retno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
END IF
end event

event editchanged;ib_any_typing =True
end event

type dw_list from datawindow within w_imt_04070
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 87
integer y = 408
integer width = 4466
integer height = 1796
integer taborder = 50
string dataobject = "d_imt_04070_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;setnull(gs_code)
choose case key
	case KeyF1! 
   	TriggerEvent(RbuttonDown!)
	case KeyF2! 
		IF This.GetColumnName() = "itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(this.getrow(),"itnbr",gs_code)
			this.TriggerEvent(ItemChanged!)
		End If
end choose
	
end event

event itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column �� �ƴ� Column ���� Error �߻��� 

IF ib_ItemError = true	THEN	
	ib_ItemError = false		
	RETURN 1
END IF



//	2) Required Column  ���� Error �߻��� 

string	sColumnName
sColumnName = dwo.name + "_t.text"


w_mdi_frame.sle_msg.text = "  �ʼ��Է��׸� :  " + this.Describe(sColumnName) + "   �Է��ϼ���."

RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event editchanged;ib_any_typing =True


end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

long lrow

lrow = row

if lrow < 1 then return 


// ���Ű�����ȣ
IF this.GetColumnName() = 'setno'	THEN
	  
	Open(w_polcsethd_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(lrow, "setno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
END IF
end event

event itemchanged;string ssetno, sbank, slcno, snull, sgyeyn
decimal {2} dusd, dwon
long lrow

setnull(snull)
lrow = getrow()

if this.getcolumnname() = 'setno' then
	ssetno = this.gettext()
	
	Select a.kumusd - a.gisausd, a.kumwon - a.gisawon, a.polcno, b.poopbk, a.gyeyn
	  into :dusd, :dwon, :slcno, :sbank, :sgyeyn
	  from polcsethd a, polchd b
	 where a.sabu   = :gs_sabu
	 	and a.setno  = :ssetno
		and a.sabu   = b.sabu 
		and a.polcno = b.polcno;
		
	if sqlca.sqlcode <> 0 then
		Messagebox("������ȣ", "������ȣ�� ����Ȯ�մϴ�", stopsign!)
		setitem(lrow, "setno", snull)
		setitem(lrow, "polcno", snull)
		setitem(lrow, "retusd", 0)
		setitem(lrow, "retwon", 0)
		setitem(lrow, "kumusd", 0)
		setitem(lrow, "kumwon", 0)		
		setitem(lrow, "poopbk", snull)		
		setitem(lrow, "gyeyn",  snull)		
		return 1
	end if
	
	if dw_detail.getitemstring(1, "bankcd") <> sbank then
		Messagebox("��������", "��������� ��ȯ������ Ʋ���ϴ�", stopsign!)
		setitem(lrow, "setno", snull)
		setitem(lrow, "polcno", snull)
		setitem(lrow, "retusd", 0)
		setitem(lrow, "retwon", 0)
		setitem(lrow, "kumusd", 0)
		setitem(lrow, "kumwon", 0)		
		setitem(lrow, "poopbk", snull)
		setitem(lrow, "gyeyn",  snull)		
		return 1
	end if
	
	setitem(lrow, "polcno", slcno)
	setitem(lrow, "retusd", dusd)
	setitem(lrow, "retwon", dwon)
	setitem(lrow, "kumusd", dusd)
	setitem(lrow, "kumwon", dwon)		
	setitem(lrow, "poopbk", sbank)
	setitem(lrow, "gyeyn",  sgyeyn)		
	
end if

end event

type rr_1 from roundrectangle within w_imt_04070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 396
integer width = 4494
integer height = 1820
integer cornerheight = 40
integer cornerwidth = 55
end type

