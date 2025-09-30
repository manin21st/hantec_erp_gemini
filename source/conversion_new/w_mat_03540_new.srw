$PBExportHeader$w_mat_03540_new.srw
forward
global type w_mat_03540_new from w_standard_print
end type
end forward

global type w_mat_03540_new from w_standard_print
integer width = 4658
integer height = 2480
string title = "수불명세서"
end type
global w_mat_03540_new w_mat_03540_new

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	
dw_ip.setitem(1, "to_ispec", sispec)

end subroutine

public function integer wf_retrieve ();String  s_depot, s_fritnbr, s_toitnbr, s_frdate, s_todate, s_yymm, s_maxym, s_gub, s_saupj

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_gub     = dw_ip.GetItemString(1,"gub")
s_depot   = dw_ip.GetItemString(1,"sdepot")
s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")
s_yymm    = trim(dw_ip.GetItemString(1,"fr_yymm"))
s_todate  = trim(dw_ip.GetItemString(1,"to_yymm"))
s_saupj   = trim(dw_ip.GetItemString(1,"saupj"))

IF s_saupj = "" OR IsNull(s_saupj) THEN s_saupj = '%'

IF s_yymm = "" OR IsNull(s_yymm) THEN
   s_frdate = '10000101'
	s_yymm = '100001'
ELSE	
   s_frdate = s_yymm + '01'
END IF

IF s_todate = "" OR IsNull(s_todate) THEN
   s_todate = '99991231'
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
	s_depot = '%'
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

if s_gub = '1' then 
	dw_list.DataObject = "d_mat_03540_1_new"
	dw_print.DataObject = "d_mat_03540_1_p_new"
else
   dw_list.DataObject = "d_mat_03540_2_new"
	dw_print.DataObject = "d_mat_03540_2_p_new"
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

IF dw_print.Retrieve(gs_sabu,s_yymm,s_frdate,s_todate,s_depot,s_fritnbr,s_toitnbr,s_maxym, s_saupj) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_mat_03540_new.create
call super::create
end on

on w_mat_03540_new.destroy
call super::destroy
end on

event open;call super::open;dw_ip.SetItem(1, "fr_yymm", left(f_today(), 6))
dw_ip.SetItem(1, "to_yymm", left(f_today(), 6))
dw_ip.SetColumn("fr_yymm")
dw_ip.Setfocus()
end event

event ue_open;call super::ue_open;////사업장
//f_mod_saupj(dw_ip, 'saupj' )

//입고창고 
f_child_saupj(dw_ip, 'sdepot', '%')
end event

type dw_list from w_standard_print`dw_list within w_mat_03540_new
integer y = 400
integer width = 4531
integer height = 1920
string dataobject = "d_mat_03540_1"
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	dw_list.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type cb_print from w_standard_print`cb_print within w_mat_03540_new
end type

type cb_excel from w_standard_print`cb_excel within w_mat_03540_new
end type

type cb_preview from w_standard_print`cb_preview within w_mat_03540_new
end type

type cb_1 from w_standard_print`cb_1 within w_mat_03540_new
end type

type dw_print from w_standard_print`dw_print within w_mat_03540_new
string dataobject = "d_mat_03540_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03540_new
integer y = 60
integer width = 4527
integer height = 292
string dataobject = "d_mat_03540_a"
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
string  sitnbr, sitdsc, sispec, sdepot, ssaupj
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
ELSEIF this.GetColumnName() = "saupj"	THEN
	sSaupj = trim(this.GetText())
	//입고창고 
	f_child_saupj(dw_ip, 'sdepot', sSaupj)
END IF
end event

type r_1 from w_standard_print`r_1 within w_mat_03540_new
integer y = 392
integer width = 4539
end type

type r_2 from w_standard_print`r_2 within w_mat_03540_new
integer width = 4535
integer height = 304
end type

