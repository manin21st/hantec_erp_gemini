$PBExportHeader$w_kbga10b.srw
$PBExportComments$���� ���Ǻ�ǥ
forward
global type w_kbga10b from w_standard_print
end type
type rr_1 from roundrectangle within w_kbga10b
end type
end forward

global type w_kbga10b from w_standard_print
integer x = 0
integer y = 0
string title = "���� ���Ǻ�ǥ ��ȸ �� ���"
rr_1 rr_1
end type
global w_kbga10b w_kbga10b

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_acc_mm, ls_acc1f, ls_acc1t, & 
       snull, sqlfd1, sqlfd2, s_yesanname, ls_ye_gu, &
 		 get_yy_q, ls_yy_q, ls_yy_q_pre, ls_mm_pre, ls_yy_pre 

if dw_ip.GetRow() < 1 then return -1

if dw_ip.acceptText() = -1 then return -1

ls_saupj   = dw_ip.GetItemString(dw_ip.GetRow(), 'saupj')   // ����� 
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")   // ����⵵
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")   // �����
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")    // ���걸��

ls_acc1f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd1')  // �������� from
ls_acc1t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd2')  // �������� to

IF trim(ls_saupj) = '' or isnull(ls_saupj) THEN
	F_MessageChk(1, "[�����]")
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   return -1 
ELSE
	IF ls_saupj = '99' THEN ls_saupj = '%'
END IF

if trim(ls_acc_yy) = '' or isnull(ls_acc_yy) then 
	F_MessageChk(1, "[����⵵]")
	dw_ip.SetColumn('acc_yy')
	dw_ip.SetFocus()	
	return -1
end if

if trim(ls_acc_mm) = '' or isnull(ls_acc_mm) then 
	F_MessageChk(1, "[�����]")
	dw_ip.SetColumn('acc_mm')
	dw_ip.SetFocus()	
	return -1
else
	
	if ls_acc_mm < '01' or ls_acc_mm > '12' then 
		MessageBox("Ȯ ��", "����� ������ ������ϴ�.(01~~12)!!")
		return -1
	end if
end if

if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
   ls_ye_gu = "%"
else
  SELECT "REFFPF"."RFNA1"  
   INTO  :s_yesanname
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_ye_gu and
         "REFFPF"."RFCOD" = 'AB' and   
         "REFFPF"."RFCOD" <> '00' using sqlca ;  
   if sqlca.sqlcode <> 0 then
      messagebox("Ȯ��","���걸���ڵ带 Ȯ���Ͻʽÿ�!")
      dw_ip.SetFocus()
      return -1
   end if
end if

if trim(ls_acc1f) = "" or IsNull(ls_acc1f) then
   ls_acc1f = "10000"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd1 
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1f ) using sqlca ;
   if sqlca.sqlcode <> 0  then
      ls_acc1f = "10000"
	else
		ls_acc1f = sqlfd1
   end if
end if

if trim(ls_acc1t) = "" or IsNull(ls_acc1t) then
   ls_acc1t = "89999"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1t ) using sqlca ;
   if sqlca.sqlcode <> 0  then
      ls_acc1t = "89999"
	else
		ls_acc1t = sqlfd2
   end if
end if

if ls_acc1f > ls_acc1t then 
	MessageBox("Ȯ ��", "���� ��������� ���� ������񺸴� ~r~rŬ �� �����ϴ�.!!")
   dw_ip.SetColumn('acc1_cd1')
	dw_ip.SetFocus()
	return -1
end if

  // ���س⵵ �б�
  SELECT DISTINCT "KFE01OM0"."QUARTER"  
    INTO :get_yy_q   
    FROM "KFE01OM0"  
	 WHERE "KFE01OM0"."SAUPJ" like :ls_saupj   AND 
          "KFE01OM0"."ACC_YY" = :ls_acc_yy AND 
         "KFE01OM0"."ACC_MM"  = :ls_acc_mm 	 ;
	if sqlca.sqlcode <> 0 or isnull(get_yy_q) then 
		ls_yy_q = '0'
	else
		ls_yy_q = get_yy_q
   end if
// ���س⵵ ���б�
if ls_yy_q = '1' then
	ls_yy_q_pre = '0'
else
	ls_yy_q_pre = string(integer(ls_yy_q) - 1 )
end if

// ���س⵵ ����
if ls_acc_mm = '01' then
	ls_mm_pre = '00'
else
	ls_mm_pre = string(integer(ls_acc_mm) - 1, '00')
end if

// ���⵵ 
ls_yy_pre = string(long(ls_acc_yy) - 1 )


dw_list.SetRedraw(false)

//�⺻���� (2 ��)
// ���س⵵ �б�, ���б�, ����, ���⵵ 
IF dw_print.Retrieve(ls_saupj, ls_acc_yy, ls_acc_mm, ls_ye_gu, &
                    ls_acc1f, ls_acc1t, &
						  ls_yy_q, ls_yy_q_pre, ls_mm_pre, ls_yy_pre) < 1 then 
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.SetRedraw(true)	

return 1
end function

on w_kbga10b.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kbga10b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(), 'saupj', gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(), 'acc_yy', left(f_today(), 4))
dw_ip.SetItem(dw_ip.GetRow(), 'acc_mm', mid(f_today(), 5,2))

dw_ip.SetColumn('saupj')
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kbga10b
end type

type p_exit from w_standard_print`p_exit within w_kbga10b
end type

type p_print from w_standard_print`p_print within w_kbga10b
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga10b
end type







type st_10 from w_standard_print`st_10 within w_kbga10b
end type



type dw_print from w_standard_print`dw_print within w_kbga10b
string dataobject = "dw_kbga10b_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga10b
integer width = 3127
integer height = 224
string dataobject = "dw_kbga10b_1"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd1, &
       ls_ye_gu, get_ye_gu, s_sql, ls_acc1_cd2, get_code, get_name, &
		 ls_dept_cd, ls_acc_mm

SetNull(snull)

if this.GetColumnName() = 'saupj' then 
	
   ls_saupj    = this.GetText()
	
	if trim(ls_saupj) = '' or isnull(ls_saupj) then 
      F_MessageChk(1, "[�����]")		
		return 1
	end if
	
	SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :ls_saupj and 
			"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      Messagebox("Ȯ ��","������ڵ带 Ȯ���Ͻʽÿ�")
      this.SetItem(row, "saupj", snull)
      return 1
   end if
	
end if

if this.GetColumnName() = 'acc_yy' then
	
	ls_acc_yy = this.GetText()
	
	if isnull(ls_acc_yy) or trim(ls_acc_yy) = '' then
      F_MessageChk(1, "[ȸ��⵵]")				
   	return 1
	end if
	
end if

if this.GetColumnName() = 'acc_mm' then
	ls_acc_mm = this.GetText()
	if trim(ls_acc_mm) = '' or isnull(ls_acc_mm) then 
		F_MessageChk(1, "[ȸ���]")
		return 1
	end if
	if ls_acc_mm < '01' or ls_acc_mm > '12' then 
		MessageBox("Ȯ ��", "ȸ��� ������ ������ϴ�.(01~~12)!!")
	end if
end if
	
if this.GetcolumnName() = 'ye_gu' then 
	ls_ye_gu = this.GetText()
	if isnull(ls_ye_gu) or trim(ls_ye_gu) = '' then 
		return
	end if
    SELECT "REFFPF"."RFGUB"
    INTO :get_ye_gu
    FROM "REFFPF" 
	 WHERE "REFFPF"."RFCOD" = 'AB'   AND   
          "REFFPF"."RFGUB" = :ls_ye_gu AND   
			 "REFFPF"."RFGUB" <> '00';  
	if sqlca.sqlcode = 0 and isnull(get_ye_gu) = false then 
	   return 
	else 
		MessageBox("Ȯ ��", "���걸�� �ڵ带 Ȯ���Ͻʽÿ�!!")		
		this.SetItem(1, 'ye_gu', snull)
		return 1
	end if
end if 	


IF this.GetColumnName() ="acc1_cd1" THEN
	
	ls_acc1_cd1 = this.GetText()
	
	IF trim(ls_acc1_cd1) ="" OR IsNull(ls_acc1_cd1) THEN
		return 
	ELSE
		
		SELECT DISTINCT "KFZ01OM0"."ACC1_NM"
    		INTO :s_sql
    		FROM "KFZ01OM0"  
   		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd1 ;
  		if sqlca.sqlcode = 0 then
     		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1", s_sql)
  		else
     		MessageBox("Ȯ ��","���������� Ȯ���ϼ���.!!")
			dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd1", snull)
      	return 1 
  		end if
	END IF
END IF

IF this.GetColumnName() ="acc1_cd2" THEN
	ls_acc1_cd2 = this.GetText()
	
	IF trim(ls_acc1_cd2) ="" OR IsNull(ls_acc1_cd2) THEN
		return 
	ELSE
		SELECT DISTINCT "KFZ01OM0"."ACC1_NM"
    		INTO :s_sql
    		FROM "KFZ01OM0"  
   		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd2 ;
  		if sqlca.sqlcode = 0 then
     		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2",s_sql)
  		else
     		MessageBox("Ȯ ��","���������� Ȯ���ϼ���.!!")
			dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd2",snull)
      	return 1 
  		end if
	END IF
END IF


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd1"  THEN 

	dw_ip.AcceptText()
	gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd1")
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd1", Left(gs_code,5))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_name1", gs_codename)
	end if
end if

IF this.GetColumnName() = "acc1_cd2"  THEN 

	dw_ip.AcceptText()
	gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd2")
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd2", Left(gs_code,5))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_name2", gs_codename)
	end if
end if

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kbga10b
integer x = 55
integer y = 248
integer width = 4544
integer height = 2004
string title = "���� ���Ǻ�ǥ"
string dataobject = "dw_kbga10b_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kbga10b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 240
integer width = 4562
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

