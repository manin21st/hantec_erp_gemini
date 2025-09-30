$PBExportHeader$w_pdt_04050.srw
$PBExportComments$재고 및 할당현황
forward
global type w_pdt_04050 from w_inherite
end type
type gb_1 from groupbox within w_pdt_04050
end type
type dw_ip from u_key_enter within w_pdt_04050
end type
type dw_jego from u_key_enter within w_pdt_04050
end type
type rr_1 from roundrectangle within w_pdt_04050
end type
type rr_2 from roundrectangle within w_pdt_04050
end type
end forward

global type w_pdt_04050 from w_inherite
string title = "재고 및 할당 현황"
string menuname = "m_main"
boolean resizable = true
gb_1 gb_1
dw_ip dw_ip
dw_jego dw_jego
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_04050 w_pdt_04050

type variables
string sIspecText, sJijilText

end variables

on w_pdt_04050.create
int iCurrent
call super::create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.gb_1=create gb_1
this.dw_ip=create dw_ip
this.dw_jego=create dw_jego
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_jego
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pdt_04050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.dw_ip)
destroy(this.dw_jego)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)
dw_jego.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

dw_jego.Setredraw(False)
dw_jego.ReSet()
dw_jego.InsertRow(0)
dw_jego.Setredraw(True)

dw_ip.Setredraw(False)
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)

dw_ip.object.gubun[1] = "1"
dw_jego.Visible = False

//규격,재질 
If f_change_name('1') = 'Y' Then
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_ip.Object.ispec_t.text =  sIspecText 
	dw_ip.Object.jijil_t.text =  sJijilText
	dw_insert.Object.ispec_tx.text =  sIspecText 
	dw_insert.Object.jijil_tx.text =  sJijilText
End If


end event

type dw_insert from w_inherite`dw_insert within w_pdt_04050
integer x = 101
integer y = 436
integer width = 4439
integer height = 1760
integer taborder = 0
string dataobject = "d_pdt_04050_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;String s_cod, s_nam1, s_nam2, s_nam3
Integer i_rtn
Long crow

s_cod = Trim(this.GetText())
crow = this.GetRow()

if	this.getcolumnname() = "itnbr" then
	i_rtn = f_get_name2("품번","Y",s_cod, s_nam1, s_nam2)
	dw_insert.object.itnbr[crow] = s_cod
	dw_insert.object.itdsc[crow] = s_nam1
	dw_insert.object.ispec[crow] = s_nam2
	if IsNull(s_cod) or s_cod = "" then 
		dw_insert.object.jijil[crow] = ""
      f_message_chk(33,"[품번]")		
	else
		select jijil into :s_nam3 from itemas
		 where itnbr = :s_cod;
		if sqlca.sqlcode <>  0 then
			dw_insert.object.jijil[crow] = ""
		else	
		   dw_insert.object.jijil[crow] = s_nam3
		end if	
	end if	
elseif this.getcolumnname() = "itdsc" then
   i_rtn = f_get_name2("품명", "Y", s_nam1, s_cod, s_nam2)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_cod
   this.object.ispec[crow] = s_nam2
   if IsNull(s_cod) or s_cod = "" then 
		dw_insert.object.jijil[crow] = ""
      f_message_chk(33,"[품명]")		
	else
		select jijil into :s_nam3 from itemas
		 where itnbr = :s_cod;
		if sqlca.sqlcode <>  0 then
			dw_insert.object.jijil[crow] = ""
		else	
		   dw_insert.object.jijil[crow] = s_nam3
		end if	
	end if
elseif this.getcolumnname() = "ispec" then
   i_rtn = f_get_name2("규격", "Y", s_nam1, s_nam2, s_cod)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_nam2
   this.object.ispec[crow] = s_cod
   if IsNull(s_cod) or s_cod = "" then 
		dw_insert.object.jijil[crow] = ""
      f_message_chk(33,"[규격]")		
	else
		select jijil into :s_nam3 from itemas
		 where itnbr = :s_cod;
		if sqlca.sqlcode <>  0 then
			dw_insert.object.jijil[crow] = ""
		else	
		   dw_insert.object.jijil[crow] = s_nam3
		end if	
	end if
elseif this.getcolumnname() = "depot_no" then	
	i_rtn = f_get_name2("창고", "Y", s_cod, s_nam1, s_nam2)
   this.object.depot_no[crow] = s_cod
   this.object.cvnas2[crow] = s_nam1
   return i_rtn  
end if

return i_rtn

end event

event dw_insert::ue_key;call super::ue_key;Long crow 
String s_jijil

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

SetNull(s_jijil)

crow = this.GetRow()
IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "itnbr" or this.getcolumnname() = "itdsc" or &
	   this.getcolumnname() = "ispec" THEN		
	   open(w_itemas_popup2)
	   this.SetItem(crow, "itnbr", gs_code)
	   this.SetItem(crow, "itdsc", gs_codename)
      this.SetItem(crow, "ispec", gs_gubun)
		if IsNull(gs_code) or gs_code = "" then return 1
		select jijil into :s_jijil from itemas
		 where itnbr = :gs_code;
		this.SetItem(crow, "jijil", s_jijil) 
      return 1
   END IF
END IF
end event

event dw_insert::rbuttondown;call super::rbuttondown;String s_jijil
Long crow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(s_jijil)
crow = this.getRow()
IF	this.getcolumnname() = "itnbr" or this.getcolumnname() = "itdsc" or &
   this.getcolumnname() = "ispec" THEN		
	open(w_itemas_popup)
	this.SetItem(crow, "itnbr", gs_code)
	this.SetItem(crow, "itdsc", gs_codename)
   this.SetItem(crow, "ispec", gs_gubun)
	if IsNull(gs_code) or gs_code = "" then return
	select jijil into :s_jijil from itemas
	 where itnbr = :gs_code;
	this.SetItem(crow, "jijil", s_jijil) 
   return 1
ELSEIF this.getcolumnname() = "depot_no" THEN		
	open(w_vndmst_46_popup)
	this.SetItem(crow, "depot_no", gs_code)
	this.SetItem(crow, "cvnas2", gs_codename)
END IF

return
end event

type p_delrow from w_inherite`p_delrow within w_pdt_04050
boolean visible = false
integer x = 3671
integer y = 3160
end type

type p_addrow from w_inherite`p_addrow within w_pdt_04050
boolean visible = false
integer x = 3497
integer y = 3160
end type

type p_search from w_inherite`p_search within w_pdt_04050
boolean visible = false
integer x = 3790
integer y = 2848
end type

type p_ins from w_inherite`p_ins within w_pdt_04050
boolean visible = false
integer x = 4183
integer y = 2864
end type

type p_exit from w_inherite`p_exit within w_pdt_04050
end type

type p_can from w_inherite`p_can within w_pdt_04050
boolean visible = false
integer x = 4192
integer y = 3160
end type

type p_print from w_inherite`p_print within w_pdt_04050
boolean visible = false
integer x = 3781
integer y = 3028
end type

type p_inq from w_inherite`p_inq within w_pdt_04050
integer x = 4270
end type

event p_inq::clicked;call super::clicked;String gubun, depot, ittyp, itnbr, itdsc, ispec, pspec
Long   i_rtn

if dw_ip.AcceptText() = -1 then return
gubun = Trim(dw_ip.object.gubun[1])
depot = Trim(dw_ip.object.depot[1])
ittyp = Trim(dw_ip.object.ittyp[1])
itnbr = Trim(dw_ip.object.itnbr[1])
itdsc = Trim(dw_ip.object.itdsc[1])
ispec = Trim(dw_ip.object.ispec[1])
pspec = Trim(dw_ip.object.pspec[1])

if gubun = "1" then //품목분류
	if IsNull(ittyp) or ittyp = "" then
		f_message_chk(30, "[품목분류]")
		dw_ip.SetColumn("ittyp")
		dw_ip.SetFocus()
   	return
	end if
else                //품번
	if IsNull(itnbr) or itnbr = "" then
		f_message_chk(30, "[품번]")
		dw_ip.SetColumn("itnbr")
		dw_ip.SetFocus()
   	return
	end if
	if IsNull(pspec) or pspec = "" then
		f_message_chk(30, "[사양]")
		dw_ip.SetColumn("pspec")
		dw_ip.SetFocus()
   	return
	end if
end if

if gubun = "2" then //품번
	if dw_jego.Retrieve(depot, itnbr, pspec) < 1 then
   	dw_jego.InsertRow(0)
		dw_jego.object.jego_qty[1] = 0
		dw_jego.object.hold_qty[1] = 0
		dw_jego.object.valid_qty[1] = 0
		dw_jego.object.exp_qty[1] = 0
	end if
end if

dw_insert.SetFilter("")
dw_insert.Filter()

if not(IsNull(depot) or depot = "") then
   dw_insert.SetFilter("out_store = '" + depot + "'")
   dw_insert.Filter()
end if

if gubun = "1" then //품목분류
   i_rtn  = dw_insert.Retrieve(gs_sabu, ittyp)
else
   i_rtn  = dw_insert.Retrieve(gs_sabu, itnbr, pspec)
end if

if i_rtn < 1 then
	f_message_chk(50, "[할당현황]")
end if	


end event

type p_del from w_inherite`p_del within w_pdt_04050
boolean visible = false
integer x = 4018
integer y = 3160
end type

type p_mod from w_inherite`p_mod within w_pdt_04050
boolean visible = false
integer x = 3845
integer y = 3160
end type

type cb_exit from w_inherite`cb_exit within w_pdt_04050
boolean visible = false
integer x = 2953
integer y = 2840
end type

type cb_mod from w_inherite`cb_mod within w_pdt_04050
boolean visible = false
integer x = 1435
integer y = 2816
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_pdt_04050
boolean visible = false
integer x = 370
integer y = 2812
integer taborder = 60
end type

type cb_del from w_inherite`cb_del within w_pdt_04050
boolean visible = false
integer x = 1088
integer y = 2816
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_pdt_04050
boolean visible = false
integer x = 2592
integer y = 2840
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;String gubun, depot, ittyp, itnbr, itdsc, ispec, pspec
Long   i_rtn

if dw_ip.AcceptText() = -1 then return
gubun = Trim(dw_ip.object.gubun[1])
depot = Trim(dw_ip.object.depot[1])
ittyp = Trim(dw_ip.object.ittyp[1])
itnbr = Trim(dw_ip.object.itnbr[1])
itdsc = Trim(dw_ip.object.itdsc[1])
ispec = Trim(dw_ip.object.ispec[1])
pspec = Trim(dw_ip.object.pspec[1])

if gubun = "1" then //품목분류
	if IsNull(ittyp) or ittyp = "" then
		f_message_chk(30, "[품목분류]")
		dw_ip.SetColumn("ittyp")
		dw_ip.SetFocus()
   	return
	end if
else                //품번
	if IsNull(itnbr) or itnbr = "" then
		f_message_chk(30, "[품번]")
		dw_ip.SetColumn("itnbr")
		dw_ip.SetFocus()
   	return
	end if
	if IsNull(pspec) or pspec = "" then
		f_message_chk(30, "[사양]")
		dw_ip.SetColumn("pspec")
		dw_ip.SetFocus()
   	return
	end if
end if

if gubun = "2" then //품번
	if dw_jego.Retrieve(depot, itnbr, pspec) < 1 then
   	dw_jego.InsertRow(0)
		dw_jego.object.jego_qty[1] = 0
		dw_jego.object.hold_qty[1] = 0
		dw_jego.object.valid_qty[1] = 0
		dw_jego.object.exp_qty[1] = 0
	end if
end if

dw_insert.SetFilter("")
dw_insert.Filter()

if not(IsNull(depot) or depot = "") then
   dw_insert.SetFilter("out_store = '" + depot + "'")
   dw_insert.Filter()
end if

if gubun = "1" then //품목분류
   i_rtn  = dw_insert.Retrieve(gs_sabu, ittyp)
else
   i_rtn  = dw_insert.Retrieve(gs_sabu, itnbr, pspec)
end if

if i_rtn < 1 then
	f_message_chk(50, "[할당현황]")
end if	


end event

type cb_print from w_inherite`cb_print within w_pdt_04050
boolean visible = false
integer x = 736
integer y = 2804
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_pdt_04050
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_04050
boolean visible = false
integer x = 1783
integer y = 2816
integer taborder = 50
end type

type cb_search from w_inherite`cb_search within w_pdt_04050
boolean visible = false
integer x = 2066
integer y = 2824
integer width = 334
integer taborder = 100
string text = "IMAGE"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_04050
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_04050
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_04050
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_04050
end type

type gb_1 from groupbox within w_pdt_04050
boolean visible = false
integer x = 2546
integer y = 2772
integer width = 777
integer height = 204
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_ip from u_key_enter within w_pdt_04050
event ue_key pbm_dwnkey
integer x = 133
integer y = 64
integer width = 2537
integer height = 340
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_04050_01"
boolean border = false
boolean livescroll = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
elseif keydown(keyF2!) THEN
	IF	this.getcolumnname() = "itnbr" or this.getcolumnname() = "itdsc" or &
   	this.getcolumnname() = "ispec" THEN		
		open(w_itemas_popup)
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
   END IF
END IF

return
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF	this.getcolumnname() = "itnbr" or this.getcolumnname() = "itdsc" or &
   this.getcolumnname() = "ispec" THEN		
	open(w_itemas_popup)
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	return
END IF
end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam1, s_nam2, s_nam3, s_nam4
Integer i_rtn

if	this.getcolumnname() = "gubun" then
   s_cod = Trim(this.GetText())
	if s_cod = "1" then
  	   this.object.cod_t.Text = "품목구분"
		dw_jego.Visible = False  
		dw_insert.DataObject = "d_pdt_04050_03"
		//규격,재질 
		If f_change_name('1') = 'Y' Then
			dw_insert.Object.ispec_tx.text =  sIspecText 
			dw_insert.Object.jijil_tx.text =  sJijilText
		End If
	else
		this.object.cod_t.Text = "품번"
		dw_jego.Visible = True
		dw_insert.DataObject = "d_pdt_04050_04"
	end if	
	dw_insert.SetTransObject(SQLCA)
elseif this.getcolumnname() = "itnbr" then
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name4("품번", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
	this.object.jijil[1] = s_nam3
	this.object.ispec_code[1] = s_nam4
	return i_rtn
elseif this.getcolumnname() = "itdsc" then
	s_nam1 = Trim(this.GetText())
	i_rtn = f_get_name4("품명", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
	this.object.jijil[1] = s_nam3
	this.object.ispec_code[1] = s_nam4
	return i_rtn
elseif this.getcolumnname() = "ispec" then
	s_nam2 = Trim(this.GetText())
	i_rtn = f_get_name4("규격", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
	this.object.jijil[1] = s_nam3
	this.object.ispec_code[1] = s_nam4
	return i_rtn
elseif this.getcolumnname() = "jijil" then
	s_nam3 = Trim(this.GetText())
	i_rtn = f_get_name4("재질", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
	this.object.jijil[1] = s_nam3
	this.object.ispec_code[1] = s_nam4
	return i_rtn
elseif this.getcolumnname() = "ispec_code" then
	s_nam4 = Trim(this.GetText())
	i_rtn = f_get_name4("규격코드", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
	this.object.jijil[1] = s_nam3
	this.object.ispec_code[1] = s_nam4
	return i_rtn
end if


end event

event getfocus;call super::getfocus;dw_insert.SetReDraw(False)
dw_insert.ReSet()
dw_insert.SetReDraw(True)

dw_jego.SetReDraw(False)
dw_jego.ReSet()
dw_jego.InsertRow(0)
dw_jego.SetReDraw(True)
end event

type dw_jego from u_key_enter within w_pdt_04050
integer x = 2656
integer y = 64
integer width = 786
integer height = 336
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_04050_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_04050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 91
integer y = 56
integer width = 3365
integer height = 356
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_04050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 428
integer width = 4466
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 55
end type

