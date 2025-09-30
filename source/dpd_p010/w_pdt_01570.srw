$PBExportHeader$w_pdt_01570.srw
$PBExportComments$** 자재 소요량 계획서
forward
global type w_pdt_01570 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01570
end type
end forward

global type w_pdt_01570 from w_standard_print
string title = "자재 소요량 계획서"
rr_1 rr_1
end type
global w_pdt_01570 w_pdt_01570

type variables


end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_gub, s_fritnbr, s_toitnbr, s_mrplastdate, s_mrpgiym, stxt, sdatagu, sgbn
decimal dactno

dw_ip.AcceptText()
s_gub  = dw_ip.GetItemString(1,'plangu')  //계획구분

s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")
sdatagu   = dw_ip.GetItemString(1,"datagu")
sgbn	    = dw_ip.GetItemString(1,"gubun")
dactno  = dw_ip.GetItemdecimal(1,"actno")

IF dactno = 0 OR IsNull(dactno) THEN
	f_message_chk(302,'[실행순번]')
	dw_ip.SetColumn("actno")
	dw_ip.SetFocus()
	Return -1
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

 SELECT MRPRUN, MRPGIYYMM, MRPTXT  
   INTO :s_mrplastdate, :s_mrpgiym, :stxt  
	FROM MRPSYS  
  WHERE ( SABU = :gs_sabu ) AND ( MRPDATA = :s_gub ) AND
	     ( ACTNO = :dActno);

if sqlca.sqlcode <> 0 then 
	s_mrplastdate = ''
	s_mrpgiym = ''
end if

IF dw_print.Retrieve(gs_sabu,dactno,s_gub,s_fritnbr,s_toitnbr,s_mrplastdate,s_mrpgiym, stxt) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

if sdatagu = '1' then // 상세인 경우에만 실행
	dw_list.setsort("mrpdtl_cinbr A, mrpdtl_mprdu A")
	dw_list.sort()
Else
	if sgbn = '2' then	
		dw_list.setfilter("tosoyqty > 0 or sacaqty > 0")
		dw_list.filter()
	End if
End if

dw_print.sharedata(dw_list)	
dw_list.accepttext()

return 1

end function

on w_pdt_01570.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_01570
integer x = 4091
end type

type p_exit from w_standard_print`p_exit within w_pdt_01570
integer x = 4439
end type

type p_print from w_standard_print`p_print within w_pdt_01570
integer x = 4265
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01570
integer x = 3918
end type











type dw_print from w_standard_print`dw_print within w_pdt_01570
integer x = 3982
integer y = 192
string dataobject = "d_pdt_01570_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01570
integer x = 14
integer y = 28
integer width = 3826
integer height = 208
string dataobject = "d_pdt_01570_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

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
		this.setitem(1, "plangu", sgubun)
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

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, s_gub, snull, s_yymm
int     ireturn
long 		l_actno

SEtnull(snull)

this.accepttext()

if this.getcolumnname() = 'plangu' then
	
	  s_gub = this.gettext()
	    
	  SELECT MAX("MRPSYS"."ACTNO")
		 INTO :l_actno
		 FROM "MRPSYS"  
		WHERE ( "MRPSYS"."SABU" = :gs_sabu ) AND  
				( "MRPSYS"."MRPDATA" = :s_gub )   ;
				
	Select mrpgiyymm
	  into :s_yymm
	  from mrpsys
	 where sabu = :gs_sabu and actno = :l_actno;
	
	if not isnull(s_yymm) then
		this.setitem(1, "mrpyymm", s_yymm)	
		this.setitem(1, "actno",  l_actno)
	else
		f_message_chk(302,'[실행순번]')		
		this.setitem(1, "mrpyymm", snull)	
		this.setitem(1, "actno",  snull)
		return 1
	end if					

elseif this.getcolumnname() = 'actno' then
	
	l_actno = double(gettext())

	Select mrpgiyymm
	  into :s_yymm
	  from mrpsys
	 where sabu = :gs_sabu and actno = :l_actno;
	
	if not isnull(s_yymm) then
		this.setitem(1, "mrpyymm", s_yymm)	
		this.setitem(1, "actno",  l_actno)
	else
		f_message_chk(302,'[실행순번]')		
		this.setitem(1, "mrpyymm", snull)	
		this.setitem(1, "actno",  snull)
		return 1
	end if	
	
elseIF this.GetColumnName() = "fr_itnbr"	THEN
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
ELSEIF this.getcolumnname() = "gubun" then
	sItnbr = trim(this.GetText())
	if getitemstring(1, "datagu") = '1' then
		if sItnbr = '1' then
			dw_list.dataobject = 'd_pdt_01570_1'
		else
			dw_list.dataobject = 'd_pdt_01570_2'
		end if
	else
		dw_list.dataobject = 'd_pdt_01570_3'		
	end if
	dw_list.settransobject(sqlca)
	dw_list.setfilter("")
	dw_list.filter()

ELSEIF this.getcolumnname() = "datagu" then
	sItnbr = trim(this.GetText())
	if sitnbr = '1' then
		if getitemstring(1, "gubun") = '1' then
			dw_list.dataobject = 'd_pdt_01570_1'
			dw_print.dataobject = 'd_pdt_01570_1_p'
		else
			dw_list.dataobject = 'd_pdt_01570_2'
			dw_print.dataobject = 'd_pdt_01570_2_p'
		end if
	else
		dw_list.dataobject = 'd_pdt_01570_3'		
		dw_print.dataobject = 'd_pdt_01570_3_p'
	end if
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	dw_list.setfilter("")
	dw_list.filter()	
	
END IF


end event

event dw_ip::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

type dw_list from w_standard_print`dw_list within w_pdt_01570
integer x = 32
integer y = 248
integer width = 4562
integer height = 2072
string dataobject = "d_pdt_01570_1"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_01570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 240
integer width = 4585
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

