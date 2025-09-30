$PBExportHeader$w_update_sales.srw
$PBExportComments$�������� ����
forward
global type w_update_sales from w_inherite
end type
type st_41 from statictext within w_update_sales
end type
type st_3 from statictext within w_update_sales
end type
type st_22 from statictext within w_update_sales
end type
type st_45 from statictext within w_update_sales
end type
type st_4 from statictext within w_update_sales
end type
type st_5 from statictext within w_update_sales
end type
type st_7 from statictext within w_update_sales
end type
type st_23 from statictext within w_update_sales
end type
type rr_1 from roundrectangle within w_update_sales
end type
type rr_2 from roundrectangle within w_update_sales
end type
type rr_3 from roundrectangle within w_update_sales
end type
end forward

global type w_update_sales from w_inherite
string title = "�������� ����"
st_41 st_41
st_3 st_3
st_22 st_22
st_45 st_45
st_4 st_4
st_5 st_5
st_7 st_7
st_23 st_23
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_update_sales w_update_sales

on w_update_sales.create
int iCurrent
call super::create
this.st_41=create st_41
this.st_3=create st_3
this.st_22=create st_22
this.st_45=create st_45
this.st_4=create st_4
this.st_5=create st_5
this.st_7=create st_7
this.st_23=create st_23
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_41
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_22
this.Control[iCurrent+4]=this.st_45
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.st_23
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.rr_3
end on

on w_update_sales.destroy
call super::destroy
destroy(this.st_41)
destroy(this.st_3)
destroy(this.st_22)
destroy(this.st_45)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_7)
destroy(this.st_23)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_Insert.Insertrow(0)

dw_insert.SetColumn("syymm")
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_update_sales
integer x = 1801
integer y = 684
integer width = 1033
integer height = 164
string dataobject = "d_update_sales"
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

type p_delrow from w_inherite`p_delrow within w_update_sales
boolean visible = false
integer x = 2715
integer y = 2196
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_update_sales
boolean visible = false
integer x = 2542
integer y = 2196
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_update_sales
boolean visible = false
integer x = 1847
integer y = 2196
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_update_sales
integer x = 2592
integer y = 928
string pointer = "C:\erpman\cur\create.cur"
boolean originalsize = true
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

IF Messagebox('�ڷẹ��',"�ڷẹ��ó�� �Ͻðڽ��ϱ�?", Question!,YesNo!,2) = 2 THEN RETURN 

w_mdi_frame.sle_msg.text = "���������ڷ� ���� �� ............"

SetPointer(HourGlass!)
 
iReturn= sqlca.update_salesum(gs_sabu, s_yymm)
If iReturn <> 0  then
	w_mdi_frame.sle_msg.text = ''
	rollback;	
	f_message_chk(89,'[�������� �ڷ� ����] [ ' + string(ireturn) + ' ]') 
	return
end if

iReturn= sqlca.update_expsum(gs_sabu, s_yymm)
If iReturn <> 0  then
	w_mdi_frame.sle_msg.text = ''
	rollback;	
	f_message_chk(89,'[�������� �ڷ� ����] [ ' + string(ireturn) + ' ]') 
	return
end if

sqlca.update_vndjan(gs_sabu, s_yymm)
If sqlca.sqlcode <> 0  then
	w_mdi_frame.sle_msg.text = ''
	rollback;	
	f_message_chk(89,'[�������� �ڷ� ����] [ ' + string(ireturn) + ' ]') 
	return
end if

Commit;
w_mdi_frame.sle_msg.text = "���������ڷᰡ ���� �Ǿ����ϴ�.!!"


end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type p_exit from w_inherite`p_exit within w_update_sales
integer x = 2770
integer y = 928
end type

type p_can from w_inherite`p_can within w_update_sales
boolean visible = false
integer x = 3237
integer y = 2196
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_update_sales
boolean visible = false
integer x = 2021
integer y = 2196
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_update_sales
boolean visible = false
integer x = 2194
integer y = 2196
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_update_sales
boolean visible = false
integer x = 3063
integer y = 2196
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_update_sales
boolean visible = false
integer x = 2889
integer y = 2196
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_update_sales
boolean visible = false
integer x = 649
integer y = 2612
end type

type cb_del from w_inherite`cb_del within w_update_sales
boolean visible = false
integer x = 1294
integer y = 2360
integer width = 581
integer height = 120
integer textsize = -9
boolean enabled = false
string text = "�����̷»���(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_update_sales
boolean visible = false
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_update_sales
boolean visible = false
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_update_sales
end type

type cb_can from w_inherite`cb_can within w_update_sales
boolean visible = false
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_update_sales
boolean visible = false
integer x = 2459
integer y = 2612
end type





type gb_10 from w_inherite`gb_10 within w_update_sales
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_update_sales
end type

type gb_button2 from w_inherite`gb_button2 within w_update_sales
end type

type st_41 from statictext within w_update_sales
integer x = 896
integer y = 1444
integer width = 2907
integer height = 76
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
string text = "1. ���س���� ������(SALESUM, EXPSUM) �ڷ����)"
boolean focusrectangle = false
end type

type st_3 from statictext within w_update_sales
integer x = 800
integer y = 1360
integer width = 2478
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 33027312
boolean enabled = false
string text = "* �ڷẹ�� ó�� ����"
boolean focusrectangle = false
end type

type st_22 from statictext within w_update_sales
integer x = 800
integer y = 1176
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
long backcolor = 33027312
boolean enabled = false
string text = "* ���س���� �Է½� �������� �ڷ�(����,���� �ֹ�����,�ݾ�/�������,�ݾ�)�� ������Ų��."
boolean focusrectangle = false
end type

type st_45 from statictext within w_update_sales
integer x = 896
integer y = 1540
integer width = 2907
integer height = 76
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
string text = "2. ����(SORDER,EXPPIH,IMHIST,EXPCIH)�ڷḦ �о �ֹ� ����/�ݾ�, ���� ����/�ݾ��� ������Ų��."
boolean focusrectangle = false
end type

type st_4 from statictext within w_update_sales
integer x = 800
integer y = 1808
integer width = 2807
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 16711680
long backcolor = 33027312
boolean enabled = false
string text = "����) �ڷḦ ������ ����� ���ݿ�����, ��������� ó���� �Ͽ� �̿��̼����� ��������Ѿ� �Ѵ�."
boolean focusrectangle = false
end type

type st_5 from statictext within w_update_sales
integer x = 800
integer y = 272
integer width = 3022
integer height = 72
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
string text = "�� �������� �ڷ� ���� �۾��� ����ڰ� �ִ� ��쿡�� ������� ���ð� ���� �߰��� �۾��Ͻñ� �ٶ��ϴ�."
boolean focusrectangle = false
end type

type st_7 from statictext within w_update_sales
integer x = 800
integer y = 336
integer width = 3022
integer height = 72
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
string text = "   [  ���� �� ���� �� ������ �Ǿ��ִ� ��쿡�� ���� ���� ��Ҹ� �� �Ŀ� �۾��Ͽ��� �Ѵ�. ]"
boolean focusrectangle = false
end type

type st_23 from statictext within w_update_sales
integer x = 800
integer y = 1232
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
long backcolor = 33027312
boolean enabled = false
string text = "                 (���س�� ���� �����ϱ��� �� �ڷḦ �����Ѵ� )"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_update_sales
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 635
integer y = 232
integer width = 3333
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_update_sales
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 635
integer y = 1104
integer width = 3333
integer height = 852
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_update_sales
long linecolor = 8388608
integer linethickness = 1
long fillcolor = 33027312
integer x = 1627
integer y = 536
integer width = 1344
integer height = 380
integer cornerheight = 40
integer cornerwidth = 55
end type

