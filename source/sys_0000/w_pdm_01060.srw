$PBExportHeader$w_pdm_01060.srw
$PBExportComments$**â�� ���
forward
global type w_pdm_01060 from w_inherite
end type
type cb_1 from commandbutton within w_pdm_01060
end type
type dw_list from datawindow within w_pdm_01060
end type
type rr_1 from roundrectangle within w_pdm_01060
end type
end forward

global type w_pdm_01060 from w_inherite
string title = "â�� ���"
cb_1 cb_1
dw_list dw_list
rr_1 rr_1
end type
global w_pdm_01060 w_pdm_01060

forward prototypes
public function integer wf_requiredchk (integer il_currow)
end prototypes

public function integer wf_requiredchk (integer il_currow);String  sCode,sCodeName,sdptno, sgub1, steam, sittyp, sgub2, sipjogun

IF dw_insert.AcceptText() = -1 THEN RETURN -1

sCode     = trim(dw_insert.GetItemString(il_currow,"cvcod"))
sCodeName = trim(dw_insert.GetItemString(il_currow,"cvnas2")) 
sDptno    = trim(dw_insert.GetItemString(il_currow,"deptcode")) 
sgub1     = trim(dw_insert.GetItemString(il_currow,"jumaechul")) //����,�Ϲ� ����
steam     = trim(dw_insert.GetItemString(il_currow,"jumaeip"))   //������(������ ��츸)
sittyp    = trim(dw_insert.GetItemString(il_currow,"juprod"))    //ǰ�񱸺�
sgub2     = trim(dw_insert.GetItemString(il_currow,"juhandle"))  //����,���� ����
                      		                                      //(ǰ�񱸺��� ����ǰ�� ��츸) 
sipjogun  = trim(dw_insert.GetItemString(il_currow,"ipjogun"))  //�ΰ� �����

IF sCode ="" OR IsNull(sCode) THEN
	f_message_chk(1400,'[â�� �ڵ�]')
	dw_insert.SetColumn("cvcod")
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetFocus()
	Return -1
END IF 

IF sCodeName ="" OR IsNull(sCodeName) THEN
	f_message_chk(1400,'[â���]')
	dw_insert.SetColumn("cvnas2")
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetFocus()
	Return -1
END IF 
//�������� ����/�Ϲݱ����� ������ ��츸
if sgub1 = '1' then 
	IF steam ="" OR IsNull(steam) THEN
		f_message_chk(1400,'[������]')
		dw_insert.SetColumn("jumaeip")
		dw_insert.ScrollToRow(il_currow)
		dw_insert.SetFocus()
		Return -1
	END IF 
end if

IF sdptno ="" OR IsNull(sdptno) THEN
	f_message_chk(1400,'[�μ�]')
	dw_insert.SetColumn("deptcode")
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetFocus()
	Return -1
END IF 

//����/���ⱸ���� ǰ�񱸺��� ����ǰ�� ��츸
if sittyp = '1' then 
	IF sgub2 ="" OR IsNull(sgub2) THEN
		f_message_chk(1400,'[����/���� ����]')
		dw_insert.SetColumn("juhandle")
		dw_insert.ScrollToRow(il_currow)
		dw_insert.SetFocus()
		Return -1
	END IF 
end if

IF sipjogun ="" OR IsNull(sipjogun) THEN
	f_message_chk(1400,'[�ΰ������]')
	dw_insert.SetColumn("ipjogun")
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetFocus()
	Return -1
END IF 


dw_insert.setitem(il_currow,"cvnas", sCodeName)

Return 1
end function

on w_pdm_01060.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_list=create dw_list
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdm_01060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;call super::open;ib_any_typing = false

dw_list.SetTransObject(sqlca)
dw_list.retrieve()
dw_insert.SetTransObject(sqlca)

dw_insert.insertrow(0)
dw_insert.setitem(1, 'sabu', '1')
dw_insert.setcolumn('cvcod')
dw_insert.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01060
integer x = 1403
integer y = 192
integer width = 2679
integer height = 2136
integer taborder = 20
string dataobject = "d_pdm_01060"
boolean border = false
end type

event dw_insert::itemchanged;string sCode,snull,get_nm, s_itt, s_name, s_name2, s_check
int    lrow, ireturn, lcnt
SetNull(snull)

lRow = this.GetRow()

IF this.GetColumnName() ="cvcod" THEN
	
	sCode = this.GetText()
	
  SELECT "VNDMST"."CVNAS2"  
    INTO :get_nm  
    FROM "VNDMST"  
   WHERE ( "VNDMST"."CVCOD" = :scode ) AND  
         ( "VNDMST"."CVGU" <> '5' )   ;

   IF sqlca.sqlcode = 0 then 
		f_message_chk(1,'[â�� ��]')
		this.SetItem(lRow, "cvcod", sNull)
		RETURN  1
	END IF
	
  SELECT "VNDMST"."CVNAS2"  
    INTO :get_nm  
    FROM "VNDMST"  
   WHERE ( "VNDMST"."CVCOD" = :scode ) AND  
         ( "VNDMST"."CVGU" = '5' )   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.Retrieve(scode) 
		this.SetTaborder('cvcod',0)
		this.Modify("cvcod.BackGround.Color= 79741120") 
		this.setcolumn('cvnas2')
		this.setfocus()
		ib_any_typing = FALSE
	END IF

ELSEIF this.GetColumnName() ="jumaechul" THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(lRow, "jumaeip", sNull)
   	return 
   end if	
	
	If s_itt <> '3' Then
		If s_itt <> '4' Then
			This.SetItem(row, 'danmock', sNull)
			This.SetItem(row, 'cvname' , sNull)
		End If
	End If
	
	if s_itt <> '1' then //����/�Ϲ� ���п��� ������ �ƴϸ� ������ ������
//		this.SetItem(lRow, "jumaeip", sNull)
   	return 
   end if

ELSEIF this.GetColumnName() ="jumaeip" THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN RETURN
	
	s_name = f_get_reffer('03', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[������]')
		this.SetItem(lRow, "jumaeip", sNull)
   	return 1
   end if	
ELSEIF this.GetColumnName() ="deptcode" THEN
	s_itt = this.gettext()
 
   ireturn = f_get_name2('�μ�', 'Y', s_itt, s_name, s_name2)
	this.SetItem(lRow, "deptcode", s_itt)
	this.SetItem(lRow, "dptnm", s_name)
  	return ireturn 
ELSEIF this.GetColumnName() ="juprod" THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(lRow, "juhandle", sNull)
   	return 
   end if	
	
	if s_itt <> '1' then //����/�Ϲ� ���п��� ������ �ƴϸ� ������ ������
		this.SetItem(lRow, "juhandle", sNull)
   	return 
   end if	
ELSEIF this.GetColumnName() ="kyungy" THEN
	s_itt 	= this.gettext()
	scode	= getitemstring(1, "cvcod")
	// ��� Minus����� ��쿡�� �ش�â�� ��� Minus�� �߻���
	// �ȵǾ� �־����
	if s_itt = 'N' then
		Lcnt = 0
		Select sum(Decode(Sign(jego_Qty), 1, 0, 1))
		  Into :lcnt
		  From stock
		 Where depot_no = :scode;
		if Lcnt > 0 then
			If MessageBox("���Ȯ��", "���� â�� Minus�� �� ��� �����ϴ�" + '~n' + &
										  "Minus ��� ������ ��� �����Ͻðڽ��ϱ�?", Question!, OKCancel! ) = 2 Then
				setitem(1, "kyungy", 'Y')
				return 1
			End If
//			MessageBox("���Ȯ��", "���� â�� Minus�� �� ��� �����ϴ�" + '~n' + &
//										  "Minus��� ����� ���� ��쿡�� �� ǰ���̶�" + '~n' + &
//										  "Minus�� �߻��Ͽ� ������ ������ �� �����ϴ�", stopsign!)
//			setitem(1, "kyungy", 'N')
//			return 1
		End if;
	End if
 
ELSEIF this.GetColumnName() ="rewapunish" THEN
	s_itt = this.gettext()
	scode	= getitemstring(1, "cvcod")	
	// ������� Minus����� ��쿡�� �ش�â�� ������� Minus�� �߻���
	// �ȵǾ� �־����
	if s_itt = 'N' then
		Lcnt = 0
		Select sum(Decode(Sign(valid_Qty), 1, 0, 1))
		  Into :lcnt
		  From stock
		 Where depot_no = :scode;
		if Lcnt > 0 then
			MessageBox("�������Ȯ��", "���� â�� Minus�� �� ������� �����ϴ�" + '~n' + &
										  "Minus ������� ����� ���� ��쿡�� �� ǰ���̶�" + '~n' + &
										  "Minus�� �߻��Ͽ� ������ ������ �� �����ϴ�", stopsign!)
			setitem(1, "rewapunish", 'Y')
			return 1
		End if;
	End if	
END IF



end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "deptcode" THEN
	Open(w_sys_dept_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(this.getrow(), "deptcode", gs_Code)
	this.SetItem(this.getrow(), "dptnm", gs_Codename)
ElseIf This.GetColumnName() = 'danmock' Then
	Open(w_vndmst_popup)
	
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(row, 'danmock', gs_code)
	This.SetItem(row, 'cvname' , gs_codename)
END IF
end event

event dw_insert::updatestart;/* Update() function ȣ��� user ���� */
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

type p_delrow from w_inherite`p_delrow within w_pdm_01060
boolean visible = false
integer x = 2290
integer y = 2400
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01060
boolean visible = false
integer x = 2117
integer y = 2400
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdm_01060
boolean visible = false
integer x = 1422
integer y = 2400
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdm_01060
boolean visible = false
integer x = 1943
integer y = 2400
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdm_01060
integer x = 3753
integer y = 36
end type

type p_can from w_inherite`p_can within w_pdm_01060
integer x = 3579
integer y = 36
end type

event p_can::clicked;call super::clicked;dw_list.retrieve()

dw_insert.SetReDraw(false)
dw_insert.reset()
dw_insert.insertrow(0)

dw_insert.setitem(1, 'sabu', '1')

dw_insert.SetTaborder('cvcod',10)
//dw_insert.Modify("cvcod.BackGround.Color= 12639424") 
dw_insert.setcolumn('cvcod')
dw_insert.setfocus()

dw_insert.SetRedraw(true)

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdm_01060
boolean visible = false
integer x = 1595
integer y = 2400
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdm_01060
boolean visible = false
integer x = 1769
integer y = 2400
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_pdm_01060
integer x = 3406
integer y = 36
end type

event p_del::clicked;call super::clicked;string scvcod
Long Lrow

if dw_insert.accepttext() = -1 then return 

IF f_msg_delete() = -1 THEN RETURN
	
scvcod = dw_insert.getitemstring(1, 'cvcod')

// â���ڵ尡 �����ϴ����� ����Check
Lrow = 0
Select 1 into :Lrow
  From stock
 Where depot_no = :sCvcod And rownum = 1;
 
If Lrow > 0  then
	MessageBox("â���ڵ�", "�̹� �����Ϸ��� â���ڵ�� �ڷᰡ ���������ϴ�", stopsign!)
	return
End if
 
// ǥ�ذ����� ���� â�� �ش� â���ڵ尡 �����ϴ����� ����Check
Lrow = 0
Select 1 into :Lrow
  From Routng
 Where depot_no = :sCvcod And rownum = 1;
 
If Lrow > 0  then
	MessageBox("ǥ�ذ���", "�̹� �����Ϸ��� â���ڵ尡 ǥ�� ������ ~r���� â��� ��ϵǾ� �ֽ��ϴ�.", stopsign!)
	return
End if

DELETE FROM "VNDMST"  
 WHERE ( "VNDMST"."CVCOD" = :scvcod ) AND  
		 ( "VNDMST"."CVGU" = '5' )   ;

IF sqlca.sqlcode >= 0 THEN
	commit;
	ib_any_typing =False
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
ELSE
	rollback;
	ib_any_typing =True
	sle_msg.text ="�ڷ� ���� ����!!"
	Return
END IF

cb_can.TriggerEvent(Clicked!)

end event

type p_mod from w_inherite`p_mod within w_pdm_01060
integer x = 3232
integer y = 36
end type

event p_mod::clicked;call super::clicked;IF dw_insert.Accepttext() = -1 THEN RETURN

IF Wf_RequiredChk(1) = -1 THEN RETURN

// ����޼��� function
IF f_msg_update() = -1 THEN RETURN

IF dw_insert.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

cb_can.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdm_01060
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01060
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01060
integer x = 649
integer y = 2408
end type

type cb_del from w_inherite`cb_del within w_pdm_01060
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01060
integer x = 302
integer y = 2404
end type

event cb_inq::clicked;call super::clicked;string s_cvcod

if dw_insert.accepttext() <> 1 then return 

s_cvcod = dw_insert.getitemstring(1, "cvcod")

// â���ڵ带 �Է����� �ʰ� [��ȸ]�� click�� ���
if s_cvcod = "" or isnull(s_cvcod) then 
	f_message_chk(30,'[â���ڵ�]')
	dw_insert.setcolumn("cvcod")
	dw_insert.setfocus()
   return 
end if	

dw_insert.setredraw(false)	 

if dw_insert.retrieve(s_cvcod) <= 0 then
  	f_message_chk(50,'[â�� ����]')
   cb_can.TriggerEvent(Clicked!)
//	dw_insert.setcolumn("cvcod")
//	dw_insert.setfocus()
   dw_insert.setredraw(true)	
	return
end if

dw_insert.setredraw(true)	

ib_any_typing = false


end event

type cb_print from w_inherite`cb_print within w_pdm_01060
integer x = 983
integer y = 2408
end type

type st_1 from w_inherite`st_1 within w_pdm_01060
integer x = 0
integer y = 2512
integer width = 361
end type

type cb_can from w_inherite`cb_can within w_pdm_01060
end type

type cb_search from w_inherite`cb_search within w_pdm_01060
integer x = 1317
integer y = 2408
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01060
integer x = 2811
integer y = 2512
integer width = 741
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01060
integer x = 366
integer y = 2512
integer width = 2446
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01060
integer x = 18
integer y = 2408
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01060
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01060
end type

type cb_1 from commandbutton within w_pdm_01060
boolean visible = false
integer x = 2674
integer y = 2412
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "�߰�(&A)"
end type

type dw_list from datawindow within w_pdm_01060
event ue_key pbm_dwnkey
integer x = 370
integer y = 204
integer width = 1019
integer height = 2100
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01060_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose
end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE

	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	
   if dw_insert.Retrieve(this.GetItemString(Row,"cvcod")) <= 0 then
		f_message_chk(56, '[â�� �ڵ�]')
		return 
   else
		dw_insert.SetTaborder('cvcod',0)
//		dw_insert.Modify("cvcod.BackGround.Color= 79741120") 
      dw_insert.setcolumn('cvnas2')
      dw_insert.setfocus()
	end if	
END IF
ib_any_typing = FALSE

end event

type rr_1 from roundrectangle within w_pdm_01060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 357
integer y = 196
integer width = 1042
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

