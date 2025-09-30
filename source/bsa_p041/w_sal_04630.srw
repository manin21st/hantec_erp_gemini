$PBExportHeader$w_sal_04630.srw
$PBExportComments$�����ں� �������� ��Ȳ
forward
global type w_sal_04630 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04630
end type
type rr_1 from roundrectangle within w_sal_04630
end type
end forward

global type w_sal_04630 from w_standard_print
string title = "�����ں� �������� ��Ȳ"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_04630 w_sal_04630

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_datef, tx_name, sgbn ,ls_saupj ,ls_emp_id

If dw_ip.accepttext() <> 1 Then Return -1

s_datef   = Trim(dw_ip.getitemstring(1,"sdatef"))
sgbn      =      dw_ip.getitemstring(1,"gbn")
ls_saupj  =      dw_ip.getitemstring(1,'saupj')
ls_emp_id = dw_ip.getitemstring(1,'emp_id')

//�ʼ��Է��׸� üũ///////////////////////////////////
If f_datechk(s_datef) <> 1  then
	f_message_chk(30,'[��������]')
	dw_ip.setfocus()
	Return -1
End if

If ls_saupj = "" Or Isnull(ls_saupj) Then ls_saupj = '%'
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'

//��ȸ////////////////////////////////////////////////
//dw_list.SetRedraw(False)
//dw_list.SetFilter('')
//dw_list.Filter()
//
//IF dw_list.retrieve(gs_sabu, s_datef ,ls_saupj ,ls_emp_id) <= 0 THEN
//   f_message_chk(50,'['+This.title+']')
//	dw_ip.setfocus()
//	SetPointer(Arrow!)
//	Return -1
//END IF
//
///* 2ȸ�̻� �Աݵ� ������ �˻� */
//If sgbn = 'Y' Then
//	dw_list.SetFilter('group_cnt > 1')
//Else
//	dw_list.SetFilter('')
//End If
//dw_list.Filter()
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
//dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
//
//dw_list.SetRedraw(True)
//

dw_list.SetRedraw(False)
dw_print.SetFilter('')
dw_print.Filter()

IF dw_print.retrieve(gs_sabu, s_datef ,ls_saupj ,ls_emp_id) <= 0 THEN
   f_message_chk(50,'['+This.title+']')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

/* 2ȸ�̻� �Աݵ� ������ �˻� */
If sgbn = 'Y' Then	
	dw_print.SetFilter('group_cnt > 1')
Else	
	dw_print.SetFilter('')
End If

dw_print.Filter()

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

dw_list.SetRedraw(True)


Return 0
end function

on w_sal_04630.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_04630.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;/* User�� ���ұ��� Setting */
String sarea, steam, saupj
Long   rtncode
datawindowchild state_child 

f_mod_saupj(dw_ip, 'saupj')

//���������
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ���������")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 


end event

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

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

dw_ip.SetTransObject(SQLCA)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //ȸ���� ���
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*����*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*���� üũ- ���� ����*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*�ڱ�*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*���� üũ- ���� ����*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_04630
string picturename = "C:\ERPMAN\image\�̸�����_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_04630
string picturename = "C:\ERPMAN\image\�ݱ�_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_04630
string picturename = "C:\ERPMAN\image\�μ�_d.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04630
string picturename = "C:\ERPMAN\image\��ȸ_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_04630
end type



type dw_print from w_standard_print`dw_print within w_sal_04630
string dataobject = "d_sal_04630_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04630
integer x = 46
integer y = 24
integer width = 3877
integer height = 228
string dataobject = "d_sal_04630_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sDateFrom, sDateTo, snull, sPrtGbn, ls_saupj, ls_emp_id
Long    rtncode 
datawindowchild state_child 

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[��������]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	/* �ڷᱸ�� */
	Case 'prtgbn'
		sPrtGbn = this.GetText()
		
		dw_list.SetRedraw(False)
		IF sPrtGbn = '1' THEN													/* �����ں� */
			dw_list.DataObject = 'd_sal_04630'
			dw_print.DataObject = 'd_sal_04630_p'
		ELSEIF sPrtGbn = '2' THEN												/* �ŷ�ó�� */
			dw_list.DataObject = 'd_sal_046301'
			dw_print.DataObject = 'd_sal_046301_p'
		END IF
		dw_print.SetTransObject(SQLCA)
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		dw_list.SetRedraw(True)
		
		p_preview.Enabled = False
		p_print.Enabled = False
		p_preview.PictureName = 'C:\ERPMAN\image\�̸�����_d.gif'
		p_print.PictureName = 'C:\ERPMAN\image\�μ�_d.gif'
		
	Case 'gbn'
		sPrtGbn = Trim(GetText())
		
		dw_list.SetRedraw(False)
		If dw_list.RowCount() > 0 Then
			If sPrtGbn = 'Y' Then
				dw_list.SetFilter('group_cnt > 1')
			Else
				dw_list.SetFilter('')
			End If
		End If
		dw_list.Filter()
		dw_list.SetRedraw(True)
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 

		//���������
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ���������")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1] 
//		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'emp_id', '')
//		End if 

		
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04630
integer x = 59
integer y = 264
integer width = 4535
integer height = 2060
string dataobject = "d_sal_04630"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_04630
integer x = 718
integer y = 36
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer weight = 700
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('sdatef')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type rr_1 from roundrectangle within w_sal_04630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 256
integer width = 4562
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

