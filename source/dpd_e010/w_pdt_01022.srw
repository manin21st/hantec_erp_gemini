$PBExportHeader$w_pdt_01022.srw
$PBExportComments$** �� �����ȹ(�� ��ȹ ����)
forward
global type w_pdt_01022 from window
end type
type p_create from picture within w_pdt_01022
end type
type p_exit from picture within w_pdt_01022
end type
type dw_ip from datawindow within w_pdt_01022
end type
type st_msg from statictext within w_pdt_01022
end type
end forward

global type w_pdt_01022 from window
integer x = 997
integer y = 676
integer width = 1422
integer height = 1028
boolean titlebar = true
string title = "�� ��ȹ ����"
windowtype windowtype = response!
long backcolor = 32106727
p_create p_create
p_exit p_exit
dw_ip dw_ip
st_msg st_msg
end type
global w_pdt_01022 w_pdt_01022

type variables

end variables

event open;f_window_center(this)

dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)

dw_ip.setitem(1, 'syymm', gs_code)
dw_ip.setitem(1, 'jjcha', integer(gs_codename))

f_mod_saupj(dw_ip, 'saupj')

dw_ip.setfocus()

end event

on w_pdt_01022.create
this.p_create=create p_create
this.p_exit=create p_exit
this.dw_ip=create dw_ip
this.st_msg=create st_msg
this.Control[]={this.p_create,&
this.p_exit,&
this.dw_ip,&
this.st_msg}
end on

on w_pdt_01022.destroy
destroy(this.p_create)
destroy(this.p_exit)
destroy(this.dw_ip)
destroy(this.st_msg)
end on

type p_create from picture within w_pdt_01022
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1001
integer y = 24
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\����_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\����_up.gif'
end event

event clicked;string s_yymm, smsgtxt, stext, s_gub, s_toym, s_team, get_nm, ssaupj
int    i_seq
long   lRtnValue, get_count

if dw_ip.AcceptText() = -1 then return 

s_gub  = trim(dw_ip.GetItemString(1,'gub1'))
s_team  = trim(dw_ip.GetItemString(1,'steam'))
s_yymm = trim(dw_ip.GetItemString(1,'syymm'))
i_seq  = dw_ip.GetItemNumber(1,'jjcha')
ssaupj = trim(dw_ip.GetItemString(1,'saupj'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_ip.Setcolumn('syymm')
	dw_ip.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("Ȯ��", "���� ���� ����� ������ �� �����ϴ�!!")

	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[Ȯ��/���� ����]')
	dw_ip.Setcolumn('jjcha')
	dw_ip.SetFocus()
	return
else
	if i_seq = 1 then 
		stext = 'Ȯ����'
	else
		stext = '������'
	end if	
end if	

if s_gub = '2' then 
	if isnull(s_team) or s_team = "" then
		f_message_chk(30,'[������]')
		dw_ip.Setcolumn('steam')
		dw_ip.SetFocus()
		return
	else
	  SELECT "REFFPF"."RFNA1"  
		 INTO :get_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."SABU" = '1' ) AND  
				( "REFFPF"."RFCOD" = '03' ) AND  
				( "REFFPF"."RFGUB" = :s_team )   ;
		IF isnull(get_nm) then get_nm = '������ ������'
	end if	
		
	smsgtxt = get_nm + '�� ' + left(s_yymm, 4) + '�� ' + mid(s_yymm, 5, 2) + '�� ' &
				 + stext + ' �� �����ȹ�� ���� �Ͻðڽ��ϱ�?'
	if messagebox("Ȯ ��", smsgtxt, Question!, YesNo!, 2) = 2 then return   

	SetPointer(HourGlass!)
	st_msg.text = "�������� ���� �����ȹ �Ϻ� �ڷ� ���� �� .......... "
	
	lRtnValue = SQLCA.ERP000000040_2(gs_sabu, s_yymm, i_seq, ssaupj, s_team)

else
	smsgtxt = left(s_yymm, 4) + '�� ' + mid(s_yymm, 5, 2) + '�� ' + stext + &
	          ' ���� �����ȹ �Ϻ� �ڷḦ ���� �Ͻðڽ��ϱ�?'
			
	if messagebox("Ȯ ��", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "���� �����ȹ �Ϻ� �ڷ� ���� �� .......... "
	
	lRtnValue = SQLCA.ERP000000040_2(gs_sabu, s_yymm, i_seq, ssaupj, '%')
end if

IF lRtnValue > 0 THEN
	st_msg.text = "�ڷᰡ �����Ǿ����ϴ�!!"
else
	st_msg.text = ""
   messagebox("��������", "������ �����Ͽ����ϴ�")
	return 
end if	
		
end event

type p_exit from picture within w_pdt_01022
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1184
integer y = 24
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\�ݱ�_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\�ݱ�_up.gif'
end event

event clicked;close(parent)
end event

type dw_ip from datawindow within w_pdt_01022
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 184
integer width = 1349
integer height = 604
integer taborder = 10
string dataobject = "d_pdt_01022"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string snull, syymm, s_gub
int    iseq, inull, get_yeacha

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	
	if syymm = "" or isnull(syymm) then
  		this.setitem(1, 'jjcha', 1)
		return 
	end if	

  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[���س��]')
		this.setitem(1, "syymm", sNull)
  		this.setitem(1, 'jjcha', 1)
		return 1
	END IF
	
	SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
	  FROM "MONPLN_SUM"  
	 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;

	if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

	this.setitem(1, 'jjcha', get_yeacha )
ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq  = integer(this.gettext())
   syymm = trim(this.getitemstring(1, 'syymm'))
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syymm = "" or isnull(syymm) then 
		messagebox("Ȯ��", "���س���� ���� �Է� �Ͻʽÿ�!!")
  		this.setitem(1, 'jjcha', inull)
		this.setcolumn('syymm')
		this.setfocus()
		return 1
	end if		
   SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
     FROM "MONPLN_SUM"  
    WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;
   
	//Ȯ����ȹ�� ���� ��� ������ȹ�� �Է��� �� ����
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("Ȯ��", left(syymm,4)+"�� "+mid(syymm,5,2)+"���� Ȯ��/������ȹ�� ������ " &
			                   + "Ȯ���� �Է°����մϴ�!!")
	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	//������ȹ�� �ִ� ��� Ȯ����ȹ�� �Է��� �� ����.	
	elseif get_yeacha = 2 then
		if iseq = 1 then
   		messagebox("Ȯ��", left(syymm,4)+"�� "+mid(syymm,5,2)+"���� ������ȹ�� ������ " &
			                   + "Ȯ���� �Է��� �� �����ϴ�!!")
	  		this.setitem(1, 'jjcha', 2)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
		end if		
   end if		
ELSEIF this.GetColumnName() ="gub1" THEN
	this.setitem(1, "steam", sNull)
END IF

end event

event itemerror;RETURN 1
end event

type st_msg from statictext within w_pdt_01022
integer x = 27
integer y = 832
integer width = 1312
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

