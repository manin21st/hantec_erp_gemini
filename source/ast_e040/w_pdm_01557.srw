$PBExportHeader$w_pdm_01557.srw
$PBExportComments$����bom(�뷮�߰� )
forward
global type w_pdm_01557 from window
end type
type cbx_1 from checkbox within w_pdm_01557
end type
type p_exit from uo_picture within w_pdm_01557
end type
type p_can from uo_picture within w_pdm_01557
end type
type p_inq from uo_picture within w_pdm_01557
end type
type st_1 from statictext within w_pdm_01557
end type
type dw_to from datawindow within w_pdm_01557
end type
type dw_from from datawindow within w_pdm_01557
end type
type dw_2 from datawindow within w_pdm_01557
end type
type rr_1 from roundrectangle within w_pdm_01557
end type
type p_mod from uo_picture within w_pdm_01557
end type
type p_add from uo_picture within w_pdm_01557
end type
type p_del from uo_picture within w_pdm_01557
end type
end forward

global type w_pdm_01557 from window
integer x = 96
integer y = 136
integer width = 3817
integer height = 2068
boolean titlebar = true
string title = "ǰ�� �뷮�߰�/����"
windowtype windowtype = response!
long backcolor = 32106727
cbx_1 cbx_1
p_exit p_exit
p_can p_can
p_inq p_inq
st_1 st_1
dw_to dw_to
dw_from dw_from
dw_2 dw_2
rr_1 rr_1
p_mod p_mod
p_add p_add
p_del p_del
end type
global w_pdm_01557 w_pdm_01557

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_check (string spinbr, string scinbr)
end prototypes

public function integer wf_check (string spinbr, string scinbr);//Long	  L_count
//
///* ����Loop �˻� */
//L_count = 0
//select count(*)
//  Into :L_count
//  from (select level, Spinbr, Scinbr
//		  from pstruc
//		 connect by  prior Spinbr = Scinbr
//		 start with Scinbr = :sSpinbr) a
// where a.Spinbr = :sScinbr;
// 
// If L_count > 0 Then Return -1
// 
//
///* ���� Loop �˻� */
//L_count = 0
//select count(*)
//  Into :L_count
//  from (select level, Spinbr, Scinbr
//		  from pstruc
//		 connect by  prior Scinbr = Spinbr
//		 start with Spinbr =  :sSpinbr) a
// where a.Scinbr = :sScinbr;
// 
// If L_count > 0 Then Return -2
//
//L_count = 0
//Select count(*)
//  into :l_count
//  from pstruc
// where Spinbr = :sSpinbr
// 	and Scinbr = :sScinbr;
// If L_count > 0 Then Return -3	 
// 

//====================================================================
// NEW ó��..
//====================================================================


// 1) ������ �ٴܰ� �˻�
//    ����ǰ���� �������� �����Ϸ��� ����ǰ���� ������ �����ϴ°��� ���� �˻�(�ٴܰ�)
// 2) ����, ������ ����ǰ�������� �˻��Ѵ�.(�ΰ��� ������ ��� return)

integer Li_count
String  sitem, sname, snull, sopseq

Setnull(snull)


Li_count = 0
select count(*)
  Into :Li_count
  from (select level, pinbr, cinbr
		  from pstruc
		 connect by  prior pinbr = cinbr
		 start with cinbr = :Spinbr) a
 where a.pinbr = :Scinbr;	


if  Li_count > 0 	then      // ����ǰ���� ������ �����Ǿ� ������
    messagebox("����ǰ��", "�����Ϸ��� �ϴ� ����ǰ���� ������ �����Ǿ� �ֽ��ϴ�", stopsign!)
    dw_2.setfocus()
    return -1
end if


Li_count = 0

SELECT COUNT(*) 
  INTO :Li_count 
  FROM ITEMAS 
 WHERE ITNBR IN (:Spinbr, :Scinbr) AND ITTYP = '8' ;

if  Li_count > 1 	then      // ��/������ ����ǰ���� ��� �ٷ� return
    messagebox("����ǰ��", "���� / ���� ǰ���� ����ǰ���Դϴ�. ǰ���� Ȯ���ϼ���!", stopsign!)
    dw_2.setfocus()
    return -1
end if




return 0
end function

event open;
f_window_center_response(this)

dw_from.settransobject(sqlca)
dw_to.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_from.InsertRow(0)
dw_to.InsertRow(0)


if isnull(gs_code) or gs_code = '' then return
dw_from.setitem(1,'itnbr', gs_code)
dw_from.triggerevent(itemchanged!)
p_inq.triggerevent(clicked!)
end event

on w_pdm_01557.create
this.cbx_1=create cbx_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_inq=create p_inq
this.st_1=create st_1
this.dw_to=create dw_to
this.dw_from=create dw_from
this.dw_2=create dw_2
this.rr_1=create rr_1
this.p_mod=create p_mod
this.p_add=create p_add
this.p_del=create p_del
this.Control[]={this.cbx_1,&
this.p_exit,&
this.p_can,&
this.p_inq,&
this.st_1,&
this.dw_to,&
this.dw_from,&
this.dw_2,&
this.rr_1,&
this.p_mod,&
this.p_add,&
this.p_del}
end on

on w_pdm_01557.destroy
destroy(this.cbx_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_inq)
destroy(this.st_1)
destroy(this.dw_to)
destroy(this.dw_from)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.p_mod)
destroy(this.p_add)
destroy(this.p_del)
end on

type cbx_1 from checkbox within w_pdm_01557
integer x = 2656
integer y = 180
integer width = 384
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

event clicked;Long Lrow

If this.Checked = True Then
	For Lrow = 1 to dw_2.rowcount()
  		 dw_2.Setitem(Lrow, "opt", 'Y')
	Next
Else
	For Lrow = 1 to dw_2.rowcount()
		 dw_2.Setitem(Lrow, "opt", 'N')
	Next
End if
end event

type p_exit from uo_picture within w_pdm_01557
integer x = 3589
integer y = 44
integer width = 178
integer taborder = 80
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;
close(parent)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_can from uo_picture within w_pdm_01557
integer x = 3415
integer y = 44
integer width = 178
integer taborder = 70
boolean bringtotop = true
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;String snull

SetNull(snull)

dw_from.enabled = true
dw_to.enabled   = true
cbx_1.enabled = true

dw_2.reset()

dw_from.setcolumn('itnbr')
dw_from.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

type p_inq from uo_picture within w_pdm_01557
integer x = 3067
integer y = 44
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event clicked;call super::clicked;String sIttyp, sitcls, ls_gritu, sjakgu
String sItnbr

String sold_sql, swhere_clause, snew_sql


if dw_from.AcceptText() = -1 then return 
if dw_to.AcceptText() = -1 then return 

sItnbr = dw_from.GetItemString(1,"itnbr")
sIttyp = dw_to.GetItemString(1,"ittyp")
sItcls = dw_to.GetItemString(1,"itcls")
sjakgu = dw_to.GetItemString(1,"jakgu")

ls_gritu = dw_to.GetItemString(1,"itemas_gritu")  // ���ڵ�

if sjakgu <> '3' then
	IF sItnbr ="" OR IsNull(sItnbr) THEN
		Messagebox("Ȯ ��","����� ǰ���� �Է��ϼ���!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

IF sIttyp ="" OR IsNull(sIttyp) THEN
	f_message_chk(30,'[ǰ�񱸺�]')
	dw_to.Setcolumn('ittyp')
	dw_to.SetFocus()
	return
END IF

IF sItcls ="" OR IsNull(sItcls) THEN
	f_message_chk(30,'[ǰ��з�]')
	dw_to.Setcolumn('itcls')
	dw_to.SetFocus()
	return
ELSE
	sItcls = sItcls + '%'
END IF


if sjakgu = '1' then
	sold_sql = &
				"  select A.ITNBR, ltrim(A.ITDSC)||' '||ltrim(a.ispec)||' '||ltrim(a.jijil) as itdsc,  "+&
				"   'N' AS OPT,   "+&
				"   1 as qtypr, '9999' as opsno, to_char(sysdate, 'yyyymmdd') as efrdt, '99991231' as eftdt, 'Y' as bomend  "+&
				  "    FROM ITEMAS A   " + &
				  "   WHERE ( A.GBWAN = 'Y' ) AND  " + &
				  "         ( A.USEYN = '0' )   " 
	  
	
	swhere_clause = ""
	
	IF not ( sIttyp ="" OR IsNull(sIttyp) )  THEN
		swhere_clause	= swhere_clause + "   AND  ( A.ITTYP = '" + sIttyp + "' ) " 
	end if
	
	IF not ( sItcls ="" OR IsNull(sItcls) ) THEN
		swhere_clause	= swhere_clause +	"   AND   ( A.ITCLS like '" + sitcls + "'  ) "
	end if
	
	// ���ڵ� ���� �߰�(2001.04.11)
	IF not (ls_gritu ="" OR IsNull(ls_gritu) ) THEN
		ls_gritu = "%" + ls_gritu + "%"
		swhere_clause	= swhere_clause + "        AND ( A.GRITU like '" + ls_gritu  +"' ) "
	END IF
	
	
	IF not (sItnbr ="" OR IsNull(sItnbr) )  THEN
		swhere_clause	= swhere_clause + "      AND  ( A.ITNBR  <> '" + sitnbr + "' ) " 	
	end if 
	
	snew_sql = sold_sql + swhere_clause

	dw_2.SetSqlSelect(snew_sql)
	dw_2.settransobject(sqlca)
		
	if dw_2.Retrieve() > 0 then
		dw_from.enabled = false
		dw_to.enabled = false
	Else
		Messagebox("��ȸ", "��ȸ �� �ڷᰡ �����ϴ�", stopsign!)
	End if
Elseif sjakgu = '2' then
	if dw_2.Retrieve(sitnbr, sittyp, sitcls) > 0 then
		dw_from.enabled = false
		dw_to.enabled = false
	Else
		Messagebox("��ȸ", "��ȸ �� �ڷᰡ �����ϴ�", stopsign!)
	End if
Elseif sjakgu = '3' then
	if dw_2.Retrieve(sittyp, sitcls) > 0 then
		dw_from.enabled = false
		dw_to.enabled = false
		cbx_1.enabled = false
	Else
		Messagebox("��ȸ", "��ȸ �� �ڷᰡ �����ϴ�", stopsign!)
	End if	
End if

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

type st_1 from statictext within w_pdm_01557
integer x = 105
integer y = 268
integer width = 206
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "����ó"
boolean focusrectangle = false
end type

type dw_to from datawindow within w_pdm_01557
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 73
integer y = 320
integer width = 3424
integer height = 80
integer taborder = 30
string dataobject = "d_pdm_01557_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" OR This.GetColumnName() = "ittyp" Then
		this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
	
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.SetItem(1,"itnm", str_sitnct.s_titnm)
		this.SetColumn('itcls')
      dw_2.reset()
		this.SetFocus()
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	s_Itcls, s_Name, s_itt, snull, ls_gritu, ls_gritu_name
int      ireturn 

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[ǰ�񱸺�]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
   end if
	
ELSEIF this.GetColumnName() = "itcls"	THEN
	
	s_itcls = this.gettext()
	
   s_itt  = this.getitemstring(1, 'ittyp')
	
   ireturn = f_get_name2('ǰ��з�2', 'Y', s_itcls, s_name, s_itt)
	
	This.setitem(1, 'itcls', s_itcls)
   This.setitem(1, 'itnm', s_name)
	
   dw_2.reset()
	
//	return ireturn 
	return 1 	
	
elseif this.GetColumnName() = 'itemas_gritu' THEN  // ���ڵ�
	
	ls_gritu = this.gettext()
 
   IF ls_gritu = "" OR IsNull(ls_gritu) THEN 
		this.SetItem(1,'itemas_gritu', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)		
      dw_2.reset()
		RETURN
   END IF
	
	ls_gritu_name = f_get_reffer('01', ls_gritu)
	
	if isnull(ls_gritu_name) or ls_gritu_name = "" then
		this.SetItem(1,'itemas_gritu', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
   end if	
elseif this.getcolumnname() = 'jakgu' then
	s_name = gettext()
	if s_name = '1' then                    //   �߰�
		p_add.visible = True
		p_mod.visible = False
		p_del.visible = False
		
		dw_2.dataobject = 'd_pdm_01557_3'
		dw_2.settransobject(sqlca)
	Elseif s_name = '2' then                //   ����     
		p_del.visible = True
		p_add.visible = False
		p_mod.visible = False
		
		dw_2.dataobject = 'd_pdm_01557_4'
		dw_2.settransobject(sqlca)		
	Elseif s_name = '3' then			  		 //   ����     
		p_mod.visible = True
		p_add.visible = False
		p_del.visible = False
		
		dw_2.dataobject = 'd_pdm_01557_5'
		dw_2.settransobject(sqlca)				
	end if	
END IF

end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
   dw_2.reset()
	this.SetFocus()
end if	
end event

event itemerror;RETURN 1
end event

type dw_from from datawindow within w_pdm_01557
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 14
integer y = 4
integer width = 2656
integer height = 260
integer taborder = 10
string dataobject = "d_pdm_01557_0"
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
		
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sitnbr, sitdsc, sispec
integer ii, ireturn
 
IF this.getcolumnname() = "itnbr"	THEN
	this.accepttext()
	sitnbr = this.getitemstring(1, "itnbr")
	ireturn = f_get_name2('ǰ��', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
   dw_2.reset()
	return ireturn
elseIF this.getcolumnname() = "itdsc"	THEN
	this.accepttext()
	sitdsc = this.getitemstring(1, "itdsc")
	ireturn = f_get_name2('ǰ��', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
   dw_2.reset()
	return ireturn
ELSEIF this.getcolumnname() = "ispec"	THEN
	this.accepttext()
	sispec = this.getitemstring(1, "ispec")
	ireturn = f_get_name2('�԰�', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
   dw_2.reset()
	return  ireturn
end if



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
	
	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	this.TriggerEvent(ItemChanged!)
	
END IF
end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_pdm_01557
integer x = 78
integer y = 400
integer width = 3657
integer height = 1524
string dataobject = "d_pdm_01557_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;string scinbr, spinbr, sdata, sjakgu
long lrow, lcnt
integer ii
decimal {4} dqty

Lrow = getrow()
scinbr = dw_from.getitemstring(1, "itnbr")
sjakgu = dw_to.getitemstring(1, "jakgu")
if sjakgu = '2' then return

if Lrow <  1 then
	return 
end if

if sjakgu = '1' then
	if isnull(scinbr) or trim(scinbr) = '' then
		Messagebox("�߰�/����ǰ��", "ǰ���� ���� �Է��Ͻ��� �۾��Ͻʽÿ�")
		setitem(Lrow, "opt", 'N')
		return 1
	End if
end if

if this.getcolumnname() = 'opt' then
	sdata = gettext()
	if sdata = 'Y' then
		spinbr = getitemstring(Lrow, "itnbr")
		ii =  wf_check(spinbr, scinbr) 
		if ii = -1 then
			Messagebox("Loop Error", "������ �ش�ǰ���� �����մϴ�", stopsign!)
		Elseif ii = -2 then
			Messagebox("Loop Error", "������ �ش�ǰ���� �����մϴ�", stopsign!)		
		Elseif ii = -3 then
			Messagebox("Loop Error", "�ش�ǰ���� �����մϴ�", stopsign!)			
		End if
			
			
		if ii <> 0 then
			setitem(Lrow, "opt", 'N')
			return 1		
		End if
	end if
Elseif this.getcolumnname() = 'qtypr' then
	dqty = dec(gettext())
	if dqty <= 0 then
		setitem(lrow, "qtypr", 1)
		Messagebox("��������", "���������� �Է��Ͻʽÿ�", stopsign!)
		return 1
	end if
Elseif this.getcolumnname() = 'opsno' then
	sdata  = gettext()
	spinbr = getitemstring(Lrow, "itnbr")
	if sdata <> '9999' then
		lcnt = 0
		Select count(*) into :lcnt from routng where itnbr = :spinbr and opseq = :sdata;
		if lcnt = 0  then
			Messagebox("ǥ�ذ���", "ǥ�ذ����� ����Ȯ�մϴ�.", stopsign!)
			setitem(Lrow, "opsno", '9999')
			return 1
		end if		
	End if
Elseif this.getcolumnname() = 'efrdt' then
	sdata  = gettext()
	if f_datechk(sdata) = -1 then
		Messagebox("��ȿ����", "�������� ����Ȯ�մϴ�.", stopsign!)
		setitem(Lrow, "efrdt", f_today())
		return 1
	End if	
Elseif this.getcolumnname() = 'eftdt' then
	sdata  = gettext()
	if f_datechk(sdata) = -1 then
		Messagebox("��ȿ����", "�������� ����Ȯ�մϴ�.", stopsign!)
		setitem(Lrow, "eftdt", '99991231')
		return 1
	End if		
End if
end event

event itemerror;return 1
end event

event rbuttondown;long Lrow 
lrow = row

if this.getcolumnname() =  "opsno" then
	OpenWithParm(w_routng_popup,this.GetItemString(lrow,"itnbr"))
	if isnull(gs_code) or trim(gs_code) = '' then
		this.SetItem(lrow,"opsno",'9999')		
	else
		this.SetItem(lrow,"opsno",Gs_Code)
	end if
	triggerevent(itemchanged!)
End If	
end event

type rr_1 from roundrectangle within w_pdm_01557
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 292
integer width = 3712
integer height = 1652
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_mod from uo_picture within w_pdm_01557
boolean visible = false
integer x = 3241
integer y = 44
integer width = 178
integer taborder = 40
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;string	scinbr, spinbr, sjakgu, smaxno, sopsno, sefrdt, seftdt, sbomend
long		lRow, lrow2, cur_row, lmaxno
integer  ii, jj, kk, ll, aa
decimal {4} dqtypr

IF	dw_from.AcceptText() = -1	THEN	RETURN
IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

scinbr = trim(dw_from.GetItemString(1, "itnbr"))
sjakgu = trim(dw_to.GetItemString(1, "jakgu"))

if sjakgu = '1' or sjakgu = '2' then
	IF scinbr ="" OR IsNull(scinbr) THEN
		Messagebox("Ȯ ��","ǰ���� �Է��ϼ���!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

aa = 0
jj = 0
kk = 0
ll = 0

IF dw_2.RowCount() < 1	THEN	return  

if dw_2.update() = 1 then
	commit;
	MESSAGEBOX("����","�ڷᰡ �����Ǿ����ϴ�", information!)
else
	rollback;
	MESSAGEBOX("����","����� Error�߻�", information!)	
	return
end if

COMMIT ;
p_can.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_add from uo_picture within w_pdm_01557
integer x = 3241
integer y = 44
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\�߰�_up.gif"
end type

event clicked;call super::clicked;string	scinbr, spinbr, sjakgu, smaxno, sopsno, sefrdt, seftdt, sbomend
long		lRow, lrow2, cur_row, lmaxno
integer  ii, jj, kk, ll, aa
decimal  {4} dqtypr

IF	dw_from.AcceptText() = -1	THEN	RETURN
IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

scinbr = trim(dw_from.GetItemString(1, "itnbr"))
sjakgu = trim(dw_to.GetItemString(1, "jakgu"))

if sjakgu = '1' or sjakgu = '2' then
	IF scinbr ="" OR IsNull(scinbr) THEN
		Messagebox("Ȯ ��","ǰ���� �Է��ϼ���!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

aa = 0
jj = 0
kk = 0
ll = 0

IF dw_2.RowCount() < 1	THEN	return  

IF MessageBox("Ȯ��", "�ڷḦ �߰� �Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	
	RETURN
End if

SetPointer(HourGlass!)

FOR lRow = 1	TO	 dw_2.RowCount()   //ǰ���� �а�
	if dw_2.getitemstring(lrow, 'opt') = 'Y' then   //üũǰ���� ����
		spinbr = dw_2.GetItemString(lRow, "itnbr")
		
		aa++
		
		// check
		ii = 0
		ii = wf_check(spinbr, scinbr)
		if ii = -1 then
			jj++
		Elseif ii = -2 then
			kk++
		Elseif ii = -3 then
			ll++
		End if
		
		if ii = 0 then
			// �ִ��ȣ�� ������ 10�� ������Ų��.
			SetNull(smaxno)
			select max(usseq) into :smaxno from pstruc 
			 Where pinbr = :spinbr;
			if isnull( smaxno ) then
				smaxno = '00010'
			Else
				lmaxno = dec(smaxno)	+ 10		
				smaxno = string(lmaxno, '00000')
			End if
			
			dqtypr  = dw_2.getitemdecimal(Lrow, "qtypr")
			sopsno  = dw_2.getitemstring(Lrow,  "opsno")
			sefrdt  = dw_2.getitemstring(Lrow,  "efrdt")
			seftdt  = dw_2.getitemstring(Lrow,  "eftdt")
			sbomend = dw_2.getitemstring(Lrow,  "bomend")				
			
			insert into pstruc (pinbr, cinbr, usseq, qtypr, adtin, opsno, efrdt, eftdt, gubun, bomend, gubun2)
							values (:spinbr,:scinbr,:smaxno,:dqtypr,0,     :sopsno,:sefrdt,:seftdt,'1',   :sbomend,'Y');
			if sqlca.sqlcode <> 0 then
				messagebox("Insert Error", sqlca.sqlerrtext + ' ' + string(sqlca.sqlcode), stopsign!)
				rollback;
				return
			end if				
						
		End if

	end if	
NEXT

MessageBox("ó�����", "��ü  ���� �Ǽ� : " + string(aa) + '~n' + &
							  "����Loop  Error : " + string(jj) + '~n' + &
							  "����Loop  Error : " + string(kk) + '~n' + &
							  "Duplicate Error : " + string(ll) + '~n' + &
							  "����  ó�� �Ǽ� : " + string(aa - (jj + kk + ll)) + " �� ó���Ǿ����ϴ�", information!)

COMMIT ;
p_can.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�߰�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�߰�_up.gif"
end event

type p_del from uo_picture within w_pdm_01557
boolean visible = false
integer x = 3241
integer y = 44
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;string	scinbr, spinbr, sjakgu, smaxno, sopsno, sefrdt, seftdt, sbomend
long		lRow, lrow2, cur_row, lmaxno
integer  ii, jj, kk, ll, aa
decimal {4} dqtypr

IF	dw_from.AcceptText() = -1	THEN	RETURN
IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

scinbr = trim(dw_from.GetItemString(1, "itnbr"))
sjakgu = trim(dw_to.GetItemString(1, "jakgu"))

if sjakgu = '1' or sjakgu = '2' then
	IF scinbr ="" OR IsNull(scinbr) THEN
		Messagebox("Ȯ ��","ǰ���� �Է��ϼ���!!")
		dw_from.setcolumn('itnbr')
		dw_from.setfocus()
		Return
	END IF
end if

aa = 0
jj = 0
kk = 0
ll = 0

IF dw_2.RowCount() < 1	THEN	return  

FOR lRow = 1	TO	 dw_2.RowCount()   //ǰ���� �а�
	if dw_2.getitemstring(lrow, 'opt') = 'Y' then   //üũǰ���� ����
		spinbr = dw_2.GetItemString(lRow, "itnbr")		
		aa++
		
		Delete from pstruc
		 Where pinbr = :spinbr And cinbr = :sCinbr;
		if sqlca.sqlcode <> 0 then
			messagebox("Insert Error", sqlca.sqlerrtext + ' ' + string(sqlca.sqlcode), stopsign!)
			rollback;
			return
		end if 
		
		MessageBox("ó�����", "��ü  ���� �Ǽ� : " + string(aa) +  " �� �����Ǿ����ϴ�", information!)			
		
	End if			
Next

COMMIT ;
p_can.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

