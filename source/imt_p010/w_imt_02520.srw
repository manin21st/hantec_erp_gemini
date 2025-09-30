$PBExportHeader$w_imt_02520.srw
$PBExportComments$** 거래계약서 관리대장
forward
global type w_imt_02520 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_02520
end type
end forward

global type w_imt_02520 from w_standard_print
string title = "거래계약서 관리대장"
rr_1 rr_1
end type
global w_imt_02520 w_imt_02520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_frvndcod, s_tovndcod, sempno1, sempno2, sfilter, sgumaeyn, &
        soyjuyn, soyjugayn, syongyn, sGita
long llen

dw_ip.AcceptText()

s_frvndcod = dw_ip.GetItemString(1, "fr_vndcod")
s_tovndcod = dw_ip.GetItemString(1, "to_vndcod")
sempno1	  = dw_ip.GetItemString(1, "empno1")
sempno2	  = dw_ip.GetItemString(1, "empno2")

sgumaeyn  = dw_ip.GetItemString(1,"gumaeyn")
soyjuyn   = dw_ip.GetItemString(1,"oyjuyn")
soyjugayn = dw_ip.GetItemString(1,"oyjugayn")
syongyn   = dw_ip.GetItemString(1,"yongyn")
sGita     = dw_ip.GetItemString(1,"Gita")

IF s_frvndcod = "" OR IsNull(s_frvndcod) THEN 
	s_frvndcod = '.'
END IF
IF s_tovndcod = "" OR IsNull(s_tovndcod) THEN 
	s_tovndcod = 'zzzzzz'
END IF
IF sempno1	  = "" OR IsNull(sempno1) THEN 
	sempno1   = '.'
END IF
IF sempno2	  = "" OR IsNull(sempno2) THEN 
	sempno2   = 'ZZZZZZZZZZZZZZz'
END IF

if s_frvndcod > s_tovndcod then 
	f_message_chk(34,'[거래처]')
	dw_ip.Setcolumn('fr_vndcod')
	dw_ip.SetFocus()
	return -1
end if	

sfilter = ""

IF sgumaeyn  = "Y"  THEN sfilter = sfilter + "gumaeyn = 'Y' or "
IF soyjuyn   = "Y"  THEN sfilter = sfilter + "oyjuyn = 'Y' or "
IF soyjugayn = "Y"  THEN sfilter = sfilter + "oyjugayn = 'Y' or "
IF syongyn   = "Y"  THEN sfilter = sfilter + "yongyn = 'Y' or "
IF sGita     = "Y"  THEN sfilter = sfilter + "cvgu = '9' or "

lLen = len(sfilter)
sfilter = left(sfilter, lLen - 3)

dw_print.SetFilter(sfilter)
dw_print.Filter( )

IF dw_print.Retrieve(s_frvndcod,s_tovndcod, sempno1, sempno2) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('fr_vndcod')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1

end function

on w_imt_02520.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_02520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_imt_02520
integer y = 36
end type

type p_exit from w_standard_print`p_exit within w_imt_02520
integer y = 36
end type

type p_print from w_standard_print`p_print within w_imt_02520
integer y = 36
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_02520
integer y = 36
end type











type dw_print from w_standard_print`dw_print within w_imt_02520
string dataobject = "d_imt_02520_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02520
integer y = 36
integer width = 3209
integer height = 228
string dataobject = "d_imt_02520_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_vndcod' then
	gs_gubun = '1'
	gs_code = this.GetText()
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_vndcod",gs_code)
	this.SetItem(1,"fr_vndnm",gs_codename)
elseif this.GetColumnName() = 'to_vndcod' then
	gs_gubun = '1'
   gs_code = this.GetText()
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_vndcod",gs_code)
	this.SetItem(1,"to_vndnm",gs_codename)
end if	

end event

event dw_ip::itemchanged;string  svndcod, svndnm, svndnm2, s_nam1, s_cod, snull
int     ireturn

setnull(snull)

IF this.GetColumnName() = "fr_vndcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_vndcod", svndcod)	
	this.setitem(1, "fr_vndnm", svndnm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_vndcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_vndcod", svndcod)	
	this.setitem(1, "to_vndnm", svndnm)	
	RETURN ireturn
elseif this.GetColumnName() = "empno1" then
	s_cod = gettext()
	select rfna1 into :s_nam1 
	  from reffpf 
	  where rfcod = '43' and rfgub = :s_cod;
	if sqlca.sqlcode <> 0 then
		Messagebox("구매담당자", "구매담당자가 부정확합니다", stopsign!)		
		setitem(1, "empno1", snull)
	end if	
elseif this.GetColumnName() = "empno2" then
	s_cod = gettext()
	select rfna1 into :s_nam1 
	  from reffpf 
	  where rfcod = '43' and rfgub = :s_cod;
	if sqlca.sqlcode <> 0 then
		Messagebox("구매담당자", "구매담당자가 부정확합니다", stopsign!)		
		setitem(1, "empno2", snull)
	end if		
END IF
end event

type dw_list from w_standard_print`dw_list within w_imt_02520
integer x = 55
integer y = 280
integer width = 4539
integer height = 2040
string dataobject = "d_imt_02520_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_02520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 268
integer width = 4571
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

