$PBExportHeader$w_imt_04000.srw
$PBExportComments$�ұ����� ���
forward
global type w_imt_04000 from window
end type
type pb_3 from u_pb_cal within w_imt_04000
end type
type pb_2 from u_pb_cal within w_imt_04000
end type
type pb_1 from u_pb_cal within w_imt_04000
end type
type dw_list from u_d_popup_sort within w_imt_04000
end type
type p_exit from uo_picture within w_imt_04000
end type
type p_can from uo_picture within w_imt_04000
end type
type p_del from uo_picture within w_imt_04000
end type
type p_mod from uo_picture within w_imt_04000
end type
type p_inq from uo_picture within w_imt_04000
end type
type st_2 from statictext within w_imt_04000
end type
type st_1 from statictext within w_imt_04000
end type
type rb_2 from radiobutton within w_imt_04000
end type
type rb_1 from radiobutton within w_imt_04000
end type
type cb_delete from commandbutton within w_imt_04000
end type
type cb_cancel from commandbutton within w_imt_04000
end type
type rb_delete from radiobutton within w_imt_04000
end type
type rb_insert from radiobutton within w_imt_04000
end type
type dw_imhist from datawindow within w_imt_04000
end type
type dw_detail from datawindow within w_imt_04000
end type
type cb_save from commandbutton within w_imt_04000
end type
type cb_exit from commandbutton within w_imt_04000
end type
type cb_retrieve from commandbutton within w_imt_04000
end type
type gb_1 from groupbox within w_imt_04000
end type
type rr_1 from roundrectangle within w_imt_04000
end type
type rr_3 from roundrectangle within w_imt_04000
end type
type rr_4 from roundrectangle within w_imt_04000
end type
type rr_5 from roundrectangle within w_imt_04000
end type
end forward

global type w_imt_04000 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "�ұ����� ���"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
boolean center = true
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
dw_list dw_list
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
st_2 st_2
st_1 st_1
rb_2 rb_2
rb_1 rb_1
cb_delete cb_delete
cb_cancel cb_cancel
rb_delete rb_delete
rb_insert rb_insert
dw_imhist dw_imhist
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
gb_1 gb_1
rr_1 rr_1
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
end type
global w_imt_04000 w_imt_04000

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

string is_pspec, is_jijil  
end variables

forward prototypes
public function integer wf_imhist_create ()
public function integer wf_imhist_delete ()
public function integer wf_initial ()
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_imhist_create ();///////////////////////////////////////////////////////////////////////
//	* ��ϸ��
//	1. �����HISTORY ����
//	2. ��ǥä������ = 'C0'
// 3. ��ǥ�������� = '006'
///////////////////////////////////////////////////////////////////////
long			lRow, lRowHist
dec	{2}	dSeq, dAmt
dec	{3}   dQty, dJegoqty 
string	sJpno, 		&
			sToday,		&
			sFromDate, 	&
			sToDate,		&
			sVendor,		&
			sDept,		&
			sEmpno,		&
			sNull, sIogbn, sDepot_no, sItnbr, sPspec, sIpno, sOpt

if dw_detail.AcceptText() = -1 then return -1 

sToday  = dw_detail.GetItemString(1, "idate")
sVendor = dw_detail.GetItemString(1, "vendor")
sDept	  = dw_detail.GetItemString(1, "dept")
sEmpno  = dw_detail.GetItemString(1, "empno")
sFromDate = dw_detail.GetItemString(1, "sdate")
sToDate   = dw_detail.GetItemString(1, "edate")
sIogbn    = dw_detail.GetItemString(1, "iogbn")

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sToday, 'C0')

IF dSeq < 1		THEN	RETURN -1

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno    = sToday + string(dSeq, "0000")

FOR	lRow = 1		TO		dw_list.RowCount()

	dQty = dw_list.GetItemDecimal(lRow, "ioqty")
	dAmt = dw_list.GetItemDecimal(lRow, "ioamt")
	sOpt = dw_list.GetItemString(lRow, "opt")

	IF dQty > 0	and dAmt <> 0 and sopt = 'Y'	THEN
	
		/////////////////////////////////////////////////////////////////////////
		//
		// ** �����HISTORY ���� **
		//
		////////////////////////////////////////////////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
	
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'006')			// ��ǥ��������
		dw_imhist.SetItem(lRowHist, "inpcnf",  'I')				// �������
		
		sIpno	= sJpno + string(lRowHist, "000") 
		dw_imhist.SetItem(lRowHist, "iojpno", 	sIpno )
		dw_imhist.SetItem(lRowHist, "iogbn",   sIogbn) 			// ���ұ���
	
		dw_imhist.SetItem(lRowHist, "sudat",	sToday)			// ��������=��������
		
		sItnbr = dw_list.GetItemString(lRow, "itnbr")
		sPspec = dw_list.GetItemString(lRow, "pspec")
		sDepot_no = dw_list.GetItemString(lRow, "depot_no")
		
		dw_imhist.SetItem(lRowHist, "itnbr",	sItnbr ) // ǰ��
		dw_imhist.SetItem(lRowHist, "pspec",	sPspec ) // ���
		dw_imhist.SetItem(lRowHist, "opseq",	'9999')			// ��������
		dw_imhist.SetItem(lRowHist, "depot_no",sDepot_no)		// ����â��=����â��
		dw_imhist.SetItem(lRowHist, "cvcod",	sVendor) 		// �ŷ�óâ��=�ŷ�ó
		dw_imhist.SetItem(lRowHist, "ioqty",	0) 			// ���Ҽ���=�ұ��������
		dw_imhist.SetItem(lRowHist, "ioprc",	dw_list.GetItemDecimal(lRow,"ioprc"))	// ���Ҵܰ�=����
		dw_imhist.SetItem(lRowHist, "ioamt",	dw_list.GetItemDecimal(lRow,"ioamt")) 	// ���ұݾ�=�ұ�����ݾ�
		dw_imhist.SetItem(lRowHist, "bigo",		dw_list.GetItemString(lRow, "bigo"))   // ���=����
		dw_imhist.SetItem(lRowHist, "ioredept",sDept)			// �����Ƿںμ�
		dw_imhist.SetItem(lRowHist, "ioreemp", sEmpno)			// ���Ҵ����
		dw_imhist.SetItem(lRowHist, "juksdat",	sFromDate)		// ���������
		dw_imhist.SetItem(lRowHist, "jukedat",	sToDate)			// ����������
		dw_imhist.SetItem(lRowHist, "prvprc",	dw_list.GetItemDecimal(lRow,"prvprc"))	// �������ܰ�
		dw_imhist.SetItem(lRowHist, "aftprc",	dw_list.GetItemDecimal(lRow,"aftprc"))	// �����Ĵܰ�
		dw_imhist.SetItem(lRowHist, "silqty",	dw_list.GetItemDecimal(lRow,"ioqty"))	// �ұ������԰����
		dw_imhist.SetItem(lRowHist, "silamt",	dw_list.GetItemDecimal(lRow,"ioamt"))	// �ұ������԰�ݾ�
		dw_imhist.setitem(lrowhist, "insdat",  sToday) // �˻�����
		dw_imhist.setitem(lrowhist, "io_confirm", 'Y') // ���ҽ����� �ڵ����� ó��
		dw_imhist.setitem(lrowhist, "io_date",  sToday) // ���ҽ������ڴ� �˻����ڿ� ����

		dw_imhist.SetItem(lRowHist, "saupj",	dw_list.GetItemString(lRow,"saupj"))	// �ΰ������
		
		//���� �����ÿ��� ����ǥ��ȣ�� ip_jpno�� �Է�
		if rb_1.checked then 
			dw_imhist.SetItem(lRowHist, "ip_jpno",	dw_list.GetItemString(lRow,"iojpno"))	
		end if

	END IF

NEXT

MessageBox("��ǥ��ȣ Ȯ��", "��ǥ��ȣ : " +sToday+ '-' + string(dSeq,"0000")+		&
									 "~r~r�����Ǿ����ϴ�.")
RETURN 1


end function

public function integer wf_imhist_delete ();string sOpt
long	 lRow, lRowCount, i

i = 0

lRowCount = dw_list.RowCount()

FOR  lRow = lRowCount 	TO		1		STEP  -1
		
	sOpt  = dw_list.getitemstring(lrow, "opt")
	
	IF sOpt = 'Y' then 
		dw_list.DeleteRow(lRow)

//		IF SQLCA.SQLCODE <> 0 THEN 
//			ROLLBACK ;
//			F_ROLLBACK()
//			RETURN -1
//		END IF	
		
		i++
 
   END IF	
NEXT

if i < 1 then return -1

RETURN 1
end function

public function integer wf_initial ();String siogbn

dw_detail.setredraw(false)
dw_list.reset()
dw_imhist.reset()

p_del.enabled = false
p_del.picturename = "C:\erpman\image\����_d.gif"
dw_detail.enabled = TRUE

dw_list.enabled  = true
p_mod.enabled  = true
p_mod.picturename = "C:\erpman\image\����_up.gif"
////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	then
	// ��Ͻ�
	dw_detail.setitem(1, "jpno",   '')
	dw_detail.settaborder("jpno",   0)
	dw_detail.settaborder("idate",  10)
	dw_detail.settaborder("vendor", 20)
	dw_detail.settaborder("sdate",  30)
	dw_detail.settaborder("edate",  40)
	dw_detail.settaborder("dept",   50)
	dw_detail.settaborder("empno",  60)
	dw_detail.settaborder("iogbn",  70)
	dw_detail.settaborder("saupj",  80)

//   dw_detail.Object.jpno.Background.Color= 79741120
//
//   dw_detail.Object.idate.Background.Color= 12639424
//   dw_detail.Object.sdate.Background.Color= 12639424
//   dw_detail.Object.edate.Background.Color= 12639424
//   dw_detail.Object.dept.Background.Color= 65535
//   dw_detail.Object.vendor.Background.Color= 65535
//   dw_detail.Object.empno.Background.Color= 65535
//   dw_detail.Object.iogbn.Background.Color= 12639424
//   dw_detail.Object.saupj.Background.Color= 12639424
	
	// �ұ޴ܰ� ���ұ����� IOMATRIX���� retrieve
	Select iogbn into :sIogbn from iomatrix
	 where sabu = :gs_sabu and sogub = 'Y' and rownum = 1;
	if sqlca.sqlcode <> 0 then
		f_message_chk(208, '[�ұ����� ���ұ���]')
		return -1
	end if
	dw_detail.setitem(1, "iogbn", siogbn)	
	
	dw_detail.setcolumn("vendor")
	dw_detail.SetItem(1, "idate", is_Date)

	w_mdi_frame.sle_msg.text = "���"
ELSE
	dw_detail.setitem(1, "jpno",   '')
	dw_detail.setitem(1, "vendor",   '')
	dw_detail.setitem(1, "dept",   '')
	dw_detail.setitem(1, "empno",   '')
	dw_detail.setitem(1, "sdate",   '')
	dw_detail.setitem(1, "edate",   '')
	dw_detail.setitem(1, "vendorname",   '')
	dw_detail.setitem(1, "deptname",   '')
	dw_detail.setitem(1, "empname",   '')
	dw_detail.setitem(1, "saupj",   '%')

	dw_detail.settaborder("jpno",   10)
	dw_detail.settaborder("idate",  0)
	dw_detail.settaborder("vendor", 0)
	dw_detail.settaborder("dept",   0)
	dw_detail.settaborder("empno",  0)
	dw_detail.settaborder("sdate",  0)
	dw_detail.settaborder("edate",  0)
	dw_detail.settaborder("iogbn",  0)	
	dw_detail.settaborder("saupj",  0)	

//   dw_detail.Object.jpno.Background.Color= 65535
//
//   dw_detail.Object.idate.Background.Color= 79741120
//   dw_detail.Object.sdate.Background.Color= 79741120
//   dw_detail.Object.edate.Background.Color= 79741120
//   dw_detail.Object.dept.Background.Color= 79741120
//   dw_detail.Object.vendor.Background.Color= 79741120
//   dw_detail.Object.empno.Background.Color= 79741120
//   dw_detail.Object.iogbn.Background.Color= 79741120
//   dw_detail.Object.saupj.Background.Color= 79741120

	dw_detail.setcolumn("jpno")

	w_mdi_frame.sle_msg.text = "����"
	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

/* �ΰ� ����� */
f_mod_saupj(dw_detail,'saupj')

return  1


end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////
string	sFromDate, 	&
			sToDate,		&
			sVendor,		&
			sDept,		&
			sEmpno, sdate
long		lRow

sdate 	 = TRIM(dw_detail.GetItemString(1, "idate"))
sVendor 	 = dw_detail.GetItemString(1, "vendor")
sDept	  	 = dw_detail.GetItemString(1, "dept")
sEmpno  	 = dw_detail.GetItemString(1, "empno")
sFromDate = TRIM(dw_detail.GetItemString(1, "sdate"))
sToDate   = TRIM(dw_detail.GetItemString(1, "edate"))

////////////////////////////////////////////////////////////////// 
IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30, '[�ұ�����]')
	dw_detail.SetColumn("idate")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sVendor) or sVendor = "" 	THEN
	f_message_chk(30, '[�ŷ�ó]')
	dw_detail.SetColumn("vendor")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sFromDate) or sFromDate = "" 	THEN
	f_message_chk(30, '[�Ⱓ]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sToDate) or sToDate = "" 	THEN
	f_message_chk(30, '[�Ⱓ]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	RETURN -1
END IF


IF isnull(sDept) or sDept = "" 	THEN
	f_message_chk(30, '[�Ƿںμ�]')
	dw_detail.SetColumn("dept")
	dw_detail.SetFocus()
	RETURN -1
END IF

IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30, '[�Ƿڴ����]')
	dw_detail.SetColumn("empno")
	dw_detail.SetFocus()
	RETURN -1
END IF


//////////////////////////////////////////////////////////////////////
//	* ���� : ������� = 0 -> ERROR
//////////////////////////////////////////////////////////////////////
dec	dQty, dAmt
int	iCount
string sOpt

FOR  lRow = 1	TO		dw_list.RowCount()

	dQty = dw_list.GetItemDecimal(lRow, "ioqty")
	dAmt = dw_list.GetItemDecimal(lRow, "ioamt")
	sOpt = dw_list.GetItemString(lRow, "opt")
	
	IF ic_status = '1'		THEN

		IF dQty > 0	and dAmt <> 0 and sopt = 'Y'	THEN 
			iCount++
			IF isnull(dw_list.getitemstring(Lrow, "bigo")) or &
				trim(  dw_list.getitemstring(Lrow, "bigo")) = '' then
				f_message_chk(1400,'[����]')		
				dw_list.SetColumn("bigo")
				dw_list.SetRow(lRow)
				dw_list.SetFocus()
				RETURN -1
			End if
		end if

	ELSE
		IF IsNull(dQty) or dQty = 0	THEN
			f_message_chk(30,'[�ұ��������]')		
			dw_list.SetColumn("ioqty")
			dw_list.SetRow(lRow)
			dw_list.SetFocus()
			RETURN -1
		END IF
		
		
		IF isnull(dw_list.getitemstring(Lrow, "bigo")) or &
			trim(  dw_list.getitemstring(Lrow, "bigo")) = '' then
			f_message_chk(1400,'[����]')		
			dw_list.SetColumn("bigo")
			dw_list.SetRow(lRow)
			dw_list.SetFocus()
			RETURN -1
		End if		
	END IF
	
NEXT


//
IF ic_status = '1'		THEN
	IF iCount = 0	THEN	RETURN -1
END IF

RETURN 1


end function

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

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_detail.settransobject(sqlca)
dw_detail.insertrow(0)

String siogbn
// �ұ޴ܰ� ���ұ����� IOMATRIX���� retrieve
Select iogbn into :sIogbn from iomatrix
 where sabu = :gs_sabu and sogub = 'Y' and rownum = 1;
if sqlca.sqlcode <> 0 then
	f_message_chk(208, '[�ұ����� ���ұ���]')
	return -1
end if
dw_detail.setitem(1, "iogbn", siogbn)

dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)

is_Date = f_Today()

//IF f_change_name('1') = 'Y' then 
//	is_pspec = f_change_name('2')
//	is_jijil = f_change_name('3')
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_imt_04000.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_list=create dw_list
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.st_2=create st_2
this.st_1=create st_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_imhist=create dw_imhist
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
this.Control[]={this.pb_3,&
this.pb_2,&
this.pb_1,&
this.dw_list,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.st_2,&
this.st_1,&
this.rb_2,&
this.rb_1,&
this.cb_delete,&
this.cb_cancel,&
this.rb_delete,&
this.rb_insert,&
this.dw_imhist,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.gb_1,&
this.rr_1,&
this.rr_3,&
this.rr_4,&
this.rr_5}
end on

on w_imt_04000.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_list)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_imhist)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type pb_3 from u_pb_cal within w_imt_04000
integer x = 1861
integer y = 276
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'edate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04000
integer x = 649
integer y = 280
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('idate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'idate', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04000
integer x = 1413
integer y = 276
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type dw_list from u_d_popup_sort within w_imt_04000
integer x = 32
integer y = 488
integer width = 4539
integer height = 1756
integer taborder = 30
string dataobject = "d_imt_04001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event doubleclicked;call super::doubleclicked;
str_item  str_parm

long	lRow
lRow = this.GetRow()

IF lRow < 1		THEN	RETURN

//////////////////////////////////////////////////////

str_parm.code = this.GetItemSTring(lRow, "itnbr")
str_parm.name = dw_detail.GetItemString(1, "saupj")
str_parm.cust = dw_detail.GetItemString(1, "vendor")
str_parm.etc1 = dw_detail.GetItemString(1, "sdate")
str_parm.flag = dw_detail.GetItemString(1, "edate")

OpenWithParm(w_imt_04010, str_parm)


end event

event itemerror;call super::itemerror;////////////////////////////////////////////////////////////////////////////
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

event losefocus;call super::losefocus;this.AcceptText()
end event

event rbuttondown;call super::rbuttondown;
long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''


// �ŷ�ó
IF this.GetColumnName() = 'cvcod'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"cvcod",gs_code)
	SetItem(lRow,"vndmst_cvnas",gs_codename)
	
END IF



end event

event clicked;call super::clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

event itemchanged;call super::itemchanged;dec{3} dQty
dec{5} dPrice
long	lRow

lRow = this.GetRow()

IF this.getcolumnname() = "ioqty"		or		&
	this.getcolumnname() = "prvprc"		or		&
	this.getcolumnname() = "aftprc"		THEN

	this.AcceptText()
	
	dQty 	 = this.GetItemDecimal(lRow, "ioqty")
	dPrice = this.GetItemDecimal(lRow, "aftprc") - this.GetItemDecimal(lRow, "prvprc")

	this.SetItem(lRow, "ioprc", dPrice)
	this.SetItem(lRow, "ioamt", truncate(dPrice * dQty, 0))

END IF



end event

type p_exit from uo_picture within w_imt_04000
integer x = 4411
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("����") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_can from uo_picture within w_imt_04000
integer x = 4238
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

rb_insert.checked = true
rb_2.checked = true

rb_insert.TriggerEvent("clicked")


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

type p_del from uo_picture within w_imt_04000
integer x = 4064
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////
if dw_list.AcceptText() = -1 then return 

IF f_msg_delete() = -1 	THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	
	MessageBOx('Ȯ ��', '������ �ڷḦ �����ϼ���')
	RETURN
END IF

//////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

// ������ ������ �����Ѵ�
If dw_detail.GetItemString(1,'iogbn') = 'I17' THEN
	string scvcod
	
	scvcod = dw_detail.GetItemstring(1, 'vendor')
	
	UPDATE DANMST_GITA A
		SET CUMMQTY = NVL(( SELECT SUM(B.SILQTY) FROM IMHIST B WHERE B.SABU = '1' AND B.IOGBN = 'I17' AND B.CVCOD = A.CVCOD AND B.ITNBR = A.ITNBR ),0)
	 WHERE A.CVCOD = :scvcod
		AND A.ITNBR >= '.' AND A.ITNBR <= 'zzzzzzzzzz';
	COMMIT;
End If

p_can.TriggerEvent("clicked")
	
	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_mod from uo_picture within w_imt_04000
integer x = 3890
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)
Long lrow

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		2. �����HISTORY : ��ǥä������('C0')
//////////////////////////////////////////////////////////////////////////////////

IF	wf_CheckRequiredField() = -1	THEN	RETURN 
	
IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_imhist_create() = -1		THEN	RETURN
	
ELSE
	
	String sIpno
	Decimal {2} dAmt
	
	For lrow = 1 to dw_list.rowcount()
		 dw_list.setitem(lrow, "silqty", dw_list.getitemdecimal(lrow,"ioqty"))
 		 dw_list.setitem(lrow, "ioprc",  dw_list.getitemdecimal(lrow,"ioamt"))		
		 dw_list.setitem(lrow, "silamt", dw_list.getitemdecimal(lrow,"ioamt"))		
		 
		 sIpno	=	dw_list.getitemstring(lrow, "iojpno")
		 dAmt		=  dw_list.getitemDecimal(lrow, "ioamt")
		 /* �ڵ� �����ǥ�� ���� */
		 Update imhist
		 	 Set ioprc = :dAmt,
			  	  ioamt = :dAmt
		  Where sabu = :gs_sabu and ip_jpno = :sIpno;

	Next
	
	IF dw_list.Update() <= 0		THEN
		ROLLBACK;
		f_Rollback()
	END IF

END IF

////////////////////////////////////////////////////////////////////////

IF dw_imhist.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

// ������ ������ �����Ѵ�
If dw_detail.GetItemString(1,'iogbn') = 'I17' THEN
	string scvcod
	
	scvcod = dw_detail.GetItemstring(1, 'vendor')
	
	UPDATE DANMST_GITA A
		SET CUMMQTY = NVL(( SELECT SUM(B.SILQTY) FROM IMHIST B WHERE B.SABU = '1' AND B.IOGBN = 'I17' AND B.CVCOD = A.CVCOD AND B.ITNBR = A.ITNBR ),0)
	 WHERE A.CVCOD = :scvcod
		AND A.ITNBR >= '.' AND A.ITNBR <= 'zzzzzzzzzz';
	COMMIT;
End If

dw_imhist.reset()
p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_inq from uo_picture within w_imt_04000
integer x = 3717
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event clicked;call super::clicked;//��ȸ��ư Ŭ��

w_mdi_frame.sle_msg.text =""

if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sVendor,		&
			sDept,		&
			sEmpno,		&
			sFrom, sTo,	&
			sNull, siogbn, sgubun, smadat, ssaupj, sitnbrr
long		lRow
SetNull(sNull)

//////////////////////////////////////////////////////////////////////////
sJpno   = dw_detail.GetItemString(1, "jpno")
sVendor = dw_detail.GetItemString(1, "vendor")
sDept	  = dw_detail.GetItemString(1, "dept")
sEmpno  = dw_detail.GetItemString(1, "empno")
sFrom	  = trim(dw_detail.GetItemString(1, "sdate"))
sTo	  = trim(dw_detail.GetItemString(1, "edate"))
siogbn  = dw_detail.GetItemString(1, "iogbn")
ssaupj  = dw_detail.GetItemString(1, "saupj")
sitnbrr  = dw_detail.GetItemString(1, "itnbrr")
	
IF ic_status = '1'	THEN
	
	IF isnull(sVendor) or sVendor = "" 	THEN
		f_message_chk(30, '[�ŷ�ó]')
		dw_detail.SetColumn("vendor")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sFrom) or sFrom = "" 	THEN
		f_message_chk(30, '[�Ⱓ]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sTo) or sTo = "" 	THEN
		f_message_chk(30, '[�Ⱓ]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF
	
	if sfrom > sto then
		f_message_chk(34, '[�Ⱓ]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	end if
	
	// �������ڸ� check�Ͽ� �������ڰ� �������� ������ ��� password��
	// check�Ͽ� ���(ȯ�漳�� y-23-2
	select max(jpdat)
	  into :smadat
	  from junpyo_closing
	 where sabu = '1' and jpgu = 'C0';	
	 
	if smadat+'99' > sfrom then
		open(w_imt_04000_pass)		
		String sPass
		
		sPass = message.stringparm
		
		if sPass = 'CANCEL' then
			RETURN			
		end if	
	end if
	
	
	IF sitnbrr = "" or isnull(sitnbrr) THEN 
		sitnbrr = '%'
	END IF	

	
	// ���ұ����� �˻��Ͽ� �������� �������� �˻��Ѵ�.
	select waigu into :sgubun from iomatrix where sabu = :gs_sabu and iogbn = :siogbn;

	IF	dw_list.Retrieve(gs_sabu, sVendor, sFrom, sTo, sgubun, ssaupj, sitnbrr) <	1		THEN
		f_message_chk(50, '')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		RETURN
	END IF

	FOR  lRow = 1	TO		dw_list.RowCount()
		dw_list.SetItem(lRow, "sdate", sFrom)
		dw_list.SetItem(lRow, "edate", sTo)
	NEXT

/////////////////////////////////////////////////////////////////////////////
ELSE
	
	IF isnull(sJpno) or sJpno = "" 	THEN
		f_message_chk(30, '[��ǥ��ȣ]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sJpno = sJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sJpno) <	1		THEN
		f_message_chk(50, '[��ǥ��ȣ]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		RETURN
	END IF
	
	// �ӽ÷� �ұ����� �԰������ �԰������ move
	FOR  lRow = 1	TO		dw_list.RowCount()
		dw_list.SetItem(lRow, "ioqty", dw_list.getitemdecimal(lrow, "silqty"))
	NEXT	
	
	p_del.enabled = true
	p_del.picturename = "C:\erpman\image\����_up.gif"

END IF


//////////////////////////////////////////////////////////////////////////

dw_list.SetColumn("ioqty")
dw_list.SetFocus()
p_mod.enabled = true
p_mod.picturename = "C:\erpman\image\����_up.gif"


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

type st_2 from statictext within w_imt_04000
integer x = 1778
integer y = 80
integer width = 942
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "�Ͻø� ���԰����� ��ȸ�˴ϴ�."
boolean focusrectangle = false
end type

type st_1 from statictext within w_imt_04000
integer x = 745
integer y = 80
integer width = 1001
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "�� �Ʒ��� ��ȸ�� ������ DOUBLE CLICK"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_imt_04000
integer x = 329
integer y = 72
integer width = 238
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
string text = "�հ�"
boolean checked = true
end type

event clicked;
ic_status = '1'	// ���

dw_list.DataObject = 'd_imt_04001'
dw_list.SetTransObject(sqlca)

//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

wf_Initial()
end event

type rb_1 from radiobutton within w_imt_04000
integer x = 50
integer y = 72
integer width = 238
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
string text = "����"
end type

event clicked;ic_status = '1'	// ���

dw_list.DataObject = 'd_imt_04003'
dw_list.SetTransObject(sqlca)

//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

wf_Initial()
end event

type cb_delete from commandbutton within w_imt_04000
boolean visible = false
integer x = 1490
integer y = 2452
integer width = 347
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "����(&D)"
end type

event clicked;//////////////////////////////////////////////////////////////////
///	* �԰��� ����
//////////////////////////////////////////////////////////////////
if dw_list.AcceptText() = -1 then return 

IF f_msg_delete() = -1 	THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	
	MessageBOx('Ȯ ��', '������ �ڷḦ �����ϼ���')
	RETURN
END IF

//////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

cb_cancel.TriggerEvent("clicked")
	
	

end event

type cb_cancel from commandbutton within w_imt_04000
boolean visible = false
integer x = 1902
integer y = 2448
integer width = 347
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

event clicked;
rb_insert.checked = true
rb_1.checked = true

rb_insert.TriggerEvent("clicked")


end event

type rb_delete from radiobutton within w_imt_04000
integer x = 4325
integer y = 336
integer width = 238
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "����"
end type

event clicked;
ic_status = '2'

dw_list.DataObject = 'd_imt_04002'
dw_list.SetTransObject(sqlca)


//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

rb_1.enabled = false
rb_2.enabled = false

wf_Initial()
end event

type rb_insert from radiobutton within w_imt_04000
integer x = 4320
integer y = 240
integer width = 238
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "���"
boolean checked = true
end type

event clicked;
ic_status = '1'	// ���

dw_list.DataObject = 'd_imt_04001'
dw_list.SetTransObject(sqlca)

rb_1.enabled = true
rb_2.enabled = true

//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

wf_Initial()
end event

type dw_imhist from datawindow within w_imt_04000
boolean visible = false
integer x = 96
integer y = 2364
integer width = 494
integer height = 212
boolean titlebar = true
string title = "�����HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event updatestart;/* Update() function ȣ��� user ���� */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type dw_detail from datawindow within w_imt_04000
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 196
integer width = 4201
integer height = 252
integer taborder = 10
string dataobject = "d_imt_04000"
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

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;//DW_DETAIL RBUTTONDOWN


gs_gubun = ''
gs_code  = ''
gs_codename = ''

string ls_itnbr
ls_itnbr = ''


// ��ǥ��ȣ
IF this.GetColumnName() = 'jpno'	THEN

	Open(w_006_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "jpno",		left(gs_code, 12))
	this.TriggerEvent("itemchanged")
	
ELSEIF this.GetColumnName() = 'vendor'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "vendor",		gs_code)
	SetItem(1, "vendorname",gs_codename)
	
ELSEIF this.GetColumnName() = 'dept'	THEN

	Open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "dept",	  gs_code)
	SetItem(1, "deptname", gs_codename)

ELSEIF this.GetColumnName() = 'empno'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "empno",   gs_code)
	SetItem(1, "empname", gs_codename)
	SetItem(1, "DEPT", gs_GUBUN)
	this.triggerEvent(itemchanged!)

ELSEIF this.GetColumnName() = 'itnbrr'	THEN

	Open(w_itemas_popup3)
	if Isnull(gs_code) or Trim(gs_code) = "" then gs_code='%'

	SetItem(1, "itnbrr", gs_code)
	
END IF



	



end event

event itemchanged;//DW_DETAIL ITEMCHANGED

string	sVendor, sVendorname,	&
			sDept, 	sDeptName,		&
			sEmpno,  sEmpname,		&
			sFromDate, sToDate,		&
			sDate,	sJpno,			&
			sNull, 	siogbn ,sitnbrr       
long		lRow

SetNull(sNull)

// �ŷ�ó
IF this.GetColumnName() = 'vendor'		THEN

	sVendor = this.gettext()
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD = :sVendor ;
//	   AND CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[�ŷ�ó]')
		this.setitem(1, "vendor", sNull)
		this.setitem(1, "vendorname", sNull)
		return 1
	end if
	
	this.setitem(1, "vendorname", sVendorName)
	 
ELSEIF this.GetColumnName() = 'dept'		THEN

	sDept = this.gettext()
	SELECT CVNAS2
	  INTO :sDeptName
	  FROM VNDMST
	 WHERE CVCOD = :sDept AND 
	 		 CVGU = '4'		 AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[�Ƿںμ�]')
		this.setitem(1, "dept", sNull)
		this.setitem(1, "deptname", sNull)
		return 1
	end if

	this.setitem(1, "deptname", sDeptName)
	 
ELSEIF this.GetColumnName() = 'empno'		THEN

	sEmpno = this.gettext()
	SELECT EMPNAME
	  INTO :sEmpname
	  FROM P1_MASTER
	 WHERE EMPNO = :sEmpno AND 
			 SERVICEKINDCODE <> '3' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[�Ƿڴ����]')
		this.setitem(1, "empno", sNull)
		this.setitem(1, "empname", sNull)
		return 1
	end if

	this.setitem(1, "empname", sEmpName)
	 
ELSEIF this.GetColumnName() = 'sdate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'edate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'idate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "idate", is_date)
		return 1
	END IF

END IF



//////////////////////////////////////////////////////////////////////////
// ��ǥ��ȣ
//////////////////////////////////////////////////////////////////////////
String  ls_saupj
ls_saupj = dw_detail.GetItemString(1, 'saupj')
IF (IsNull(ls_saupj) or ls_saupj = "" ) then
	f_message_chk(30, "[�����]")
   dw_detail.SetColumn( 'saupj')
	dw_detail.SetFocus()
	return -1
end if

IF this.GetColumnName() = 'jpno'	THEN

	sJpno = this.GetText()
	
	SELECT A.SUDAT,  A.CVCOD, A.IOREDEPT, A.IOREEMP, A.IOGBN, 
			 A.JUKSDAT, A.JUKEDAT, 
			 B.CVNAS2, C.CVNAS, D.EMPNAME 
	  INTO :sDate, :sVendor, :sDept, :sEmpno, :siogbn, 
	  		 :sFromDate, :sToDate, 
	  		 :sVendorName, :sDeptName, :sEmpName 
	  FROM IMHIST A, VNDMST B, VNDMST C, P1_MASTER D
	 WHERE A.CVCOD    = B.CVCOD(+)	AND
	 		 A.IOREDEPT = C.CVCOD(+)	AND	
			 A.IOREEMP  = D.EMPNO(+)	AND
	 		 A.SABU = :gs_sabu			AND
	 		 SUBSTR(A.IOJPNO,1,12) = :sJpno		AND
			 A.SAUPJ = :ls_saupj AND
			 A.JNPCRT = '006' ;
	 
	IF SQLCA.SQLCODE = 100	THEN
		f_message_chk(33,'[��ǥ��ȣ]')
		this.setitem(row, "jpno", sNull)
		RETURN 1
	END IF

	this.SetItem(1, "idate",   sDate)
	this.SetItem(1, "vendor",  sVendor)
	this.SetItem(1, "vendorname", sVendorName)
	this.SetItem(1, "dept",    sDept)
	this.SetItem(1, "deptname",sDeptname)
	this.SetItem(1, "empno",	sEmpno)
	this.SetItem(1, "empname", sEmpname)
	this.SetItem(1, "sdate",	sFromDate)
	this.SetItem(1, "edate", 	sToDate)
	this.SetItem(1, "iogbn", 	sIogbn)
END IF

//////////////////////////////////////////////////////////////////////////
// �ұ����뱸��
//////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'iogbn'	THEN
	// �������� ���
	If GetText() = 'I17' Then
		dw_list.DataObject = 'd_imt_04000_1'
	Else
		If rb_2.Checked Then
			dw_list.DataObject = 'd_imt_04001'
		Else
			dw_list.DataObject = 'd_imt_04003'
		End If
	End If
	dw_list.SetTransObject(sqlca)
End If
end event

type cb_save from commandbutton within w_imt_04000
boolean visible = false
integer x = 1129
integer y = 2452
integer width = 347
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

event clicked;SetPointer(HourGlass!)
Long lrow

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//////////////////////////////////////////////////////////////////////////////////
//		2. �����HISTORY : ��ǥä������('C0')
//////////////////////////////////////////////////////////////////////////////////

IF	wf_CheckRequiredField() = -1	THEN	RETURN 
	
IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. ��Ͻ� ��ǥ��ȣ ����
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	IF wf_imhist_create() = -1		THEN	RETURN
	
ELSE
	
	String sIpno
	Decimal {2} dAmt
	
	For lrow = 1 to dw_list.rowcount()
		 dw_list.setitem(lrow, "silqty", dw_list.getitemdecimal(lrow,"ioqty"))
 		 dw_list.setitem(lrow, "ioprc",  dw_list.getitemdecimal(lrow,"ioamt"))		
		 dw_list.setitem(lrow, "silamt", dw_list.getitemdecimal(lrow,"ioamt"))		
		 
		 sIpno	=	dw_list.getitemstring(lrow, "iojpno")
		 dAmt		=  dw_list.getitemDecimal(lrow, "ioamt")
		 /* �ڵ� �����ǥ�� ���� */
		 Update imhist
		 	 Set ioprc = :dAmt,
			  	  ioamt = :dAmt
		  Where sabu = :gs_sabu and ip_jpno = :sIpno;

	Next
	
	IF dw_list.Update() <= 0		THEN
		ROLLBACK;
		f_Rollback()
	END IF

END IF

////////////////////////////////////////////////////////////////////////

IF dw_imhist.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF


dw_imhist.reset()
cb_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from commandbutton within w_imt_04000
event key_in pbm_keydown
boolean visible = false
integer x = 2267
integer y = 2448
integer width = 347
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_retrieve from commandbutton within w_imt_04000
boolean visible = false
integer x = 768
integer y = 2452
integer width = 347
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ȸ(&R)"
end type

event clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sVendor,		&
			sDept,		&
			sEmpno,		&
			sFrom, sTo,	&
			sNull, siogbn, sgubun, smadat, ssaupj
long		lRow
SetNull(sNull)

//////////////////////////////////////////////////////////////////////////
sJpno   = dw_detail.GetItemString(1, "jpno")
sVendor = dw_detail.GetItemString(1, "vendor")
sDept	  = dw_detail.GetItemString(1, "dept")
sEmpno  = dw_detail.GetItemString(1, "empno")
sFrom	  = trim(dw_detail.GetItemString(1, "sdate"))
sTo	  = trim(dw_detail.GetItemString(1, "edate"))
siogbn  = dw_detail.GetItemString(1, "iogbn")
ssaupj  = dw_detail.GetItemString(1, "saupj")
	
IF ic_status = '1'	THEN
	
	IF isnull(sVendor) or sVendor = "" 	THEN
		f_message_chk(30, '[�ŷ�ó]')
		dw_detail.SetColumn("vendor")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sFrom) or sFrom = "" 	THEN
		f_message_chk(30, '[�Ⱓ]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sTo) or sTo = "" 	THEN
		f_message_chk(30, '[�Ⱓ]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF
	
	if sfrom > sto then
		f_message_chk(34, '[�Ⱓ]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	end if
	
	// �������ڸ� check�Ͽ� �������ڰ� �������� ������ ��� password��
	// check�Ͽ� ���(ȯ�漳�� y-23-2
	select max(jpdat)
	  into :smadat
	  from junpyo_closing
	 where sabu = '1' and jpgu = 'C0';	
	 
	if smadat+'99' > sfrom then
		open(w_imt_04000_pass)		
		String sPass
		
		sPass = message.stringparm
		
		if sPass = 'CANCEL' then
			RETURN			
		end if	
	end if
	
	
	// ���ұ����� �˻��Ͽ� �������� �������� �˻��Ѵ�.
	select waigu into :sgubun from iomatrix where sabu = :gs_sabu and iogbn = :siogbn;

	IF	dw_list.Retrieve(gs_sabu, sVendor, sFrom, sTo, sgubun, ssaupj) <	1		THEN
		f_message_chk(50, '')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		RETURN
	END IF

	FOR  lRow = 1	TO		dw_list.RowCount()
		dw_list.SetItem(lRow, "sdate", sFrom)
		dw_list.SetItem(lRow, "edate", sTo)
	NEXT

/////////////////////////////////////////////////////////////////////////////
ELSE
	
	IF isnull(sJpno) or sJpno = "" 	THEN
		f_message_chk(30, '[��ǥ��ȣ]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sJpno = sJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sJpno) <	1		THEN
		f_message_chk(50, '[��ǥ��ȣ]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		RETURN
	END IF
	
	// �ӽ÷� �ұ����� �԰������ �԰������ move
	FOR  lRow = 1	TO		dw_list.RowCount()
		dw_list.SetItem(lRow, "ioqty", dw_list.getitemdecimal(lrow, "silqty"))
	NEXT	
	
	cb_delete.enabled = true

END IF

//////////////////////////////////////////////////////////////////////////

dw_list.SetColumn("ioqty")
dw_list.SetFocus()
cb_save.enabled = true


end event

type gb_1 from groupbox within w_imt_04000
integer x = 37
integer y = 28
integer width = 549
integer height = 136
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_imt_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4288
integer y = 184
integer width = 288
integer height = 276
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_imt_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 184
integer width = 4247
integer height = 276
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_imt_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 713
integer y = 64
integer width = 2903
integer height = 88
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_5 from roundrectangle within w_imt_04000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 480
integer width = 4562
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 46
end type

