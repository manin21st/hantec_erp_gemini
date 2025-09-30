$PBExportHeader$w_pdm_11721.srw
$PBExportComments$���/����/����bom-���/����Ȳ
forward
global type w_pdm_11721 from w_standard_print
end type
type cbx_eng from checkbox within w_pdm_11721
end type
type cbx_pdt from checkbox within w_pdm_11721
end type
end forward

global type w_pdm_11721 from w_standard_print
string title = "����BOM-���/��"
cbx_eng cbx_eng
cbx_pdt cbx_pdt
end type
global w_pdm_11721 w_pdm_11721

type variables
long    il_row
int       check_box, ii_ddlb, ii_ddlb1
string  is_Gubun, Isbom
str_itnct lstr_sitnct
datastore ds_bom


end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_calculation (string arg_itnbr, string susedate)
end prototypes

public function integer wf_retrieve ();string   sitdsc, sispec, sjijil, sunmsr, sUsedate, Sgubun, sbigyo, smdname, xx
string 	sItnbr[7]
string 	sCvcod[5], sColName, sChkit, sNull
integer  ii, jj 
Long Lrow, Lrow1, Lfind
Boolean  lb_find

SetNull(sNull)

// ǰ���ȣ
if dw_ip.accepttext() = -1 		then	
	return -1
end if

//��������
IF trim(dw_ip.getitemstring(1, "bdate")) = ''		or  IsNull(dw_ip.getitemstring(1, "bdate")) THEN
	is_Gubun = 'ALL'
	sUseDate = f_today()
ELSE
	is_Gubun = 'NOTALL'
	sUseDate = trim(dw_ip.getitemstring(1, "bdate"))
END IF

sgubun  = dw_ip.getitemstring(1, "gubun")
sbigyo  = dw_ip.getitemstring(1, "bigyo")

sitnbr[1] = dw_ip.getitemstring(1, "itnbr1")
sitnbr[2] = dw_ip.getitemstring(1, "itnbr2")
sitnbr[3] = dw_ip.getitemstring(1, "itnbr3")
sitnbr[4] = dw_ip.getitemstring(1, "itnbr4")
sitnbr[5] = dw_ip.getitemstring(1, "itnbr5")
sitnbr[6] = dw_ip.getitemstring(1, "itnbr6")
sitnbr[7] = dw_ip.getitemstring(1, "itnbr7")

sCvcod[1] = dw_ip.getitemstring(1, "cvcod1")
sCvcod[2] = dw_ip.getitemstring(1, "cvcod2")
sCvcod[3] = dw_ip.getitemstring(1, "cvcod3")
sCvcod[4] = dw_ip.getitemstring(1, "cvcod4")
sCvcod[5] = dw_ip.getitemstring(1, "cvcod5")

If Not cbx_eng.checked And Not cbx_pdt.checked Then
	MessageBox("����BOM", "���� �Ǵ� ����BOM�� 1���� ���õǾ�� �մϴ�", stopsign!)
	return -1
End if

dw_list.setredraw(False)
dw_print.reset()
dw_list.reset()

ds_bom = create datastore

// ��ǰ�������� ��ȸ
If sgubun = '1' then 
	Select itdsc, ispec, jijil, unmsr
	  into :sitdsc, :sispec, :sjijil, :sunmsr
	  from itemas
	 Where itnbr = :sitnbr[1];
	If sqlca.sqlcode <> 0 then
		MEssagebox("ǰ��", "ǰ���� ����Ȯ �մϴ�", stopsign!)
		dw_list.setredraw(true)		
		return -1
	End if
	
	ii = 0
	For Lrow = 1 to 5
		 sColName = 'cvcod' + string(Lrow)
		 sCvcod[Lrow] = dw_ip.getitemstring(1, sColName)
		 If Trim(sCvcod[Lrow]) = '' then sCvcod[Lrow] = sNull
		 If Not IsNull( sCvcod[Lrow] ) then
			 II++
		 End if	
	Next
	
	If ii < 1 then
		MessageBox("�ŷ�ó", "�ŷ�ó�� �ּ� 1���̻� ���õǾ�� �մϴ�", stopsign!)
		dw_list.setredraw(true)
		return -1
	End if	
	

	lb_find = True
	jj      = 0

	if sbigyo = '1' then
		dw_print.retrieve(sitnbr[1], sitnbr[1])
	Else
		dw_print.retrieve(sitnbr[1], '%')		
	End if
	dw_print.modify("st_date.text = '"  + string(susedate, "@@@@.@@.@@")  + "'")
	dw_print.modify("t_pinbr.text = '"   + sitnbr[1] +"'")
	dw_print.modify("t_pitdsc.text = '"   + sitdsc  + "'")
	dw_print.modify("t_pispec.text = '"   + sispec  + "'")
	dw_print.modify("t_pjijil.text = '"   + sjijil  + "'")
	dw_print.modify("t_punmsr.text = '"   + sUnmsr  + "'")	

	if cbx_eng.checked then  // ��� BOM���ǥ
		jj++
		ds_bom.dataobject   = "d_pdm_11730_p_single"	
		ds_bom.settransobject(sqlca)	
		if wf_calculation(sitnbr[1], susedate) = -1 Then
			dw_print.reset()
		Else
			For Lrow = 1 to ds_bom.rowcount()
				 Lrow1 = 0
				 sChkit = ds_bom.getitemstring(Lrow, "estruc_cinbr")
				 Lrow1 = dw_print.find("itnbr = '"+ schkit +"'", 1, dw_print.rowcount())

				 If Lrow1 < 1 then
					 lb_find = False
				 Else
					 sColname = 'qtypr' + string(jj)
					 dw_print.setitem(Lrow1, sColname, ds_bom.getitemdecimal(Lrow, "qtypr"))	 
				 End if
			Next
		End if
	End if
	
	if cbx_pdt.checked then  // ���� BOM���ǥ
		jj++
		ds_bom.dataobject   = "d_pdm_11730_m_single"	
		ds_bom.settransobject(sqlca)	
		if wf_calculation(sitnbr[1], susedate) = -1 Then
			dw_print.reset()
		Else
			For Lrow = 1 to ds_bom.rowcount()
				 Lrow1 = 0
				 sChkit = ds_bom.getitemstring(Lrow, "pstruc_cinbr")
				 Lrow1 = dw_print.find("itnbr = '"+ schkit +"'", 1, dw_print.rowcount())

				 If Lrow1 < 1 then
					 lb_find = False
				 Else
					 sColname = 'qtypr' + string(jj)
					 dw_print.setitem(Lrow1, sColname, ds_bom.getitemdecimal(Lrow, "qtypr"))	 
				 End if
			Next
		End if
	End if	
	
	ds_bom.dataobject   = "d_pdm_11737_single"	
	ds_bom.settransobject(sqlca)		
	For Lrow = 1 to 5
		 jj++		
		
		 If Not Isnull( sCvcod[Lrow] ) Then			
			 ds_bom.retrieve(sItnbr[1], sItnbr[1], sCvcod[Lrow], sUseDate)
			 For Lrow1 = 1 to ds_bom.rowcount()
				  
				  Lfind = 0
				  sChkit = ds_bom.getitemstring(Lrow1, "wstruc_cinbr")
				  Lfind = dw_print.find("itnbr = '"+ schkit +"'", 1, dw_print.rowcount())

				  If Lfind < 1 then
					  lb_find = False
				  Else
					  sColname = 'qtypr' + string(jj)
					  dw_print.setitem(Lfind, sColname, ds_bom.getitemdecimal(Lrow1, "qtypr"))
				  End if				
				
			 Next
		 End if
		
	Next

	If Cbx_eng.Checked then 
		dw_print.object.t_name1.text = '����'
		dw_list.object.t_name1.text = '����'		
		Lrow++
	End if
	
	If Cbx_pdt.Checked then
		If Not Cbx_eng.Checked then 
			dw_print.object.t_name1.text = '����'
			dw_list.object.t_name1.text = '����'
			Lrow++
			
			dw_print.object.t_name2.text = sCvcod[1]
			dw_print.object.t_name3.text = sCvcod[2]
			dw_print.object.t_name4.text = sCvcod[3]
			dw_print.object.t_name5.text = sCvcod[4]
			dw_print.object.t_name6.text = sCvcod[5]			
			
			dw_list.object.t_name2.text = sCvcod[1]
			dw_list.object.t_name3.text = sCvcod[2]
			dw_list.object.t_name4.text = sCvcod[3]
			dw_list.object.t_name5.text = sCvcod[4]
			dw_list.object.t_name6.text = sCvcod[5]			
		Else
			dw_print.object.t_name2.text = '����'
			dw_list.object.t_name2.text = '����'			
			Lrow++		
			
			dw_print.object.t_name3.text = sCvcod[1]
			dw_print.object.t_name4.text = sCvcod[2]
			dw_print.object.t_name5.text = sCvcod[3]
			dw_print.object.t_name6.text = sCvcod[4]
			dw_print.object.t_name7.text = sCvcod[5]			
			
			dw_list.object.t_name3.text = sCvcod[1]
			dw_list.object.t_name4.text = sCvcod[2]
			dw_list.object.t_name5.text = sCvcod[3]
			dw_list.object.t_name6.text = sCvcod[4]
			dw_list.object.t_name7.text = sCvcod[5]			
		End if
	End if	
	
	If lB_Find = false then
		Messagebox("��ǰ���� �˻�", "�˻��� ã������ ǰ���� �߻������ϴ�", stopsign!)
	End if

End if

// �ŷ�ó�������� ��ȸ
If sgubun = '2' then 
	Select cvnas
	  into :sitdsc
	  from vndmst
	 Where cvcod = :scvcod[1];
	If sqlca.sqlcode <> 0 then
		MEssagebox("�ŷ�ó", "�ŷ�ó�� ����Ȯ �մϴ�", stopsign!)
		dw_list.setredraw(true)
		return -1
	End if
	
	ii = 0
	For Lrow = 1 to 7
		 sColName = 'itnbr' + string(Lrow)
		 If Trim(sItnbr[Lrow]) = '' then sitnbr[Lrow] = sNull
		 If Not IsNull( sItnbr[Lrow] ) then
			 II++
		 End if	
	Next
	
	If ii < 1 then
		MessageBox("ǰ��", "ǰ���� �ּ� 1���̻� ���õǾ�� �մϴ�", stopsign!)
		dw_list.setredraw(true)
		return -1
	End if	
	

	lb_find = True
	jj      = 0

	dw_print.retrieve(sCvcod[1], sitnbr[1], sitnbr[2], sitnbr[3], sitnbr[4], sitnbr[5], sitnbr[6], sitnbr[7])

	dw_print.modify("st_date.text = '"  + string(susedate, "@@@@.@@.@@")  + "'")
	dw_print.modify("t_cvcod.text = '"   + scvcod[1] +"'")
	dw_print.modify("t_cvnas.text = '"   + sitdsc  + "'")
	
	ds_bom.dataobject   = "d_pdm_11737_single"	
	ds_bom.settransobject(sqlca)		
	For Lrow = 1 to 7
		 jj++		
		 
		 
		 sMdname = "t_name" + String(jj) + ".text = '" + sItnbr[Lrow] + "'"
		 dw_print.modify(sMdname)		 
		 dw_list.modify(sMdname)
		
		 If Not Isnull( sItnbr[Lrow] ) Then			
			 ds_bom.retrieve(sItnbr[Lrow], sItnbr[Lrow], sCvcod[1], sUseDate)
			 For Lrow1 = 1 to ds_bom.rowcount()
				  
				  Lfind = 0
				  sChkit = ds_bom.getitemstring(Lrow1, "wstruc_cinbr")
				  Lfind = dw_print.find("itnbr = '"+ schkit +"'", 1, dw_print.rowcount())

				  If Lfind < 1 then
					  lb_find = False
				  Else
					  sColname = 'qtypr' + string(jj)
					  dw_print.setitem(Lfind, sColname, ds_bom.getitemdecimal(Lrow1, "qtypr"))
				  End if				
				
			 Next
		 End if
		
	Next
	
	If lB_Find = false then
		Messagebox("��ǰ���� �˻�", "�˻��� ã������ ǰ���� �߻������ϴ�", stopsign!)
	End if

End if

destroy ds_bom

ii = dw_print.ShareData ( dw_list )

dw_list.setredraw(True)

w_mdi_frame.sle_msg.text = ''
setpointer(arrow!)

If dw_list.rowcount() = 0 then
	MEssagebox("���", "����� �ڷᰡ �����ϴ�", stopsign!)	
	return -1
End if
Return 1
end function

public function integer wf_calculation (string arg_itnbr, string susedate);string 	sItem,		&
			sbom1,		&
			sbom2, slname, sSTART, snewsql, snull, scvcod, scvnas, sbigyo
Decimal {5} dUnprc1, dUnprc2, dUnprc3 			
			
Long		Lpos, lvlno, imsg, Lrow, Lrow1 

SetNull(snull)

ds_bom.reset()

// ǰ���ȣ
sItem = arg_itnbr
////////////////////////////////////////////////////////////////////////////
sbigyo  = dw_ip.getitemstring(1, "bigyo")
If sBigyo = '1' then
	sstart = arg_itnbr
Else
	sstart = '%'
End if

/* Argument ���� */
if ds_bom.retrieve(arg_itnbr, sstart) < 1 then 
	return 1
end if

Decimal {4}  dsaveqty[10], dtempqty, drstqty

/* ��ȿ���� ���뿩�� */
for lrow = 1 to ds_bom.rowcount()
	 ds_bom.setitem(lrow, "gidat", susedate)
Next

For lrow = 1 to ds_bom.rowcount()
	 if susedate < ds_bom.getitemstring(lrow, "efrdt")  or &
		 susedate > ds_bom.getitemstring(lrow, "eftdt")  Then
		 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
		 ds_bom.deleterow(lrow)
		 Do while true	
			 if lrow  > ds_bom.rowcount() then exit
			 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
				 ds_bom.deleterow(lrow)				 
			 Else
				 Exit
			 End if
		 Loop
		 lrow = lrow - 1
	 End if
	 
	 // �������� ��� ��üǰ������ ��� ó��
	 if Lrow <= ds_bom.rowcount() and Lrow > 0 then
		 if not IsNull( ds_bom.getitemstring(lrow, "dcinbr") )  Then
			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			 ds_bom.deleterow(lrow)
			 Do while true	
				 if lrow  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
					 ds_bom.deleterow(lrow)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
	 End if
	 	 
	 // �������� ��� BOM�̿Ϸ��̸� ����
	 if Lrow <= ds_bom.rowcount() and Lrow > 0  then		
		 if ds_bom.getitemstring(lrow, "bomend") = 'N'   Then
			 lvlno = ds_bom.getitemdecimal(lrow, "lvlno")
			 ds_bom.deleterow(lrow)
			 Do while true	
				 if lrow  > ds_bom.rowcount() then exit
				 if lvlno < ds_bom.getitemdecimal(lrow, "lvlno") then
					 ds_bom.deleterow(lrow)				 
				 Else
					 Exit
				 End if
			 Loop
			 lrow = lrow - 1
		 End if
	 End if
	 
Next

/* ǰ���� ���� */
w_mdi_frame.sle_msg.text = 'ǰ�� ������ �������Դϴ�'	

if ds_bom.dataobject = "d_pdm_11730_p_single"    or &
	ds_bom.dataobject = "d_pdm_11730_p_single_1"  then
	 ds_bom.setsort("estruc_cinbr A")
Elseif ds_bom.dataobject = "d_pdm_11730_m_single"    or &
	 ds_bom.dataobject = "d_pdm_11730_m_single_1"  then
	 ds_bom.setsort("pstruc_cinbr A")
End if
ds_bom.sort()

Lrow = 0
Do while True
	Lrow++
	If Lrow >= ds_bom.rowcount() Then
		Exit
	End if

	if ds_bom.dataobject = "d_pdm_11730_p_single"    or &
		ds_bom.dataobject = "d_pdm_11730_p_single_1"  then
		
		If ds_bom.getitemstring(Lrow,     "estruc_cinbr") = &
			ds_bom.getitemstring(Lrow + 1, "estruc_cinbr")   Then
			ds_bom.setitem(Lrow + 1, "qtypr", ds_bom.getitemdecimal(Lrow + 1, "qtypr") + &
														 ds_bom.getitemdecimal(Lrow, "qtypr"))
			ds_bom.deleterow(Lrow)
			Lrow = Lrow - 1
		End if
		
	Elseif ds_bom.dataobject = "d_pdm_11730_m_single"    or &
		 ds_bom.dataobject = "d_pdm_11730_m_single_1"  then
		 
		If ds_bom.getitemstring(Lrow,     "pstruc_cinbr") = &
			ds_bom.getitemstring(Lrow + 1, "pstruc_cinbr")   Then
			ds_bom.setitem(Lrow + 1, "qtypr", ds_bom.getitemdecimal(Lrow + 1, "qtypr") + &
														 ds_bom.getitemdecimal(Lrow, "qtypr"))
			ds_bom.deleterow(Lrow)
			Lrow = Lrow - 1
		End if
		 
	End if

Loop

return 1
end function

on w_pdm_11721.create
int iCurrent
call super::create
this.cbx_eng=create cbx_eng
this.cbx_pdt=create cbx_pdt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_eng
this.Control[iCurrent+2]=this.cbx_pdt
end on

on w_pdm_11721.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_eng)
destroy(this.cbx_pdt)
end on

type p_preview from w_standard_print`p_preview within w_pdm_11721
end type

type p_exit from w_standard_print`p_exit within w_pdm_11721
end type

type p_print from w_standard_print`p_print within w_pdm_11721
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11721
end type

event p_retrieve::clicked;
IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\�μ�_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\�̸�����_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\�μ�_up.gif'
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\�̸�����_up.gif'
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)

//dw_list.object.datawindow.print.preview="yes"



	
end event







type st_10 from w_standard_print`st_10 within w_pdm_11721
end type



type dw_print from w_standard_print`dw_print within w_pdm_11721
integer x = 4151
integer y = 112
integer width = 489
integer height = 132
string dataobject = "d_pdm_11721_1_vndmst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11721
integer x = 32
integer y = 24
integer width = 3826
integer height = 208
string dataobject = "d_pdm_11721_3"
end type

event dw_ip::itemchanged;call super::itemchanged;string scolname, sname, sdata, sNull

SetNull(sNull)

scolname = this.GetColumnName()
if Left(sColName, 5) = 'itnbr' then
	sData = gettext()
	Select itdsc into :sname from itemas where itnbr = :sData;
	If sqlca.sqlcode <> 0  then
		this.SetItem(1, scolname, sNull)
		Messagebox("ǰ��", "ǰ���� ��Ȯ���� �����ϴ�", stopsign!)
		return 1
	end if
elseif Left(sColName, 5) = 'cvcod' then
	sData = gettext()
	Select cvnas into :sname from vndmst where cvcod = :sData;
	If sqlca.sqlcode <> 0  then
		this.SetItem(1, scolname, sNull)
		Messagebox("�ŷ�ó", "�ŷ�ó�� ��Ȯ���� �����ϴ�", stopsign!)
		return 1
	end if
elseif sColName = 'gubun' then
	
	sData = gettext()

	dw_ip.setredraw(False)
	If sData = '1' then
		dw_ip.dataobject = 'd_pdm_11721_3'	
		dw_print.dataobject = 'd_pdm_11721_1_vndmst'
		dw_list.dataobject  = 'd_pdm_11721_1_vndmst_d'	
	Else
		dw_ip.dataobject = 'd_pdm_11721_31'
		dw_print.dataobject = 'd_pdm_11721_1_itemas'
		dw_list.dataobject  = 'd_pdm_11721_1_itemas_d'			
	End if
	dw_ip.insertrow(0)
	dw_ip.setredraw(True)	
	
	dw_print.settransobject(sqlca)
	dw_list.settransobject(sqlca)	
	
end if	
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sittyp, scolname
Long Lrow

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

Lrow = row
if Lrow < 1 then return

this.accepttext()
scolname = this.GetColumnName()
if Left(sColName, 5) = 'itnbr' then

	Open(w_itemas_popup)
	this.SetItem(1, scolname, gs_code)

elseif Left(sColName, 5) = 'cvcod' then
	open(w_vndmst_popup)		
	this.SetItem(1,scolname,gs_code)
end if	


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	open(w_itemas_popup2)
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "itnbr", gs_code)
   RETURN 1
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdm_11721
integer y = 264
integer height = 1988
string dataobject = "d_pdm_11721_1_vndmst_d"
end type

type cbx_eng from checkbox within w_pdm_11721
integer x = 3593
integer y = 48
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 33027312
string text = "����BOM"
boolean checked = true
end type

type cbx_pdt from checkbox within w_pdm_11721
integer x = 3593
integer y = 128
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 33027312
string text = "����BOM"
boolean checked = true
end type

