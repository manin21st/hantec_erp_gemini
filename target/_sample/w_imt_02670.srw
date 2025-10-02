$PBExportHeader$w_imt_02670.srw
$PBExportComments$** 원가 변동 현황
forward
global type w_imt_02670 from w_standard_print
end type
end forward

global type w_imt_02670 from w_standard_print
string title = "원가 변동 현황"
end type
global w_imt_02670 w_imt_02670

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_year, s_frdate, s_todate, s_fitnbr, s_titnbr, s_fcvcod, s_tcvcod, SNULL, &
		 sitcls1, sitcls2, sempno, sitgu
long lcha

if dw_ip.AcceptText() = -1 then return -1

setnull(snull)

s_year	= trim(dw_ip.GetItemString(1, "arg_year"))
s_fitnbr = trim(dw_ip.GetItemString(1, "arg_fitnbr"))
s_titnbr = trim(dw_ip.GetItemString(1, "arg_titnbr"))
s_fcvcod = trim(dw_ip.GetItemString(1, "fcvcod"))
s_tcvcod = trim(dw_ip.GetItemString(1, "tcvcod"))
sitcls1 = trim(dw_ip.GetItemString(1, "arg_itcls1"))
sitcls2 = trim(dw_ip.GetItemString(1, "arg_itcls2"))
sempno  = trim(dw_ip.GetItemString(1, "arg_empno1"))
sitgu   = trim(dw_ip.GetItemString(1, "arg_itgu1"))

IF s_year = "" OR IsNull(s_year) THEN 
	f_message_chk(30,'[기준년도]')
	dw_ip.Setcolumn('arg_year')
	dw_ip.SetFocus()
	return -1
END IF

IF s_fitnbr = "" OR IsNull(s_fitnbr) THEN 
	s_fitnbr = '.'
END IF
IF s_titnbr = "" OR IsNull(s_titnbr) THEN 
	s_titnbr = 'zzzzzzzzzzzzzzz'
END IF

IF s_fcvcod = "" OR IsNull(s_fcvcod) THEN 
	s_fcvcod = '.'
END IF
IF s_tcvcod = "" OR IsNull(s_tcvcod) THEN 
	s_tcvcod = 'zzzzzz'
END IF
IF sitcls1 = "" OR IsNull(sitcls1) THEN sitcls1 = '.'
IF sitcls2 = "" OR IsNull(sitcls2) THEN sitcls2 = 'zzzzzz'
IF sempno  = "" OR IsNull(sempno)  THEN sempno  = '%'
IF sitgu   = "" OR IsNull(sitgu)   THEN sitgu   = '%'

s_frdate = s_year + '0101'
s_todate = s_year + '1231'

/* 당해년도 계획차수 */
//select max(mtrqty) into :lcha
//  from yeapln_mtr
// where sabu = :gs_sabu and mtryymm like :s_year||'%';


IF dw_print.Retrieve(gs_sabu, s_frdate,s_todate, s_year, lcha, s_fitnbr, s_titnbr, &
                    s_fcvcod, s_tcvcod, sitcls1, sitcls2, sempno, sitgu) < 1 THEN
	f_message_chk(50,'')
//	dw_ip.Setcolumn('fr_date')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1

end function

on w_imt_02670.create
call super::create
end on

on w_imt_02670.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1, 'arg_year', left(f_today(), 4))
dw_ip.Setfocus()


end event

type dw_list from w_standard_print`dw_list within w_imt_02670
integer y = 484
integer width = 3489
integer height = 1964
string dataobject = "d_imt_02670_1"
end type

type cb_print from w_standard_print`cb_print within w_imt_02670
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02670
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02670
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02670
end type

type dw_print from w_standard_print`dw_print within w_imt_02670
string dataobject = "d_imt_02670_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02670
integer y = 56
integer width = 3489
integer height = 388
string dataobject = "d_imt_02670_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string  snull, svndcod, svndnm, svndnm2 
int     ireturn 
setnull(snull)

IF this.GetColumnName() = "fcvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "fcvcod", svndcod)	
	this.setitem(1, "fcvnas", svndnm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "tcvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "tcvcod", svndcod)	
	this.setitem(1, "tcvnas", svndnm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "arg_gub"	THEN
	svndcod = trim(this.GetText())
	
	if svndcod = '1' then 
		dw_list.DataObject = 'd_imt_02670_1'
		dw_print.DataObject = 'd_imt_02670_1_p'
	else
		dw_list.DataObject = 'd_imt_02670_2'
		dw_print.DataObject = 'd_imt_02670_2_p'
	end if	
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	
ELSEIF this.GetColumnName() = "arg_fitnbr"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "arg_fitnbr", svndcod)	
	this.setitem(1, "arg_fitdsc", svndnm)	
	RETURN ireturn	
ELSEIF this.GetColumnName() = "arg_titnbr"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "arg_titnbr", svndcod)	
	this.setitem(1, "arg_titdsc", svndnm)	
	RETURN ireturn		
ELSEIF this.GetColumnName() = "arg_fitdsc"	THEN
	svndnm = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "arg_fitnbr", svndcod)	
	this.setitem(1, "arg_fitdsc", svndnm)	
	RETURN ireturn		
ELSEIF this.GetColumnName() = "arg_titdsc"	THEN
	svndnm = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "arg_titnbr", svndcod)	
	this.setitem(1, "arg_titdsc", svndnm)	
	RETURN ireturn			
ELSEIF this.GetColumnName() = "arg_empno1"	THEN
	svndcod = trim(this.GetText())
	select rfna1 into :svndnm from reffpf where rfcod = '43' and rfgub = :svndcod;
	if sqlca.sqlcode <> 0 then
		this.setitem(1, "arg_empno1", snull)
		return 1
	end if
ELSEIF this.GetColumnName() = "arg_itgu1"	THEN
	svndcod = trim(this.GetText())
	select rfna1 into :svndnm from reffpf where rfcod = '03' and rfgub = :svndcod;
	if sqlca.sqlcode <> 0 then
		this.setitem(1, "arg_itgu1", snull)
		return 1
	end if	
END IF
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fcvcod' then
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fcvcod",gs_code)
	this.SetItem(1,"fcvnas",gs_codename)
elseif this.GetColumnName() = 'tcvcod' then
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"tcvcod",gs_code)
	this.SetItem(1,"tcvnas",gs_codename)
elseif this.GetColumnName() = 'arg_fitnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"arg_fitnbr",gs_code)
elseif this.GetColumnName() = 'arg_titnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"arg_titnbr",gs_code)
elseif this.GetColumnName() = 'arg_itcls1' then
	open(w_itnct_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"arg_itcls1",gs_code)	
elseif this.GetColumnName() = 'arg_itcls2' then
	open(w_itnct_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"arg_itcls2",gs_code)		
end if	

end event

type r_1 from w_standard_print`r_1 within w_imt_02670
integer y = 480
end type

type r_2 from w_standard_print`r_2 within w_imt_02670
integer height = 396
end type

