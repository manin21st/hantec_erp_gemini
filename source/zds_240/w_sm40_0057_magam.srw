$PBExportHeader$w_sm40_0057_magam.srw
$PBExportComments$** ���� ����
forward
global type w_sm40_0057_magam from w_inherite
end type
type st_22 from statictext within w_sm40_0057_magam
end type
type st_34 from statictext within w_sm40_0057_magam
end type
type dw_1 from datawindow within w_sm40_0057_magam
end type
type pb_1 from u_pb_cal within w_sm40_0057_magam
end type
type st_2 from statictext within w_sm40_0057_magam
end type
type rr_2 from roundrectangle within w_sm40_0057_magam
end type
end forward

global type w_sm40_0057_magam from w_inherite
string title = "���� ����"
st_22 st_22
st_34 st_34
dw_1 dw_1
pb_1 pb_1
st_2 st_2
rr_2 rr_2
end type
global w_sm40_0057_magam w_sm40_0057_magam

forward prototypes
public function integer wf_check (string ar_yymm)
end prototypes

public function integer wf_check (string ar_yymm);long ll_cnt = 0 
	
	select count(*) into :ll_cnt
	  from sale_magam x
	 where x.mayymm = :ar_yymm
	   and exists (select 'x' from imhist a , iomatrix b
									 where a.sabu = b.sabu
										and a.iogbn = b.iogbn
										and b.salegu = 'Y'
										and a.yebi1 like :ar_yymm||'%'
/*										and a.saupj = :ar_saupj		*/
										and a.iojpno = x.iojpno) ;
										
return ll_cnt
								
	
	
end function

on w_sm40_0057_magam.create
int iCurrent
call super::create
this.st_22=create st_22
this.st_34=create st_34
this.dw_1=create dw_1
this.pb_1=create pb_1
this.st_2=create st_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_22
this.Control[iCurrent+2]=this.st_34
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rr_2
end on

on w_sm40_0057_magam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_22)
destroy(this.st_34)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_1.Settransobject(sqlca)
dw_1.Retrieve()
dw_Insert.Insertrow(0)

String sLdate, sLyymm

Setnull(sLdate)
Select last_jnpo_date into :sLdate
  from imhist_last_modify
 where sabu = :gs_sabu;

SELECT MAX("SALE_MAGAM"."MAYYMM")  
  INTO :sLyymm
  FROM "SALE_MAGAM" ;
 
dw_insert.setitem(1, "syymm", left(f_today(), 6))
dw_insert.setitem(1, "ldate", sLdate)
dw_insert.setitem(1, "last_mayymm", sLyymm)

dw_insert.SetColumn("syymm")
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_sm40_0057_magam
integer x = 1440
integer y = 652
integer width = 1673
integer height = 376
string dataobject = "d_sm40_0057_magam1"
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

type p_delrow from w_inherite`p_delrow within w_sm40_0057_magam
boolean visible = false
integer x = 1490
integer y = 2396
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm40_0057_magam
boolean visible = false
integer x = 1317
integer y = 2396
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm40_0057_magam
boolean visible = false
integer x = 622
integer y = 2396
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sm40_0057_magam
integer x = 3072
integer y = 72
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_ins::clicked;call super::clicked;String  s_yymm, s_yymm2, serror, s_iwnm, s_maxym, s_maxym2
long    get_count, i
int     iReturn 

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm = trim(dw_insert.GetItemString(1, 'syymm'))
if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	

if s_yymm < '200701' then
	Messagebox('Ȯ��',"2007�� ���� ���⸶�� �۾��� �Ұ��մϴ�!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	


SELECT MAX(MAYYMM)  INTO :s_maxym FROM SALE_MAGAM ; 
if s_maxym = "" or isnull(s_maxym) then 
else
   s_maxym2 = f_aftermonth(s_maxym,1)
   if s_maxym2 < s_yymm then
		Messagebox('Ȯ��',"������ �� ���������� �����Ͻʽÿ�!!!")
		RETURN
	elseif s_maxym = s_yymm then 
		Messagebox('Ȯ��',"�̹� ������ ���س���Դϴ�." +"~n~n" +&
									 "�����ڷḦ �����Ͻð� ���� ���� �Ͻʽÿ�!!!")
		RETURN
  end if
end if	

//if wf_check( s_yymm ) > 0 Then
//	MessageBox('Ȯ��','�̹� ������ ���س���Դϴ�.') 
//	return 
//end if


IF Messagebox('Ȯ��',"���� ���� ó���� �Ͻðڽ��ϱ�?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)


Update imhist x set x.sale_mayymm = :s_yymm
 where x.sabu = :gs_sabu
/*   and x.saupj = :ls_saupj*/
   and x.yebi1 like :s_yymm||'%'
   and exists (select 'x' from iomatrix where iogbn = x.iogbn) ;

// 2017.12.29 - �Ʒ� ���� ���� �������� �� �������� ��ü ��
// where exists (select 'x'
//					  from imhist a ,iomatrix b
//					 where a.sabu = b.sabu
//						and a.iogbn = b.iogbn
//						and b.salegu = 'Y'
//						and a.yebi1 like :s_yymm||'%'
///*							and a.saupj = :ls_saupj		*/
//						and a.iojpno = x.iojpno ) ;

if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
	rollback ;
	MessageBox("Ȯ������1" , "Ȯ������")
	return
else
	
	Insert into SALE_MAGAM
	Select :s_yymm as mayymm ,
			 a.iojpno ,
			 a.cvcod  ,
			 a.itnbr ,
			 a.ioamt ,
			 a.facgbn 
	  from imhist a
	 where a.sabu = :gs_sabu
		and a.sale_mayymm = :s_yymm ;
											
	if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		rollback ;
		MessageBox("Ȯ������2" , "Ȯ������")
		return
	else
		commit;
		
		dw_insert.object.last_mayymm[1] = s_yymm
		w_mdi_frame.sle_msg.text ="�ش���� ������ǥ�� ���� �Ϸ� �Ͽ����ϴ�."
	end if
end if
end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sm40_0057_magam
integer x = 3429
integer y = 72
end type

type p_can from w_inherite`p_can within w_sm40_0057_magam
boolean visible = false
integer x = 2011
integer y = 2396
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_sm40_0057_magam
boolean visible = false
integer x = 795
integer y = 2396
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm40_0057_magam
boolean visible = false
integer x = 969
integer y = 2396
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_sm40_0057_magam
integer x = 3250
integer y = 72
end type

event p_del::clicked;call super::clicked;String  s_yymm, s_yymm2, serror, s_iwnm, s_maxym, s_maxym2
long    get_count, i
int     iReturn 

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm = trim(dw_insert.GetItemString(1, 'syymm'))
if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if

if s_yymm < '200701' then
	Messagebox('Ȯ��',"2007�� ���� ���⸶�� ���� �۾��� �Ұ��մϴ�!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	


SELECT MAX(MAYYMM)  INTO :s_maxym FROM SALE_MAGAM ; 
if s_maxym = "" or isnull(s_maxym) then 
else
   if s_maxym > s_yymm then
		Messagebox('Ȯ��',"���� ���������� ���������� �����Ͻʽÿ�!!!")
		RETURN
	elseif s_maxym < s_yymm then 
		Messagebox('Ȯ��',"������ �����ڷᰡ �������� �ʽ��ϴ�!!!")
		RETURN
  end if
end if	


//if wf_check( s_yymm ) = 0 Then
//	MessageBox('Ȯ��','���� ������ ���س���� �ƴմϴ�.') 
//	return 
//end if


IF Messagebox('Ȯ��',"���� ���� ���� ó���� �Ͻðڽ��ϱ�?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)


Delete from SALE_MAGAM x Where mayymm = :s_yymm ;

if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
	rollback ;
	MessageBox("Ȯ������1" , "Ȯ������")
	return
else
	
	Update imhist x set x.sale_mayymm = null
	 where x.sabu = :gs_sabu
		and x.sale_mayymm = :s_yymm ;
											
	if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		rollback ;
		MessageBox("Ȯ������2" , "Ȯ������")
		return
	else
		commit;
		
		SELECT MAX("IMHIST"."SALE_MAYYMM")  
		  INTO :s_maxym
		  FROM "IMHIST", "IOMATRIX"  
		 WHERE ( "IMHIST"."SABU" = "IOMATRIX"."SABU" ) AND  
				 ( "IMHIST"."IOGBN" = "IOMATRIX"."IOGBN" ) AND
				 ( "IOMATRIX"."SALEGU" = 'Y' ) ;

		dw_insert.object.last_mayymm[1] = s_maxym
		w_mdi_frame.sle_msg.text ="���� ���������� ���� �Ϸ� �Ͽ����ϴ�."
	end if
end if
end event

type p_mod from w_inherite`p_mod within w_sm40_0057_magam
boolean visible = false
integer x = 1664
integer y = 2396
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_sm40_0057_magam
end type

type cb_mod from w_inherite`cb_mod within w_sm40_0057_magam
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_sm40_0057_magam
end type

type cb_del from w_inherite`cb_del within w_sm40_0057_magam
end type

type cb_inq from w_inherite`cb_inq within w_sm40_0057_magam
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_sm40_0057_magam
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_sm40_0057_magam
end type

type cb_can from w_inherite`cb_can within w_sm40_0057_magam
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_sm40_0057_magam
integer x = 2459
integer y = 2612
end type





type gb_10 from w_inherite`gb_10 within w_sm40_0057_magam
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_sm40_0057_magam
end type

type gb_button2 from w_inherite`gb_button2 within w_sm40_0057_magam
end type

type st_22 from statictext within w_sm40_0057_magam
integer x = 1102
integer y = 1248
integer width = 2121
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
string text = "* �� ���� ������ ���س���� ���� ����(����������)�� ���� ó���մϴ�."
boolean focusrectangle = false
end type

type st_34 from statictext within w_sm40_0057_magam
integer x = 1161
integer y = 1328
integer width = 2094
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "- �� ���� ���� �� �� ���� Ȯ������ �˼����� �� �ݾ��� Ȯ���Ͻʽÿ�."
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sm40_0057_magam
boolean visible = false
integer x = 41
integer y = 824
integer width = 457
integer height = 152
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_mat_03030_b"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_sm40_0057_magam
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

type st_2 from statictext within w_sm40_0057_magam
integer x = 1161
integer y = 1412
integer width = 2098
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "- ���� ó���� �� �ش� ���� ���ؼ��� ���� (�˼�) �� �ݾ��� ������ �Ұ��մϴ�."
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sm40_0057_magam
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 791
integer y = 1152
integer width = 2999
integer height = 424
integer cornerheight = 40
integer cornerwidth = 55
end type

