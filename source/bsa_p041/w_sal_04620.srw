$PBExportHeader$w_sal_04620.srw
$PBExportComments$���� �̵��� ���� ��Ȳ
forward
global type w_sal_04620 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04620
end type
type rr_1 from roundrectangle within w_sal_04620
end type
end forward

global type w_sal_04620 from w_standard_print
string title = "���� �̵��� ���� ��Ȳ"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_04620 w_sal_04620

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_cvcod, s_datef,s_datet, sdeptcode, sareacode, tx_name ,ls_emp_id

If dw_ip.accepttext() <> 1 Then Return -1

s_datef = dw_ip.getitemstring(1,"sdatef")
s_datet = dw_ip.getitemstring(1,"sdatet")
s_cvcod = dw_ip.getitemstring(1,"custcode")
sdeptcode = dw_ip.getitemstring(1,"deptcode")
sareacode = dw_ip.getitemstring(1,"areacode")
ls_emp_id  = dw_ip.getitemstring(1,'emp_id')

//�ʼ��Է��׸� üũ///////////////////////////////////
if f_datechk(s_datef) <> 1  then
	f_message_chk(30,'[��������]')
	dw_ip.setfocus()
	return -1
end if

If IsNull(s_cvcod ) Then s_cvcod = ''
If IsNull(sdeptcode ) Then sdeptcode = ''
If IsNull(sareacode ) Then sareacode = ''
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'

//��ȸ////////////////////////////////////////////////
//IF dw_list.retrieve(gs_sabu, s_datef, sdeptcode+'%',sareacode+'%',s_cvcod+'%',ls_emp_id) <= 0 THEN
//   f_message_chk(50,'['+This.title+']')
//	dw_ip.setfocus()
//	SetPointer(Arrow!)
//	Return -1
//END IF

IF dw_print.retrieve(gs_sabu, s_datef, sdeptcode+'%',sareacode+'%',s_cvcod+'%',ls_emp_id) <= 0 THEN
   f_message_chk(50,'['+This.title+']')
	dw_ip.setfocus()
	SetPointer(Arrow!)	
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1,'custcode'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("txt_cvcod.text = '"+tx_name+"'")

Return 0
end function

on w_sal_04620.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_04620.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;/* User�� ���ұ��� Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If
dw_ip.SetItem(1, "deptcode", steam)
dw_ip.SetItem(1, "areacode", sarea)

dw_ip.SetItem(1,"sdatef", is_today)
end event

type p_preview from w_standard_print`p_preview within w_sal_04620
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_sal_04620
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_sal_04620
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04620
integer x = 3899
boolean originalsize = true
end type







type st_10 from w_standard_print`st_10 within w_sal_04620
end type



type dw_print from w_standard_print`dw_print within w_sal_04620
string dataobject = "d_sal_04620_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04620
integer x = 27
integer y = 28
integer width = 3456
integer height = 196
string dataobject = "d_sal_04620_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[�ԱݱⰣ]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[�ԱݱⰣ]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	/* ������ */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* ���ұ��� */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sarea = this.GetText()
		IF sarea = "" OR IsNull(sarea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sarea   ;
		
		SetItem(1,'deptcode',steam)
	/* �ŷ�ó */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "custcode", sNull)
			SetItem(1, "custname", snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
			SetItem(1,"areacode",   sarea)
			SetItem(1,"custname",	scvnas)
		END IF
	/* �ŷ�ó�� */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "custcode", sNull)
			SetItem(1, "custname", snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
			SetItem(1,"areacode",   sarea)
			SetItem(1,"custcode", sCvcod)
			SetItem(1,"custname", scvnas)
			Return 1
		END IF
END Choose
end event

event dw_ip::rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* �ŷ�ó */
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_04620
integer x = 46
integer y = 260
integer width = 4526
integer height = 2044
string dataobject = "d_sal_04620"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_04620
integer x = 695
integer y = 36
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('sdatef')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type rr_1 from roundrectangle within w_sal_04620
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 252
integer width = 4553
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

