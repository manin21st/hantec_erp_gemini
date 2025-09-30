$PBExportHeader$w_pdt_00310.srw
$PBExportComments$** 월 외주생산계획현황
forward
global type w_pdt_00310 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_00310
end type
end forward

global type w_pdt_00310 from w_standard_print
string title = "월 외주 생산 계획 현황"
rr_1 rr_1
end type
global w_pdt_00310 w_pdt_00310

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int     i_seq, i_plym
String  gubun, s_frTeam,s_toteam, s_yymm, s_fritnbr, s_toitnbr, s_plym, s_lastday, &
        ssaupj

if dw_ip.AcceptText() = -1 then return -1

gubun = dw_ip.GetItemString(1,"gubun")
s_yymm = dw_ip.GetItemString(1,"syymm")
i_seq  = dw_ip.GetItemNumber(1,"jjcha")

ssaupj = dw_ip.GetItemString(1,"saupj")

i_plym  = dw_ip.GetItemNumber(1,'planym')  //계획년월

s_frTeam  = dw_ip.GetItemString(1,"fr_team")
s_toTeam  = dw_ip.GetItemString(1,"to_team")

s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")

IF s_yymm = "" OR IsNull(s_yymm) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF
IF i_seq = 0 OR IsNull(i_seq) THEN
	f_message_chk(30,'[확정/조정]')
	dw_ip.SetColumn("jjcha")
	dw_ip.SetFocus()
	Return -1
END IF
if isnull(i_plym) then
	f_message_chk(30,'[계획년월]')
	dw_ip.Setcolumn('planym')
	dw_ip.SetFocus()
	return -1
else
	s_plym = f_aftermonth(s_yymm, i_plym)    //기준년월에 계획년월을 더하여 실제 계획년월을...
	s_lastday = right(f_last_date(s_plym), 2)//계획년월에 마지막일자를 가져오기 
end if	

IF s_frteam = "" OR IsNull(s_frteam) THEN 
	s_frteam = '.'
END IF
IF s_toteam = "" OR IsNull(s_toteam) THEN 
	s_toteam = 'zzzzzz'
END IF

if s_frteam > s_toteam then 
	f_message_chk(34,'[거래처]')
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

dw_print.SetFilter("")
if gubun = "2" then
   dw_print.SetFilter("totday > 0")
end if	
dw_print.Filter( )

IF dw_print.Retrieve(gs_sabu, s_yymm,   i_seq,     s_plym,   s_lastday, &
                    s_frteam, s_toteam, s_fritnbr, s_toitnbr, ssaupj) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
   
	dw_print.sharedata(dw_list)
	

return 1

end function

on w_pdt_00310.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_00310.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, "syymm", left(is_today,6))

if f_check_saupj() = 1 then
	dw_ip.setitem(1, "saupj", gs_code)
End if

/* 부가 사업장 */
setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'saupj', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("saupj.protect=1")
//		dw_ip.Modify("saupj.background.color = 80859087")
//	End if
//End If

f_mod_saupj(dw_ip, 'saupj' )

dw_ip.SetColumn("syymm")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_00310
end type

type p_exit from w_standard_print`p_exit within w_pdt_00310
end type

type p_print from w_standard_print`p_print within w_pdt_00310
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_00310
end type











type dw_print from w_standard_print`dw_print within w_pdt_00310
integer x = 4064
integer y = 176
integer height = 96
string dataobject = "d_pdt_00310_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_00310
integer x = 69
integer y = 28
integer width = 3845
integer height = 240
string dataobject = "d_pdt_00310_a"
end type

event dw_ip::itemerror;
Return 1
end event

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
elseif this.GetColumnName() = 'fr_team' then
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_team",gs_code)	
elseif this.GetColumnName() = 'to_team' then
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_team",gs_code)		
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
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_00310
integer x = 87
integer y = 296
integer width = 4507
integer height = 2008
string dataobject = "d_pdt_00310_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_00310
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 288
integer width = 4530
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

