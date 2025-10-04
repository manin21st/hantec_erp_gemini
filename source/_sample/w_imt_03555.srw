$PBExportHeader$w_imt_03555.srw
$PBExportComments$** 품목별/구매처별 가격 비교표
forward
global type w_imt_03555 from w_standard_print
end type
type dw_1 from datawindow within w_imt_03555
end type
type pb_2 from u_pb_cal within w_imt_03555
end type
type rr_1 from roundrectangle within w_imt_03555
end type
type rr_2 from roundrectangle within w_imt_03555
end type
end forward

global type w_imt_03555 from w_standard_print
string title = "품목별 구매처별 가격비교표"
dw_1 dw_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_03555 w_imt_03555

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	
dw_ip.setitem(1, "to_ispec", sispec)

end subroutine

public function integer wf_retrieve ();String  sitnbr, eitnbr, scvcod, ecvcod, sittyp, syymm, sRate, scurr, stxt
int     k
dec{2}  drate

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sitnbr  = TRIM(dw_ip.GetItemString(1,"fr_itnbr"))
eitnbr  = TRIM(dw_ip.GetItemString(1,"to_itnbr"))

scvcod  = TRIM(dw_ip.GetItemString(1,"fr_cvcod"))
ecvcod  = TRIM(dw_ip.GetItemString(1,"to_cvcod"))

sittyp  = TRIM(dw_ip.GetItemString(1,"ittyp"))
syymm   = TRIM(dw_ip.GetItemString(1,"yymm"))

IF sitnbr = "" OR IsNull(sitnbr) THEN sitnbr = '.'
IF eitnbr = "" OR IsNull(eitnbr) THEN eitnbr = 'ZZZZZZZZZZZZ'
IF scvcod = "" OR IsNull(scvcod) THEN scvcod = '.'
IF ecvcod = "" OR IsNull(ecvcod) THEN ecvcod = 'ZZZZZZ'

IF sittyp = "" OR IsNull(sittyp) THEN sittyp = '%'
IF syymm = "" OR IsNull(syymm) THEN syymm = is_today

//FOR k = 1 TO dw_1.rowcount()
//	scurr = dw_1.getitemstring(k, 'rcurr')
//	dRate = dw_1.getitemdecimal(k, 'rpmaz')
//	
//	sRate = scurr + ' : ' + string(dRate, '###,##0.00')
//	
//	if k > 1 then 
//		stxt  = stxt + ', ' + sRate 
//	else
//		stxt  = sRate
//	end if
//NEXT
//
//dw_list.object.rate_t.text = stxt

IF dw_list.Retrieve(sittyp, sitnbr, eitnbr, scvcod, ecvcod, syymm) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
//	return -1
end if

IF dw_print.Retrieve(sittyp, sitnbr, eitnbr, scvcod, ecvcod, syymm) < 1 THEN
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

//dw_print.ShareData(dw_list)

return 1

end function

on w_imt_03555.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_imt_03555.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1, 'yymm', is_today)

dw_1.settransobject(sqlca)
dw_1.retrieve(is_today)

end event

type p_preview from w_standard_print`p_preview within w_imt_03555
integer x = 4091
end type

type p_exit from w_standard_print`p_exit within w_imt_03555
integer x = 4439
end type

type p_print from w_standard_print`p_print within w_imt_03555
integer x = 4265
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03555
integer x = 3918
end type







type st_10 from w_standard_print`st_10 within w_imt_03555
end type



type dw_print from w_standard_print`dw_print within w_imt_03555
integer x = 4027
integer y = 184
string dataobject = "d_imt_03555_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03555
integer x = 32
integer y = 12
integer width = 3049
integer height = 188
string dataobject = "d_imt_03555_01"
end type

event dw_ip::itemchanged;string snull, sitnbr, sitdsc, sispec
int    ireturn 

setnull(snull)

IF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
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
elseif this.getcolumnname() = 'fr_cvcod' then   
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2("V0", "N", sitnbr, sitdsc, sispec) 
	this.SetItem(1,"fr_cvcod", sitnbr)	
	this.SetItem(1,"fr_cvnm",  sitdsc)	
	RETURN ireturn
elseif this.getcolumnname() = 'to_cvcod' then   
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2("V0", "N", sitnbr, sitdsc, sispec) 
	this.SetItem(1, "to_cvcod", sitnbr)	
	this.SetItem(1, "to_cvnm",  sitdsc)	
	RETURN ireturn
elseif this.GetColumnName() = "yymm" then
	sItnbr = trim(this.GetText())
	if IsNull(sItnbr) or sItnbr = "" then return 
	if f_datechk(sItnbr) = -1 then
		f_message_chk(35,"[기준일자]")
		this.object.yymm[1] = ""
		dw_1.reset()
		return 1
	end if
	
	dw_1.retrieve(sItnbr)
END IF
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
	gs_gubun = '3'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	gs_gubun = '3'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)

elseIF this.getcolumnname() = "fr_cvcod"	THEN		
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "fr_cvcod", gs_code)
	this.SetItem(1, "fr_cvnm", gs_codename)
ELSEIF this.getcolumnname() = "to_cvcod"	THEN		
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "to_cvcod", gs_code)
	this.SetItem(1, "to_cvnm", gs_codename)
end if	

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_03555
integer y = 236
integer width = 4558
integer height = 2060
string dataobject = "d_imt_03555_02"
boolean border = false
end type

type dw_1 from datawindow within w_imt_03555
integer x = 3109
integer y = 36
integer width = 645
integer height = 144
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_imt_03555_03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type pb_2 from u_pb_cal within w_imt_03555
integer x = 2469
integer y = 96
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('yymm')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'yymm', gs_code)



end event

type rr_1 from roundrectangle within w_imt_03555
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3095
integer y = 20
integer width = 667
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_03555
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 228
integer width = 4576
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

