$PBExportHeader$w_sal_04800.srw
$PBExportComments$��ǰ���� ��Ȳ
forward
global type w_sal_04800 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04800
end type
type pb_2 from u_pb_cal within w_sal_04800
end type
type rr_1 from roundrectangle within w_sal_04800
end type
end forward

global type w_sal_04800 from w_standard_print
integer height = 2440
string title = "��ǰ���� ��Ȳ"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_04800 w_sal_04800

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String frdate, todate, sSaupj, tx_name ,ls_emp_id		

If dw_ip.accepttext() <> 1 Then Return -1

frdate    = trim(dw_ip.getitemstring(1, 'frdate'))
todate    = trim(dw_ip.getitemstring(1, 'todate'))
ssaupj    = dw_ip.getitemstring(1,"saupj")
ls_emp_id = dw_ip.getitemstring(1,'emp_id')

IF	f_datechk(frdate) = -1  Or f_datechk(todate) = -1 then
	MessageBox("Ȯ��","���ڸ� Ȯ���ϼ���!")
	dw_ip.setcolumn('frdate')
	dw_ip.setfocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[�ΰ������]')
//	dw_ip.SetFocus()
//	Return -1
//End If

if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'
//////////////////////////////////////////////////////// �˻�
SetPointer(HourGlass!)

dw_list.SetRedraw(False)

//If dw_list.retrieve(gs_sabu, frdate, todate, ssaupj,ls_emp_id) < 1	then
//	f_message_chk(50,"")
//	dw_ip.setcolumn('frdate')
//	dw_ip.setfocus()
//	return -1
//End If

If dw_print.retrieve(gs_sabu, frdate, todate, ssaupj,ls_emp_id) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('frdate')
	dw_ip.setfocus()
	return -1
End If

dw_print.ShareData(dw_list)

if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
//dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 1


end function

on w_sal_04800.create
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

on w_sal_04800.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;string sDate

sDate = f_today()
dw_ip.SetItem(1,'frdate',left(sDate,6)+'01' )
dw_ip.SetItem(1,'todate',sDate)

sle_msg.text = "��¹� - ����ũ�� : A4, ��¹��� : ���ι���"

/* User�� ���ұ��� Setting */
String sarea, steam , saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'saupj', saupj)
//End If
//
DataWindowChild state_child
integer rtncode

/* ����� ���� */
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

type p_preview from w_standard_print`p_preview within w_sal_04800
end type

type p_exit from w_standard_print`p_exit within w_sal_04800
end type

type p_print from w_standard_print`p_print within w_sal_04800
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04800
end type

type st_window from w_standard_print`st_window within w_sal_04800
boolean visible = true
end type

type sle_msg from w_standard_print`sle_msg within w_sal_04800
boolean visible = true
end type

type dw_datetime from w_standard_print`dw_datetime within w_sal_04800
boolean visible = true
end type

type st_10 from w_standard_print`st_10 within w_sal_04800
boolean visible = true
end type

type gb_10 from w_standard_print`gb_10 within w_sal_04800
boolean visible = true
end type

type dw_print from w_standard_print`dw_print within w_sal_04800
string dataobject = "d_sal_04800_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04800
integer y = 24
integer width = 2391
integer height = 224
string dataobject = "d_sal_04800_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;string sCol
str_itnct str_sitnct

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
		Case   "itnbr" 
  		    open(w_itemas_popup4)
		    if IsNull(gs_code) or gs_code = "" then return
		    SetItem(1,"itnbr",gs_code)
          SetItem(1,"itnbrnm",gs_codename)		
	   Case  'itcls'
		    open(w_ittyp_popup3)
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	




end event

event dw_ip::itemchanged;call super::itemchanged;Long nRow
String sNull

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case	GetColumnName() 
	Case "frdate","todate"
		IF f_datechk(trim(gettext())) = -1	then
			f_message_chk(35,'[�Ⱓ]')
			Setitem(1, GetColumnName(), sNull)
			return 1
		END IF
	case 'saupj ' 
		STRING ls_return, ls_sarea , ls_steam, ls_emp_id, ls_saupj
		long   rtncode
		datawindowchild state_child 
		
		//�ŷ�ó
		ls_saupj = gettext() 

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
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04800
integer x = 55
integer y = 268
integer width = 4526
integer height = 2056
string dataobject = "d_sal_04800"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_sal_04800
integer x = 768
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('frdate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'frdate', gs_code)
end event

type pb_2 from u_pb_cal within w_sal_04800
integer x = 1230
integer y = 36
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('todate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'todate', gs_code)
end event

type rr_1 from roundrectangle within w_sal_04800
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 256
integer width = 4558
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

