$PBExportHeader$w_pdt_01510.srw
$PBExportComments$** 년간 생산 계획 대 실적 현황
forward
global type w_pdt_01510 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01510
end type
end forward

global type w_pdt_01510 from w_standard_print
string title = "년간 생산 계획 대 실적 현황"
rr_1 rr_1
end type
global w_pdt_01510 w_pdt_01510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int     i_seq
String  s_frTeam,s_toteam, s_year, s_fritnbr, s_toitnbr, s_year2, s_gub, ssaupj

dw_ip.AcceptText()
s_year = dw_ip.GetItemString(1,"syear")
ssaupj = dw_ip.GetItemString(1,"saupj")
s_gub = dw_ip.GetItemString(1,"gijun")

s_frTeam  = dw_ip.GetItemString(1,"fr_team")
s_toTeam  = dw_ip.GetItemString(1,"to_team")

s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")

IF s_year = "" OR IsNull(s_year) THEN
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("syear")
	dw_ip.SetFocus()
	Return -1
ELSE
   //마지막 차수 가져오기 (마지막 차수가 계획 마지막)
	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :i_seq  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" LIKE :s_year||'%' )   ;
	
	s_year2 = s_year + '%'
END IF
IF i_seq = 0 OR IsNull(i_seq) THEN
	f_message_chk(30,'[기준년도 차수]')
	dw_ip.SetFocus()
	Return -1
END IF

IF s_gub = '1' THEN
   dw_print.DataObject ="d_pdt_01510_1_p" 
   dw_list.DataObject ="d_pdt_01510_1" 
	dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
ELSE
   dw_print.DataObject ="d_pdt_01510_2_p" 
   dw_list.DataObject ="d_pdt_01510_2" 
	dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
END IF

IF s_frteam = "" OR IsNull(s_frteam) THEN 
	s_frteam = '.'
END IF
IF s_toteam = "" OR IsNull(s_toteam) THEN 
	s_toteam = 'zzzzzz'
END IF

if s_frteam > s_toteam then 
	f_message_chk(34,'[생산팀]')
	dw_ip.Setcolumn('fr_team')
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

IF dw_print.Retrieve(gs_sabu,s_year,s_year2,i_seq,s_frteam,s_toteam,s_fritnbr, s_toitnbr, ssaupj) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

   dw_print.sharedata(dw_list)
  
return 1

end function

on w_pdt_01510.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string s_nextyear

s_nextyear = string(long(left(f_today(), 4)) + 1)

f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'fr_team', gs_saupj)
f_child_saupj(dw_ip, 'to_team', gs_saupj)
dw_ip.setitem(1, 'syear', s_nextyear)
dw_ip.SetColumn("syear")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_01510
end type

type p_exit from w_standard_print`p_exit within w_pdt_01510
end type

type p_print from w_standard_print`p_print within w_pdt_01510
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01510
end type











type dw_print from w_standard_print`dw_print within w_pdt_01510
string dataobject = "d_pdt_01510_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01510
integer x = 73
integer y = 32
integer width = 2894
integer height = 184
string dataobject = "d_pdt_01510_a"
end type

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	
elseif getcolumnname() = 'saupj' then
	f_child_saupj(this, 'fr_team', gettext())
	f_child_saupj(this, 'to_team', gettext())
end if	

end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "fr_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"fr_itnbr",gs_code)
			RETURN 1
		ELSEIF This.GetColumnName() = "to_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"to_itnbr",gs_code)
			RETURN 1
      End If
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_01510
integer x = 91
integer y = 248
integer width = 4503
integer height = 2052
string dataobject = "d_pdt_01510_1"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_01510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 240
integer width = 4530
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

