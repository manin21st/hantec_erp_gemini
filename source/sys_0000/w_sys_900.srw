$PBExportHeader$w_sys_900.srw
$PBExportComments$���� �ڷ� ���� SYSTEM
forward
global type w_sys_900 from w_inherite
end type
type st_41 from statictext within w_sys_900
end type
type st_3 from statictext within w_sys_900
end type
type st_22 from statictext within w_sys_900
end type
type st_45 from statictext within w_sys_900
end type
type st_46 from statictext within w_sys_900
end type
type st_4 from statictext within w_sys_900
end type
type st_5 from statictext within w_sys_900
end type
type dw_1 from datawindow within w_sys_900
end type
type rr_1 from roundrectangle within w_sys_900
end type
type rr_2 from roundrectangle within w_sys_900
end type
end forward

global type w_sys_900 from w_inherite
string title = "���� �ڷ� ���� "
st_41 st_41
st_3 st_3
st_22 st_22
st_45 st_45
st_46 st_46
st_4 st_4
st_5 st_5
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sys_900 w_sys_900

on w_sys_900.create
int iCurrent
call super::create
this.st_41=create st_41
this.st_3=create st_3
this.st_22=create st_22
this.st_45=create st_45
this.st_46=create st_46
this.st_4=create st_4
this.st_5=create st_5
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_41
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_22
this.Control[iCurrent+4]=this.st_45
this.Control[iCurrent+5]=this.st_46
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_sys_900.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_41)
destroy(this.st_3)
destroy(this.st_22)
destroy(this.st_45)
destroy(this.st_46)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_Insert.Insertrow(0)
dw_1.Settransobject(sqlca)

dw_insert.SetColumn("syymm")
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_sys_900
integer x = 1664
integer y = 664
integer width = 1179
integer height = 256
string dataobject = "d_sys_900"
boolean border = false
end type

event dw_insert::itemchanged;STRING s_date, snull

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date + '01') = -1	then
      f_message_chk(35, '[���س��]')
		this.setitem(1, "syymm", snull)
		return 1
	END IF
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sys_900
boolean visible = false
integer x = 2519
integer y = 2248
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sys_900
boolean visible = false
integer x = 2345
integer y = 2248
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sys_900
boolean visible = false
integer x = 1650
integer y = 2248
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sys_900
integer x = 2446
integer y = 928
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_ins::clicked;call super::clicked;String  s_yymm, sDepot, sValid_yn, sJego_yn
long    get_count
int     iReturn, k 

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm 	= trim(dw_insert.GetItemString(1, 'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	

if s_yymm < '200701' then
	Messagebox('Ȯ��',"2007�� ���� ���Һ��� �۾��� �Ұ��մϴ�!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	


SELECT COUNT(*)
  INTO :get_count
  FROM STOCKMONTH  
 WHERE STOCK_YYMM = :s_yymm
   AND IOGBN      IN ( SELECT IOGBN FROM IOMATRIX 
							   WHERE SABU = :gs_sabu AND TRANSGUB = 'Y' )  ;

if get_count < 1 then
	MessageBox('Ȯ ��', '���س���� �̿���� �������� �ʽ��ϴ�. ���س���� Ȯ���ϼ���!')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	

IF Messagebox('�ڷẹ��',"�ڷẹ��ó�� �Ͻðڽ��ϱ�?", Question!,YesNo!,2) = 2 THEN RETURN 

//dw_1.retrieve()

sle_msg.text = "�����ڷ� ���� �� ............"

SetPointer(HourGlass!)

iReturn = sqlca.FUN_RECOVERY(gs_sabu, s_yymm);
If ireturn < 0  then
	sle_msg.text = ''
	rollback;	
	f_message_chk(89,'[���� �ڷ� ����] [ ' + string(ireturn) + ' ]') 
	return
end if

//FOR k=1 TO dw_1.RowCount()
// 
//   sDepot    = dw_1.GetItemString(k, 'cvcod')
//   sValid_yn = dw_1.GetItemString(k, 'rewapunish')  //������� ���̳ʽ� ��� ����
//   sJego_yn  = dw_1.GetItemString(k, 'kyungy')      //����� ���̳ʽ� ��� ����
//	
//   UPDATE "VNDMST"  
//      SET "REWAPUNISH" = :sValid_yn,  "KYUNGY" = :sJego_yn  
//    WHERE "VNDMST"."CVCOD" = :sDepot   ;
//	 
//	IF SQLCA.SQLCODE <> 0 THEN  
//		Rollback;	
//		f_message_chk(89,'[â�� �ڷ� ����]') 
//		Return
//	END IF
//NEXT
//	
Commit;
sle_msg.text = "�����ڷᰡ ���� �Ǿ����ϴ�.!!"


end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sys_900
integer x = 2624
integer y = 928
end type

type p_can from w_inherite`p_can within w_sys_900
boolean visible = false
integer x = 3040
integer y = 2248
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_sys_900
boolean visible = false
integer x = 1824
integer y = 2248
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sys_900
boolean visible = false
integer x = 1998
integer y = 2248
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_sys_900
boolean visible = false
integer x = 2866
integer y = 2248
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sys_900
boolean visible = false
integer x = 2693
integer y = 2248
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_sys_900
end type

type cb_mod from w_inherite`cb_mod within w_sys_900
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_sys_900
end type

type cb_del from w_inherite`cb_del within w_sys_900
integer x = 1294
integer y = 2360
integer width = 581
integer height = 120
integer textsize = -9
boolean enabled = false
string text = "�����̷»���(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_sys_900
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_sys_900
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_sys_900
end type

type cb_can from w_inherite`cb_can within w_sys_900
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_sys_900
integer x = 2459
integer y = 2612
end type





type gb_10 from w_inherite`gb_10 within w_sys_900
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_sys_900
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_900
end type

type st_41 from statictext within w_sys_900
integer x = 882
integer y = 1484
integer width = 3031
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33554431
boolean enabled = false
string text = "1. ���س�� �����Ͽ� ���� �����(STOCKMONTH, STOCKMONTH_VENDOR) �ڷ����(��, ���س�� �̿��� ����)"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sys_900
integer x = 805
integer y = 1400
integer width = 2478
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 33554431
boolean enabled = false
string text = "* �ڷẹ�� ó�� ����"
boolean focusrectangle = false
end type

type st_22 from statictext within w_sys_900
integer x = 805
integer y = 1240
integer width = 2725
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 33554431
boolean enabled = false
string text = "* �̿��ڷᰡ �����ϴ� ���س���� �Է½� �����ڷ�(����ó ������ ���, �����)�� ������Ų��."
boolean focusrectangle = false
end type

type st_45 from statictext within w_sys_900
integer x = 882
integer y = 1580
integer width = 2327
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33554431
boolean enabled = false
string text = "2. ����(IMHIST)�ڷḦ �о ������ ����� ����, �ݾ��� ������Ų��."
boolean focusrectangle = false
end type

type st_46 from statictext within w_sys_900
integer x = 882
integer y = 1676
integer width = 2345
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33554431
boolean enabled = false
string text = "3. ���(STOCK, STOCK_VENDOR)�� ����� ����� ������ ��� ������Ų��."
boolean focusrectangle = false
end type

type st_4 from statictext within w_sys_900
integer x = 805
integer y = 1848
integer width = 2062
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 16711680
long backcolor = 33554431
boolean enabled = false
string text = "����) �ڷḦ ������ ���Ҹ��� ó���� �Ͽ� �̿���� �������Ѿ� �Ѵ�."
boolean focusrectangle = false
end type

type st_5 from statictext within w_sys_900
integer x = 827
integer y = 392
integer width = 2935
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 255
long backcolor = 33554431
boolean enabled = false
string text = "�� ���� �ڷ� ���� �۾��� ����ڰ� �ִ� ��쿡�� ������� ���ð� ���� �߰��� �۾��Ͻñ� �ٶ��ϴ�."
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sys_900
boolean visible = false
integer x = 37
integer y = 2172
integer width = 160
integer height = 36
boolean bringtotop = true
string dataobject = "d_sys_900_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sys_900
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33554431
integer x = 658
integer y = 348
integer width = 3191
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sys_900
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33554431
integer x = 462
integer y = 1196
integer width = 3584
integer height = 768
integer cornerheight = 40
integer cornerwidth = 55
end type

