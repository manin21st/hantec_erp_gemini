$PBExportHeader$w_mat_03030.srw
$PBExportComments$** ���� ����
forward
global type w_mat_03030 from w_inherite
end type
type st_41 from statictext within w_mat_03030
end type
type st_3 from statictext within w_mat_03030
end type
type st_22 from statictext within w_mat_03030
end type
type st_33 from statictext within w_mat_03030
end type
type st_44 from statictext within w_mat_03030
end type
type st_45 from statictext within w_mat_03030
end type
type st_34 from statictext within w_mat_03030
end type
type dw_1 from datawindow within w_mat_03030
end type
type st_42 from statictext within w_mat_03030
end type
type st_2 from statictext within w_mat_03030
end type
type st_49 from statictext within w_mat_03030
end type
type pb_1 from u_pb_cal within w_mat_03030
end type
type rr_1 from roundrectangle within w_mat_03030
end type
type rr_2 from roundrectangle within w_mat_03030
end type
end forward

global type w_mat_03030 from w_inherite
string title = "���� ����"
st_41 st_41
st_3 st_3
st_22 st_22
st_33 st_33
st_44 st_44
st_45 st_45
st_34 st_34
dw_1 dw_1
st_42 st_42
st_2 st_2
st_49 st_49
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_03030 w_mat_03030

forward prototypes
public function integer wf_check (string ar_yymm, integer ar_count)
end prototypes

public function integer wf_check (string ar_yymm, integer ar_count);//////////////////////////////////////////////////////////////
//                                                          //
//   ��������� ����ó���� �� �� �ִ��� ���θ� üũ�Ѵ�.    //
//                                                          //
//////////////////////////////////////////////////////////////
Long  get_count
string sYymm

//��ӻ��� �� �������� ���
if ar_count > 1 then   
	sYymm = f_aftermonth(ar_yymm, ar_count)
else
	sYymm = ar_yymm
end if

//���� ��� �������̽� �ڷᰡ ȸ��ó�� �Ǿ����� ������ �� ����
  SELECT COUNT(*)  
    INTO :get_count
    FROM KIF02OT0  
   WHERE SABU = :gs_sabu   
     AND IO_DATE >= ( SELECT MIN(CLDATE) FROM P4_CALENDAR
                       WHERE YYYYMM = :ar_yymm )
     AND IO_DATE <= ( SELECT MAX(CLDATE) FROM P4_CALENDAR
                       WHERE YYYYMM = :sYymm )
     AND BAL_DATE is not null   ;

if get_count > 0 then 
	sle_msg.text = ""
	messagebox("���� �Ұ�", "����ó���� �� �� �����ϴ�. ��������� Ȯ���ϼ���!" + '~n~n' + &
	                        "���� ��� �������̽���  ȸ�� ��ǥó�� �� �ڷᰡ �ֽ��ϴ�.")
   return -1
end if	

return 1
end function

on w_mat_03030.create
int iCurrent
call super::create
this.st_41=create st_41
this.st_3=create st_3
this.st_22=create st_22
this.st_33=create st_33
this.st_44=create st_44
this.st_45=create st_45
this.st_34=create st_34
this.dw_1=create dw_1
this.st_42=create st_42
this.st_2=create st_2
this.st_49=create st_49
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_41
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_22
this.Control[iCurrent+4]=this.st_33
this.Control[iCurrent+5]=this.st_44
this.Control[iCurrent+6]=this.st_45
this.Control[iCurrent+7]=this.st_34
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.st_42
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_49
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
end on

on w_mat_03030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_41)
destroy(this.st_3)
destroy(this.st_22)
destroy(this.st_33)
destroy(this.st_44)
destroy(this.st_45)
destroy(this.st_34)
destroy(this.dw_1)
destroy(this.st_42)
destroy(this.st_2)
destroy(this.st_49)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_1.Settransobject(sqlca)
dw_1.Retrieve()
dw_Insert.Insertrow(0)

// ������̷� �߿��� ������ ���� ���������� ��ȸ�Ͽ� ���ڸ� ����Ѵ�.
// ������ ���� ��ǥ�߿���(���ҽ������� ����) �Է����� �Ǵ� �������ڰ� 
// ���������� �������ڷ� �Ǿ��ִ� ��ǥ�� ���ҽ������ڸ� �˻��Ͽ� ����ϰ�
// �ش� ���ҽ������ں��� ������ �����Ѵ�.
String sLdate, sLyymm

Setnull(sLdate)
Select last_jnpo_date into :sLdate
  from imhist_last_modify
 where sabu = :gs_sabu;

SELECT MAX("JUNPYO_CLOSING"."JPDAT")  
  INTO :sLyymm
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
       ( "JUNPYO_CLOSING"."JPGU" = 'C0' )   ;
 
dw_insert.setitem(1, "syymm", left(f_today(), 6))
dw_insert.setitem(1, "ldate", sLdate)
dw_insert.setitem(1, "last_mayymm", sLyymm)

dw_insert.SetColumn("syymm")
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_mat_03030
integer x = 1083
integer y = 232
integer width = 2542
integer height = 152
string dataobject = "d_mat_03030_a"
boolean border = false
end type

event dw_insert::itemchanged;STRING s_date, snull

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date + '01') = -1	then
      f_message_chk(35, '[���س��]')
		this.setitem(1, "syymm", left(f_today(), 6))
		return 1
	END IF
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_mat_03030
boolean visible = false
integer x = 1490
integer y = 2396
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_mat_03030
boolean visible = false
integer x = 1317
integer y = 2396
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_mat_03030
boolean visible = false
integer x = 622
integer y = 2396
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_mat_03030
integer x = 3072
integer y = 72
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_ins::clicked;call super::clicked;String  s_yymm, s_yymm2, serror, s_iwnm, s_maxym, s_maxym2
long    get_count, i
int     iReturn 

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm 	= trim(dw_insert.GetItemString(1, 'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
else
	s_yymm2 = f_aftermonth(s_yymm, 1)
end if	

if s_yymm < '200701' then
	Messagebox('Ȯ��',"2007�� ���� ���Ҹ��� �۾��� �Ұ��մϴ�!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	


IF Messagebox('���Ҹ���',"���Ҹ���ó�� �Ͻðڽ��ϱ�?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)

SELECT "IOMATRIX"."IOGBN"  
  INTO :s_iwnm
  FROM "IOMATRIX"  
 WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND ( "IOMATRIX"."TRANSGUB" = 'Y' )   ;

if sqlca.sqlcode <> 0 then 
	f_message_chk(41,'[ �̿����п� ���� �����ڵ� ]')
	return
end if	

/* ���Ҹ����� ���� ���� ��ǥ */
  SELECT MAX(JPDAT)  
    INTO :s_maxym
    FROM JUNPYO_CLOSING  
   WHERE SABU = :gs_sabu AND JPGU = 'C0' ;

if s_maxym = "" or isnull(s_maxym) then 
   get_count = 1
else
   s_maxym2 = f_aftermonth(s_maxym,1)
   if s_maxym2 < s_yymm then  //�������� ���� ������ + 1���� ũ�� error 
   	f_message_chk(111,'[���س��]')
		dw_insert.SetColumn('syymm')
		dw_insert.SetFocus()
		return
	elseif s_maxym = s_yymm then 
		IF Messagebox('���Ҹ���',"�����Ϸ��� �̿� �ڷᰡ �̹� �����մϴ�." +"~n~n" +&
									 "�����ڷḦ �����Ͻð� ���� ���� �Ͻðڽ��ϱ�?", +&
									  Question!,YesNo!,2) = 2 THEN RETURN 
      get_count = 1
	elseif s_maxym > s_yymm then 
		IF Messagebox('���Ҹ���',"�����Ϸ��� �̿� �ڷᰡ �̹� �����մϴ�." +"~n~n" +&
              		 "�����ڷḦ ���� ���Ҹ����Ͻø� ���س�� ���� �ڷᵵ ���� �����մϴ�." +"~n" +&
									 "�����ڷḦ �����Ͻð� ���� ���� �Ͻðڽ��ϱ�?", +&
     								  Question!,YesNo!,2) = 2 THEN RETURN 
		get_count = f_month_between(s_maxym, s_yymm) + 1
  else    
      get_count = 1
  end if
end if	

sle_msg.text = "�����ڷ� �������� ���� üũ �� .........!!"
/* get_count�� �����ؾ��� �������� ���Ѵ� */
if wf_check(s_yymm, get_count) = -1 then 
   sle_msg.text = ""
	return 
end if

sle_msg.text = "�����ڷ� ���� �� .........!!"

/* ���Ҹ��� ��ǥ�̷� ���� */
DELETE FROM JUNPYO_CLOSING  
WHERE SABU   = :gs_sabu AND JPGU = 'C0' AND
		JPDAT >= :s_yymm   AND JPDAT <= :s_maxym  ;
		
/* �̿��ڷ� ���� */
FOR i = 1 TO get_count
   if i > 1 then   
      s_yymm  = f_aftermonth(s_yymm,  1)
      s_yymm2 = f_aftermonth(s_yymm2, 1)
      sle_msg.text = left(s_yymm,4) + '�� ' + mid(s_yymm,5,2) + "�� �����ڷ� ���� �� .........!!"
   end if
  
  /* �ڻ�â�� - ������ �̿��ڷ� ���� */
  	DELETE FROM STOCKMONTH  
   	  WHERE ( STOCK_YYMM = :s_yymm2 ) AND 
         ( IOGBN  = :s_iwnm) ;
	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox("Ȯ��", "[�ڻ�â�� - ������ �̿��ڷ� ����] �� ������ �߻��߽��ϴ�." )
		return 0
	end if
	COMMIT;

  /* �ڻ�â�� - ������ �̿��ڷ� ���� */
  	DELETE FROM STOCKMONTH_LOT
   	  WHERE ( STOCK_YYMM = :s_yymm2 ) AND 
         ( IOGBN  = :s_iwnm) ;
	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox("Ȯ��", "[�ڻ�â�� - ������ �̿��ڷ� ����] �� ������ �߻��߽��ϴ�." )
		return 0
	end if
	COMMIT;
	
  /* ����ó   - ������ �̿��ڷ� ���� */
	Update stockmonth_vendor
		 set iwol_stock_qty = 0
	 where base_yymm 	= :s_yymm2;

	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox("Ȯ��", "[����ó   - ������ �̿��ڷ� ����] �� ������ �߻��߽��ϴ�." )
		return 0
	end if
	COMMIT;
	
	//���� 30�ڸ� ���� 
	serror = '123456789012345678901234567890'
	
   sqlca.erp000001000(gs_sabu, s_yymm, s_yymm2, s_iwnm, serror);
	If serror <> 'N' then
		sle_msg.text = ''
		rollback;
		f_message_chk(89,'[' + serror + ']') 
		return
	end if
	
	iReturn = sqlca.erp000000905(gs_sabu, s_yymm);
	If ireturn < 0  then
		sle_msg.text = ''
		rollback;	
		f_message_chk(89,'[������� �������̽� ����] [ ' + string(ireturn) + ' ]') 
		return
	end if
	
NEXT

Commit;
sle_msg.text = "���Ҹ��� ó���Ǿ����ϴ�.!!"


end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_exit from w_inherite`p_exit within w_mat_03030
integer x = 3429
integer y = 72
end type

type p_can from w_inherite`p_can within w_mat_03030
boolean visible = false
integer x = 2011
integer y = 2396
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_mat_03030
boolean visible = false
integer x = 795
integer y = 2396
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_mat_03030
boolean visible = false
integer x = 969
integer y = 2396
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_mat_03030
integer x = 3250
integer y = 72
end type

event p_del::clicked;call super::clicked;String  s_yymm, serror

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm 	= trim(dw_insert.GetItemString(1, 'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if

if s_yymm < '200701' then
	Messagebox('Ȯ��',"2007�� ���� ���Ҹ��� �����۾��� �Ұ��մϴ�!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	

//��ǥó�� �� �����ִ��� ���� üũ�Ͽ� ���� ����� �� ������ üũ

IF Messagebox('����Ȯ��',"���� ����������� ��������� �Է½� ���س������ �������� �̷��ڷḦ �����մϴ�."+&
              '~n~n' +  "�����̷��� ���� �Ͻðڽ��ϱ�?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)

// ���Լ��� History����
sError = 'X'
sqlca.erp000001070(gs_sabu, s_yymm, serror);
If serror <> 'N' then
	sle_msg.text = ''
	rollback;
	f_message_chk(89,'[' + serror + ']') 
	return
end if

/* ���Ҹ��� ��ǥ�̷� ���� */
DELETE FROM JUNPYO_CLOSING  
WHERE SABU   = :gs_sabu AND JPGU = 'C0' AND
      JPDAT >= :s_yymm   ;
		
if sqlca.sqlcode < 0 then 
	rollback;	
	f_message_chk(31,'') 
	return
end if

commit;
sle_msg.text = "�����̷� ���� �Ϸ�"

end event

type p_mod from w_inherite`p_mod within w_mat_03030
boolean visible = false
integer x = 1664
integer y = 2396
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_mat_03030
end type

type cb_mod from w_inherite`cb_mod within w_mat_03030
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_mat_03030
end type

type cb_del from w_inherite`cb_del within w_mat_03030
end type

type cb_inq from w_inherite`cb_inq within w_mat_03030
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_mat_03030
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_mat_03030
end type

type cb_can from w_inherite`cb_can within w_mat_03030
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_mat_03030
integer x = 2459
integer y = 2612
end type





type gb_10 from w_inherite`gb_10 within w_mat_03030
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_mat_03030
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_03030
end type

type st_41 from statictext within w_mat_03030
integer x = 1015
integer y = 1636
integer width = 1819
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "* �����̷»����� ���س�� ���Ŀ� �����̷��� ��� �����Ѵ�."
boolean focusrectangle = false
end type

type st_3 from statictext within w_mat_03030
integer x = 1074
integer y = 1708
integer width = 2478
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "Ex) ���س�� 1999�� 11���� �Է½� 11�� �̷� �����Ͽ� ���Ŀ� �ڷḦ ��� �����Ѵ�."
boolean focusrectangle = false
end type

type st_22 from statictext within w_mat_03030
integer x = 1015
integer y = 1444
integer width = 1490
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "* ���Ҹ��������� ���س���� ���� ������ �����Ͽ� "
boolean focusrectangle = false
end type

type st_33 from statictext within w_mat_03030
integer x = 2491
integer y = 1444
integer width = 261
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 255
long backcolor = 33027312
boolean enabled = false
string text = "�̿����"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_44 from statictext within w_mat_03030
integer x = 2757
integer y = 1444
integer width = 677
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "�� ������Ų��."
boolean focusrectangle = false
end type

type st_45 from statictext within w_mat_03030
integer x = 1015
integer y = 1828
integer width = 2327
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "* ���Ҹ��� �ڷ� ���� �� �����ܰ��� ���� ��� Interface �ڷᵵ ���� �����Ѵ�."
boolean focusrectangle = false
end type

type st_34 from statictext within w_mat_03030
integer x = 1074
integer y = 1516
integer width = 2478
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "Ex) ���س�� 2000.06 �Է½� 2000.07 �� �̿��ڷ� ����"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_mat_03030
integer x = 1403
integer y = 428
integer width = 1938
integer height = 844
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_mat_03030_b"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_42 from statictext within w_mat_03030
integer x = 1015
integer y = 1952
integer width = 2327
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "*  �ܰ����������� ������ �ְ� ���ܰ��� 0 �� ��� ����ȴ�. "
boolean focusrectangle = false
end type

type st_2 from statictext within w_mat_03030
integer x = 1111
integer y = 2028
integer width = 2089
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "��, ���������� ��� �������(���������� ������ �̿������� �����ϹǷ�)"
boolean focusrectangle = false
end type

type st_49 from statictext within w_mat_03030
integer x = 1015
integer y = 2140
integer width = 2734
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "*  ��������������̽� �ڷ� ������ ǰ�񱸺��� �����ڵ� ~'05~'���� ó�������� 1 �� �ڷḸ ����"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_mat_03030
boolean visible = false
integer x = 3451
integer y = 256
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('ldate')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'ldate', gs_code)



end event

type rr_1 from roundrectangle within w_mat_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1106
integer y = 412
integer width = 2514
integer height = 896
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 864
integer y = 1360
integer width = 2999
integer height = 896
integer cornerheight = 40
integer cornerwidth = 55
end type

