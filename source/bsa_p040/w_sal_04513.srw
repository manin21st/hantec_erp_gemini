$PBExportHeader$w_sal_04513.srw
$PBExportComments$ ===> ����ȸ���� ��Ȳ
forward
global type w_sal_04513 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04513
end type
type pb_2 from u_pb_cal within w_sal_04513
end type
type rr_1 from roundrectangle within w_sal_04513
end type
end forward

global type w_sal_04513 from w_standard_print
string title = "���� ȸ���� ��Ȳ"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_04513 w_sal_04513

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSarea, sSDate, sEDate, sNull, sCvcod, sSaupj, tx_name, sGubun ,ls_emp_id

SetNull(sNull)

If dw_ip.AcceptText() <> 1 Then Return 1

sSarea = Trim(dw_ip.GetItemString(1,'sarea'))
sCvcod = Trim(dw_ip.GetItemString(1,'cvcod'))
ls_emp_id = dw_ip.getitemstring(1,'emp_id')

If IsNull(sSarea) Then	sSarea = '%'
If IsNull(sCvcod) Then	sCvcod = ''

sGubun = Trim(dw_ip.GetItemString(1,'pgubun'))
If IsNull(sGubun) Or sGubun = '' Then sGubun = '1'

dw_ip.SetFocus()

sSaupj = Trim(dw_ip.GetItemString(1,'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_Message_Chk(1400, '[�ΰ������]')
	dw_ip.setcolumn("saupj")
	return -1
end if

// �������� ��ȿ�� Check
sSDate = Trim(dw_ip.GetItemString(1,'start_date'))
If f_DateChk(sSdate) = -1 then
	f_Message_Chk(35, '[��������]')
	dw_ip.SetItem(1, "start_date", sNull)
	dw_ip.setcolumn("start_date")
	return -1
End If
		
// ������ ��ȿ�� Check
sEDate = Trim(dw_ip.GetItemString(1,'end_date'))
If f_DateChk(sEdate) = -1 then
	f_Message_Chk(35, '[��������]')
	dw_ip.SetItem(1, "end_date", sNull)
	dw_ip.setcolumn("end_date")
	return -1
End if

If	( sSDate > sEDate ) then
	f_message_Chk(200, '[���� �� ������ CHECK]')
	dw_ip.setcolumn("start_date")
	Return -1
End if

if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%' 

if dw_print.Retrieve(gs_sabu, sSarea+'%', sCvcod+'%', sSDate, sEDate, sSaupj, sGubun,ls_emp_id ) < 1 then
	f_message_Chk(300, '[������� CHECK]')
	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

dw_print.object.s_date.Text = Left(sSDate,4)+'.'+Mid(sSDate,5,2)+'.'+Right(sSDate,2)
dw_print.object.e_date.Text = Left(sEDate,4)+'.'+Mid(sEDate,5,2)+'.'+Right(sEDate,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

return 1


//if dw_list.Retrieve(gs_sabu, sSarea+'%', sCvcod+'%', sSDate, sEDate, sSaupj, sGubun,ls_emp_id ) < 1 then
//	f_message_Chk(300, '[������� CHECK]')
//	dw_ip.setcolumn('sarea')
//	dw_ip.setfocus()
//	return -1
//end if
//
//dw_list.object.s_date.Text = Left(sSDate,4)+'.'+Mid(sSDate,5,2)+'.'+Right(sSDate,2)
//dw_list.object.e_date.Text = Left(sEDate,4)+'.'+Mid(sEDate,5,2)+'.'+Right(sEDate,2)
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
//dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
//
//return 1
//
end function

on w_sal_04513.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_04513.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;String sToday

sle_msg.text = "��������� �Է��ϰ� ��ȸ������ ��������"

sToday = f_today()
dw_ip.SetItem(1, 'start_date', left(sToday,6) + '01')
dw_ip.SetItem(1, 'end_date', sToday)

/* User�� ���ұ��� Setting */
String sarea, steam, saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'saupj', saupj)
//	dw_ip.SetItem(1, 'sarea', sarea)
//	dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//End If

/* �ΰ� ����� */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj') 

DataWindowChild state_child
integer rtncode

//���� ����
f_child_saupj(dw_ip, 'sarea', gs_saupj) 

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

type p_preview from w_standard_print`p_preview within w_sal_04513
integer x = 4064
end type

type p_exit from w_standard_print`p_exit within w_sal_04513
integer x = 4411
end type

type p_print from w_standard_print`p_print within w_sal_04513
integer x = 4238
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04513
integer x = 3890
end type







type st_10 from w_standard_print`st_10 within w_sal_04513
end type



type dw_print from w_standard_print`dw_print within w_sal_04513
string dataobject = "d_sal_04513_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04513
integer x = 23
integer y = 32
integer width = 3621
integer height = 224
string dataobject = "d_sal_04513_1"
end type

event dw_ip::itemchanged;String sNull, ls_saupj, scode
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long rtncode
Datawindowchild state_child
SetNull(sNull)

Choose Case GetColumnName()
	// ��±��� ���ý�
	Case "gubun"
		if this.GetText() = '1' then
         dw_ip.SetItem(1, 'start_date', f_today())
         dw_ip.SetItem(1, 'end_date', f_today())
		elseif this.GetText() = '2' then
         dw_ip.SetItem(1, 'start_date', Left(f_today(),6) + '01')
         dw_ip.SetItem(1, 'end_date', f_last_date(Left(f_today(),6)))
		else
         dw_ip.SetItem(1, 'start_date', sNull)
         dw_ip.SetItem(1, 'end_date', sNull)
		end if
		
   // �������� ��ȿ�� Check
	Case "start_date"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[��������]')
			this.SetItem(1, "start_date", sNull)
			return 1
		end if
		
	// ������ ��ȿ�� Check
   Case "end_date"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "end_date", sNull)
			f_Message_Chk(35, '[��������]')
			return 1
		end if
	/* ���ұ��� */
	Case "sarea"
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvcodnm",sNull)
	/* �ŷ�ó */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"sarea",   sarea)
				SetItem(1,"cvcodnm",	scvnas)
			else
				Messagebox('Ȯ��', scvnas + '[ ' + sCvcod +  ' ]�� ��ϵ� ����� �ٸ��ϴ�. ~n ����� ������ Ȯ���ϼ���' )
			End if 
		END IF
	/* �ŷ�ó�� */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,'cvcod', sCvcod)
				SetItem(1,"cvcodnm", scvnas)
			else
				Messagebox('Ȯ��', scvnas + '[ ' + sCvcod +  ' ]�� ��ϵ� ����� �ٸ��ϴ�. ~n ����� ������ Ȯ���ϼ���' )
			End if 
			Return 1
		END IF
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam, ls_emp_id  
		ls_saupj = gettext() 
		//�ŷ�ó
		sCode 	= this.object.cvcod[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
		End if 
 
		//���� ����
		f_child_saupj(dw_ip, 'sarea', ls_saupj)
		ls_sarea = dw_ip.object.sarea[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'sarea', '')
		End if 

		//���������
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - ���������")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1] 
		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'emp_id', '')
		End if 
	
end Choose

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04513
integer x = 46
integer y = 276
integer width = 4526
integer height = 2032
string dataobject = "d_sal_04513"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_04513
integer x = 686
integer y = 136
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('start_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'start_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_04513
integer x = 1143
integer y = 136
integer height = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('end_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'end_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_04513
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 268
integer width = 4553
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

