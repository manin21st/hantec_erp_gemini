$PBExportHeader$w_pdt_05520.srw
$PBExportComments$** 외주발주예정LIST
forward
global type w_pdt_05520 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_05520
end type
type pb_2 from u_pb_cal within w_pdt_05520
end type
type rr_1 from roundrectangle within w_pdt_05520
end type
end forward

global type w_pdt_05520 from w_standard_print
string title = "외주발주예정 LIST"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_05520 w_pdt_05520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cvcod1, cvcod2, fitnbr, titnbr, sgub, sdate, edate

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
fitnbr = trim(dw_ip.object.fr_itnbr[1])
titnbr = trim(dw_ip.object.to_itnbr[1])
sgub   = trim(dw_ip.object.sgub[1])
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])

if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"

if (IsNull(fitnbr) or fitnbr = "")  then fitnbr = "."
if (IsNull(titnbr) or titnbr = "")  then titnbr = "zzzzzzzzzzzzzzz"

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99999999"

dw_print.setredraw(false)
if sgub = '1' then //거래처순
   dw_list.DataObject = 'd_pdt_05520_02'
   dw_print.DataObject = 'd_pdt_05520_02_p' 
else
   dw_list.DataObject = 'd_pdt_05520_03'
   dw_print.DataObject = 'd_pdt_05520_03_p' 
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_print.setredraw(true)

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

if dw_print.Retrieve(gs_sabu, sdate, edate, fitnbr, titnbr, cvcod1, cvcod2) <= 0 then
	f_message_chk(50,'[외주발주예정 LIST]')
	dw_ip.Setfocus()
	return -1
end if
   
	dw_print.Sharedata(dw_list)
return 1
end function

on w_pdt_05520.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_05520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', left(is_today, 6)+'01')
dw_ip.setitem(1, 'edate', is_today)

end event

type p_preview from w_standard_print`p_preview within w_pdt_05520
end type

type p_exit from w_standard_print`p_exit within w_pdt_05520
end type

type p_print from w_standard_print`p_print within w_pdt_05520
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_05520
end type







type st_10 from w_standard_print`st_10 within w_pdt_05520
end type



type dw_print from w_standard_print`dw_print within w_pdt_05520
string dataobject = "d_pdt_05520_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_05520
integer x = 87
integer y = 184
integer width = 4375
integer height = 204
string dataobject = "d_pdt_05520_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn
string  sitnbr, sitdsc, sispec, s_gub, snull
int     ireturn

s_cod = Trim(this.GetText()) 

if this.GetColumnName() = "cvcod1" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod1",s_cod)
	this.SetItem(1,"cvnam1",s_nam1)
	return i_rtn 
elseif this.GetColumnName() = "cvcod2" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod2",s_cod)
	this.SetItem(1,"cvnam2",s_nam1)
	return i_rtn 
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
elseif this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지시일자 FROM]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지시일자 TO]")
		this.object.edate[1] = ""
		return 1
	end if
end if


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_Gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
   if gs_code = '' or isnull(gs_code) then return 	
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
   if gs_code = '' or isnull(gs_code) then return 	
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
ELSEif this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_pdt_05520
integer x = 110
integer y = 420
integer width = 4457
integer height = 1872
string dataobject = "d_pdt_05520_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_pdt_05520
integer x = 1710
integer y = 200
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_05520
integer x = 2149
integer y = 200
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_05520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 416
integer width = 4489
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

