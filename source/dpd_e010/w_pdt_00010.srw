$PBExportHeader$w_pdt_00010.srw
$PBExportComments$ ===> �ְ� �����ȹ ����
forward
global type w_pdt_00010 from w_inherite
end type
type st_4 from statictext within w_pdt_00010
end type
type dw_jogun from u_key_enter within w_pdt_00010
end type
type gb_3 from groupbox within w_pdt_00010
end type
type cb_add from commandbutton within w_pdt_00010
end type
type p_create from uo_picture within w_pdt_00010
end type
type p_1 from uo_picture within w_pdt_00010
end type
type pb_1 from u_pb_cal within w_pdt_00010
end type
type gb_2 from groupbox within w_pdt_00010
end type
type rr_2 from roundrectangle within w_pdt_00010
end type
end forward

global type w_pdt_00010 from w_inherite
integer width = 4677
integer height = 2504
string title = "�ְ� ���� ��ȹ ����"
st_4 st_4
dw_jogun dw_jogun
gb_3 gb_3
cb_add cb_add
p_create p_create
p_1 p_1
pb_1 pb_1
gb_2 gb_2
rr_2 rr_2
end type
global w_pdt_00010 w_pdt_00010

type variables
string is_cvcod, &
         is_ymd, &
         is_cvnas2 
str_itnct lstr_sitnct
        
end variables

forward prototypes
public function integer wf_check_itnbr (integer lrow, string sitnbr)
public subroutine wf_clear_item (integer icurrow)
end prototypes

public function integer wf_check_itnbr (integer lrow, string sitnbr);String spl_yymm, sNull, sToday, sItdsc, sIspec, sJijil
Decimal {2} dDanga
Long   cnt

SetNull(sNull)

spl_yymm = dw_insert.GetItemString(lrow, "prod_ymd")

/* �߰� ǰ���� �����ϴ��� ���� üũ */
Select count(*) Into :cnt From weekprplan
 Where sabu = :gs_sabu and prod_ymd = :is_ymd 
   and itnbr = :sitnbr;

if cnt > 0 then
  	MessageBox("�ڷ� Ȯ��", "�ش� ǰ���� �ְ���ȹ�� �̹� �����մϴ�.")
	dw_insert.SetItem(lrow, "itnbr", sNull)
	dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
	dw_insert.SetItem(lrow, "itemas_ispec", sNull)
	dw_insert.SetItem(lrow, "itemas_jijil", sNull)
  	return 1			
end if 

sToday = f_today()
//*****************************************************************************
Select itnbr, itdsc, ispec, jijil Into :sitnbr, :sitdsc, :sispec, :sJijil From itemas
 Where (itnbr = :sitnbr) and (useyn = '0');
//*****************************************************************************
if SQLCA.SQLCODE <> 0  then
   open(w_itemas_popup)
	sitnbr = gs_code 
	sitdsc = gs_codename 
	sispec = gs_gubun			
end if
//*****************************************************************************
dw_insert.SetItem(lrow, "itnbr", sNull)
dw_insert.SetItem(lrow, "itemas_itdsc", sNull)
dw_insert.SetItem(lrow, "itemas_ispec", sNull)
dw_insert.SetItem(lrow, "itemas_jijil", sNull)
dw_insert.SetItem(lrow, "weekprplan_wonsrc", 0)
	
if sitnbr = '' Or IsNull(sitnbr) Then Return 1	

/* �ܰ� */
Select Fun_Erp100000012(:sToday, :sitnbr, '.')
  Into :dDanga
  From dual;

If IsNull(dDanga) Then dDanga = 0
dw_insert.SetItem(lrow, "weekprplan_wonsrc", ddanga)
		
dw_insert.SetItem(lrow, "itnbr", sitnbr)
dw_insert.SetItem(lrow, "itemas_itdsc", sitdsc)		  
dw_insert.SetItem(lrow, "itemas_ispec", sispec)
dw_insert.SetItem(lrow, "itemas_jijil", sJijil)




Return 0
end function

public subroutine wf_clear_item (integer icurrow);String sNull

SetNull(snull)

dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_jijil",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"weekprplan_wonsrc",   		   0)


end subroutine

on w_pdt_00010.create
int iCurrent
call super::create
this.st_4=create st_4
this.dw_jogun=create dw_jogun
this.gb_3=create gb_3
this.cb_add=create cb_add
this.p_create=create p_create
this.p_1=create p_1
this.pb_1=create pb_1
this.gb_2=create gb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.dw_jogun
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.p_create
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.rr_2
end on

on w_pdt_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.dw_jogun)
destroy(this.gb_3)
destroy(this.cb_add)
destroy(this.p_create)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.gb_2)
destroy(this.rr_2)
end on

event open;call super::open;String sYn

dw_Jogun.SetTransObject(sqlca)
dw_Insert.Settransobject(sqlca)

dw_Jogun.Insertrow(0)

p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'

f_mod_saupj(dw_jogun, 'saupj')

w_mdi_frame.sle_msg.Text = ''

dw_Jogun.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_00010
integer x = 64
integer y = 352
integer width = 4544
integer height = 1932
integer taborder = 10
string dataobject = "d_pdt_00010"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;String sCol_Name
Long   lrow

sCol_Name = GetColumnName()
lrow = GetRow()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
	// ǰ���ڵ� ����Ʈ�� Right ����Ŭ���� Popup ȭ��
	Case "itnbr"
   	Open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
      SetItem(lrow,"itnbr",gs_code)
		
		wf_check_itnbr(lrow, gs_code)
		Return 1
	Case "itemas_itdsc"
   	gs_codename = GetText()
	
	   open(w_itemas_popup)
   	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	   SetItem(lrow,"itnbr",gs_code)
		wf_check_itnbr(lrow, gs_code)
		Return 1
   Case "itemas_ispec", "itemas_jijil"
	   gs_gubun = GetText()
 	
   	open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
   	SetItem(lrow,"itnbr",gs_code)
		wf_check_itnbr(lrow, gs_code)
		Return 1
End Choose

end event

event dw_insert::itemchanged;call super::itemchanged;String sNull, sitnbr, stoday, sitdsc, sispec, spl_yymm, sJijil, sispeccode
Long lRow, lQty, cnt, lPqty
Dec  dDan, ddanga, dIncrRate, lAmt

lRow = GetRow()
If lRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()

	/* ǰ�� */
	Case "itnbr"
      sitnbr = Trim(GetText())
      If IsNull(sitnbr) Or sitnbr = '' Then			Return 1
		
		wf_check_itnbr(lrow, sItnbr)
		Return 1
	Case  "itemas_itdsc"                   // ǰ���Է½�
		sitdsc = Trim(GetText())

		/* ǰ������ ǰ��ã�� */
		f_get_name4_sale('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		

		wf_check_itnbr(lrow, sItnbr)
   Case  "itemas_ispec"                   // �԰��Է½�
	   sispec = Trim(GetText())

		f_get_name4_sale('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		
		wf_check_itnbr(lrow, sItnbr)		
   Case  "itemas_jijil"                   // �԰��Է½�
	   sJijil = Trim(GetText())
		f_get_name4_sale('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If sItnbr <> '' Then
			SetItem(LRow,"itnbr",sItnbr)
		ELSE
			Wf_Clear_Item(LRow)
			SetColumn("itemas_itdsc")
			Return 1
		End If		
		wf_check_itnbr(lrow, sItnbr)

End Choose 
end event

event dw_insert::editchanged;call super::editchanged;String sColumn
Long Lrow
Dec {2} dQty

sColumn = dwo.name
Lrow    = getrow()

Choose case sColumn
	    Case "weekprplan_prod_qty_d101" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d1", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d201"))
	    Case "weekprplan_prod_qty_d102" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d2", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d202"))
	    Case "weekprplan_prod_qty_d103" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d3", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d203"))
	    Case "weekprplan_prod_qty_d104" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d4", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d204"))
	    Case "weekprplan_prod_qty_d105" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d5", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d205"))
	    Case "weekprplan_prod_qty_d106" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d6", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d206"))
	    Case "weekprplan_prod_qty_d107" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d7", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d207"))
	    Case "weekprplan_prod_qty_d108" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d8", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d208"))
	    Case "weekprplan_prod_qty_d109" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d9", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d209"))
	    Case "weekprplan_prod_qty_d110" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d10", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d210"))
	    Case "weekprplan_prod_qty_d111" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d11", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d211"))
	    Case "weekprplan_prod_qty_d112" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d12", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d212"))
	    Case "weekprplan_prod_qty_d113" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d13", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d213"))
	    Case "weekprplan_prod_qty_d114" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d14", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d214"))
				
	    Case "weekprplan_prod_qty_d201" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d1", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d101"))
	    Case "weekprplan_prod_qty_d202" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d2", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d102"))
	    Case "weekprplan_prod_qty_d203" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d3", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d103"))
	    Case "weekprplan_prod_qty_d204" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d4", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d104"))
	    Case "weekprplan_prod_qty_d205" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d5", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d105"))
	    Case "weekprplan_prod_qty_d206" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d6", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d106"))
	    Case "weekprplan_prod_qty_d207" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d7", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d107"))
	    Case "weekprplan_prod_qty_d208" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d8", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d108"))
	    Case "weekprplan_prod_qty_d209" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d9", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d109"))
	    Case "weekprplan_prod_qty_d210" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d10", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d110"))
	    Case "weekprplan_prod_qty_d211" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d11", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d111"))
	    Case "weekprplan_prod_qty_d212" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d12", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d112"))
	    Case "weekprplan_prod_qty_d213" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d13", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d113"))
	    Case "weekprplan_prod_qty_d214" 
				dQty = Dec(gettext())
				setitem(Lrow, "weekprplan_prod_qty_d14", dQty + getitemdecimal(Lrow, "weekprplan_prod_qty_d114"))				
End choose			
end event

type p_delrow from w_inherite`p_delrow within w_pdt_00010
boolean visible = false
integer x = 4151
integer y = 3196
end type

type p_addrow from w_inherite`p_addrow within w_pdt_00010
boolean visible = false
integer x = 3977
integer y = 3196
end type

type p_search from w_inherite`p_search within w_pdt_00010
boolean visible = false
integer x = 3282
integer y = 3196
end type

type p_ins from w_inherite`p_ins within w_pdt_00010
integer x = 3749
end type

event p_ins::clicked;call super::clicked;long lrow

If (is_ymd = '') or isNull(is_ymd) or  &
   (is_cvcod = '') or isNull(is_cvcod) then
	If (is_cvcod = '') or isNull(is_cvcod) then
		f_Message_Chk(203, '[������ �Է� Ȯ��]')
	   dw_jogun.SetFocus()
	Else
   	f_Message_Chk(30, '[�ʼ��Է��ڷ� Ȯ��]')
	   dw_jogun.SetFocus()
	End If
	Return 1
End If


Lrow = dw_insert.insertrow(0)
dw_insert.setitem(Lrow, "sabu", gs_sabu)
dw_insert.setitem(Lrow, "prod_ymd", is_ymd)
dw_insert.scrolltorow(Lrow)
dw_insert.setcolumn("itnbr")
dw_insert.setfocus()
end event

type p_exit from w_inherite`p_exit within w_pdt_00010
end type

type p_can from w_inherite`p_can within w_pdt_00010
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

 
p_ins.enabled = False
p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
p_create.enabled = true
p_create.PictureName = 'C:\erpman\image\�ڷ����_up.gif'

ib_any_typing = False

w_mdi_frame.sle_msg.Text = ''


dw_Jogun.SetFocus()
end event

type p_print from w_inherite`p_print within w_pdt_00010
boolean visible = false
integer x = 3456
integer y = 3196
end type

type p_inq from w_inherite`p_inq within w_pdt_00010
integer x = 3575
end type

event p_inq::clicked;String  sYmd, spdtgu, ls_saupj , ls_itcls, ls_itnbr
Long Lrow

SetPointer(hourGlass!)


w_mdi_frame.sle_msg.Text = '�ְ� ���� ��ȹ�� ��ȸ�� �Դϴ�... ��� ��ٷ� �ּ���'
If dw_Jogun.AcceptText() <> 1 Then Return

sYmd  	= dw_Jogun.GetItemString(1, 'symd')
spdtgu 	= dw_Jogun.GetItemString(1, 'pdtgu')

ls_saupj  	= dw_Jogun.GetItemString(1, 'saupj')

ls_itnbr  	= dw_Jogun.GetItemString(1, 'itnbr')
ls_itcls  	= dw_Jogun.GetItemString(1, 'itcls')

if	isNull(ls_itcls	)  or ls_itcls = "" then ls_itcls = '%'
if	isNull(ls_itnbr)  or ls_itnbr = "" then ls_itnbr = '%'
is_ymd 	= symd
is_cvcod 	= spdtgu

If 	isnull( symd ) or trim( symd ) = '' then
	MessageBox("��������", "�������ڸ� ���� �Է��ϼ���", stopsign!)
	w_mdi_frame.sle_msg.Text = ''
	return 
End if

If 	isnull( spdtgu ) or trim( spdtgu ) = '' then
	MessageBox("������", "�������ڵ带 ���� �Է��ϼ���", stopsign!)
	w_mdi_frame.sle_msg.Text = ''
	return 
End if

If 	dw_Insert.Retrieve(gs_sabu, ls_saupj,  sYmd, spdtgu, ls_itcls, ls_itnbr) < 1 then
	f_message_Chk(50, '[�ְ� ������ ��ȹ ��ȸ]')
	w_mdi_frame.sle_msg.text = ''
End if

Lrow = 0
Select Count(*) into :lrow
  from weekouplan
 where sabu = :gs_sabu and prod_ymd = :symd;

If Lrow > 0 then
	MessageBox("���ְ�ȹ", "���ְ�ȹ�� �����Ƿ� ���ְ�ȹ ������ ���ֿ��� �ϼ���", information!)
	dw_insert.object.weekprplan_prod_qty_d201.protect=1
	dw_insert.object.weekprplan_prod_qty_d202.protect=1	
	dw_insert.object.weekprplan_prod_qty_d203.protect=1	
	dw_insert.object.weekprplan_prod_qty_d204.protect=1	
	dw_insert.object.weekprplan_prod_qty_d205.protect=1	
	dw_insert.object.weekprplan_prod_qty_d206.protect=1	
	dw_insert.object.weekprplan_prod_qty_d207.protect=1
	
	dw_insert.object.weekprplan_prod_qty_d201.background.color=Rgb(240,244,247)
	dw_insert.object.weekprplan_prod_qty_d202.background.color=Rgb(240,244,247)
	dw_insert.object.weekprplan_prod_qty_d203.background.color=Rgb(240,244,247)
	dw_insert.object.weekprplan_prod_qty_d204.background.color=Rgb(240,244,247)
	dw_insert.object.weekprplan_prod_qty_d205.background.color=Rgb(240,244,247)
	dw_insert.object.weekprplan_prod_qty_d206.background.color=Rgb(240,244,247)
	dw_insert.object.weekprplan_prod_qty_d207.background.color=Rgb(240,244,247)	

	
Else
	dw_insert.object.weekprplan_prod_qty_d201.protect=0
	dw_insert.object.weekprplan_prod_qty_d202.protect=0
	dw_insert.object.weekprplan_prod_qty_d203.protect=0
	dw_insert.object.weekprplan_prod_qty_d204.protect=0
	dw_insert.object.weekprplan_prod_qty_d205.protect=0
	dw_insert.object.weekprplan_prod_qty_d206.protect=0
	dw_insert.object.weekprplan_prod_qty_d207.protect=0
	
	dw_insert.object.weekprplan_prod_qty_d201.background.color=Rgb(255,255,255)	
	dw_insert.object.weekprplan_prod_qty_d202.background.color=Rgb(255,255,255)	
	dw_insert.object.weekprplan_prod_qty_d203.background.color=Rgb(255,255,255)	
	dw_insert.object.weekprplan_prod_qty_d204.background.color=Rgb(255,255,255)	
	dw_insert.object.weekprplan_prod_qty_d205.background.color=Rgb(255,255,255)	
	dw_insert.object.weekprplan_prod_qty_d206.background.color=Rgb(255,255,255)	
	dw_insert.object.weekprplan_prod_qty_d207.background.color=Rgb(255,255,255)	
	
End if


p_ins.enabled = True
p_ins.PictureName = 'C:\erpman\image\�߰�_up.gif'
p_del.enabled = True
p_del.PictureName = 'C:\erpman\image\����_up.gif'
p_mod.enabled = True
p_mod.PictureName = 'C:\erpman\image\����_up.gif'
p_create.enabled = false
p_create.PictureName = 'C:\erpman\image\�ڷ����_d.gif'

w_mdi_frame.sle_msg.Text = '�ְ� ���� ��ȹ ��ȸ �Ϸ�. ���� �� �߰�, ������ �� �� �ֽ��ϴ�.'

dw_Insert.SetFocus()

end event

type p_del from w_inherite`p_del within w_pdt_00010
end type

event p_del::clicked;call super::clicked;string sitnbr, sitdsc

If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.GetRow() <= 0 Then Return

sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itemas_itdsc')

if MessageBox("���� Ȯ��", sitdsc + "�� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return

dw_insert.deleterow(dw_insert.getrow())


end event

type p_mod from w_inherite`p_mod within w_pdt_00010
end type

event p_mod::clicked;call super::clicked;long lcnt

if 	dw_insert.Update() = -1 then  
   	f_message_Chk(32,'[�ְ������ȹ �����۾�]')
 	Rollback;
   	SetPointer(Arrow!)	 
   	return
else
	If 	MessageBox("�۾�����","���� ��ȹ�� �����ұ��", question!, yesno!) = 1 then
		LCNT = sqlca.van_weekplan4(gs_sabu, is_ymd, gs_saupj, is_cvcod, '1');
		
		Commit;		
		f_message_Chk(202,'[�ְ������ȹ �����۾�]')
	End If	
	ib_any_typing = False
end if
SetPointer(Arrow!)


p_can.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_pdt_00010
integer x = 3369
integer y = 3132
integer width = 352
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_pdt_00010
integer x = 2583
integer y = 3132
integer width = 370
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;//SetPointer(HourGlass!)
//If dw_update.AcceptText() <> 1 Then Return 1
//
//if dw_update.Update() = -1 then  
//   f_message_Chk(32,'[�Ⱓ�ǸŰ�ȹ �����۾�]')
// 	Rollback;
//   SetPointer(Arrow!)	 
//   return
//else
//   Commit;		
//   f_message_Chk(202,'[�Ⱓ�ǸŰ�ȹ �����۾�]')
//	ib_any_typing = False
//end if
//SetPointer(Arrow!)	 
//
//cb_can.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdt_00010
integer x = 2459
integer y = 2820
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_pdt_00010
integer x = 1015
integer y = 3132
integer width = 393
integer taborder = 80
end type

event cb_del::clicked;call super::clicked;//string sitnbr, sitdsc
//
//If dw_insert.AcceptText() <> 1 Then Return
//
//If dw_insert.GetRow() <= 0 Then Return
//
//sitnbr = dw_insert.GetItemString(dw_insert.GetRow(), 'itnbr')
//sitdsc = dw_insert.GetItemString(dw_insert.GetRow(), 'itdsc')
//
//if MessageBox("���� Ȯ��", sitdsc + "�� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return
//
///* �Ⱓ�ǸŰ�ȹ �ش�⵵�� �ŷ�ó�� ǰ�� ����Ÿ ���� */
//Delete From yearsaplan
//Where (sabu = :gs_sabu) and (substr(plan_yymm,1,4) = :is_Year) and
//      (plan_chasu = :is_chasu) and (cvcod = :is_cvcod) and
//		(itnbr = :sitnbr);
//
//if SQLCA.SqlCode < 0 then
//   f_Message_Chk(31, '[�Ⱓ�ǸŰ�ȹ �ŷ�ó,ǰ�� ����]')
//	Rollback;
//	return
//else
//   commit;
//	ib_any_typing = False
//end if
//
//cb_inq.TriggerEvent(Clicked!)
//
//
end event

type cb_inq from w_inherite`cb_inq within w_pdt_00010
integer x = 183
integer y = 3132
integer width = 393
integer taborder = 90
end type

event cb_inq::clicked;call super::clicked;//String  sYear, sjYear
//Integer iChasu
//
//SetPointer(hourGlass!)
//
//sle_msg.Text = '�ش� �Ⱓ �Ǹ� ��ȹ�� ��ȸ�� �Դϴ�... ��� ��ٷ� �ּ���'
//If dw_Jogun.AcceptText() <> 1 Then Return
//
//sYear  = dw_Jogun.GetItemString(1, 'syy')
//sjYear = String(integer(sYear) - 1)
//iChasu = dw_Jogun.GetItemNumber(1, 'sChasu')
//
//cb_add.enabled = True
//cb_del.enabled = True
//
//dw_update.Reset()
//If dw_Insert.Retrieve(gs_sabu, sYear, iChasu, is_cvcod, f_today(), sjYear) < 1 then
//	f_message_Chk(50, '[�Ⱓ �Ǹ� ��ȹ ��ȸ]')
//	sle_msg.text = ''
//	return -1
//End if
//
//dw_update.Retrieve(gs_sabu, sYear, iChasu, is_cvcod)
//
//sle_msg.Text = '�Ⱓ �Ǹ� ��ȹ ��ȸ �Ϸ�. ���� �� �߰�, ������ �� �� �ֽ��ϴ�.'
//
//dw_Insert.SetFocus()
//
end event

type cb_print from w_inherite`cb_print within w_pdt_00010
integer x = 2473
integer y = 2692
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_pdt_00010
end type

type cb_can from w_inherite`cb_can within w_pdt_00010
integer x = 2981
integer y = 3132
integer width = 361
integer taborder = 130
end type

event cb_can::clicked;call super::clicked;//dw_insert.Reset()
//dw_update.Reset()
//
//cb_add.enabled = False
//cb_del.enabled = False
//ib_any_typing = False
//
//sle_msg.Text = '������ ��ȹ�⵵ �� ���� ���ұ����� �Է� �� �����ϼ���'
//
//dw_Jogun.SetFocus()
end event

type cb_search from w_inherite`cb_search within w_pdt_00010
integer x = 2414
integer y = 2556
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_00010
end type

type st_4 from statictext within w_pdt_00010
integer x = 69
integer y = 272
integer width = 1243
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
boolean enabled = false
string text = " ��ǰ�� �ְ� �����ȹ ����"
boolean focusrectangle = false
end type

type dw_jogun from u_key_enter within w_pdt_00010
event ue_key pbm_dwnkey
integer x = 41
integer y = 40
integer width = 2994
integer height = 192
integer taborder = 20
string dataobject = "d_pdt_00010_01"
boolean border = false
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(Rbuttondown!)
End if
end event

event itemchanged;String sCol_Name, sNull, sData, sName, sName1, sJijil, sCode
integer iReturn

dw_Jogun.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)
//cb_inq.Enabled = False
p_ins.Enabled = False
p_ins.PictureName = 'C:\erpman\image\�߰�_d.gif'
p_del.Enabled = False
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_mod.Enabled = False
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
dw_insert.Reset()

Choose Case sCol_Name
   // ���س⵵ ��ȿ�� Check
	Case "symd"  
		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 8) then
			f_Message_Chk(35, '[��������]')
			this.SetItem(1, "syy", sNull)
			return 1
		end if
		is_ymd = this.GetText()
/* ǰ��з� */
  Case "itcls"
  	sName = Trim(GetText())
  	IF 	sName = "" OR IsNull(sName) THEN 		RETURN
	
	sData = '1' // ����ǰ.
		
	SELECT "ITNCT"."TITNM"  	INTO :sName1
	 FROM "ITNCT"  
	WHERE ( "ITNCT"."ITTYP" = :sData ) AND ( "ITNCT"."ITCLS" = :sName );
		
	IF 	SQLCA.SQLCODE <> 0 THEN
	  	TriggerEvent(RButtonDown!)
	  	Return 2
	ELSE
	  	SetItem(1,"titnm1",sName1)
	END IF
		
	/* ǰ�� */
	Case "itnbr"
		sData = trim(GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sData, sName, sName1, sjijil, scode)	
		setitem(1, "itnbr", sData)	
		setitem(1, "itdsc", sName)	
//		setitem(1, "ispec", sName1)
		RETURN ireturn
end Choose
end event

event itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;string snull, sname

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose Case  this.GetColumnName() 
	Case 	'itnbr'	
		gs_code = this.GetText()
		open(w_itemas_popup3)
		
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
		RETURN 1
	Case 	'itcls'	
		// ����ǰ.
		OpenWithParm(w_ittyp_popup, '1')
		
		lstr_sitnct = Message.PowerObjectParm	
		
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
		this.SetItem(1,"titnm1", lstr_sitnct.s_titnm)
		this.SetColumn('itcls')
		this.SetFocus()
		this.TriggerEvent(ItemChanged!)
		RETURN 1
End Choose

end event

type gb_3 from groupbox within w_pdt_00010
boolean visible = false
integer x = 2551
integer y = 3084
integer width = 1202
integer height = 176
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_add from commandbutton within w_pdt_00010
boolean visible = false
integer x = 599
integer y = 3132
integer width = 393
integer height = 108
integer taborder = 160
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�߰�(&A)"
end type

event cb_add::clicked;call super::clicked;//str_yearsaplan str_plan
//Double dRtn
//
//If (is_year = '') or isNull(is_year) or (is_chasu = 0) or isNull(is_chasu) or &
//   (is_cvcod = '') or isNull(is_cvcod) then
//	If (is_cvcod = '') or isNull(is_cvcod) then
//		f_Message_Chk(203, '[�ŷ�ó �Է� Ȯ��]')
//		dw_vnd.SetFocus()
//	Else
//   	f_Message_Chk(30, '[�ʼ��Է��ڷ� Ȯ��]')
//	   dw_jogun.SetFocus()
//	End If
//	Return 1
//End If
//
//sle_msg.Text = '�Ⱓ �Ǹ� ��ȹ ǰ���߰� �۾��� �ϼ���'
//
//str_plan.str_year = is_year
//str_plan.str_chasu = is_chasu
//str_plan.str_cvcod = is_cvcod
//str_plan.str_cvnas2 = is_cvnas2
//str_plan.str_series = is_series
//
//openwithparm(w_sal_01040_01, str_plan)
//dRtn = Message.DoubleParm 
//If dRtn = -1 Then Return
//
//If dw_update.Update() = -1 Then
// 	Rollback;
//   Return
//Else
//   Commit;
//	ib_any_typing = False
//End if
//
//sle_msg.Text = ''
//cb_inq.TriggerEvent(Clicked!)
//dw_insert.scrolltorow(dw_insert.rowcount())
end event

type p_create from uo_picture within w_pdt_00010
integer x = 3401
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\�ڷ����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ڷ����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ڷ����_up.gif"
end event

event clicked;call super::clicked;gs_code = dw_jogun.getitemstring(1, "symd")

If isnull( gs_code ) or trim( gs_code ) = '' then
	MessageBox("��������", "�������ڸ� �Է��ϼ���", stopsign!)
	Setnull(gs_code)
	return 
end if

open(w_pdt_00010_1)
 


end event

type p_1 from uo_picture within w_pdt_00010
integer x = 3227
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\�ҿ䷮���_up.gif"
end type

event clicked;call super::clicked;String symd
integer icnt

if dw_jogun.accepttext() = -1 then return

symd = dw_jogun.getitemstring(1, "symd")

If 	isnull( symd ) or trim( symd ) = '' then
	MessageBox("��������", "�������ڸ� �Է��ϼ���", stopsign!)
	Setnull( symd )
	return 
end if



String sgijun, sgyymm, serror, smsgtxt, scalgu, sTxt, sstdat, seddat, scheck, ssaupj



Long Lrow
Lrow = 0
Select Count(*) into :Lrow
  From weekprplan
 Where sabu = :gs_sabu and prod_ymd = :symd;
If Lrow <1 then
	MessageBox("�ҿ䷮ ���", "����� �ڷᰡ �����ϴ�" + '~n' + &
									  "�ְ� �����ȹ ������ �ٽ� �����ϼ���", information!)
	return
End if

w_mdi_frame.sle_msg.Text = '�ְ� �ҿ䷮�� ��ȸ�� �Դϴ�... ��� ��ٷ� �ּ���'

//===========================================================================//
/* MRP Server procedure �� ����
   step���� error check�� �����Ͽ� error�� �߻��� ��� �ش��������
	�ߴ� */
String temp_calgu
integer dseq, dCnt, dMaxno, dAddNo

sgijun = '4'  // �ְ� �����ȹ ����
sgyymm = symd
// Factor���� ���� 
		SELECT DATANAME	  INTO :scalgu
		  FROM SYSCNFG
		 WHERE SYSGU = 'Y' and SERIAL = '26' and LINENO = '2';

//scalgu = '1'  // Factor���� 
sstdat = symd
seddat = f_afterday(symd, 13)
ssaupj = dw_jogun.getitemstring(1, "saupj")

smsgtxt = symd + ' �� ���� �ְ� �ҿ䷮ ����(MRP)ó���� �Ͻðڽ��ϱ�?'
if messagebox("Ȯ ��", smsgtxt, Question!, YesNo!, 2) = 2 then return   

setpointer(hourglass!)

serror = 'X'
icnt = 0

// Mrp History Create
/* MRP�����̷��� �ִ� ��������� ���Ѵ� */
SELECT MAX(ACTNO)	
  INTO :dmaxno
  FROM MRPSYS
 WHERE SABU = :gs_sabu;

if isnull(dmaxno) then dmaxno = 0;

dMaxno = dmaxno + 1

IF sCalgu = '1' THEN
	sTXT	= 'FACTOR����';
ELSEIF sCalgu = '2' THEN
	sTXT  = 'FACTOR�������';
ELSE
	sTXT  = 'FACTOR����+�������';
END IF;

/* MRP�̷��� �ۼ��Ѵ� */
INSERT INTO MRPSYS (SABU, ACTNO, MRPRUN, MRPGIYYMM, MRPDATA, MRPCUDAT, MRPSIDAT,
						  MRPEDDAT, MRPTXT, MRPSEQ, MRPCALGU, MRPPDTSND, MRPMATSND, MRPDELETE, SAUPJ)
		VALUES(:gs_sabu, :dMAXNO, TO_CHAR(SYSDATE, 'YYYYMMDD'), :symd, :sgijun,
				 TO_CHAR(SYSDATE, 'YYYYMMDD'), :sstdat, :seddat, :stxt, :dseq, 'N','N','N','N', :ssaupj);
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp History Create]' + '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END If

COMMIT;

openwithparm(w_pdt_01030_2, dmaxno)
sCheck = message.stringparm
if sCheck = 'N' then 
	return
end if
w_mdi_frame.sle_msg.text = "���� �ҿ䷮ ����(MRP)ó����. .............."

String ssilgu
ssilgu = f_get_syscnfg('S', 8, '40')

// mrp initial
w_mdi_frame.sle_msg.Text = "���� �ҿ䷮ ����(MRP)ó����. .............." + "MRP Initial Create"
sqlca.erp000000050_1(gs_sabu, dmaxno, sgijun, sgyymm, dseq, ssaupj, ssilgu, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp Initial]' + '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

// open order merge
serror = 'X'
w_mdi_frame.sle_msg.Text = "���� �ҿ䷮ ����(MRP)ó����. ..............Open Order Merge"
IF SCALGU = '1' THEN /* FACTOR�� �����ϴ� ��쿡�� ���� */
	sqlca.erp000000050_2(gs_sabu, dmaxno, sgijun, serror);
	If isnull(serror) or serror = 'X' or serror = 'Y' then
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(41,'[MRP RUN-Open Order Merge]'+ '~n' + sqlca.sqlerrtext)
		dw_jogun.setfocus()
		return
	END IF
END IF

// product schedule
serror = 'X'
w_mdi_frame.sle_msg.Text = "���� �ҿ䷮ ����(MRP)ó����. ..............Open Product Schedule"
sqlca.erp000000050_3(gs_sabu, dmaxno, sgijun, sgyymm, dseq, ssaupj, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN- Product Schedule]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

// manufacturing resource create
serror = 'X'
w_mdi_frame.sle_msg.Text = "���� �ҿ䷮ ����(MRP)ó����. ..............Manufacturing Resource Create"
sqlca.erp000000050_4(gs_sabu, dmaxno, sgijun, sgyymm, scalgu, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Manufacturing Resource Create]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

//// mrp detail record create
//w_mdi_frame.sle_msg.Text = "���� �ҿ䷮ ����(MRP)ó����. ..............MRP Detail Record Create"
//sqlca.erp000000050_5(gs_sabu, dmaxno, sgijun, serror);
//If isnull(serror) or serror = 'X' or serror = 'Y' then
//	w_mdi_frame.sle_msg.text = ""
//	f_message_chk(41,'[MRP RUN-Mrp Detail Record Create-1]'+ '~n' + sqlca.sqlerrtext)
//	dw_jogun.setfocus()
//	return
//END IF
//

// plan detail record create
serror = 'X'
w_mdi_frame.sle_msg.Text = "���� �ҿ䷮ ����(MRP)ó����. ..............Plan Detail Record Create"
sqlca.erp000000050_6(gs_sabu, dmaxno, sgijun, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Plan Detail Record Create-2]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

// Data Transfer
serror = 'X'
w_mdi_frame.sle_msg.Text = "�ڷ� ������. ..............Data Transfer"
sqlca.erp000000050_8(gs_sabu, dmaxno, symd, sgijun, serror); 
If 	isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Plan Detail Record Create-3]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END IF

/* MRP����� ���������� ����Ǿ��ٴ� ǥ�ø� �Ѵ� */
Update mrpsys
   set mrpcalgu = 'Y'
 Where sabu = :gs_sabu and actno = :dmaxno;

If sqlca.sqlcode <> 0 then
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[����̷� �ۼ��� �����߻�]'+ '~n' + sqlca.sqlerrtext)
	dw_jogun.setfocus()
	return
END If 

Update reffpf
   set rfna2 = to_char(:dmaxno)
 where sabu = '1' and rfcod = '1A' and rfgub = '1';

COMMIT;

messagebox("���� �ҿ䷮ ���", "�����ȣ -> " + string(dmaxno) + " �� ��������Ǿ����ϴ�")


setpointer(Arrow!)

//===========================================================================//

w_mdi_frame.sle_msg.text = ""
dw_jogun.setfocus()



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ҿ䷮���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ҿ䷮���_up.gif"
end event

type pb_1 from u_pb_cal within w_pdt_00010
integer x = 855
integer y = 52
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('symd')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'symd', gs_code)
end event

type gb_2 from groupbox within w_pdt_00010
boolean visible = false
integer x = 155
integer y = 3084
integer width = 1294
integer height = 176
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_2 from roundrectangle within w_pdt_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 256
integer width = 4594
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

