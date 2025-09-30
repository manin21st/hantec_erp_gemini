$PBExportHeader$w_pdt_01610.srw
$PBExportComments$** 발주 예정 현황
forward
global type w_pdt_01610 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01610
end type
end forward

global type w_pdt_01610 from w_standard_print
string title = "발주 예정 현황"
rr_1 rr_1
end type
global w_pdt_01610 w_pdt_01610

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_gub,s_gub2,s_gub3,s_fritnbr,s_toitnbr,s_frcvcod,s_tocvcod,s_gu1, s_gu2, s_gu3, s_gu4
dec dactno

dw_ip.AcceptText()
s_gub   = dw_ip.GetItemString(1,'gubun')   //계획구분
s_gub2  = dw_ip.GetItemString(1,'gubun2')  //출력구분
s_gub3  = dw_ip.GetItemString(1,'gubun3')  //수입구분
dactno  = dw_ip.GetItemdecimal(1,"actno")

IF dactno = 0 OR IsNull(dactno) THEN
	f_message_chk(302,'[실행순번]')
	dw_ip.SetColumn("actno")
	dw_ip.SetFocus()
	Return -1
end if

IF s_gub3 = '1' then   //수입구분이 '1'(내자)이면 구입형태가 '1','2'인것 
	s_gu1 = '1'   
	s_gu2 = '1'
	s_gu3 = '2'   
	s_gu4 = '2'	
ELSeif s_gub3 = '2' then //외자
	s_gu1 = '3'   
	s_gu2 = '3'
	s_gu3 = '4'   
	s_gu4 = '4'	
else // ALL
	s_gu1 = '1'   
	s_gu2 = '2'
	s_gu3 = '3'   
	s_gu4 = '4'		
END IF	

if s_gub2 = '1' then  //출력구분이 품목인 경우만
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
   dw_print.DataObject ="d_pdt_01610_1_p" 
   dw_print.SetTransObject(SQLCA)

	IF dw_print.Retrieve(gs_sabu,dactno,s_gub,s_fritnbr,s_toitnbr,s_gu1, s_gu2, s_gu3, s_gu4, gs_saupcd) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
else   //출력구분이 거래처인 경우
	s_frcvcod = dw_ip.GetItemString(1,"fr_cvcod")
	s_tocvcod = dw_ip.GetItemString(1,"to_cvcod")
	IF s_frcvcod = "" OR IsNull(s_frcvcod) THEN 
		s_frcvcod = '.'
	END IF
	IF s_tocvcod = "" OR IsNull(s_tocvcod) THEN 
		s_tocvcod = 'zzzzzz'
	END IF
	if s_frcvcod > s_tocvcod then 
		f_message_chk(34,'[거래처]')
		dw_ip.Setcolumn('fr_cvcod')
		dw_ip.SetFocus()
		return -1
	end if	
   dw_print.DataObject ="d_pdt_01610_2_p" 
   dw_print.SetTransObject(SQLCA)

	IF dw_print.Retrieve(gs_sabu,dactno,s_gub,s_frcvcod,s_tocvcod,s_gu1, s_gu2, s_gu3, s_gu4, gs_saupcd) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
end if	
      dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_01610.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_01610
end type

type p_exit from w_standard_print`p_exit within w_pdt_01610
end type

type p_print from w_standard_print`p_print within w_pdt_01610
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01610
end type











type dw_print from w_standard_print`dw_print within w_pdt_01610
string dataobject = "d_pdt_01610_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01610
integer x = 69
integer y = 188
integer width = 4142
integer height = 252
string dataobject = "d_pdt_01610_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
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
	
ElseIF this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "fr_cvcod" THEN
   gs_gubun = '1'	
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "fr_cvcod", gs_Code)
	this.SetItem(1, "fr_cvnm", gs_Codename)
ELSEIF this.GetColumnName() = "to_cvcod" THEN
   gs_gubun = '1'	
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "to_cvcod", gs_Code)
	this.SetItem(1, "to_cvnm", gs_Codename)
END IF

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

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, scvcod, s_yymm, snull, s_gub
int     ireturn
long l_actno

SEtnull(snull)

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
	
elseIF this.GetColumnName() = "fr_itnbr"	THEN
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
ELSEIF this.GetColumnName() = "fr_cvcod"	THEN
	scvcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_cvcod", scvcod)	
	this.setitem(1, "fr_cvnm", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_cvcod"	THEN
	scvcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_cvcod", scvcod)	
	this.setitem(1, "to_cvnm", sitdsc)	
	RETURN ireturn
END IF
end event

type dw_list from w_standard_print`dw_list within w_pdt_01610
integer x = 82
integer y = 476
integer width = 4507
integer height = 1824
string dataobject = "d_pdt_01610_1"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_01610
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 468
integer width = 4535
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

