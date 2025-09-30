$PBExportHeader$w_kbgb05.srw
$PBExportComments$�⿹�� �ϰ�����
forward
global type w_kbgb05 from w_inherite
end type
type dw_list from datawindow within w_kbgb05
end type
end forward

global type w_kbgb05 from w_inherite
string title = "�⿹�� �ϰ�����"
dw_list dw_list
end type
global w_kbgb05 w_kbgb05

on w_kbgb05.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_kbgb05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
end on

event open;call super::open;dw_list.SetTransObject(sqlca)
dw_list.reset()

dw_list.insertrow(0)
dw_list.SetItem(1, 'bg_yyyy', string(today(), 'YYYY'))
dw_list.SetItem(1, 'dept_cd', Gs_Dept)
dw_list.SetItem(1, 'ctr_rate', 100)

dw_list.SetColumn('bg_yyyy')
dw_list.setfocus()



end event

type dw_insert from w_inherite`dw_insert within w_kbgb05
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbgb05
boolean visible = false
integer x = 3579
integer y = 2196
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbgb05
boolean visible = false
integer x = 3406
integer y = 2196
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbgb05
boolean visible = false
integer x = 2711
integer y = 2196
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kbgb05
boolean visible = false
integer x = 3232
integer y = 2196
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbgb05
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kbgb05
boolean visible = false
integer x = 4101
integer y = 2196
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kbgb05
boolean visible = false
integer x = 2885
integer y = 2196
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbgb05
boolean visible = false
integer x = 3058
integer y = 2196
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kbgb05
boolean visible = false
integer x = 3927
integer y = 2196
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbgb05
integer x = 4270
integer taborder = 20
end type

event p_mod::clicked;call super::clicked;/* �۾����� :                                                       */ 
/*           ����⵵�� �⺻�ݾ��� �����Ͽ� ����������              */ 
/*           �⺻�ݾ��� ������Ѵ�.                                 */  
/*                                                                  */ 
/* ���� :                                                           */ 
/*       1) ���� ���� �ݾ� = �⺻����ݾ� * ���� ����               */ 

string ls_saupj, ls_bg_yyyy, ls_bgbn, ls_dept_cd, ls_smm, ls_emm, &
       snull, get_code, get_name, get_gbn
decimal ll_ctr_rate
integer li_return 

SetNull(snull)

if dw_list.AcceptText() = -1 then return

ls_saupj = gs_saupj         /* �����         */

ls_bg_yyyy = dw_list.GetItemString(1, 'bg_yyyy')    /* ����⵵  */
ls_bgbn = dw_list.GetItemString(1, 'bgbn')          /* ���걸��       */
ls_dept_cd = dw_list.GetItemString(1, 'dept_cd')    /* ���� �μ�      */
ls_smm = dw_list.GetItemString(1, 'smm')            /* ���� ������    */
ls_emm = dw_list.GetItemString(1, 'emm')            /* ���� ������    */
ll_ctr_rate = dw_list.GetItemNumber(1, 'ctr_rate')  /* ������         */

if isnull(ls_bg_yyyy) or trim(ls_bg_yyyy) = '' then 
   F_MessageChk(1, "[����⵵]")
	dw_list.setcolumn('bg_yyyy')
	dw_list.setfocus()
	return
end if

if isnull(ls_bgbn) or trim(ls_bgbn) = '' then 
	ls_bgbn = ''		
else
	SELECT "REFFPF"."RFGUB"
	INTO :get_gbn
	FROM "REFFPF" 
	WHERE "REFFPF"."RFCOD" = 'AB'   AND   
		   "REFFPF"."RFGUB" = :ls_bgbn AND   
		   "REFFPF"."RFGUB" <> '00';  
	if sqlca.sqlcode <> 0 or isnull(get_gbn) then 
		ls_bgbn = ''		
		dw_list.SetItem(1, 'bgbn', snull)
   end if
end if

if isnull(ls_dept_cd) or trim(ls_dept_cd) = '' then 
	ls_dept_cd = ''
else
	SELECT "KFE03OM0"."DEPTCODE", "KFE03OM0"."DEPTNAME"
		INTO :get_code, :get_name
		FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
	if sqlca.sqlcode <> 0 then 	
		ls_dept_cd = ''
		dw_list.SetItem(1, 'dept_cd', snull)
	end if 
end if

if isnull(ls_smm) or trim(ls_smm) = '' then 
	F_MessageChk(1, "[���� ������]")
	dw_list.SetColumn('smm')
	dw_list.Setfocus()
	return 
else
	if long(ls_smm) < 1 or long(ls_smm) > 12 then 
		MessageBox("Ȯ ��", "������(01-12)�� ������ϴ�. ~r~rȮ���Ͻʽÿ�!!")
		
		if len(trim(ls_smm)) <> 2 then 
			dw_list.SetItem(1, 'smm', ls_smm)
   	end if		
		
		dw_list.SetColumn('smm')
		dw_list.Setfocus()
		
		return 
	end if
end if


if isnull(ls_emm) or trim(ls_emm) = '' then 
	F_MessageChk(1, "[���� ������]")
	dw_list.SetColumn('emm')
	dw_list.Setfocus()
	return 
else
   if long(ls_emm) < 1 or long(ls_emm) > 12 then 
		MessageBox("Ȯ ��", "������(01-12)�� ������ϴ�. ~r~rȮ���Ͻʽÿ�!!")
		if len(trim(ls_smm)) <> 2 then 
			dw_list.SetItem(1, 'emm', ls_emm)
   	end if		
		dw_list.SetColumn('emm')
		dw_list.Setfocus()
		return 
   end if
end if

if long(ls_smm) > long(ls_emm) then 
	MessageBox("Ȯ ��", "���� �������� ���� ���������� ~r~rŬ �� �����ϴ�.!!")
	dw_list.SetColumn('emm')
	dw_list.Setfocus()
	return 
end if


if MessageBox("ó  ��", "�ڷḦ �����Ͻðڽ��ϱ�", QUESTION!, YesNo!) = 2 then return 

setpointer(hourglass!)

//���� funtion u_create_transation�� ����Ǿ� �ֽ�.
// return : 1(����), -1(funtion ����), 2(������ ���)

li_return = sqlca.acfnbg02(ls_saupj, ls_bg_yyyy, ls_bgbn, ls_dept_cd, &
                             ls_smm, ls_emm, ll_ctr_rate)
									
if li_return = 1 THEN   // ����
   setpointer(Arrow!)	
	sle_msg.text = "�ڷ� ������ �����Ͽ����ϴ�.!!"
elseif li_return = -1 THEN   // ���� 
   MessageBox("�� ��", "�������� acfnbg02 ������ ���� �߻�" + "~n" + "~n" + &
	                    "����Ƿ� �����Ͻʽÿ�!!")
	sle_msg.text = "�ڷ� ������ �����Ͽ����ϴ�.!!"							  
	setpointer(Arrow!)
	return
elseif li_return = 2 then  // ���� ������ ���...(�۾��� �̷������ ����)
   F_MessageChk(16, "[�⿹�� �ϰ� ����]")										
	setpointer(Arrow!)
	sle_msg.text = "������ ������ ������ �ڷᰡ �������� �ʽ��ϴ�.!!"							  	
	return 
else
   MessageBox("�� ��", "�������� acfnbg02 ������ ���� �߻�" + "~n" + "~n" + &
	                    "����Ƿ� �����Ͻʽÿ�!!")
	sle_msg.text = "�ڷ� ������ �����Ͽ����ϴ�.!!"							  
	setpointer(Arrow!)
	return
end if

end event

type cb_exit from w_inherite`cb_exit within w_kbgb05
boolean visible = false
integer x = 3173
integer y = 1872
end type

type cb_mod from w_inherite`cb_mod within w_kbgb05
boolean visible = false
integer x = 2821
integer y = 1880
integer height = 100
string text = "ó��(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kbgb05
boolean visible = false
integer x = 1015
integer y = 2736
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kbgb05
boolean visible = false
integer x = 1376
integer y = 2740
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kbgb05
boolean visible = false
integer x = 1737
integer y = 2740
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_kbgb05
integer x = 2098
integer y = 2740
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kbgb05
boolean visible = false
integer y = 2064
end type

type cb_can from w_inherite`cb_can within w_kbgb05
boolean visible = false
integer x = 2459
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_kbgb05
integer x = 2821
integer y = 2740
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kbgb05
boolean visible = false
integer y = 2064
end type

type sle_msg from w_inherite`sle_msg within w_kbgb05
boolean visible = false
integer y = 2064
end type

type gb_10 from w_inherite`gb_10 within w_kbgb05
boolean visible = false
integer y = 2012
end type

type gb_button1 from w_inherite`gb_button1 within w_kbgb05
boolean visible = false
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgb05
boolean visible = false
integer x = 2770
integer y = 1816
integer width = 782
end type

type dw_list from datawindow within w_kbgb05
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1102
integer y = 548
integer width = 2510
integer height = 1176
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kbgb05_1"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9, 0)
 
return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string snull, get_code, get_name, ls_dept_cd, ls_bg_yyyy, ls_smm, &
       ls_emm, ls_bgbn, get_gbn

if this.GetColumnName() = 'bg_yyyy' then 
	ls_bg_yyyy = this.GetText()
	if isnull(ls_bg_yyyy) or trim(ls_bg_yyyy) = "" then 
      F_MessageChk(1, "[����⵵]")
		return 1
	end if
end if

if this.GetcolumnName() = 'bgbn' then 
	ls_bgbn = this.GetText()
	if isnull(ls_bgbn) or trim(ls_bgbn) = '' then 
		return
	end if
    SELECT "REFFPF"."RFGUB"
    INTO :get_gbn
    FROM "REFFPF" 
	 WHERE "REFFPF"."RFCOD" = 'AB'   AND   
          "REFFPF"."RFGUB" = :ls_bgbn AND   
			 "REFFPF"."RFGUB" <> '00';  
	if sqlca.sqlcode = 0 and isnull(get_gbn) = false then 
	   return 
	else 
		this.SetItem(1, 'bgbn', snull)
		return 1
	end if
end if 

if this.GetColumnName() = 'smm' then
	ls_smm = this.GetText()
	
	if isnull(ls_smm) or trim(ls_smm) = '' then 
      F_MessageChk(1, "[���� ������]")
		return 1
	end if
	
	
   if long(ls_smm) < 1 or long(ls_smm) > 12 then 
		MessageBox("Ȯ ��", "������(01-12)�� ������ϴ�. ~r~rȮ���Ͻʽÿ�!!")
		if len(trim(ls_smm)) <> 2 then 
			ls_smm = string(long(ls_smm), '00')
			this.SetItem(1, 'smm', ls_smm)
   	end if
		return 1
	end if
	
	if len(trim(ls_smm)) <> 2 then 
		ls_smm = string(long(ls_smm), '00')
		this.SetItem(1, 'smm', ls_smm)
		return 2
	end if
	
end if

if this.GetColumnName() = 'emm' then
	
	ls_smm = this.GetItemString(1, 'smm')
	ls_emm = this.GetText()
	if isnull(ls_emm) or trim(ls_emm) = '' then 
      F_MessageChk(1, "[���� ������]")
		return 1
	end if
	
   if long(ls_emm) < 1 or long(ls_emm) > 12 then 
		MessageBox("Ȯ ��", "������(01-12)�� ������ϴ�. ~r~rȮ���Ͻʽÿ�!!")
		if len(trim(ls_emm)) <> 2 then 
			ls_emm = string(long(ls_emm), '00')
			this.SetItem(1, 'emm', ls_emm)
		end if		
		return 1
	end if
	
	if long(ls_smm) > long(ls_emm) then 
		MessageBox("Ȯ ��", "���� �������� ���� ���������� ~r~rŬ �� �����ϴ�.!!")
		if len(trim(ls_emm)) <> 2 then 
			ls_emm = string(long(ls_emm), '00')
			this.SetItem(1, 'emm', ls_emm)
		end if		
		return 1
	end if
	
	if len(trim(ls_emm)) <> 2 then 
		ls_emm = string(long(ls_emm), '00')
		this.SetItem(1, 'emm', ls_emm)
		return 2
	end if	
	
end if

if this.GetColumnName() = 'dept_cd' then
	ls_dept_cd = this.GetText()
	if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then return
	
	SELECT "KFE03OM0"."DEPTNAME"  
		 INTO :get_name  
		 FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
	
	if sqlca.sqlcode = 0 then 	
		this.SetItem(row, 'dept_cd', ls_dept_cd)
	end if
end if
end event

event itemerror;return 1
end event

