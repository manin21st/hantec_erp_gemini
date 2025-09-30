$PBExportHeader$w_kfga03.srw
$PBExportComments$�濵�м��ڷ� �ۼ�
forward
global type w_kfga03 from w_inherite
end type
type cb_1 from commandbutton within w_kfga03
end type
type uo_progress from u_progress_bar within w_kfga03
end type
type dw_update from datawindow within w_kfga03
end type
type dw_cond from datawindow within w_kfga03
end type
end forward

global type w_kfga03 from w_inherite
string title = "�濵�м��ڷ� �ۼ�"
cb_1 cb_1
uo_progress uo_progress
dw_update dw_update
dw_cond dw_cond
end type
global w_kfga03 w_kfga03

type variables
Boolean Lb_amt,Lb_fs,Lb_ma

String   Ls_FromYm,Ls_ToYm
Integer LiD_Ses
String   LsCurrSaupj
end variables

forward prototypes
public function integer wf_delete_table (string sprocess_gubun)
end prototypes

public function integer wf_delete_table (string sprocess_gubun);
IF sprocess_gubun ='CURRENT_MAGAM' THEN
	DELETE FROM "KFZ09DAT"  
   	WHERE "ACYEAR" = :Lid_Ses AND "ACYMF"  = :Ls_FromYm AND "ACYMT" = :Ls_ToYm ;
	
ELSEIF sprocess_gubun = 'YEAR_BUSINESS' THEN
	DELETE FROM "KFZ09WK"  
   	WHERE "ACYEAR" = :Lid_Ses AND "ACYMF"  = :Ls_FromYm AND "ACYMT" = :Ls_ToYm ;
		
ELSEIF sprocess_gubun = 'YEAR_FINANCIAL' THEN
	DELETE FROM "KFZ09WK2"  
   	WHERE "ACYEAR" = :Lid_Ses AND "ACYMF"  = :Ls_FromYm AND "ACYMT" = :Ls_ToYm ;
END IF

IF SQLCA.SQLCODE <> 0 THEN
	RETURN -1
END IF

Return 1

end function

on w_kfga03.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.uo_progress=create uo_progress
this.dw_update=create dw_update
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_progress
this.Control[iCurrent+3]=this.dw_update
this.Control[iCurrent+4]=this.dw_cond
end on

on w_kfga03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_progress)
destroy(this.dw_update)
destroy(this.dw_cond)
end on

event open;call super::open;String  sFromYm,sToYm,sCurYm
Integer iD_Ses

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

sCurYm = Left(F_Today(),6)

SELECT "D_SES",   "DYM01",   	"DYM12"  
	INTO :iD_Ses,	:sFromYm,	:sToYm   
   FROM "KFZ08OM0"  ;

dw_cond.SetItem(1,"acyear",  iD_Ses)
dw_cond.SetItem(1,"acymf",   sFromYm)
dw_cond.SetItem(1,"acymt",   sToYm)

dw_cond.SetColumn("acyear")
dw_cond.SetFocus()

Lb_amt = True
Lb_fs  = True
Lb_ma  = True

//select max(rfgub) into :LsCurrSaupj from reffpf where rfcod = 'AD' and rfgub <> '00';
select max(rfgub) into :LsCurrSaupj from reffpf where rfcod = 'AD' and rfgub <> '00' and rfgub <> '99';
if sqlca.sqlcode <> 0 then
	LsCurrSaupj = '99'
end if
uo_progress.Hide()

ib_any_typing =False
end event

type dw_insert from w_inherite`dw_insert within w_kfga03
boolean visible = false
integer x = 512
integer y = 2568
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfga03
boolean visible = false
integer x = 1833
integer y = 20
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfga03
boolean visible = false
integer x = 1659
integer y = 20
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfga03
boolean visible = false
integer x = 965
integer y = 20
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfga03
boolean visible = false
integer x = 1486
integer y = 20
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfga03
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_kfga03
boolean visible = false
integer x = 2354
integer y = 20
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kfga03
boolean visible = false
integer x = 1138
integer y = 20
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfga03
boolean visible = false
integer x = 1312
integer y = 20
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfga03
boolean visible = false
integer x = 2181
integer y = 20
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfga03
integer x = 4270
integer taborder = 20
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event p_mod::clicked;Int   il_rowcount =0,iFunVal

w_mdi_frame.sle_msg.text =""

IF dw_cond.AcceptText() = -1 THEN RETURN

LiD_Ses   = dw_cond.GetItemNumber(1,"acyear")
Ls_FromYm = dw_cond.GetItemString(1,"acymf")
Ls_ToYm   = dw_cond.GetItemString(1,"acymt")

IF Lid_Ses = 0 OR IsNull(Lid_Ses) THEN
	F_MessageChk(1,'[ȸ��]')
	dw_cond.SetColumn("acyear")
	dw_cond.SetFocus()
	Return	
END IF
IF Ls_FromYm = "" OR IsNull(Ls_FromYm) THEN
	F_MessageChk(1,'[ȸ��]')
	dw_cond.SetColumn("acyear")
	dw_cond.SetFocus()
	Return	
END IF
IF Ls_ToYm = "" OR IsNull(Ls_ToYm) THEN
	F_MessageChk(1,'[ȸ��]')
	dw_cond.SetColumn("acyear")
	dw_cond.SetFocus()
	Return	
END IF

IF Lb_amt =False AND Lb_fs =False AND Lb_ma =False THEN
	MessageBox("Ȯ ��","ó�������� �����ϼ���.!!")
	dw_cond.SetFocus()
	Return
END IF

//IF Lb_amt =True THEN
//	IF MessageBox('Ȯ ��','�ڷḦ �����Ͻðڽ��ϱ�?',Question!,YesNo!) = 1 THEN
//		IF MessageBox('Ȯ ��','������� �����Ͻðڽ��ϱ�?',Question!, YesNo!) = 1 THEN
//			w_mdi_frame.sle_msg.text ="�ǰ�� ó�� ��(�û�ǥ ����)..."
//			IF f_closing_copy(Ls_FromYm,Ls_ToYm,String(Long(Left(Ls_FromYm,4)) - 1)+Right(Ls_FromYm,2),String(Long(Left(Ls_ToYm,4)) - 1)+Right(Ls_ToYm,2)) <> 1 THEN
//				MessageBox("Ȯ ��","�û�ǥ ���� ���� !!")
//				Return -1
//			END IF
//			
//			w_mdi_frame.sle_msg.text = '����� ��ǥ ���� ��...'
//			IF f_closing_sum(Ls_FromYm,Ls_ToYm) <> 1 THEN
//				MessageBox("Ȯ ��","��������� ���� !!")
//				RETURN -1
//			END IF
//			w_mdi_frame.sle_msg.text = '����� ��ǥ ���� �Ϸ�!!'
//		ELSE
//			w_mdi_frame.sle_msg.text ="�ǰ�� ó�� ��(�û�ǥ ����)..."
//			IF f_closing_copy(Ls_FromYm,Ls_ToYm,String(Long(Left(Ls_FromYm,4)) - 1)+Right(Ls_FromYm,2),String(Long(Left(Ls_ToYm,4)) - 1)+Right(Ls_ToYm,2)) <> 1 THEN
//				MessageBox("Ȯ ��","�û�ǥ ���� ���� !!")
//				Return -1
//			END IF
//		END IF
//		
//		IF Lb_amt =True THEN
//			w_mdi_frame.sle_msg.text ="��⸶���ڷ� ��ȯ ��..."
//			SetPointer(HourGlass!)
//			iFunVal = sqlca.fun_create_kfz09dat(LiD_Ses,Ls_FromYm,Ls_ToYm)
//			IF iFunVal = -1 THEN
//				MessageBox('Ȯ ��','��⸶���ڷ� ��ȯ ����!')
//				Return -1
//			END IF
//		END IF
//END IF

IF Lb_amt =True THEN
	wf_Delete_Table("CURRENT_MAGAM")
	
	w_mdi_frame.sle_msg.text ="��⸶���ڷ� ��ȯ ��..."
	SetPointer(HourGlass!)
	iFunVal = sqlca.fun_create_kfz09dat(LiD_Ses,Ls_FromYm,Ls_ToYm)
	IF iFunVal = -1 THEN
		MessageBox('Ȯ ��','��⸶���ڷ� ��ȯ ����!')
		Return -1
	END IF
END IF

IF Lb_fs = True THEN
	wf_Delete_Table("YEAR_FINANCIAL")
	
	w_mdi_frame.sle_msg.text ="�⺰ �繫��ǥ�м� �ۼ� ��..."
	SetPointer(HourGlass!)
	iFunVal = sqlca.fun_create_kfz09wk2(LiD_Ses,Ls_FromYm,Ls_ToYm,'%')
	IF iFunVal = -1 THEN
		MessageBox('Ȯ ��','�⺰ �繫��ǥ�м� �ۼ� ����!')
		Return -1
	END IF	
END IF		

IF Lb_ma = True THEN
	wf_Delete_Table("YEAR_BUSINESS")
	
	w_mdi_frame.sle_msg.text ="�⺰ �濵�м�ǥ �ۼ� ��..."
	SetPointer(HourGlass!)
		iFunVal = sqlca.fun_create_kfz09wk(LiD_Ses,Ls_FromYm,Ls_ToYm)
	IF iFunVal = -1 THEN
		MessageBox('Ȯ ��','�⺰ �濵�м�ǥ �ۼ� ����!')
		Return -1
	END IF
END IF

COMMIT;
w_mdi_frame.sle_msg.text ="�濵�м��ڷ� �ۼ� �Ϸ�!!"

end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kfga03
boolean visible = false
integer x = 3424
integer y = 2760
end type

type cb_mod from w_inherite`cb_mod within w_kfga03
boolean visible = false
integer x = 2944
integer y = 2724
string text = "����"
end type

type cb_ins from w_inherite`cb_ins within w_kfga03
boolean visible = false
integer x = 2592
integer y = 2716
end type

type cb_del from w_inherite`cb_del within w_kfga03
boolean visible = false
integer x = 3127
integer y = 2588
end type

type cb_inq from w_inherite`cb_inq within w_kfga03
boolean visible = false
integer x = 2235
integer y = 2716
end type

type cb_print from w_inherite`cb_print within w_kfga03
boolean visible = false
integer y = 2588
end type

type st_1 from w_inherite`st_1 within w_kfga03
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfga03
boolean visible = false
integer x = 1678
integer y = 2596
integer width = 526
string text = "�繫��ǥ �м�"
end type

type cb_search from w_inherite`cb_search within w_kfga03
boolean visible = false
integer y = 2588
end type

type dw_datetime from w_inherite`dw_datetime within w_kfga03
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfga03
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfga03
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfga03
boolean visible = false
integer x = 1618
integer y = 2540
end type

type gb_button2 from w_inherite`gb_button2 within w_kfga03
boolean visible = false
integer x = 3013
integer y = 2708
integer width = 773
end type

type cb_1 from commandbutton within w_kfga03
boolean visible = false
integer x = 3058
integer y = 2764
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "ó��(&S)"
end type

type uo_progress from u_progress_bar within w_kfga03
integer x = 1376
integer y = 1744
integer width = 1083
integer height = 72
borderstyle borderstyle = stylelowered!
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type dw_update from datawindow within w_kfga03
boolean visible = false
integer x = 722
integer y = 2412
integer width = 841
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "ó���� �ڷ� ����"
string dataobject = "d_kfga0321"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_cond from datawindow within w_kfga03
event ue_enterkey pbm_dwnprocessenter
integer x = 466
integer y = 284
integer width = 3035
integer height = 1400
integer taborder = 10
string dataobject = "d_kfga031"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String  sFromYm,sToYm,sNull
Integer iD_Ses

SetNull(snull)
IF this.GetColumnName() = "acyear" THEN
	iD_Ses = Integer(this.GetText())
	IF iD_Ses = 0 OR IsNull(iD_Ses) THEN 
		this.SetItem(this.GetRow(),"acymf",sNull)
		this.SetItem(this.GetRow(),"acymt",sNull)
		Return
	END IF
	
	SELECT "DYM01",   	"DYM12"  		INTO :sFromYm,	:sToYm   
		FROM "KFZ08OM0"  
		WHERE "KFZ08OM0"."D_SES" = :iD_Ses ;
		
	dw_cond.SetItem(this.GetRow(),"acymf",   sFromYm)
	dw_cond.SetItem(this.GetRow(),"acymt",   sToYm)
END IF

IF dwo.name ="gubun_amt" THEN
	IF data = '1' THEN
		Lb_amt =True
	ELSE
		Lb_amt =False
	END IF
END IF
IF dwo.name ="gubun_fs" THEN
	IF data = '1' THEN
		Lb_fs =True
	ELSE
		Lb_fs =False
	END IF
END IF
IF dwo.name ="gubun_ma" THEN
	IF data = '1' THEN
		Lb_ma =True
	ELSE
		Lb_ma =False
	END IF
END IF
end event

event itemerror;Return 1
end event

