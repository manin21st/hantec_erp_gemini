$PBExportHeader$w_pdm_01475.srw
$PBExportComments$���bom(�뷮 ��������)
forward
global type w_pdm_01475 from window
end type
type cbx_1 from checkbox within w_pdm_01475
end type
type p_save from uo_picture within w_pdm_01475
end type
type dw_1 from datawindow within w_pdm_01475
end type
type dw_list from datawindow within w_pdm_01475
end type
type rr_1 from roundrectangle within w_pdm_01475
end type
type p_exit from uo_picture within w_pdm_01475
end type
end forward

global type w_pdm_01475 from window
integer x = 379
integer y = 148
integer width = 3817
integer height = 2080
boolean titlebar = true
string title = "BOM �뷮 ���� ����"
windowtype windowtype = response!
long backcolor = 32106727
cbx_1 cbx_1
p_save p_save
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
p_exit p_exit
end type
global w_pdm_01475 w_pdm_01475

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
end variables

forward prototypes
public subroutine wf_additem (string arg_itnbr)
end prototypes

public subroutine wf_additem (string arg_itnbr);//int k
//string s_opseq, s_opdsc
//
//ddlb_1.reset()
//
//if dw_hidden.retrieve(arg_itnbr) > 0 then 
//	FOR k=1 TO dw_hidden.rowcount()
//       s_opseq = string(dw_hidden.getitemstring(k, 'opseq'), "@@@@")       
//       s_opdsc = dw_hidden.getitemstring(k, 'opdsc')       
//		 
//		 ddlb_1.additem(s_opseq + '  ' + s_opdsc)
//	NEXT
//end if

DataWindowChild Dw_Child
Integer    iVal
String     sItnbr

dw_1.AcceptText()

iVal = dw_1.GetChild("opseq",Dw_Child)
IF iVal = 1 THEN
	sItnbr = dw_1.GetItemSTring(1,"itnbr")	
	dw_child.Retrieve(sItnbr)
END IF
		
end subroutine

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)

DataWindowChild Dw_Child
Integer    iVal

dw_1.Reset()
iVal = dw_1.GetChild("opseq",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	dw_child.Retrieve('1')
END IF

dw_1.InsertRow(0)
dw_1.SetItem(1,"sdate",f_today())


end event

on w_pdm_01475.create
this.cbx_1=create cbx_1
this.p_save=create p_save
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.p_exit=create p_exit
this.Control[]={this.cbx_1,&
this.p_save,&
this.dw_1,&
this.dw_list,&
this.rr_1,&
this.p_exit}
end on

on w_pdm_01475.destroy
destroy(this.cbx_1)
destroy(this.p_save)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.p_exit)
end on

type cbx_1 from checkbox within w_pdm_01475
integer x = 2907
integer y = 144
integer width = 347
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "��ü����"
end type

event clicked;Long Lrow, lcount
string spdtgu

lcount = dw_list.rowcount()

If this.Checked = True Then

	For Lrow = 1 to lcount
		 spdtgu = dw_list.getitemstring(Lrow, 'estruc_opsno')	 
		
		 if spdtgu = '' or isnull(spdtgu) then 
			 dw_list.setitem(lrow, "scheck", 'Y')
		 end if	 
	Next
Else
	For Lrow = 1 to lcount
		 dw_list.Setitem(Lrow, "scheck", 'N')
	Next
End if
end event

type p_save from uo_picture within w_pdm_01475
integer x = 3392
integer y = 8
integer width = 178
integer taborder = 30
boolean bringtotop = true
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event clicked;string sopseq, sitnbr,sdate

if dw_1.accepttext() = -1 then return 

sitnbr = dw_1.getitemstring(1, 'itnbr')
sopseq = dw_1.getitemstring(1, 'opseq')
sdate  = Trim(dw_1.getitemstring(1, 'sdate'))

if sitnbr = "" or isnull(sitnbr) then 
	f_message_chk(30,'[ǰ��]')
	dw_1.Setcolumn('itnbr')
	dw_1.SetFocus()
	Return 
end if
if sopseq = "" or isnull(sopseq) then 
	f_message_chk(30,'[����]')
	dw_1.SetFocus()
	Return 
end if

If Messagebox("Ȯ��", "������ �������� ���� �Ͻð����ϱ�?", question!, yesno!) = 2 then
	return
End if

long	lRow, lRowCount
lRowCount = dw_list.RowCount()

FOR	lRow = lRowCount	TO		1		STEP  -1
		if dw_list.getitemstring(lrow, "scheck") = 'Y' then
			dw_list.setitem(lrow, 'estruc_opsno', sopseq)
//			IF trim(em_date.text) = ''		or  em_date.text = '0000.00.00'		THEN
//			ELSE
// 				dw_list.setitem(lrow, 'estruc_efrdt', sdate )
//			END IF
		end if
NEXT
		
IF dw_list.Update() > 0 THEN			
	COMMIT ;
ELSE
	ROLLBACK ;
	f_RollBack()
	return 
END IF

Messagebox("ó���Ϸ�", "���������� ����������� ����ó�� �Ǿ����ϴ�")

dw_list.retrieve(sitnbr)

cbx_1.Checked = False

dw_1.setcolumn('itnbr')
dw_1.setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type dw_1 from datawindow within w_pdm_01475
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 12
integer width = 2848
integer height = 212
integer taborder = 10
string dataobject = "d_pdm_01475_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		
		if dw_list.retrieve(gs_code) > 0 then 
			cbx_1.enabled = true
			p_save.enabled = true
		else
			cbx_1.enabled = false
			p_save.enabled = false
		end if	
      wf_additem(gs_code)
		RETURN 1
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sitnbr, sitdsc, sispec, sjijil, sispec_code
integer ii, ireturn

IF this.getcolumnname() = "itnbr"	THEN
	sitnbr = this.gettext()
	ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	if dw_list.retrieve(sitnbr) > 0 then 
		p_save.enabled = true
	else
		p_save.enabled = false
	end if	
   wf_additem(sitnbr)
	return ireturn
elseIF this.getcolumnname() = "itdsc"	THEN
	sitdsc = this.gettext()
	ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	if dw_list.retrieve(sitnbr) > 0 then 
		cbx_1.enabled = true
	else
		cbx_1.enabled = false
	end if	
   wf_additem(sitnbr)
	return ireturn
ELSEIF this.getcolumnname() = "ispec"	THEN
	sispec = this.gettext()
	ireturn = f_get_name4('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	if dw_list.retrieve(sitnbr) > 0 then 
		cbx_1.enabled = true
	else
		cbx_1.enabled = false
	end if	
   wf_additem(sitnbr)
	return  ireturn
ELSEIF this.getcolumnname() = "jijil"	THEN
	sjijil = this.gettext()
	ireturn = f_get_name4('����', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	if dw_list.retrieve(sitnbr) > 0 then 
		cbx_1.enabled = true
	else
		cbx_1.enabled = false
	end if	
   wf_additem(sitnbr)
	return  ireturn
ELSEIF this.getcolumnname() = "ispec_code"	THEN
	sispec_code = this.gettext()

	ireturn = f_get_name4('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	if dw_list.retrieve(sitnbr) > 0 then 
		cbx_1.enabled = true
	else
		cbx_1.enabled = false
	end if	
   wf_additem(sitnbr)
	return  ireturn
end if



end event

event itemerror;RETURN 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
Setnull(Gs_Gubun)

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	if dw_list.retrieve(gs_code) > 0 then 
		cbx_1.enabled = true
		p_save.enabled = true
	else
		cbx_1.enabled = false
		p_save.enabled = false
	end if	
   wf_additem(gs_code)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	if dw_list.retrieve(gs_code) > 0 then 
		cbx_1.enabled = true
		p_save.enabled = true
	else
		cbx_1.enabled = false
		p_save.enabled = false
	end if	
   wf_additem(gs_code)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	if dw_list.retrieve(gs_code) > 0 then 
		cbx_1.enabled = true
		p_save.enabled = true
	else
		cbx_1.enabled = false
		p_save.enabled = false
	end if	
   wf_additem(gs_code)
	
END IF
	

end event

type dw_list from datawindow within w_pdm_01475
integer x = 78
integer y = 236
integer width = 3657
integer height = 1680
string dragicon = "Rectangle!"
string dataobject = "d_pdm_01475_2"
boolean vscrollbar = true
boolean livescroll = true
end type

event retrieveend;long   ii, lcount
string spdtgu

lcount = this.rowcount()

for ii = 1 to lcount
    spdtgu = this.getitemstring(ii, 'estruc_opsno')	 
	
	 if spdtgu = '' or isnull(spdtgu) then 
		 this.setitem(ii, "scheck", 'Y')
	 end if	 
next
end event

event updatestart;/* Update() function ȣ��� user ���� */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event itemchanged;string spdtgu, sOpt

sOpt = this.gettext()

IF sOpt = 'Y' THEN 
	spdtgu = this.getitemstring(row, 'estruc_opsno')
	
	if not (spdtgu = '' or isnull(spdtgu)) then 
		IF messagebox("Ȯ ��", "������ �����մϴ�. ���缱���� �Ͻðڽ��ϱ�?", &
								  Exclamation!, YESNO!, 2) = 2 then 
			RETURN 1					  
		END IF
	end if	 
END IF
end event

event itemerror;RETURN 1
end event

type rr_1 from roundrectangle within w_pdm_01475
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 224
integer width = 3689
integer height = 1704
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_exit from uo_picture within w_pdm_01475
integer x = 3566
integer y = 8
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

