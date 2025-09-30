$PBExportHeader$w_imt_02500.srw
$PBExportComments$** 대체품 현황
forward
global type w_imt_02500 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_02500
end type
end forward

global type w_imt_02500 from w_standard_print
string title = "대체품 현황"
rr_1 rr_1
end type
global w_imt_02500 w_imt_02500

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_gub, s_fritnbr, s_toitnbr, s_sitcls, s_eitcls

if dw_ip.AcceptText() = -1 then return -1

s_gub  = dw_ip.GetItemString(1,'itgu')  
if s_gub = "" or isnull(s_gub) then s_gub = '%'

s_sitcls = dw_ip.GetItemString(1,"sitcls")
s_eitcls = dw_ip.GetItemString(1,"eitcls")
s_fritnbr = dw_ip.GetItemString(1,"sitnbr")
s_toitnbr = dw_ip.GetItemString(1,"eitnbr")

IF s_fritnbr = "" OR IsNull(s_fritnbr) THEN 
	s_fritnbr = '.'
END IF
IF s_toitnbr = "" OR IsNull(s_toitnbr) THEN 
	s_toitnbr = 'zzzzzzzzzzzzzzz'
END IF

IF s_sitcls = "" OR IsNull(s_sitcls) THEN 
	s_sitcls = '.'
END IF
IF s_eitcls = "" OR IsNull(s_eitcls) THEN 
	s_eitcls = 'zzzzzzzzzzzzzzz'
END IF

if s_sitcls > s_eitcls then 
	f_message_chk(34,'[품목분류]')
	dw_ip.Setcolumn('sitcls')
	dw_ip.SetFocus()
	return -1
end if	

if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[품번]')
	dw_ip.Setcolumn('sitnbr')
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(s_gub, s_sitcls, s_eitcls, s_fritnbr,s_toitnbr) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1

end function

on w_imt_02500.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_02500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_imt_02500
end type

type p_exit from w_standard_print`p_exit within w_imt_02500
end type

type p_print from w_standard_print`p_print within w_imt_02500
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_02500
end type











type dw_print from w_standard_print`dw_print within w_imt_02500
string dataobject = "d_imt_02500_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02500
integer x = 9
integer y = 4
integer width = 2958
integer height = 324
string dataobject = "d_imt_02500_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;String s_colname
string	sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
s_colname = GetColumnName()
nRow = GetRow()
if (s_colname = 'sitnbr') or (s_colname = 'eitnbr') then 

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	if s_colname = 'sitnbr' then
		SetItem(nRow,"sitnbr",gs_code)
		SetItem(nRow,"fname",gs_codename)
	elseif s_colname = 'eitnbr' then
		SetItem(nRow,"eitnbr",gs_code)
		SetItem(nRow,"tname",gs_codename)
	end if

end if

if this.GetColumnName() = 'sitcls' then
   this.accepttext()

	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"sitcls", lstr_sitnct.s_sumgub)
	this.SetColumn('sitcls')
	this.SetFocus()

end if

if this.GetColumnName() = 'eitcls' then
   this.accepttext()

	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"eitcls", lstr_sitnct.s_sumgub)
	this.SetColumn('eitcls')
	this.SetFocus()

end if

end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"to_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_ip::itemchanged;
string	sCode, sName, sNull, sitnbr, sitdsc, sispec
integer  ireturn

Setnull(sNull)

IF this.GetColumnName() = "sitnbr"	THEN
	sitnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "sitnbr", sitnbr)	
	this.setitem(1, "fname", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fname"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "sitnbr", sitnbr)	
	this.setitem(1, "fname", sitdsc)	
	RETURN ireturn
elseIF this.GetColumnName() = "eitnbr"	THEN
	sitnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "eitnbr", sitnbr)	
	this.setitem(1, "tname", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "tname"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "eitnbr", sitnbr)	
	this.setitem(1, "tname", sitdsc)	
	RETURN ireturn	
end if


// 출력구분
IF this.GetColumnName() = 'gubun'	THEN
	
	choose case data
		case '1'
			  dw_list.dataobject = 'd_imt_02500_1'
			  dw_print.dataobject = 'd_imt_02500_1_p'
		case '2'
			  dw_list.dataobject = 'd_imt_02500_11'
			  dw_print.dataobject = 'd_imt_02500_11_p'
		case '3'
			  dw_list.dataobject = 'd_imt_02500_12'
			  dw_print.dataobject = 'd_imt_02500_12_p'
	end choose
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)	

	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

//	cb_ruler.Enabled = false
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//	ddlb_zoom.text = '100'
//	cb_ruler.text = '여백ON'

END IF
end event

type dw_list from w_standard_print`dw_list within w_imt_02500
integer x = 37
integer y = 340
integer width = 4558
integer height = 1988
string dataobject = "d_imt_02500_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_02500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 332
integer width = 4590
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

