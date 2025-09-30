$PBExportHeader$w_pdt_02900.srw
$PBExportComments$** 품목별 표준시간 대비 실적시간 분석표
forward
global type w_pdt_02900 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02900
end type
end forward

global type w_pdt_02900 from w_standard_print
string title = "품목별시간대비실적시간비교표"
rr_1 rr_1
end type
global w_pdt_02900 w_pdt_02900

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDate1,sDate2,sgub,sfrom, sto, sfitnbr, stitnbr
	
if dw_ip.AcceptText() = -1 then return -1

sDate1 = trim(dw_ip.GetITemString(1,"sidat"))
sDate2 = trim(dw_ip.GetITemString(1,"sidat1"))
sgub   = trim(dw_ip.GetITemString(1,"gubun"))

IF sDate1 = '' OR ISNULL(sDate1) THEN sdate1 = '10000101'
IF sDate2 = '' OR ISNULL(sDate2) THEN sdate2 = '99991231'
	
if sgub = '1' then 
	sFrom  = trim(dw_ip.GetITemString(1,"fpordno"))
	sto    = trim(dw_ip.GetITemString(1,"tpordno"))
	IF sfrom = '' OR ISNULL(sfrom) THEN sfrom = '1000000000000000'
	IF sto   = '' OR ISNULL(sto)   THEN sto   = '9999999999999999'
	
	sfitnbr  = trim(dw_ip.GetITemString(1,"fr_itnbr"))
	stitnbr  = trim(dw_ip.GetITemString(1,"to_itnbr"))
	IF sfitnbr = '' OR ISNULL(sfitnbr) THEN sfitnbr = '.'
	IF stitnbr = '' OR ISNULL(stitnbr) THEN stitnbr = 'zzzzzzzzzzzzzzz'
else
	sfitnbr  = trim(dw_ip.GetITemString(1,"fr_itnbr"))
	stitnbr  = trim(dw_ip.GetITemString(1,"to_itnbr"))
	IF sfitnbr = '' OR ISNULL(sfitnbr) THEN sfitnbr = '.'
	IF stitnbr = '' OR ISNULL(stitnbr) THEN stitnbr = 'zzzzzzzzzzzzzzz'
end if

if sgub = '1' then
	dw_list.dataobject = "dw_pdt_02900"
	dw_print.dataobject = "dw_pdt_02900_p"
else
	dw_list.dataobject = "dw_pdt_02910"
	dw_print.dataobject = "dw_pdt_02910_p"
end if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

if sgub = '1' then
	IF dw_print.Retrieve(gs_sabu,sDate1,sDate2, sfrom, sto, sfitnbr, stitnbr) < 1 THEN
		f_message_chk(50,'')
		dw_ip.setfocus()
		return -1
	END IF	
else
	IF dw_print.Retrieve(gs_sabu,sDate1,sDate2, sfitnbr, stitnbr) < 1 THEN
		f_message_chk(50,'')
		dw_ip.setfocus()
		return -1
	END IF	
end if

dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_02900.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_02900.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sidat",F_today())
dw_ip.SetItem(1,"sidat1",F_today())
end event

type p_preview from w_standard_print`p_preview within w_pdt_02900
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pdt_02900
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pdt_02900
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02900
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_pdt_02900
end type

type gb_10 from w_standard_print`gb_10 within w_pdt_02900
boolean visible = false
integer x = 5
integer y = 2428
integer width = 274
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
end type

type dw_print from w_standard_print`dw_print within w_pdt_02900
string dataobject = "dw_pdt_02900_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02900
integer x = 27
integer width = 3730
integer height = 224
string dataobject = "d_pdt_02900_ret"
end type

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, s_gub, snull
int     ireturn

SEtnull(snull)

IF this.GetColumnName() = "fr_itnbr"	THEN
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
END IF

end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
	gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "fpordno"	THEN	
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "fpordno", gs_Code)
   return 1
ELSEIF this.GetColumnName() = "tpordno"	THEN	
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "tpordno", gs_Code)
   return 1
END IF	

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02900
integer x = 46
integer y = 248
integer width = 4521
integer height = 2064
string dataobject = "dw_pdt_02900"
boolean controlmenu = true
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_02900
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 240
integer width = 4553
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

