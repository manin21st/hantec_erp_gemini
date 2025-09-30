$PBExportHeader$w_qct_01050.srw
$PBExportComments$����/���ְ˻� ���-�ҷ�
forward
global type w_qct_01050 from window
end type
type p_del from picture within w_qct_01050
end type
type p_ins from picture within w_qct_01050
end type
type p_exit from picture within w_qct_01050
end type
type p_mod from picture within w_qct_01050
end type
type st_1 from statictext within w_qct_01050
end type
type dw_1 from datawindow within w_qct_01050
end type
type cb_exit from commandbutton within w_qct_01050
end type
type cb_delete from commandbutton within w_qct_01050
end type
type cb_insert from commandbutton within w_qct_01050
end type
type cb_save from commandbutton within w_qct_01050
end type
type dw_list from datawindow within w_qct_01050
end type
end forward

global type w_qct_01050 from window
integer x = 379
integer y = 312
integer width = 3095
integer height = 1872
boolean titlebar = true
string title = "�ҷ�,���Ǻγ���"
windowtype windowtype = response!
long backcolor = 32106727
p_del p_del
p_ins p_ins
p_exit p_exit
p_mod p_mod
st_1 st_1
dw_1 dw_1
cb_exit cb_exit
cb_delete cb_delete
cb_insert cb_insert
cb_save cb_save
dw_list dw_list
end type
global w_qct_01050 w_qct_01050

type variables
char c_status

// �ڷắ�濩�� �˻�
Boolean ib_any_typing 

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

str_qct_01040 str_01040
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_initial ()
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_warndataloss (string as_titletext);/*===================================================================
 1. window-level user function : ����, ���, ��ȸ�� ȣ���
    dw_detail, dw_list �� typing(datawindow) ������� �˻�

 2. ��������� ��� ��������� ������� ������ ���                                                               

 3. Argument:  as_titletext (warning messagebox)                                                                          
    Return values:                                                   
                                                                  
      *  1 : ��������� �������� �ʰ� ��� ������ ���.
		* -1 : ������ �ߴ��� ���.                      
=====================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)�� typing ����Ȯ��

	Beep(1)
	IF MessageBox("Ȯ�� : " + as_titletext , &
		 "�������� ���� ���� �ֽ��ϴ�. ~r��������� �����Ͻðڽ��ϱ�", &
		 question!, yesno!) = 1 THEN

		dw_list.SetFocus()						// yes �� ���: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1																// (dw_detail) �� ��������� ���ų� no�� ���
																		// ��������� �������� �ʰ� ������� 


end function

public subroutine wf_initial ();
string	sDateFrom,	&
			sDateTo,		&
			sRemark,		&
			sRemark2, sItnbr, sGrpno1, sIttyp, sjijil, sispec_code 
			
		
/* �⺻���� */
dw_1.insertrow(0)
dw_1.setitem(1, "iojpno", str_01040.iojpno)
dw_1.setitem(1, "itnbr",  str_01040.itnbr)
dw_1.setitem(1, "itdsc",  str_01040.itdsc)
dw_1.setitem(1, "ispec",  str_01040.ispec)
dw_1.setitem(1, "ioqty",  str_01040.ioqty)
dw_1.setitem(1, "buqty",  str_01040.buqty)
dw_1.setitem(1, "joqty",  str_01040.joqty)

/* �˻��׸� */
sItnbr = str_01040.itnbr;
Select a.ittyp, b.grpno1, a.jijil, a.ispec_code 
  into :sIttyp, :sgrpno1, :sjijil, :sispec_code 
  from itemas a,  itemas_inspection b
 where a.itnbr = :sItnbr and a.itnbr = b.itnbr;

dw_1.setitem(1, "ittyp",  sIttyp)
dw_1.setitem(1, "insgbn", sGrpno1)
dw_1.setitem(1, "jijil",  sjijil)
dw_1.setitem(1, "ispec_code", sispec_code)

/* �˻���׸� */
datawindowchild dws1
dw_list.getchild("bulcod", dws1)
dws1.settransobject(sqlca)
if dws1.retrieve(sGrpno1+'%')	  < 1 then
	Messagebox("�˻��׸�", "ǰ�� ���� �˻��׸��� �����ϴ�" + '~n' + &
								  "��ü�˻��׸��� ��µ˴ϴ�")
	dws1.retrieve('%')
end if

IF dw_list.Retrieve(gs_sabu, gs_code) <	1		THEN
	cb_insert.triggerevent(clicked!)
END IF

dw_list.SetColumn("bulcod")
dw_list.SetFocus()

end subroutine

public function integer wf_checkrequiredfield ();string	sCode
long		lRow
dec{3}	dQty

FOR lRow = 1	TO		dw_list.RowCount()
	
	// �ҷ��ڵ�
	sCode = dw_list.GetitemString(lRow, "bulcod")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[�ҷ��ڵ�]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("bulcod")
		dw_list.setfocus()
		RETURN -1
	END IF

	// �ҷ�����
	dQty = dw_list.GetitemDecimal(lRow, "bulqty")
	IF IsNull(dQty)	or   dQty = 0	THEN
		f_message_chk(30,'[�ҷ�����]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("bulqty")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	dw_list.setitem(lrow, "iojpno", str_01040.iojpno)

	
NEXT


RETURN 1
end function

event open;f_window_center_response(this)

datawindowchild dws
dw_1.getchild("insgbn", dws)
dws.settransobject(sqlca)
dws.retrieve('%')

/* �˻���׸� */
datawindowchild dws1
dw_list.getchild("bulcod", dws1)
dws1.settransobject(sqlca)
dws1.retrieve('%')	

dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)

IF f_change_name('1') = 'Y' then 
	string s_ispec, s_jijil
	s_ispec = f_change_name('2')
	s_jijil = f_change_name('3')
	dw_1.object.ispec_t.text = s_ispec
	dw_1.object.jijil_t.text = s_jijil
END IF

str_01040 = message.powerobjectparm
wf_initial()

end event

on w_qct_01050.create
this.p_del=create p_del
this.p_ins=create p_ins
this.p_exit=create p_exit
this.p_mod=create p_mod
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_exit=create cb_exit
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_save=create cb_save
this.dw_list=create dw_list
this.Control[]={this.p_del,&
this.p_ins,&
this.p_exit,&
this.p_mod,&
this.st_1,&
this.dw_1,&
this.cb_exit,&
this.cb_delete,&
this.cb_insert,&
this.cb_save,&
this.dw_list}
end on

on w_qct_01050.destroy
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_exit)
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_save)
destroy(this.dw_list)
end on

type p_del from picture within w_qct_01050
integer x = 2853
integer y = 392
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
dw_list.DeleteRow(0)

end event

type p_ins from picture within w_qct_01050
integer x = 2674
integer y = 392
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\�߰�_up.gif"
boolean focusrectangle = false
end type

event clicked;
IF f_CheckRequired(dw_list) = -1	THEN	RETURN


//////////////////////////////////////////////////////////////////////////
long	lRow
lRow = dw_list.InsertRow(0)

dw_list.setitem(lrow, "silyoq", str_01040.siqty)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("bulcod")
dw_list.SetFocus()


end event

type p_exit from picture within w_qct_01050
integer x = 2853
integer y = 20
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
boolean focusrectangle = false
end type

event clicked;If Messagebox("�ҷ�����", "�ش� ��ǥ�� ���� �ҷ������� �ڵ����� �����˴ϴ�" + '~n' + &
								  "����Ͻð����ϱ�?", question!, yesno!) = 2 then
	Return										  
end if

SetPointer(HourGlass!)

String iojpno
Long   lrow
Datawindow dwname

iojpno = str_01040.iojpno
Lrow	 = str_01040.rowno
dwname = str_01040.dwname
/* �ҷ� �� ���Ǻ� ���� */
Delete from imhfat
 Where sabu = :gs_sabu and iojpno = :iojpno;

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
	close(parent)
END IF

/* �԰��̷¿� �ҷ�,���Ǻθ� 0�� setting */
dwname.setitem(lrow, "imhist_iofaqty", 0)
dwname.setitem(lrow, "imhist_iocdqty", 0)

if str_01040.gubun = 'Y' then  //���԰˻翡�� open�� ��츸 ������ ��ȯ�ʿ� 0 ����
	dwname.setitem(lrow, "imhist_cnviofa", 0)
	dwname.setitem(lrow, "imhist_cnviocd", 0)
	dwname.setitem(lrow, "imhist_gongqty", 0)
	dwname.setitem(lrow, "imhist_cnvgong", 0)
	dwname.setitem(lrow, "imhist_gongprc", 0)
end if

/* ������ �̻� ���� ���� */
Delete from imhfag
 Where sabu = :gs_sabu and iojpno = :iojpno; 

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)
 
close(parent)

end event

type p_mod from picture within w_qct_01050
integer x = 2674
integer y = 20
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;SetPointer(HourGlass!)

if str_01040.buqty > 0 or str_01040.joqty > 0 then
	if dw_list.rowcount() = 0 then
		MessageBox("Ȯ��", "�ڷḦ �Է��Ͻñ� �ٶ��ϴ�.")
		dw_list.SetFocus()
		RETURN
	END IF	
end if

IF dw_list.AcceptText() = -1 THEN RETURN 

IF	wf_CheckRequiredField() = -1		THEN		RETURN

dec{3} dSum_Qty

IF dw_list.RowCount() > 0	THEN
	dSum_Qty = dw_list.GetItemDecimal(1, "sum_buqty")
	if str_01040.buqty <> dSum_Qty then
//		IF dSum_qty <> 1	THEN
			MessageBox("Ȯ��", "�ҷ������� ���� �ʽ��ϴ�.")
			dw_list.SetFocus()
			RETURN
//		END IF
	end if
	
	dSum_Qty = dw_list.GetItemDecimal(1, "sum_joqty")	
	IF dSum_qty <> str_01040.joqty	THEN
		MessageBox("Ȯ��", "���Ǻμ����� ���� �ʽ��ϴ�.")
		dw_list.SetFocus()
		RETURN
	END IF	

END IF

IF f_msg_update() = -1 	THEN	RETURN

st_1.TEXT = '�ڷḦ ������.......'

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)

close(parent)

/////////////////////////////////////////////////////////////////////////


end event

type st_1 from statictext within w_qct_01050
boolean visible = false
integer x = 987
integer y = 1624
integer width = 1225
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_qct_01050
integer y = 12
integer width = 2624
integer height = 540
integer taborder = 10
string dataobject = "d_qct_01051_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
if getcolumnname() = 'ittyp' then
	
	String sNull
	
	datawindowchild dws
	this.getchild("insgbn", dws)
	dws.settransobject(sqlca)
	dws.retrieve(data)	
	
end if

if getcolumnname() = 'insgbn' then
	
	/* �˻���׸� */
	datawindowchild dws1
	dw_list.getchild("bulcod", dws1)
	dws1.settransobject(sqlca)
	dws1.retrieve(data+'%')	
	
end if
end event

type cb_exit from commandbutton within w_qct_01050
boolean visible = false
integer x = 2688
integer y = 1604
integer width = 329
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&X)"
end type

event clicked;If Messagebox("�ҷ�����", "�ش� ��ǥ�� ���� �ҷ������� �ڵ����� �����˴ϴ�" + '~n' + &
								  "����Ͻð����ϱ�?", question!, yesno!) = 2 then
	Return										  
end if

SetPointer(HourGlass!)

String iojpno
Long   lrow
Datawindow dwname

iojpno = str_01040.iojpno
Lrow	 = str_01040.rowno
dwname = str_01040.dwname
/* �ҷ� �� ���Ǻ� ���� */
Delete from imhfat
 Where sabu = :gs_sabu and iojpno = :iojpno;

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
	close(parent)
END IF

/* �԰��̷¿� �ҷ�,���Ǻθ� 0�� setting */
dwname.setitem(lrow, "imhist_iofaqty", 0)
dwname.setitem(lrow, "imhist_iocdqty", 0)

if str_01040.gubun = 'Y' then  //���԰˻翡�� open�� ��츸 ������ ��ȯ�ʿ� 0 ����
	dwname.setitem(lrow, "imhist_cnviofa", 0)
	dwname.setitem(lrow, "imhist_cnviocd", 0)
	dwname.setitem(lrow, "imhist_gongqty", 0)
	dwname.setitem(lrow, "imhist_cnvgong", 0)
	dwname.setitem(lrow, "imhist_gongprc", 0)
end if

/* ������ �̻� ���� ���� */
Delete from imhfag
 Where sabu = :gs_sabu and iojpno = :iojpno; 

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)
 
close(parent)

end event

type cb_delete from commandbutton within w_qct_01050
boolean visible = false
integer x = 475
integer y = 1604
integer width = 407
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�����(&L)"
end type

event clicked;long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
dw_list.DeleteRow(0)




end event

type cb_insert from commandbutton within w_qct_01050
boolean visible = false
integer x = 50
integer y = 1604
integer width = 407
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���߰�(&A)"
end type

event clicked;
IF f_CheckRequired(dw_list) = -1	THEN	RETURN


//////////////////////////////////////////////////////////////////////////
long	lRow
lRow = dw_list.InsertRow(0)

dw_list.setitem(lrow, "silyoq", str_01040.siqty)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("bulcod")
dw_list.SetFocus()


end event

type cb_save from commandbutton within w_qct_01050
boolean visible = false
integer x = 2336
integer y = 1604
integer width = 329
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

event clicked;SetPointer(HourGlass!)

if str_01040.buqty > 0 or str_01040.joqty > 0 then
	if dw_list.rowcount() = 0 then
		MessageBox("Ȯ��", "�ڷḦ �Է��Ͻñ� �ٶ��ϴ�.")
		dw_list.SetFocus()
		RETURN
	END IF	
end if

IF dw_list.AcceptText() = -1 THEN RETURN 

IF	wf_CheckRequiredField() = -1		THEN		RETURN

dec{3} dSum_Qty

IF dw_list.RowCount() > 0	THEN
	dSum_Qty = dw_list.GetItemDecimal(1, "buqty")
	if str_01040.buqty > 0 then
		IF dSum_qty < 1	THEN
			MessageBox("Ȯ��", "�ҷ������� 0�̻��̾�� �մϴ�.")
			dw_list.SetFocus()
			RETURN
		END IF
	end if
	
	dSum_Qty = dw_list.GetItemDecimal(1, "joqty")	
	IF dSum_qty <> str_01040.joqty	THEN
		MessageBox("Ȯ��", "���Ǻμ����� ���� �ʽ��ϴ�.")
		dw_list.SetFocus()
		RETURN
	END IF	

END IF

IF f_msg_update() = -1 	THEN	RETURN

st_1.TEXT = '�ڷḦ ������.......'

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)

close(parent)

/////////////////////////////////////////////////////////////////////////


end event

type dw_list from datawindow within w_qct_01050
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 9
integer y = 560
integer width = 3049
integer height = 1180
integer taborder = 20
string dataobject = "d_qct_01050"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
RETURN 1
end event

on editchanged; ib_any_typing = true
end on

on rowfocuschanged;this.setrowfocusindicator ( HAND! )
end on

event dberror;//String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
//Integer iPos, iCount
//
//iCount			= 0
//sNewline			= '~r'
//sReturn			= '~n'
//sErrorcode 		= Left(sqlerrtext, 9)
//iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
//sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))
//
//For iPos = Len(sErrorSyntax) to 1 STEP -1
//	 sMsg = Mid(sErrorSyntax, ipos, 1)
//	 If sMsg   = sReturn or sMsg = sNewline Then
//		 iCount++
//	 End if
//Next
//
//sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)
//
//
//str_db_error db_error_msg
//db_error_msg.rowno 	 				= row
//db_error_msg.errorcode 				= sErrorCode
//db_error_msg.errorsyntax_system	= sErrorSyntax
//db_error_msg.errorsyntax_user		= sErrorSyntax
//db_error_msg.errorsqlsyntax			= sqlsyntax
//OpenWithParm(w_error, db_error_msg)
//
//
///*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
//		 "Error Code   -> " + sErrorcode			    + '~n' + &
//		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
//		 "SqlSyntax    -> " + Sqlsyntax
//	MESSAGEBOX("�ڷ�ó���� �����߻�", sMsg) */
//
//RETURN 1
end event

event itemchanged;
string	sCode, sName,	&
			sNull
long		lRow, lReturnRow
SetNull(sNull)

lRow = this.GetRow()

// �ҷ��ڵ�
IF this.GetColumnName() = 'bulcod' THEN

	sCode = this.gettext()
	
	/////////////////////////////////////////////////////////////////////////
	//  1. �ߺ��� ��� RETURN
	/////////////////////////////////////////////////////////////////////////
	sCode = THIS.GETTEXT()								

	lReturnRow = This.Find("bulcod = '"+sCode+"' ", 1, This.RowCount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(33,'[�ҷ��ڵ�]')
		this.SetItem(lRow, "bulcod", sNull)
		RETURN  1
	END IF
	
	
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '32' ) AND  
         ( "REFFPF"."RFGUB" = :sCode )   ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[�ҷ��ڵ�]')
		this.setitem(row, "bulcod", sNull)
		return 1
	end if
	 
	 
END IF


end event

