$PBExportHeader$w_pdt_01530.srw
$PBExportComments$** ���� ���� ��ȹ ��Ȳ(����)
forward
global type w_pdt_01530 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01530
end type
end forward

global type w_pdt_01530 from w_standard_print
integer height = 2512
string title = "���� ���� ��ȹ ��Ȳ"
rr_1 rr_1
end type
global w_pdt_01530 w_pdt_01530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int     i_seq
String  gubun, s_frTeam,s_toteam, s_yymm, s_fritnbr, s_toitnbr, sLmsgu, ssaupj

IF dw_ip.AcceptText() = -1 THEN RETURN -1
gubun = dw_ip.GetItemString(1,"gubun")
ssaupj = dw_ip.GetItemString(1,"saupj")
s_yymm = TRIM(dw_ip.GetItemString(1,"syymm"))
i_seq  = dw_ip.GetItemNumber(1,"jjcha")

s_frTeam  = dw_ip.GetItemString(1,"fr_team")
s_toTeam  = dw_ip.GetItemString(1,"to_team")

s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")

sLmsgu    = dw_ip.GetItemString(1,"lmsgu")

IF s_yymm = "" OR IsNull(s_yymm) THEN
	f_message_chk(30,'[���س��]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF
IF i_seq = 0 OR IsNull(i_seq) THEN
	f_message_chk(30,'[Ȯ��/����]')
	dw_ip.SetColumn("jjcha")
	dw_ip.SetFocus()
	Return -1
END IF

IF s_frteam = "" OR IsNull(s_frteam) THEN 
	s_frteam = '.'
END IF
IF s_toteam = "" OR IsNull(s_toteam) THEN 
	s_toteam = 'zzzzzz'
END IF

if s_frteam > s_toteam then 
	f_message_chk(34,'[������]')
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
	f_message_chk(34,'[ǰ��]')
	dw_ip.Setcolumn('fr_itnbr')
	dw_ip.SetFocus()
	return -1
end if	

dw_print.SetFilter("")
if gubun = "2" then
   dw_print.SetFilter("totmon > 0")
end if	
dw_print.Filter( )

IF dw_print.Retrieve(gs_sabu,s_yymm,i_seq,s_frteam,s_toteam,s_fritnbr, s_toitnbr,  slmsgu, ssaupj) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
  
  dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_01530.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;

/* �ΰ� ����� */
setnull(gs_code)
dw_ip.Reset()
dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'fr_team', gs_saupj)
f_child_saupj(dw_ip, 'to_team', gs_saupj)

dw_ip.SetItem(1, "syymm", left(is_today,6))
dw_ip.SetColumn("syymm")
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_pdt_01530
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_pdt_01530
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_pdt_01530
integer x = 4256
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01530
integer x = 3909
end type











type dw_print from w_standard_print`dw_print within w_pdt_01530
integer x = 4224
integer y = 172
string dataobject = "d_pdt_01530_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01530
integer x = 32
integer y = 12
integer width = 3799
integer height = 320
string dataobject = "d_pdt_01530_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
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

event dw_ip::itemchanged;string snull, syymm

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	
	if syymm = "" or isnull(syymm) then	return 

  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[���س��]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'saupj' then
	f_child_saupj(dw_ip, 'fr_team', gettext())	
	f_child_saupj(dw_ip, 'to_team', gettext())
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_01530
integer y = 348
integer width = 4544
integer height = 1944
string dataobject = "d_pdt_01530_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_01530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 332
integer width = 4562
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

