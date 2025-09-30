$PBExportHeader$w_pdt_01500.srw
$PBExportComments$** 년간 생산계획 현황
forward
global type w_pdt_01500 from w_standard_print
end type
type st_2 from statictext within w_pdt_01500
end type
type rr_1 from roundrectangle within w_pdt_01500
end type
end forward

global type w_pdt_01500 from w_standard_print
string title = "년간 생산계획 현황"
st_2 st_2
rr_1 rr_1
end type
global w_pdt_01500 w_pdt_01500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int     i_seq
String  s_frTeam,s_toteam, s_year, s_fritnbr, s_toitnbr, sgub, sporgu

if dw_ip.AcceptText() = -1 then return -1
 
sgub   = dw_ip.GetItemString(1,"gub")
sporgu = dw_ip.GetItemString(1,"porgu")

s_year = dw_ip.GetItemString(1,"syear")
i_seq  = dw_ip.GetItemNumber(1,"jjcha")

s_frTeam  = dw_ip.GetItemString(1,"fr_team")
s_toTeam  = dw_ip.GetItemString(1,"to_team")

s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")

IF s_year = "" OR IsNull(s_year) THEN
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("syear")
	dw_ip.SetFocus()
	Return -1
END IF
IF i_seq = 0 OR IsNull(i_seq) THEN
	f_message_chk(30,'[차수]')
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

if sgub = '1' then 
   dw_list.DataObject ="d_pdt_01500_2" 
   dw_print.DataObject ="d_pdt_01500_2_p"   
elseif sgub = '2' then 
   dw_list.DataObject ="d_pdt_01500_3" 
   dw_print.DataObject ="d_pdt_01500_3_p"   
else	
   dw_list.DataObject ="d_pdt_01500_1" 
   dw_print.DataObject ="d_pdt_01500_1_p" 
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

IF dw_print.Retrieve(gs_sabu, sporgu, s_year, i_seq, s_frteam, s_toteam, &
                    s_fritnbr, s_toitnbr) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
  dw_print.sharedata(dw_list)

return 1

end function

on w_pdt_01500.create
int iCurrent
call super::create
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_01500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;string s_nextyear
int    get_yeacha

s_nextyear = string(long(left(f_today(), 4)) + 1)

dw_ip.setitem(1, 'syear', s_nextyear)

SELECT MAX("YEAPLN"."YEACHA")  
  INTO :get_yeacha  
  FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( substr("YEAPLN"."YEAYYMM", 1, 4) = :s_nextyear )   ;

dw_ip.setitem(1, "jjcha", get_yeacha)

if f_check_saupj() = 1 then
	dw_ip.setitem(1, "porgu", gs_code)
End if

/* 부가 사업장 */
setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'porgu', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("porgu.protect=1")
//		dw_ip.Modify("porgu.background.color = 80859087")
//	End if
//End If

f_mod_saupj(dw_ip, 'porgu')
f_child_saupj(dw_ip, 'fr_team', gs_saupj)
f_child_saupj(dw_ip, 'to_team', gs_saupj)
dw_ip.SetColumn("syear")
dw_ip.Setfocus()

  
end event

type p_preview from w_standard_print`p_preview within w_pdt_01500
integer x = 4087
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_pdt_01500
integer x = 4434
integer y = 28
end type

type p_print from w_standard_print`p_print within w_pdt_01500
integer x = 4261
integer y = 28
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01500
integer x = 3913
integer y = 28
end type











type dw_print from w_standard_print`dw_print within w_pdt_01500
integer x = 3781
string dataobject = "d_pdt_01500_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01500
integer x = 78
integer y = 32
integer width = 3685
integer height = 216
integer taborder = 1
string dataobject = "d_pdt_01500_a"
end type

event dw_ip::rbuttondown;setnull(gs_code)
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

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;int get_yeacha
string syear, snull

setnull(snull)

IF this.GetColumnName() ="syear" THEN
	syear = trim(this.GetText())
	
	if syear = "" or isnull(syear) then	return 
	
	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( substr("YEAPLN"."YEAYYMM", 1, 4) = :syear )   ;
			 
	dw_ip.setitem(1, "jjcha", get_yeacha)
elseif getcolumnname() = 'porgu' then
	f_child_saupj(this, 'fr_team', gettext())
	f_child_saupj(this, 'to_team', gettext())
END IF



end event

type dw_list from w_standard_print`dw_list within w_pdt_01500
integer x = 91
integer y = 280
integer width = 4498
integer height = 2012
string dataobject = "d_pdt_01500_2"
boolean border = false
boolean hsplitscroll = false
end type

type st_2 from statictext within w_pdt_01500
integer x = 4192
integer y = 212
integer width = 425
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 31778020
string text = "(금액단위:천원)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_01500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 272
integer width = 4526
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

