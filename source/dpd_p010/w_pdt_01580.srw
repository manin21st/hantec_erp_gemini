$PBExportHeader$w_pdt_01580.srw
$PBExportComments$** 계획 ORDER 현황
forward
global type w_pdt_01580 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01580
end type
end forward

global type w_pdt_01580 from w_standard_print
string title = "계획 ORDER 현황"
rr_1 rr_1
end type
global w_pdt_01580 w_pdt_01580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_gub, soutgbn, pdtgu1, pdtgu2, s_fritnbr, s_toitnbr, s_team, s_mrplastdate, s_mrpgiym, stxt
decimal dactno

dw_ip.AcceptText()
soutgbn = dw_ip.GetItemString(1,'outgbn')  
s_gub  = dw_ip.GetItemString(1,'gubun')  //년간/연동 구분
pdtgu1 = dw_ip.GetItemString(1,"pdtgu1")
pdtgu2 = dw_ip.GetItemString(1,"pdtgu2")
s_team = dw_ip.GetItemString(1,"steam")
s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")
dactno  = dw_ip.GetItemdecimal(1,"actno")

IF dactno = 0 OR IsNull(dactno) THEN
	f_message_chk(302,'[실행순번]')
	dw_ip.SetColumn("actno")
	dw_ip.SetFocus()
	Return -1
end if

SELECT MRPRUN, MRPGIYYMM, MRPTXT  
 INTO :s_mrplastdate, :s_mrpgiym, :stxt  
 FROM MRPSYS  
WHERE SABU = :gs_sabu  AND ACTNO = :dactno;

if s_team = '' or isnull(s_team) then
	s_team = '%'
end if

IF s_fritnbr = "" OR IsNull(s_fritnbr) THEN 
	s_fritnbr = '.'
END IF
IF s_toitnbr = "" OR IsNull(s_toitnbr) THEN 
	s_toitnbr = 'zzzzzzzzzzzzzzz'
END IF

if IsNull(pdtgu1) or pdtgu1 = "" then pdtgu1 = "."
if IsNull(pdtgu2) or pdtgu2 = "" then pdtgu2 = "ZZZZZZ"

if soutgbn = "1" then
	pdtgu1 = "."
	pdtgu2 = "ZZZZZZ"
end if	
	
if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[품번]')
	dw_ip.Setcolumn('fr_itnbr')
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(gs_sabu, dactno, s_gub, s_team,s_fritnbr,s_toitnbr, s_mrpgiym, stxt, s_mrplastdate, pdtgu1, pdtgu2) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

 dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_01580.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_01580
end type

type p_exit from w_standard_print`p_exit within w_pdt_01580
end type

type p_print from w_standard_print`p_print within w_pdt_01580
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01580
end type









type gb_10 from w_standard_print`gb_10 within w_pdt_01580
boolean visible = false
integer x = 1701
integer y = 2308
end type

type dw_print from w_standard_print`dw_print within w_pdt_01580
string dataobject = "d_pdt_01580_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01580
integer x = 69
integer y = 188
integer width = 4101
integer height = 268
string dataobject = "d_pdt_01580_a"
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
		this.setitem(1, "gubun", sgubun)
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

event dw_ip::itemchanged;string  soutgbn, sitnbr, sitdsc, sispec, steam, sname, snull, s_yymm, s_gub
int     ireturn
long 		l_actno

setnull(snull)

if this.getcolumnname() = 'gubun' then
	
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
	 
elseIF this.GetColumnName() = "outgbn" THEN
	soutgbn = Trim(this.GetText())
	if soutgbn = "1" then
		dw_list.dataobject  = "d_pdt_01580_2"
	   dw_print.DataObject = "d_pdt_01580_1_p"	
	else
		dw_list.dataobject  = "d_pdt_01580_1"		
		dw_print.DataObject = "d_pdt_01580_2_p"
	end if
	dw_list.SetTransObject(SQLCA)	
	dw_print.SetTransObject(SQLCA)
	
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
elseif this.GetColumnName() = "steam"	THEN
   steam = this.GetText()
	
   IF steam = "" OR IsNull(steam) THEN RETURN
	
	sname = f_get_reffer('05', steam)
	if isnull(sname) or sname = "" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'steam', snull)
		return 1
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

type dw_list from w_standard_print`dw_list within w_pdt_01580
integer x = 87
integer y = 480
integer width = 4503
integer height = 1820
string dataobject = "d_pdt_01580_2"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_01580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 472
integer width = 4535
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

