$PBExportHeader$w_pdt_01550.srw
$PBExportComments$** 월 생산계획 대 실적현황
forward
global type w_pdt_01550 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01550
end type
end forward

global type w_pdt_01550 from w_standard_print
string title = "월 생산계획 대 실적현황"
rr_1 rr_1
end type
global w_pdt_01550 w_pdt_01550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int     i_seq, imm
String  s_frTeam,s_toteam, s_yymm, s_b2ym, s_year, s_byear, sLmsgu, ssaupj

if dw_ip.AcceptText() = -1 then return -1
s_yymm = trim(dw_ip.GetItemString(1,"syymm"))

s_frTeam  = dw_ip.GetItemString(1,"fr_team")
s_toTeam  = dw_ip.GetItemString(1,"to_team")
sLmsgu    = dw_ip.GetItemString(1,"lmsgu")
ssaupj    = dw_ip.GetItemString(1,"saupj")
IF s_yymm = "" OR IsNull(s_yymm) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
ELSE
	s_b2ym  = f_aftermonth(s_yymm, -2)     // -2개월 평균판매량
	s_year  = left(s_yymm, 4)             
	s_byear = string(integer(s_year) - 1) 
	imm = integer(mid(s_yymm, 5, 2))
	if imm = 0 or isnull(imm) then imm = 1 
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

SELECT MAX("YEAPLN"."YEACHA")  
  INTO :i_seq 
  FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( substr("YEAPLN"."YEAYYMM", 1, 4) = :s_year )   ;

if i_seq = 0 or isnull(i_seq) then i_seq = 1 
//수량이나 금액이 없으면 조회되지 않게 함....
string DWfilter
DWfilter = "bqty <> 0 or cqty <> 0 or camt <> 0 or dqty <> 0 or damt <> 0 or eqty <> 0 or " &
         + "eamt <> 0 or fqty <> 0 or famt <> 0 or dmqty <> 0  or dmamt <> 0 or " &
	   	+ "fmqty <> 0 or fmamt <> 0 or gqty <> 0 or gamt <> 0 or gqty1 <> 0 or gamt1 <> 0 " 
dw_list.SetFilter(DWfilter)
dw_list.Filter( )

string ls_silgu
ls_silgu = f_get_syscnfg('S', 8, '40')

IF dw_print.Retrieve(gs_sabu,s_frteam,s_toteam,s_yymm,s_b2ym,s_year,s_byear,i_seq, sLmsgu, imm, ssaupj, ls_silgu) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
	
dw_print.sharedata(dw_list)

IF  sLmsgu = 'L' THEN
	dw_list.object.jname_t.text = '대분류'
ELSEIF  sLmsgu = 'M' THEN
	dw_list.object.jname_t.text = '중분류'
ELSE
	dw_list.object.jname_t.text = '소분류'
END IF

dw_list.object.month1_t.text = s_year + '.' + right(s_yymm, 2) 
dw_list.object.month2_t.text = s_year  + '년 '  + right( s_yymm ,2) + '월 누계'
dw_list.object.month3_t.text = s_year  + '년 '  + right( s_yymm ,2) + '월'

return 1

end function

on w_pdt_01550.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;
dw_ip.SetItem(1, "syymm", left(is_today,6))

/* 부가 사업장 */
setnull(gs_code)

f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'fr_team', gs_saupj)
f_child_saupj(dw_ip, 'to_team', gs_saupj)

dw_ip.SetColumn("syymm")
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_pdt_01550
integer x = 4087
integer y = 36
end type

type p_exit from w_standard_print`p_exit within w_pdt_01550
integer x = 4434
integer y = 36
end type

type p_print from w_standard_print`p_print within w_pdt_01550
integer x = 4261
integer y = 36
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01550
integer x = 3913
integer y = 36
end type











type dw_print from w_standard_print`dw_print within w_pdt_01550
string dataobject = "d_pdt_01550_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01550
integer x = 69
integer y = 32
integer width = 3639
integer height = 184
string dataobject = "d_pdt_01550_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
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
ELSEIF this.GetColumnName() = 'saupj' then
	f_child_saupj(dw_ip, 'fr_team', gettext())	
	f_child_saupj(dw_ip, 'to_team', gettext())
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_01550
integer x = 91
integer y = 244
integer width = 4503
integer height = 2056
string dataobject = "d_pdt_01550_1"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_01550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 236
integer width = 4535
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

