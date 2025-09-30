$PBExportHeader$w_mm90_00050.srw
$PBExportComments$수불 명세서
forward
global type w_mm90_00050 from w_standard_print
end type
type rr_1 from roundrectangle within w_mm90_00050
end type
type rr_2 from roundrectangle within w_mm90_00050
end type
end forward

global type w_mm90_00050 from w_standard_print
string title = "수불명세서"
rr_1 rr_1
rr_2 rr_2
end type
global w_mm90_00050 w_mm90_00050

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	
dw_ip.setitem(1, "to_ispec", sispec)

end subroutine

public function integer wf_retrieve ();String  s_depot, s_fritnbr, s_toitnbr, s_frdate, s_todate, s_yymm, s_maxym, s_gub

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_depot   = dw_ip.GetItemString(1,"sdepot")
s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")
s_yymm    = trim(dw_ip.GetItemString(1,"fr_yymm"))
s_todate  = trim(dw_ip.GetItemString(1,"to_yymm"))

IF s_yymm = "" OR IsNull(s_yymm) or f_datechk(s_yymm+'01') < 1 THEN
   f_messagechk(35,'[기준년월]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("fr_yymm")
ELSE	
   s_frdate = s_yymm + '01'
END IF

IF s_todate = "" OR IsNull(s_todate) or f_datechk(s_todate+'01') < 1 THEN
   f_messagechk(35,'[기준년월]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("to_yymm")
ELSE	
   s_todate = s_todate + '31'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[기준년월]')
	dw_ip.Setcolumn('fr_yymm')
	dw_ip.SetFocus()
	return -1
end if	

if s_depot = '' or isnull(s_depot) then
	f_message_chk(1400,'[수불 대상 창고]')
	dw_ip.Setcolumn('sdepot')
	dw_ip.SetFocus()
	return -1
end if

IF s_fritnbr = "" OR IsNull(s_fritnbr) THEN 
	s_fritnbr = '.'
END IF
IF s_toitnbr = "" OR IsNull(s_toitnbr) THEN 
	s_toitnbr = 'zzzzzzzzzzzzzzz'
END IF

if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[품번]')
	dw_ip.Setcolumn('fr_itnbr')
	dw_ip.SetFocus()
	return -1
end if	

SELECT MAX(JPDAT)  
  INTO :s_maxym
  FROM JUNPYO_CLOSING  
 WHERE SABU = :gs_sabu AND JPGU = 'C0' ;


IF dw_list.Retrieve(gs_sabu,s_yymm,s_frdate,s_todate,s_depot,s_fritnbr,s_toitnbr,s_maxym) < 1 THEN
	f_message_chk(50 , '')
	dw_list.Reset()
	Return -1
END IF


return 1

end function

on w_mm90_00050.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_mm90_00050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, "fr_yymm", left(f_today(), 6))
dw_ip.SetItem(1, "to_yymm", left(f_today(), 6))
dw_ip.SetColumn("fr_yymm")
dw_ip.Setfocus()

/* MRO 부서인 경우 */
string sdepot

/* 소모품은 juprod = '5' - by shingoon 2008.01.08 */
/*
select cvcod into :sdepot from vndmst
 where cvgu = '5' and juprod = 'Z' and deptcode in ( Select deptcode  from p1_master where empno = :gs_empno ) and rownum = 1;
*/
//select cvcod into :sdepot from vndmst
// where cvgu = '5' and juprod = '5' and deptcode in ( Select deptcode  from p1_master where empno = :gs_empno ) and rownum = 1; 
 SELECT CVCOD
  INTO :sdepot
  FROM VNDMST
 WHERE CVGU = '5'
   AND JUMAECHUL = '9';

if sqlca.sqlcode = 0 then
	dw_ip.setitem(1,'sdepot',sdepot)
end if

end event

type p_xls from w_standard_print`p_xls within w_mm90_00050
end type

type p_sort from w_standard_print`p_sort within w_mm90_00050
end type

type p_preview from w_standard_print`p_preview within w_mm90_00050
end type

type p_exit from w_standard_print`p_exit within w_mm90_00050
end type

type p_print from w_standard_print`p_print within w_mm90_00050
end type

type p_retrieve from w_standard_print`p_retrieve within w_mm90_00050
end type











type dw_print from w_standard_print`dw_print within w_mm90_00050
string dataobject = "d_mm90_00050_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mm90_00050
integer x = 101
integer y = 60
integer width = 2825
integer height = 204
integer taborder = 1
string dataobject = "d_mm90_00050_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
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

event dw_ip::itemchanged;string snull, sdate
string  sitnbr, sitdsc, sispec, sdepot
int     ireturn

setnull(snull)

IF this.GetColumnName() ="fr_yymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월 FROM]')
		this.setitem(1, "fr_yymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() ="to_yymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월 TO]')
		this.setitem(1, "to_yymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
//ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
//	sItdsc = trim(this.GetText())
//	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
//	this.setitem(1, "fr_itnbr", sitnbr)	
//	this.setitem(1, "fr_itdsc", sitdsc)	
//	this.setitem(1, "fr_ispec", sispec)
//	wf_move(sitnbr, sitdsc, sispec)
//	RETURN ireturn
//ELSEIF this.GetColumnName() = "fr_ispec"	THEN
//	sIspec = trim(this.GetText())
//	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
//	this.setitem(1, "fr_itnbr", sitnbr)	
//	this.setitem(1, "fr_itdsc", sitdsc)	
//	this.setitem(1, "fr_ispec", sispec)
//	wf_move(sitnbr, sitdsc, sispec)
//	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
//ELSEIF this.GetColumnName() = "to_itdsc"	THEN
//	sItdsc = trim(this.GetText())
//	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
//	this.setitem(1, "to_itnbr", sitnbr)	
//	this.setitem(1, "to_itdsc", sitdsc)	
//	this.setitem(1, "to_ispec", sispec)
//	RETURN ireturn
//ELSEIF this.GetColumnName() = "to_ispec"	THEN
//	sIspec = trim(this.GetText())
//	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
//	this.setitem(1, "to_itnbr", sitnbr)	
//	this.setitem(1, "to_itdsc", sitdsc)	
//	this.setitem(1, "to_ispec", sispec)
//	RETURN ireturn
END IF
end event

type dw_list from w_standard_print`dw_list within w_mm90_00050
integer x = 46
integer y = 296
integer width = 4562
integer height = 1960
string dataobject = "d_mm90_00050_a"
boolean border = false
end type

type rr_1 from roundrectangle within w_mm90_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 52
integer width = 2939
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mm90_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 288
integer width = 4581
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

