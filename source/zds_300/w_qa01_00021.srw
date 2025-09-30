$PBExportHeader$w_qa01_00021.srw
$PBExportComments$** ����ǰ���˻� ���� ���(�˾�)
forward
global type w_qa01_00021 from window
end type
type p_del from picture within w_qa01_00021
end type
type p_ins from picture within w_qa01_00021
end type
type p_exit from picture within w_qa01_00021
end type
type p_mod from picture within w_qa01_00021
end type
type st_1 from statictext within w_qa01_00021
end type
type dw_1 from datawindow within w_qa01_00021
end type
type cb_exit from commandbutton within w_qa01_00021
end type
type cb_delete from commandbutton within w_qa01_00021
end type
type cb_insert from commandbutton within w_qa01_00021
end type
type cb_save from commandbutton within w_qa01_00021
end type
type dw_list from datawindow within w_qa01_00021
end type
type rr_2 from roundrectangle within w_qa01_00021
end type
end forward

global type w_qa01_00021 from window
integer x = 379
integer y = 312
integer width = 3072
integer height = 1628
boolean titlebar = true
string title = "���� ǰ���˻� �������"
boolean controlmenu = true
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
rr_2 rr_2
end type
global w_qa01_00021 w_qa01_00021

type variables
char c_status

// �ڷắ�濩�� �˻�
Boolean ib_any_typing 

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����

str_qct_01040 str_01040
str_qa01_00020 str_00020

Datawindow  idw_imhfat
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
dw_1.Reset()
dw_1.insertrow(0)
dw_1.setitem(1, "iojpno", str_00020.iojpno)
dw_1.setitem(1, "itnbr",  str_00020.itnbr)
dw_1.setitem(1, "itdsc",  str_00020.itdsc)
dw_1.setitem(1, "ispec",  str_00020.ispec)
dw_1.setitem(1, "ioqty",  str_00020.ioqty)
dw_1.setitem(1, "buqty",  str_00020.buqty)

/* �˻��׸� */
sItnbr = str_00020.itnbr;

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

if dws1.retrieve('%')	  < 1 then
//	Messagebox("�˻��׸�", "ǰ�� ���� �˻��׸��� �����ϴ�" + '~n' + &
//								  "��ü�˻��׸��� ��µ˴ϴ�")
	dws1.retrieve('%')
end if

dw_list.Retrieve(gs_sabu, str_00020.iojpno)


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
	
	dw_list.setitem(lrow, "iojpno", str_00020.iojpno)

NEXT


RETURN 1
end function

event open;f_window_center_response(This)

/* �˻���׸� */
dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)	

DataWindowChild dws1
dw_list.GetChild("bulcod", dws1)
dws1.SetTransObject(SQLCA)
dws1.Retrieve('%')	

str_00020 = Message.PowerObjectParm

IF IsValid(str_00020) = FALSE THEN Close(This)

wf_initial()


end event

on w_qa01_00021.create
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
this.rr_2=create rr_2
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
this.dw_list,&
this.rr_2}
end on

on w_qa01_00021.destroy
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
destroy(this.rr_2)
end on

type p_del from picture within w_qa01_00021
integer x = 2665
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;long	lrow ,i
Dec{3} dSum_Qty = 0 
String ls_new

dw_list.AcceptText()

lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN

ls_new = Trim(dw_list.Object.is_new[lRow])

dw_list.DeleteRow(lRow)
dw_list.AcceptText()
IF dw_list.RowCount() > 0	THEN
	For i = 1 To dw_list.RowCount()
		dSum_Qty = dSum_Qty + dw_list.GetItemDecimal(i, "buqty")
	Next
//	dw_1.Object.buqty[1] = dSum_Qty
END IF

ib_any_typing = 	False

If ls_new = 'Y' Then Return

IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
	Return
Else
	Commit ;
END IF



SetPointer(Arrow!)


end event

type p_ins from picture within w_qa01_00021
integer x = 2491
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\�߰�_up.gif"
boolean focusrectangle = false
end type

event clicked;
IF f_CheckRequired(dw_list) = -1	THEN	RETURN

ib_any_typing = 	True
//////////////////////////////////////////////////////////////////////////	
long	lRow
lRow = dw_list.InsertRow(0)

dw_list.setitem(lrow, "silyoq", str_00020.siqty)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("bulcod")
dw_list.SetFocus()




end event

type p_exit from picture within w_qa01_00021
integer x = 2839
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
boolean focusrectangle = false
end type

event clicked;

If wf_warndataloss("����ǰ������ ����") < 1 Then Return

CloseWithReturn(parent,"OK")

end event

type p_mod from picture within w_qa01_00021
integer x = 2318
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;//SetPointer(HourGlass!)

If f_msg_update() < 1 Then Return

IF dw_list.AcceptText() = -1 THEN RETURN 

IF	wf_CheckRequiredField() = -1		THEN		RETURN

dec{3} dSum_Qty = 0 ,ld_reqty
Long  i

IF dw_list.RowCount() > 0	THEN
	
	For i = 1 To dw_list.RowCount()
		dSum_Qty = dSum_Qty + dw_list.GetItemDecimal(i, "bulqty")
	Next

	ld_reqty = dw_1.Object.ioqty[1]

	If ld_reqty < dSum_qty Then
		MessageBox('Ȯ��','�԰� �������� �ҷ������� �� ���� �� �����ϴ�.')
		Return
	End If
	
END IF

// �ҷ����� Ȯ��
IF	dw_1.Object.buqty[1] <> dSum_Qty THEN
	MessageBox('Ȯ��','�� �ҷ������� Ʋ���ϴ�!!!')
	Return
End If


st_1.TEXT = '�ڷḦ ������.......'

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
Else
	Commit ;
END IF

ib_any_typing = 	False

SetPointer(Arrow!)

p_exit.TriggerEvent(Clicked!)

/////////////////////////////////////////////////////////////////////////


end event

type st_1 from statictext within w_qa01_00021
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

type dw_1 from datawindow within w_qa01_00021
integer y = 192
integer width = 3035
integer height = 264
integer taborder = 10
string dataobject = "d_qa01_00021_1"
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

type cb_exit from commandbutton within w_qa01_00021
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

type cb_delete from commandbutton within w_qa01_00021
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

type cb_insert from commandbutton within w_qa01_00021
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

type cb_save from commandbutton within w_qa01_00021
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

type dw_list from datawindow within w_qa01_00021
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 18
integer y = 472
integer width = 2976
integer height = 992
integer taborder = 20
string dataobject = "d_qa01_00021_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
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

event itemchanged;
string	ls_code, ls_name,	&
			ls_Null
long		lReturnRow
Dec      ld_bulqty , ld_sum_bulqty

SetNull(ls_null)

// �ҷ��ڵ�
IF Lower(GetColumnName()) = 'bulcod' THEN

	ls_code = this.GetText()
	
	/////////////////////////////////////////////////////////////////////////
	//  1. �ߺ��� ��� RETURN
	/////////////////////////////////////////////////////////////////////////
	lReturnRow = This.Find("bulcod = '"+ls_code+"' ", 1, This.RowCount())

	IF (row <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(33,'[�ҷ��ڵ�]')
		this.SetItem(Row, "bulcod", ls_null)
		RETURN  1
	END IF
	
	
//  SELECT "REFFPF"."RFNA1"  
//    INTO :ls_name  
//    FROM "REFFPF"  
//   WHERE ( "REFFPF"."RFCOD" = '32' ) AND  
//         ( "REFFPF"."RFGUB" = :ls_code )   ;
//	 
//	if sqlca.sqlcode <> 0 	then
//		f_message_chk(33,'[�ҷ��ڵ�]')
//		this.setitem(row, "bulcod", ls_null)
//		return 1
//	end if

ElseIF Lower(GetColumnName()) = 'bulqty' THEN
	
	 ld_bulqty     = dw_1.Object.ioqty[1]
	 ld_sum_bulqty = This.Object.c_buqty[1]
	 
	If ld_bulqty < ld_sum_bulqty Then
		MessageBox('Ȯ��','����� �ҷ������� �԰�������� �����ϴ�.') 
		Return 1
	End If
	 	 
END IF
end event

type rr_2 from roundrectangle within w_qa01_00021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 464
integer width = 2999
integer height = 1012
integer cornerheight = 40
integer cornerwidth = 55
end type

