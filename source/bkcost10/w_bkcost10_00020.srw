$PBExportHeader$w_bkcost10_00020.srw
$PBExportComments$ item�� ���Ŀ��� ���
forward
global type w_bkcost10_00020 from w_inherite
end type
type p_1 from picture within w_bkcost10_00020
end type
end forward

global type w_bkcost10_00020 from w_inherite
integer height = 2360
string title = "ITEM�� ���Ŀ��� ���"
long backcolor = 80859087
p_1 p_1
end type
global w_bkcost10_00020 w_bkcost10_00020

on w_bkcost10_00020.create
int iCurrent
call super::create
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
end on

on w_bkcost10_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
end on

event open;call super::open;string sdate
int    nRow

sdate = f_today()

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nrow,'fryymm',left(sdate,6))
dw_insert.SetItem(nrow,'toyymm',left(sdate,6))
end event

type dw_insert from w_inherite`dw_insert within w_bkcost10_00020
integer x = 1147
integer y = 500
integer width = 2249
integer height = 1096
integer taborder = 10
string dataobject = "d_bkcost_00020_2"
boolean border = false
end type

event dw_insert::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'sdate'
		sdate = Left(data,4) + Mid(data,5,2) + Right(data,2)
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
	      Return 1
      END IF
End Choose
end event

event dw_insert::editchanged;ib_any_typing = False
end event

type p_delrow from w_inherite`p_delrow within w_bkcost10_00020
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_bkcost10_00020
boolean visible = false
end type

type p_search from w_inherite`p_search within w_bkcost10_00020
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_bkcost10_00020
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_bkcost10_00020
integer x = 3154
integer y = 324
end type

type p_can from w_inherite`p_can within w_bkcost10_00020
boolean visible = false
end type

type p_print from w_inherite`p_print within w_bkcost10_00020
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_bkcost10_00020
boolean visible = false
end type

type p_del from w_inherite`p_del within w_bkcost10_00020
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_bkcost10_00020
boolean visible = false
end type

type cb_exit from w_inherite`cb_exit within w_bkcost10_00020
integer x = 1989
integer y = 1200
integer width = 443
integer taborder = 40
end type

type cb_mod from w_inherite`cb_mod within w_bkcost10_00020
integer x = 878
integer y = 2416
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_bkcost10_00020
integer x = 517
integer y = 2416
end type

type cb_del from w_inherite`cb_del within w_bkcost10_00020
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_bkcost10_00020
integer x = 1600
integer y = 2416
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_bkcost10_00020
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_bkcost10_00020
end type

type cb_can from w_inherite`cb_can within w_bkcost10_00020
integer x = 1509
integer y = 1200
integer width = 443
integer taborder = 30
string text = "�������(&C)"
end type

event cb_can::clicked;call super::clicked;//string sDate
//int    nRow,nCnt
//
//dw_insert.AcceptText()
//nRow  = dw_insert.GetRow()
//If nRow <=0 Then Return
//	  
//sDate = Trim(dw_insert.GetItemString(nRow,'sdate'))
//If IsNull(sdate) Or sdate = '' Then
//   f_message_chk(1400,'[��������]')
//	Return 1
//End If
//
//
///* ����ó���� ���� Ȯ�� */
//  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
//    INTO :nCnt
//    FROM "JUNPYO_CLOSING"  
//   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//         ( "JUNPYO_CLOSING"."JPGU" = 'B0' ) AND  
//         ( "JUNPYO_CLOSING"."JPDAT" = :sDate )   ;
//
//If nCnt = 0 Then
//	f_message_chk(66,'[����ó�� Ȯ��]')
//	Return 
//End If
//
//IF MessageBox("��  ��", "�ϸ����� ��� ó���˴ϴ�." +"~n~n" +&
//                     	"��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
//
//
//DELETE FROM "JUNPYO_CLOSING"  
//   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//         ( "JUNPYO_CLOSING"."JPGU" = 'B0' ) AND  
//         ( "JUNPYO_CLOSING"."JPDAT" = :sDate ) AND  
//         ( "JUNPYO_CLOSING"."DEPOT" = '000000' )   ;
//
//If sqlca.sqlcode <> 0 Then
//	f_message_chk(32,sqlca.sqlerrtext)
//	RollBack;
//	Return
//End If
//
// DELETE FROM "ORDER_NOT_HOLD"  
//  WHERE ( "ORDER_NOT_HOLD"."SABU" = :gs_sabu ) AND  
//        ( "ORDER_NOT_HOLD"."ORDER_DATE" = :sDate ) ;
//
//If sqlca.sqlcode <> 0 Then
//	f_message_chk(32,sqlca.sqlerrtext)
//	RollBack;
//	Return
//End If
//
//
//Commit;
//MessageBox('�Ҵ� �ϸ��� ���','������� �Ǿ����ϴ�.')
//
end event

type cb_search from w_inherite`cb_search within w_bkcost10_00020
integer x = 1029
integer y = 1200
integer width = 443
integer taborder = 20
string text = "����ó��(&P)"
end type

event cb_search::clicked;call super::clicked;//string sDate
//int    nRow,nCnt
//
//dw_insert.AcceptText()
//nRow  = dw_insert.GetRow()
//If nRow <=0 Then Return
//	  
//sDate = Trim(dw_insert.GetItemString(nRow,'sdate'))
//If IsNull(sdate) Or sdate = '' Then
//   f_message_chk(1400,'[��������]')
//	Return 1
//End If
//
///* ����ó���� ���� Ȯ�� */
//  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
//    INTO :nCnt
//    FROM "JUNPYO_CLOSING"  
//   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//         ( "JUNPYO_CLOSING"."JPGU" = 'B0' ) AND  
//         ( "JUNPYO_CLOSING"."JPDAT" = :sDate )   ;
//
//If nCnt > 0 Then
//	f_message_chk(60,'')
//	Return 
//End If
//
///* ��ǥ ������ ��� */
//INSERT INTO "JUNPYO_CLOSING"  
//         ( "SABU",           "JPGU",         "JPDAT",           "DEPOT" )  
//  VALUES ( :gs_sabu,           'B0',         :sDate,           '000000' ) ;
//
//
//If sqlca.sqlcode = 0 Then
//	MessageBox('�Ҵ� �ϸ���','����ó�� �Ǿ����ϴ�.')
//   commit;
//Else
//	f_message_chk(32,sqlca.sqlerrtext)
//	Rollback;
//End If
//
end event







type gb_button1 from w_inherite`gb_button1 within w_bkcost10_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_bkcost10_00020
end type

type p_1 from picture within w_bkcost10_00020
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 2962
integer y = 324
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\���_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event clicked;If dw_insert.AcceptText() = -1 Then Return

String sFryymm, sToyymm, sError
Double dIoqty=0
Long ll_cnt

Double dMat_amt=0, dIga_amt = 0, dOga_amt = 0

sFryymm  = Trim(dw_insert.GetItemString(1, 'fryymm'))
If sFryymm = '' or isNull(sFryymm) then
	f_Message_Chk(35, '[���س��]')
	dw_insert.SetColumn('fryymm')
	Return 1
End If

sToyymm  = Trim(dw_insert.GetItemString(1, 'toyymm'))
If sToyymm = '' or isNull(sToyymm) then
	f_Message_Chk(35, '[���س��]')
	dw_insert.SetColumn('toyymm')
	Return 1
End If

dMat_amt = dw_insert.GetItemDecimal(1, 'mat_amt')
dIga_amt = dw_insert.GetItemDecimal(1, 'iga_amt')
dOga_amt = dw_insert.GetItemDecimal(1, 'oga_amt')

if dMat_amt = 0 and dIga_amt = 0 and dOga_amt = 0 then
	MessageBox("�ݾ׾���","����, ������ ���� �����ϴ�.!!!")	
	return
end if 

select count(*) into :ll_cnt
  from bk_cost_production
 where SAUPJ = '%' and yymm_fr = :sFryymm and yymm_to = :sToyymm;	
if ll_cnt > 0 then
	if MessageBox("����Ȯ��", sFryymm + " ~ " +sToyymm + "�Ⱓ�� ITEM�� ��������ڷᰡ �����մϴ�. ���� �Ͻðڽ��ϱ�? ", question!,yesno!, 1) <> 1 THEN Return
else
	if MessageBox("����Ȯ��", sFryymm + " ~ " +sToyymm + "�Ⱓ�� ITEM�� ������� �ڷ��� ���� �Ͻðڽ��ϱ�? ", question!,yesno!, 1) <> 1 THEN Return																	
end if

SetPointer(HourGlass!)

sError = 'N'
sqlca.sp_bkcost_main('%', sFryymm, sToyymm, dMat_amt, dIga_amt, dOga_amt, sError);
if sError <> 'N' then
	MessageBox("��������","�ٽ� ���� �� �ּ���.!!!")
	return
end if

MessageBox("�����Ϸ�","�ڷ��� �����߽��ϴ�. ��ȸȭ�鿡�� Ȯ���ϼ���.")
end event

