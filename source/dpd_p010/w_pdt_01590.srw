$PBExportHeader$w_pdt_01590.srw
$PBExportComments$** MRP 권고 LIST(구매/생산)
forward
global type w_pdt_01590 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01590
end type
end forward

global type w_pdt_01590 from w_standard_print
string title = "MRP 권고 LIST(구매/생산)"
rr_1 rr_1
end type
global w_pdt_01590 w_pdt_01590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_gub, s_fritnbr, s_toitnbr, s_mrplastdate, s_ittyp, smprgu, syymm, stxt
decimal dactno

dw_ip.AcceptText()
s_gub  = dw_ip.GetItemString(1,'gubun')  //구매/생산 구분
dactno  = dw_ip.GetItemdecimal(1,"actno")

IF dactno = 0 OR IsNull(dactno) THEN
	f_message_chk(302,'[실행순번]')
	dw_ip.SetColumn("actno")
	dw_ip.SetFocus()
	Return -1
end if

if s_gub = '2' then  //생산인 경우만
   s_ittyp = dw_ip.GetItemString(1,"ittyp")
   if s_ittyp = '' or isnull(s_ittyp) then
		s_ittyp = '%'
	end if
end if	

s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")

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


  SELECT MRPRUN, MRPGIYYMM, MRPTXT
	 INTO :s_mrplastdate, :SYYMM, :STXT
	 FROM MRPSYS  
	WHERE ( SABU = :gs_sabu ) AND
	      ( ACTNO = :dactno) ;

if sqlca.sqlcode <> 0 then 
	s_mrplastdate = ''
end if

if s_gub = '1' then   //구매인 경우
   dw_print.DataObject ="d_pdt_01590_1_p" 
   dw_print.SetTransObject(SQLCA)

	IF dw_print.Retrieve(gs_sabu,dactno,s_fritnbr,s_toitnbr,s_mrplastdate, '2', SYYMM, STXT) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
else   //생산인 경우
   dw_print.DataObject ="d_pdt_01590_2_p" 
   dw_print.SetTransObject(SQLCA)

	IF dw_print.Retrieve(gs_sabu,dactno,s_ittyp,s_fritnbr,s_toitnbr,s_mrplastdate,  '2', SYYMM, STXT) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
end if	

dw_print.sharedata(dw_list)

return 1

end function

on w_pdt_01590.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_01590
end type

type p_exit from w_standard_print`p_exit within w_pdt_01590
end type

type p_print from w_standard_print`p_print within w_pdt_01590
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01590
end type











type dw_print from w_standard_print`dw_print within w_pdt_01590
string dataobject = "d_pdt_01590_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01590
integer x = 73
integer y = 184
integer width = 4137
integer height = 188
string dataobject = "d_pdt_01590_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Long l_actno
String 	s_yymm, s_mrplastdate, stxt, ssidat, seddat, snull, sgubun

Setnull(snull)

if this.getcolumnname() = 'actno' then
	open(w_mrpsys_popup)
	setitem(1, "actno", double(gs_code))
	
	L_actno = double(gs_code)
	
	Select mrpgiyymm, mrprun, mrptxt, mrpsidat, mrpeddat, mrpdata
	  into :s_yymm, :s_mrplastdate, :stxt, :ssidat, :seddat, :sgubun
	  from mrpsys
	 where sabu = :gs_sabu and actno = :l_actno;
	
	if not isnull(s_yymm) then
		this.setitem(1, "mrpyymm", s_yymm)
		this.setitem(1, "actno",  l_actno)
	else
		this.setitem(1, "mrpyymm", snull)
		this.setitem(1, "actno",  snull)
	end if	
	
elseif this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
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

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, sittyp, snull, sname, s_yymm, sgubun
int     ireturn
long l_actno

setnull(snull)

if this.getcolumnname() = 'actno' then
	
	l_actno = double(gettext())

	Select mrpgiyymm, mrpdata
	  into :s_yymm, :sgubun
	  from mrpsys
	 where sabu = :gs_sabu and actno = :l_actno;
	
	if not isnull(s_yymm) or sgubun = '2' then
		this.setitem(1, "mrpyymm", s_yymm)	
		this.setitem(1, "actno",  l_actno)
	else
		f_message_chk(302,'[실행순번]')		
		this.setitem(1, "mrpyymm", snull)	
		this.setitem(1, "actno",  snull)
		return 1
	end if	
	
elseIF this.GetColumnName() = "ittyp"	THEN
   sittyp = this.GetText()
	
   IF sittyp = "" OR IsNull(sittyp) THEN RETURN
	
	sname = f_get_reffer('05', sittyp)
	if isnull(sname) or sname = "" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   else 
		if sittyp = '1' or sittyp = '2' then
		else
			f_message_chk(62,'[품목구분]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if	
   end if	
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
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

type dw_list from w_standard_print`dw_list within w_pdt_01590
integer x = 82
integer y = 388
integer width = 4517
integer height = 1908
string dataobject = "d_pdt_01590_1"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_01590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 376
integer width = 4535
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

