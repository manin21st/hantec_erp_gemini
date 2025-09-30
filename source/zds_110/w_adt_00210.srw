$PBExportHeader$w_adt_00210.srw
$PBExportComments$제품수불명세서
forward
global type w_adt_00210 from w_standard_print
end type
type rr_1 from roundrectangle within w_adt_00210
end type
type rr_2 from roundrectangle within w_adt_00210
end type
end forward

global type w_adt_00210 from w_standard_print
string title = "제품수불명세서"
rr_1 rr_1
rr_2 rr_2
end type
global w_adt_00210 w_adt_00210

type variables
dec idMeter
end variables

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

String ls_saupj
String ls_yymm , ls_sdate , ls_edate , ls_depot , ls_itnbr_fr , ls_itnbr_to

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_saupj = Trim(dw_ip.object.saupj[1]) 
ls_yymm  = Trim(dw_ip.object.fr_yymm[1]) 

If f_datechk(ls_yymm+'01') < 1 Then
	f_message_chk(34,'[기준년월]')
	Return -1
End If

ls_sdate = ls_yymm + '01'
ls_edate = ls_yymm + '31'

ls_depot  = Trim(dw_ip.object.sdepot[1])

ls_itnbr_fr = Trim(dw_ip.object.fr_itnbr[1])
ls_itnbr_to = Trim(dw_ip.object.to_itnbr[1])

If ls_itnbr_fr = '' or isNull(ls_itnbr_fr) Then ls_itnbr_fr = '.'
If ls_itnbr_to = '' or isNull(ls_itnbr_to) Then ls_itnbr_to = 'zzzzzzzzzzzzzzzzzzz'

SELECT MAX(JPDAT)  
  INTO :s_maxym
  FROM JUNPYO_CLOSING  
 WHERE SABU = :gs_sabu AND JPGU = 'C0' ;
 
IF s_maxym = '' or isNull( s_maxym) Then s_maxym = '20060101'

IF dw_print.Retrieve(gs_sabu,ls_yymm ,ls_sdate,ls_edate,ls_depot,ls_itnbr_fr,ls_itnbr_to,s_maxym, ls_saupj ) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_adt_00210.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_adt_00210.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, "fr_yymm", left(f_today(), 6))
dw_ip.SetItem(1, "to_yymm", left(f_today(), 6))
dw_ip.SetColumn("fr_yymm")
dw_ip.Setfocus()
end event

event ue_open;call super::ue_open;dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
//사업장
f_mod_saupj(dw_ip, 'saupj' )

//입고창고 
f_child_saupj(dw_ip, 'sdepot', gs_saupj)

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000
end event

type p_xls from w_standard_print`p_xls within w_adt_00210
boolean visible = true
integer x = 4270
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_adt_00210
end type

type p_preview from w_standard_print`p_preview within w_adt_00210
end type

type p_exit from w_standard_print`p_exit within w_adt_00210
end type

type p_print from w_standard_print`p_print within w_adt_00210
boolean visible = false
integer x = 3749
integer y = 188
end type

type p_retrieve from w_standard_print`p_retrieve within w_adt_00210
end type











type dw_print from w_standard_print`dw_print within w_adt_00210
string dataobject = "d_adt_00210_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_adt_00210
integer x = 59
integer y = 36
integer width = 3653
integer height = 292
string dataobject = "d_adt_00210_a"
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
END IF
end event

type dw_list from w_standard_print`dw_list within w_adt_00210
integer x = 46
integer y = 372
integer width = 4562
integer height = 1920
string dataobject = "d_adt_00210_1"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	dw_list.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_adt_00210
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 28
integer width = 3698
integer height = 312
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_adt_00210
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 364
integer width = 4581
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

