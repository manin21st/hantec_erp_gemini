$PBExportHeader$w_sal_03590_1.srw
$PBExportComments$�����Ȳ(����ȸ)
forward
global type w_sal_03590_1 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sal_03590_1
end type
end forward

global type w_sal_03590_1 from w_inherite_popup
integer x = 110
integer y = 200
integer width = 3488
integer height = 1908
rr_1 rr_1
end type
global w_sal_03590_1 w_sal_03590_1

type variables
string out_store,hold_gu

end variables

on w_sal_03590_1.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_03590_1.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String sGubun, sItdsc, sIspec, sJijil, sispeccode

sGubun = message.stringparm

dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)

Choose Case sGubun
	Case '��ó����'
		 This.Title = '��ó�� ���� ����'
		 dw_1.dataobject = 'd_sal_03590_1'
	Case '�Ҵ����'
		 This.Title = '�Ҵ� ����'
		 dw_1.dataobject = 'd_sal_03590_2'
	Case '���ü���'
		 This.Title = '���� ���� ����'
		 dw_1.dataobject = 'd_sal_03590_3'
	Case '���ּ���'
		 This.Title = '���� ���� ����'
		 dw_1.dataobject = 'd_sal_03590_4'
	Case '�����԰������'
		 This.Title = '�����԰��� ����'
		 dw_1.dataobject = 'd_sal_03590_5'
	Case '�����԰������'
		 This.Title = '�����԰��� ����'
		 dw_1.dataobject = 'd_sal_03590_6'
	Case Else
		Close(This)
		Return
End Choose

/* gs_code     : â�� */
/* gs_codename : ǰ�� */
/* gs_gubun    : ��� */
select itdsc ,ispec, jijil, ispec_code
  into :sItdsc, :sIspec, :sJijil, :sispeccode
  from itemas
 where itnbr = :gs_codename;
 
dw_jogun.SetItem(1,'depot_no',gs_code)
dw_jogun.SetItem(1,'itnbr',   gs_codename)
dw_jogun.SetItem(1,'itdsc',   sItdsc)
dw_jogun.SetItem(1,'ispec',   sIspec)
dw_jogun.SetItem(1,'jijil',   sJijil)
dw_jogun.SetItem(1,'ispec_code',   sIspeccode)

dw_1.SetTransObject(Sqlca)
dw_1.Retrieve(gs_sabu, gs_code, gs_codename, gs_gubun )
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_03590_1
integer x = 23
integer y = 152
integer width = 3429
integer height = 140
string dataobject = "d_sal_03590_1_01"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sNull, sCvcod, sget_name, sItnbr, sItdsc, sIspec, sJijil, sIspecCode
long   lcount, ireturn

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "vndcod"
		scvcod = trim(this.GetText())
		
		IF scvcod ="" OR IsNull(scvcod) THEN 
			this.SetItem(1,"vndnm",snull)
			RETURN
		END IF
		
		SELECT "VNDMST"."CVNAS2"  INTO :sget_name  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :scvcod   ;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"vndnm",sget_name)
		ELSE
			this.TriggerEvent(RbuttonDown!)
			
			IF gs_code ="" OR IsNull(gs_code) THEN 
				this.Setitem(1,"vndcod",snull)
				this.SetItem(1,"vndnm",snull)
			END IF
			Return 1
		END IF
	Case "fr_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "fr_date", sNull)
			return 1
		END IF
	Case "to_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "to_date", sNull)
			return 1
		END IF
	/* ǰ�� */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* ǰ�� */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* �԰� */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* ���� */
	Case "jijil"
		sJijil = trim(GetText())
	
		ireturn = f_get_name4('����', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* �԰��ڵ� */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4('�԰��ڵ�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
END Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = "vndcod" THEN
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN gs_code =""
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(1, "vndcod", gs_Code)
	this.SetItem(1, "vndnm", gs_Codename)
//	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
END IF
end event

type p_exit from w_inherite_popup`p_exit within w_sal_03590_1
integer x = 3241
integer y = 4
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_03590_1
integer x = 3067
integer y = 4
end type

event p_inq::clicked;call super::clicked;String sDepotNo, sItnbr, sPspec

sDepotNo = Trim(dw_jogun.GetItemString(1,'depot_no'))
sItnbr   = Trim(dw_jogun.GetItemString(1,'itnbr'))
spspec = Trim(dw_jogun.GetItemString(1,'pspec'))

IF IsNull(sDepotNo) Then sDepotNo = ''
IF IsNull(sItnbr) Then sItnbr = ''
IF IsNull(sPspec) Or sPspec = '' Then sPspec = '.'

dw_1.Retrieve(gs_sabu, sDepotNo, sItnbr, sPspec )
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_sal_03590_1
integer x = 2894
integer y = 4
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\�μ�_up.gif"
end type

event p_choose::clicked;call super::clicked;If dw_1.RowCount() > 0 then
	gi_page = dw_1.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_1)
End If



end event

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\�μ�_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\�μ�_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_03590_1
integer x = 37
integer y = 308
integer width = 3392
integer height = 1468
integer taborder = 20
string dataobject = "d_sal_03590_1"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_03590_1
boolean visible = false
integer x = 805
integer y = 1896
integer width = 1225
integer taborder = 0
end type

type cb_1 from w_inherite_popup`cb_1 within w_sal_03590_1
boolean visible = false
integer x = 1271
integer y = 1872
boolean enabled = false
string text = "���(&P)"
end type

type cb_return from w_inherite_popup`cb_return within w_sal_03590_1
boolean visible = false
integer x = 1902
integer y = 1872
boolean enabled = false
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_sal_03590_1
boolean visible = false
integer x = 1595
integer y = 1872
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sal_03590_1
boolean visible = false
integer x = 603
integer y = 1896
integer width = 197
integer taborder = 0
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_sal_03590_1
boolean visible = false
integer x = 274
integer y = 1908
integer width = 315
string text = "�ŷ�ó�ڵ�"
end type

type rr_1 from roundrectangle within w_sal_03590_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 296
integer width = 3419
integer height = 1488
integer cornerheight = 40
integer cornerwidth = 55
end type

