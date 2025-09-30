$PBExportHeader$w_sal_05020.srw
$PBExportComments$���� �� ���� ������
forward
global type w_sal_05020 from w_inherite
end type
type st_2 from statictext within w_sal_05020
end type
type st_3 from statictext within w_sal_05020
end type
type st_4 from statictext within w_sal_05020
end type
type st_5 from statictext within w_sal_05020
end type
type dw_cvcod from datawindow within w_sal_05020
end type
type st_6 from statictext within w_sal_05020
end type
type rr_1 from roundrectangle within w_sal_05020
end type
type rr_2 from roundrectangle within w_sal_05020
end type
type rr_3 from roundrectangle within w_sal_05020
end type
type rr_4 from roundrectangle within w_sal_05020
end type
end forward

global type w_sal_05020 from w_inherite
string title = "���� �� ���� ������"
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
dw_cvcod dw_cvcod
st_6 st_6
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sal_05020 w_sal_05020

forward prototypes
public function integer wf_auto_calc (string sdate, string sdate2)
end prototypes

public function integer wf_auto_calc (string sdate, string sdate2);Long nCnt, rtn

select count(*) into :ncnt
  from vnddc
 where substr(start_date,1,6) = substr(:sDate2,1,6);

If IsNull(nCnt ) Then nCnt = 0

IF nCnt > 0 Then
	If MessageBox("�Ϳ� ������ �ڵ�����","������۳���� �ڷᰡ �̹� ��ϵǾ� �ֽ��ϴ�~r~n~r~n " + &
                          "�ش� �������ڷ� ��ϵ� �ڷᰡ ������� �����˴ϴ�." +"~n~n" +&
								  "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN -1
End If

SetPointer(hourglass!)

rtn = sqlca.fun_calc_vnddc(gs_sabu,'1',sDate,sDate2,'%','%')

Choose Case rtn
  Case 0
	   commit;
	   MessageBox('�Ϳ�������','ó���� �Ǽ��� �����ϴ�~r~n~r~n',Information!,Ok!)
  Case IS > 0
	   commit;
	   MessageBox('�Ϳ�������','�ŷ�ó ������ �ڵ������ �Ϸ�Ǿ����ϴ�~r~n~r~n'+string(rtn),Information!,Ok!)
		
		/* �������� �ŷ�ó */
		dw_cvcod.Retrieve()
  Case -1
	   rollback;
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		f_message_chk(39,'[�ŷ�ó ������ �ڵ����]')
		Return -1
  Case -3
	   rollback;
		f_message_chk(39,'[�Ϳ� ������ ���� ����]')
		Return -1
	Case Else
	   rollback;
		f_message_chk(39,'[�Ϳ� ������ ���� ERROR]')
		Return -1
End Choose

Return 0
end function

on w_sal_05020.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.dw_cvcod=create dw_cvcod
this.st_6=create st_6
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.dw_cvcod
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.rr_4
end on

on w_sal_05020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.dw_cvcod)
destroy(this.st_6)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;string sdate, sChkdate
int    nRow

sdate = f_today()

nRow = dw_insert.InsertRow(0)

/* ���� ���� ��� */
String slast_ym
SELECT Max("JUNPYO_CLOSING"."JPDAT"  )
  INTO :sLast_ym
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		 ( "JUNPYO_CLOSING"."JPGU" = 'G1' ) ;
		 
dw_insert.SetItem(nrow,'ladate',slast_ym)
sChkdate = f_aftermonth(sLast_ym, 1)
dw_insert.SetItem(nrow,'sdate',sChkdate)

/* �������� �ŷ�ó */
dw_cvcod.SetTransObject(sqlca)
dw_cvcod.Retrieve()
end event

type dw_insert from w_inherite`dw_insert within w_sal_05020
integer x = 704
integer y = 456
integer width = 1801
integer height = 356
string dataobject = "d_sal_05020_01"
boolean border = false
end type

event dw_insert::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'sdate'
		sdate = Trim(GetText())
		If f_datechk(sdate+'01') <> 1 Then
			f_message_chk(35,'')
	      Return 1
      END IF
	Case 'sdate2'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
	      Return 1
      END IF
	Case 'gubun'
		If GetText() = 'Y' Then Post SetColumn('sdate2')
End Choose
end event

event dw_insert::editchanged;ib_any_typing = False
end event

event dw_insert::itemerror;Return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_05020
boolean visible = false
integer x = 2034
integer y = 2260
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_05020
boolean visible = false
integer x = 1861
integer y = 2260
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_05020
integer x = 1856
integer y = 1536
integer width = 306
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\����ó��_up.gif"
end type

event p_search::clicked;call super::clicked;string sDate, sDate2, sGubun, sladate, schkdate
int    nRow,nCnt

If dw_insert.AcceptText() <> 1 then Return

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return
	  
sDate = Trim(dw_insert.GetItemString(nRow,'sdate'))
If f_datechk(sDate+'01') <> 1 Then
   f_message_chk(1400,'[��������]')
	Return 1
End If

sLaDate = Trim(dw_insert.GetItemString(nRow,'ladate'))

sChkdate = f_aftermonth(sLadate, 1)

If not isnull(sladate)  then
   if schkdate <> sDate Then
		MessageBox("������� Ȯ��", "��������� ���� ������� + 1�� ���� �մϴ�", stopsign!)
		return
	End if
end if

sGubun = Trim(dw_insert.GetItemString(nRow,'gubun'))
If sGubun = 'Y' Then
	sDate2 = Trim(dw_insert.GetItemString(nRow,'sdate2'))
	If f_datechk(sDate2) <> 1 Then
		f_message_chk(1400,'[���������]')
		Return 1
	End If
End If

IF MessageBox("�� ����","����ó���� �������� ���� �� �����Է��� �ϽǼ� �����ϴ�." +"~n~n" +&
                    	 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN

/* ���⸶�� */
INSERT INTO "JUNPYO_CLOSING"
         ( "SABU",           "JPGU",         "JPDAT",           "DEPOT" )
  VALUES ( :gs_sabu,        'G0',           :sDate,            '000000' );
  
INSERT INTO "JUNPYO_CLOSING"
         ( "SABU",           "JPGU",         "JPDAT",           "DEPOT" )
  VALUES ( :gs_sabu,        'G1',           :sDate,            '000000' );

If sqlca.sqlcode = 0 Then
	commit;
	
	/* �̿�ó�� */
	sqlca.ERP000000070(gs_sabu, sDate );
	If sqlca.sqlcode = 0 Then
		commit;
		MessageBox('������','����ó�� �Ǿ����ϴ�.')
	Else
		rollback;
		MessageBox('������','����ó�� �����Ͽ����ϴ�.')
   End If
	
	/* �Ϳ������� �ڵ� ���� */
	If sGubun = 'Y' Then
		wf_auto_calc(sDate, sDate2)
	End If
Else
	rollback;
	f_message_chk(32,sqlca.sqlerrtext)
End If

/* ���� ���� ��� */
String slast_ym
SELECT Max("JUNPYO_CLOSING"."JPDAT"  )
  INTO :sLast_ym
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		 ( "JUNPYO_CLOSING"."JPGU" = 'G1' ) ;
		 
dw_insert.SetItem(nrow,'ladate',slast_ym)
sChkdate = f_aftermonth(sLast_ym, 1)
dw_insert.SetItem(nrow,'sdate',sChkdate)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\����ó��_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\����ó��_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_05020
boolean visible = false
integer x = 1687
integer y = 2260
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sal_05020
boolean visible = false
integer x = 3726
integer y = 1536
end type

type p_can from w_inherite`p_can within w_sal_05020
integer x = 2153
integer y = 1536
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\�������_up.gif"
end type

event p_can::clicked;call super::clicked;string sDate, schkdate
int    nRow,nCnt

If dw_insert.AcceptText() <>   1 Then return

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return
	  
sDate 	= Trim(dw_insert.GetItemString(nRow,'sdate'))
schkdate = Trim(dw_insert.GetItemString(nRow,'ladate'))
If IsNull(sdate) Or sdate = '' Then
   f_message_chk(1400,'[��������]')
	Return 1
End If

If sdate <> schkdate then
	Messagebox("�������", "������� ����� ���������� �� ���� �մϴ�", stopsign!)
	return
End if


/* ����ó���� ���� Ȯ�� */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'G1' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sDate )   ;

If nCnt = 0 Then
	f_message_chk(66,'[����ó�� Ȯ��]')
	Return 
End If

IF MessageBox("��  ��", "�������� ��� ó���˴ϴ�." +"~n~n" +&
                     	"��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN


DELETE FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" IN ( 'G0', 'G1' )) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sDate ) AND  
         ( "JUNPYO_CLOSING"."DEPOT" = '000000' )   ;

Choose Case sqlca.sqlcode
	Case 0
		commit;
		MessageBox('������ ���','������� �Ǿ����ϴ�.')
	Case Else
		rollback;
		f_message_chk(32,sqlca.sqlerrtext)
End Choose


/* ���� ���� ��� */
String slast_ym
SELECT Max("JUNPYO_CLOSING"."JPDAT"  )
  INTO :sLast_ym
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		 ( "JUNPYO_CLOSING"."JPGU" = 'G1' ) ;
		 
dw_insert.SetItem(nrow,'ladate',slast_ym)
sChkdate = f_aftermonth(sLast_ym, 1)
dw_insert.SetItem(nrow,'sdate',sChkdate)

end event

event p_can::ue_lbuttonup;PictureName = "C:\erpman\image\�������_up.gif"
end event

event p_can::ue_lbuttondown;PictureName = "C:\erpman\image\�������_dn.gif"
end event

type p_print from w_inherite`p_print within w_sal_05020
boolean visible = false
integer x = 1339
integer y = 2260
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_05020
boolean visible = false
integer x = 1513
integer y = 2260
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_sal_05020
boolean visible = false
integer x = 2226
integer y = 2264
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sal_05020
boolean visible = false
integer x = 3547
integer y = 1536
end type

event p_mod::clicked;call super::clicked;
If dw_cvcod.AcceptText() <> 1 Then Return

If dw_cvcod.RowCount() <= 0 then Return

If dw_cvcod.Update() <> 1 Then
	f_message_chk(32,'')
	RollBack;
	Return
End If

Commit;

dw_cvcod.Retrieve()
end event

type cb_exit from w_inherite`cb_exit within w_sal_05020
integer x = 2779
integer y = 2244
integer width = 443
integer taborder = 60
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_05020
integer x = 2309
integer y = 2244
integer width = 443
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05020
integer x = 517
integer y = 2416
end type

type cb_del from w_inherite`cb_del within w_sal_05020
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_05020
integer x = 1600
integer y = 2416
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_05020
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_05020
end type

type cb_can from w_inherite`cb_can within w_sal_05020
integer x = 960
integer y = 2244
integer width = 443
integer taborder = 50
boolean enabled = false
string text = "�������(&C)"
end type

type cb_search from w_inherite`cb_search within w_sal_05020
integer x = 475
integer y = 2244
integer width = 443
integer taborder = 40
boolean enabled = false
string text = "����ó��(&P)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_05020
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_05020
end type

type st_2 from statictext within w_sal_05020
integer x = 773
integer y = 1052
integer width = 649
integer height = 104
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
string text = "* ����ó���� ����δ�"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_05020
integer x = 1399
integer y = 1052
integer width = 498
integer height = 104
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
string text = "���� �� �����Է�"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_05020
integer x = 1879
integer y = 1044
integer width = 567
integer height = 104
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
string text = "�� �� �� �����ϴ�."
boolean focusrectangle = false
end type

type st_5 from statictext within w_sal_05020
boolean visible = false
integer x = 773
integer y = 1156
integer width = 1490
integer height = 104
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
string text = "* �Ϳ��������� �������� ���� �ڵ������Ǿ����ϴ�."
boolean focusrectangle = false
end type

type dw_cvcod from datawindow within w_sal_05020
boolean visible = false
integer x = 2519
integer y = 508
integer width = 1403
integer height = 980
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sal_05020_02"
boolean border = false
boolean livescroll = true
end type

type st_6 from statictext within w_sal_05020
boolean visible = false
integer x = 2551
integer y = 456
integer width = 462
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�������� �ŷ�ó"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sal_05020
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2514
integer y = 480
integer width = 1417
integer height = 1020
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_05020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 727
integer y = 828
integer width = 1765
integer height = 672
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_05020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 727
integer y = 1516
integer width = 1765
integer height = 188
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sal_05020
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2514
integer y = 1516
integer width = 1417
integer height = 188
integer cornerheight = 40
integer cornerwidth = 55
end type

