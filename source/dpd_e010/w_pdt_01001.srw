$PBExportHeader$w_pdt_01001.srw
$PBExportComments$** �Ⱓ �����ȹ ����(�Ǹ� ��ȹ ����)
forward
global type w_pdt_01001 from window
end type
type p_exit from uo_picture within w_pdt_01001
end type
type p_1 from uo_picture within w_pdt_01001
end type
type dw_ip from datawindow within w_pdt_01001
end type
type st_msg from statictext within w_pdt_01001
end type
type gb_2 from groupbox within w_pdt_01001
end type
end forward

global type w_pdt_01001 from window
integer x = 814
integer y = 436
integer width = 1979
integer height = 908
boolean titlebar = true
string title = "�Ǹ� ��ȹ ����"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_1 p_1
dw_ip dw_ip
st_msg st_msg
gb_2 gb_2
end type
global w_pdt_01001 w_pdt_01001

type variables

end variables

event open;f_window_center(this)

Int iMaxSeq
dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)

dw_ip.setitem(1, 'syear', gs_code)
dw_ip.setitem(1, 'jjcha', integer(gs_codename))

  SELECT MAX("PLAN_CHASU")  
    INTO :iMaxSeq
    FROM "YEARSAPLAN_CONFIRM"  
   WHERE "SABU"      = :gs_sabu AND  
         "PLAN_YYYY" = :gs_code AND
			"MAFLAG" = 'Y';

//  SELECT MAX("PLAN_CHASU")  
//    INTO :iMaxSeq
//    FROM "YEARSAPLAN"  
//   WHERE "SABU"      =    :gs_sabu AND  
//         "PLAN_YYMM" Like :gs_code||'%' ;

if isnull(iMaxSeq) or iMaxSeq = 0 then   
   dw_ip.setitem(1, 'opt', 'N')
else
   dw_ip.setitem(1, 'opt', 'Y')
   dw_ip.setitem(1, 'sale_year', gs_code)
   dw_ip.setitem(1, 'sale_last', iMaxSeq)
end if

// �ΰ��� ����� ����
f_mod_saupj(dw_ip, 'porgu')
f_child_saupj(dw_ip, 'steam', gs_saupj)

dw_ip.setfocus()

end event

on w_pdt_01001.create
this.p_exit=create p_exit
this.p_1=create p_1
this.dw_ip=create dw_ip
this.st_msg=create st_msg
this.gb_2=create gb_2
this.Control[]={this.p_exit,&
this.p_1,&
this.dw_ip,&
this.st_msg,&
this.gb_2}
end on

on w_pdt_01001.destroy
destroy(this.p_exit)
destroy(this.p_1)
destroy(this.dw_ip)
destroy(this.st_msg)
destroy(this.gb_2)
end on

type p_exit from uo_picture within w_pdt_01001
integer x = 1733
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\�ݱ�_up.gif"
end type

event clicked;close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\�ݱ�_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\�ݱ�_dn.gif"
end event

type p_1 from uo_picture within w_pdt_01001
integer x = 1559
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\�ǸŰ�ȹ_up.gif"
end type

event clicked;call super::clicked;string s_year, s_nextyear, smsgtxt, s_gub, s_team, sOpt, sItemgub, sQtygub, ls_porgu
int    i_seq, get_yeacha, iSaleseq 
long   lRtnValue, get_count

if dw_ip.AcceptText() = -1 then return 
sItemgub  = dw_ip.GetItemString(1,'itemgub')
sQtygub   = dw_ip.GetItemString(1,'qty_gub')
sOpt      	= dw_ip.GetItemString(1,'Opt')
ls_Porgu 	= dw_ip.GetItemString(1,'porgu')

s_gub  	= dw_ip.GetItemString(1,'gub1')
s_team 	= dw_ip.GetItemString(1,'steam')
s_year 	= trim(dw_ip.GetItemString(1,'syear'))
i_seq  	= dw_ip.GetItemNumber(1,'jjcha')
iSaleseq  = dw_ip.GetItemNumber(1,'sale_last')

if sOpt = 'N' then 
	messagebox('Ȯ ��', '������ȹ�� �������� �ʽ��ϴ�. �ڷḦ Ȯ���ϼ���!')
	return 
end if

if isnull(s_year) or s_year = "" then
	f_message_chk(30,'[��ȹ�⵵]')
	dw_ip.Setcolumn('syear')
	dw_ip.SetFocus()
	return
end if

s_nextyear = string(long(left(f_today(), 4)) + 1)

//if s_year <> s_nextyear then
//	messagebox("Ȯ��", "��ȹ�⵵�� " + s_nextyear + " �⸸ �Է°����մϴ�!!")
//	dw_ip.setcolumn('syear')
//	dw_ip.setfocus()
//	return 1
//end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[��������]')
	dw_ip.Setcolumn('jjcha')
	dw_ip.SetFocus()
	return
end if	
		
SELECT MAX("YEAPLN"."YEACHA")  
  INTO :get_yeacha  
  FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( "YEAPLN"."YEAYYMM" LIKE :s_year||'%' )   ;
		 
if isnull(get_yeacha) or get_yeacha = 0  then
	IF i_seq <> 1 then
		messagebox("Ȯ��", s_year + "�⿡ ���� ���������� ������ " &
								 + "1���� �Է°����մϴ�!!")
		dw_ip.setcolumn('jjcha')
		dw_ip.setfocus()
		return 
	end if		
else
	if i_seq <> get_yeacha + 1 and i_seq <> get_yeacha then
		messagebox("Ȯ��", s_year + "�⿡ ���� ���������� " + &
								 string(get_yeacha) + "�� �̹Ƿ� ���������� ���������� �Է��ϼ���!!")
		dw_ip.setcolumn('jjcha')
		dw_ip.setfocus()
		return 
	end if		
end if		

// ���������� ���...
if s_gub = '2' then 
	if isnull(s_team) or s_team = '' then
		f_message_chk(30,'[������]')
		dw_ip.Setcolumn('steam')
		dw_ip.SetFocus()
		return
	end if	
	
	SELECT COUNT(*) 
	  INTO :get_count
	  FROM YEAPLN A, ITEMAS B, ITNCT C
	 WHERE A.SABU = :gs_sabu AND  A.YEAYYMM LIKE :s_year||'%' AND A.YEACHA = :i_seq  AND
	       A.ITNBR = B.ITNBR  AND  B.ITTYP = C.ITTYP           AND B.ITCLS = C.ITCLS  AND 
	       C.PDTGU = :s_team ;
	
	IF get_count > 0 then 
		smsgtxt = '������ => ' + s_year + '�� ' + string(i_seq) + '�� �����ȹ�� �����մϴ�. ~n~n'  &
							  + '�ǸŰ�ȹ �������� �����ȹ���� ���� �Ͻðڽ��ϱ�?'
	ELSE
		smsgtxt = '������ => ' + s_year + '�� ' + string(i_seq) + &
		          '�� �ǸŰ�ȹ �������� �����ȹ���� ���� �Ͻðڽ��ϱ�?'
	END IF
	
	if messagebox("Ȯ ��", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "�������� �Ⱓ �����ȹ �ڷ� ���� �� .......... "

	// ������α��� 1: �ǸŰ�ȹ, 2:����������..
//	messagebox('',sqtygub)
	if sQtygub = '1' then 
		lRtnValue = sqlca.erp000000020_1(gs_sabu, ls_porgu, s_year, i_seq, iSaleseq, sItemgub, s_team)
	else
		lRtnValue = sqlca.erp000000020(gs_sabu, ls_porgu,  s_year, i_seq, iSaleseq, sItemgub, s_team)
   end if
else
	SELECT COUNT(*) 
	  INTO :get_count
	  FROM YEAPLN
	 WHERE SABU = :gs_sabu AND YEAYYMM like :s_year||'%' AND YEACHA = :i_seq ;
	
	IF get_count > 0 then 
		smsgtxt = s_year + '�� ' + string(i_seq) + '�� �����ȹ�� �����մϴ�. ~n~n'  &
							  + '�ǸŰ�ȹ �������� �����ȹ���� ���� �Ͻðڽ��ϱ�?'
	ELSE
		smsgtxt = s_year + '�� ' + string(i_seq) + '�� �ǸŰ�ȹ �������� �����ȹ���� ���� �Ͻðڽ��ϱ�?'
	END IF
	
	if messagebox("Ȯ ��", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "�Ⱓ �����ȹ �ڷ� ���� �� .......... "
	
	if sQtygub = '1' then 
		lRtnValue = sqlca.erp000000020_1(gs_sabu, ls_porgu,  s_year, i_seq, iSaleseq, sItemgub, '%')
	else	
		lRtnValue = sqlca.erp000000020(gs_sabu, ls_porgu,  s_year, i_seq, iSaleseq, sItemgub, '%')
   end if
end if	

IF lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'ERROR CODE ' + STRING(lRtnValue) )
	Return
ELSE
	commit ;
	st_msg.text = string(lRtnValue) + '�ǿ� �ڷᰡ ����ó�� �Ǿ����ϴ�!!'
END IF

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\�ǸŰ�ȹ_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\�ǸŰ�ȹ_dn.gif"
end event

type dw_ip from datawindow within w_pdt_01001
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 96
integer y = 236
integer width = 1792
integer height = 464
integer taborder = 10
string dataobject = "d_pdt_01001"
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

event itemchanged;string snull, syear, s_gub
int    iseq, inull, get_yeacha, iMaxSeq

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="porgu" THEN
	s_gub = trim(this.GetText())
	
	//������
	f_child_saupj(this, 'steam', s_gub)
ElseIF this.GetColumnName() ="syear" THEN
	syear = trim(this.GetText())
	
	if syear = "" or isnull(syear) then
  		this.setitem(1, 'jjcha', inull)
		return 
	end if	

	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" like :syear||'%' )   ;
	
	this.setitem(1, 'jjcha', get_yeacha)

  SELECT MAX("PLAN_CHASU")  
    INTO :iMaxSeq
    FROM "YEARSAPLAN"  
   WHERE "SABU"      =    :gs_sabu AND  
         "PLAN_YYMM" Like :syear||'%' ;

	if isnull(iMaxSeq) or iMaxSeq = 0 then   
		dw_ip.setitem(1, 'opt', 'N')
	else
		dw_ip.setitem(1, 'opt', 'Y')
		dw_ip.setitem(1, 'sale_year', syear)
		dw_ip.setitem(1, 'sale_last', iMaxSeq)
	end if

ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq = integer(this.GetText())
   syear = this.getitemstring(1, 'syear')
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syear = "" or isnull(syear) then 
		messagebox("Ȯ��", "��ȹ�⵵�� ���� �Է� �Ͻʽÿ�!!")
		this.setcolumn('syear')
		this.setfocus()
		return 1
	end if		
	
	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" like :syear||'%' )  ;
			 
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("Ȯ��", syear + "�⿡ ���� ���������� ������ " &
			                   + "1���� �Է°����մϴ�!!")

	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	else
		if iseq > get_yeacha + 1 then
   		messagebox("Ȯ��", syear + "�⿡ ���� ���������� " + &
			                   string(get_yeacha) + "�� �Դϴ�!!")
			this.setitem(1, 'jjcha', get_yeacha)
       	this.setcolumn('jjcha')
         this.setfocus()
			return 1
		end if		
   end if		
END IF
end event

event itemerror;RETURN 1
end event

type st_msg from statictext within w_pdt_01001
integer x = 133
integer y = 728
integer width = 1605
integer height = 80
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

type gb_2 from groupbox within w_pdt_01001
integer x = 32
integer y = 176
integer width = 1888
integer height = 536
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

