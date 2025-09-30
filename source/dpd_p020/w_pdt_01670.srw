$PBExportHeader$w_pdt_01670.srw
$PBExportComments$** 과거 3개월 판매실적대비 생산실적 현황
forward
global type w_pdt_01670 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_01670
end type
end forward

global type w_pdt_01670 from w_standard_print
string title = "과거 3개월 판매실적대비 생산실적 현황"
rr_1 rr_1
end type
global w_pdt_01670 w_pdt_01670

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_frTeam,s_toteam, s_b3ym, s_b2ym, s_b1ym, s_jb3ym, s_jb2ym, s_jb1ym, &
        sittyp, sitcls, sfitnbr, stitnbr, sLmsgu, ssaupj  

if dw_ip.AcceptText() = -1 then return -1

s_b1ym = trim(dw_ip.GetItemString(1,"syymm"))

s_frTeam  = dw_ip.GetItemString(1,"fr_team")
s_toTeam  = dw_ip.GetItemString(1,"to_team")

ssaupj    = dw_ip.GetItemString(1,"saupj")

sittyp  =  dw_ip.GetItemString(1,"ittyp")
sitcls  =  trim(dw_ip.GetItemString(1,"fitcls"))
sfitnbr =  trim(dw_ip.GetItemString(1,"fr_itnbr"))
stitnbr =  trim(dw_ip.GetItemString(1,"to_itnbr"))
sLmsgu  = dw_ip.GetItemString(1,"lmsgu")

IF s_b1ym = "" OR IsNull(s_b1ym) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
ELSE
	s_b2ym  = f_aftermonth(s_b1ym, -1)     
	s_b3ym  = f_aftermonth(s_b1ym, -2)     
	s_jb1ym = f_aftermonth(s_b1ym, -12)     
	s_jb2ym = f_aftermonth(s_b1ym, -13)     
	s_jb3ym = f_aftermonth(s_b1ym, -14)     
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

IF sittyp = "" OR IsNull(sittyp) THEN 
	sittyp = '%'
END IF

IF sitcls = "" OR IsNull(sitcls) THEN 
	sitcls = '%'
ELSE
	sitcls = sitcls + '%' 
END IF

IF sfitnbr = "" OR IsNull(sfitnbr) THEN 
	sfitnbr = '.'
END IF
IF sTitnbr = "" OR IsNull(sTitnbr) THEN 
	sTitnbr = 'zzzzzzzzzzzzzzzz'
END IF

if sfitnbr > sTitnbr then 
	f_message_chk(34,'[품번]')
	dw_ip.Setcolumn('sfitnbr')
	dw_ip.SetFocus()
	return -1
end if	

//수량이나 금액이 없으면 조회되지 않게 함....
string DWfilter
DWfilter = "bqty3<>0 or bamt3<>0 or bqty2<>0 or bamt2<>0 or bqty1<>0 or bamt1<>0 or " &
		  	  + "cqty3<>0 or camt3<>0 or cqty2<>0 or camt2<>0 or cqty1<>0 or camt1<>0 or " &
			  + "dqty3<>0 or damt3<>0 or dqty2<>0 or damt2<>0 or dqty1<>0 or damt1<>0 or " &
			  + "eqty3<>0 or eamt3<>0 or eqty2<>0 or eamt2<>0 or eqty1<>0 or eamt1<>0" 

dw_print.SetFilter(DWfilter)
dw_print.Filter( )

string ls_silgu
ls_silgu = f_get_syscnfg('S', 8, '40')

IF dw_print.Retrieve(gs_sabu,s_frteam,s_toteam,s_b1ym,s_b2ym,s_b3ym,s_jb1ym,s_jb2ym,s_jb3ym,&
                    sittyp, sitcls, sfitnbr, stitnbr, sLmsgu, ssaupj, ls_silgu) < 1 THEN
	f_message_chk(50,'')
	
	dw_ip.Setfocus()
	return -1
end if
   
dw_print.sharedata(dw_list)
dw_list.object.mon3_t.text = string(integer(right( s_b3ym , 2))) + '월'
dw_list.object.mon2_t.text = string(integer(right( s_b2ym , 2))) + '월'
dw_list.object.mon1_t.text = string(integer(right( s_b1ym , 2))) + '월'
dw_list.object.mon31_t.text = string(integer(right( s_b3ym , 2))) + '월'
dw_list.object.mon21_t.text = string(integer(right( s_b2ym , 2))) + '월'
dw_list.object.mon11_t.text = string(integer(right( s_b1ym , 2))) + '월'
return 1



end function

on w_pdt_01670.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_01670.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, "syymm", left(is_today,6))

//if f_check_saupj() = 1 then
//	dw_ip.setitem(1, "saupj", gs_code)
//End if

f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'fr_team', gs_saupj)
f_child_saupj(dw_ip, 'to_team', gs_saupj)

dw_ip.SetColumn("syymm")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_01670
integer x = 4091
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_pdt_01670
integer x = 4439
integer y = 28
end type

type p_print from w_standard_print`p_print within w_pdt_01670
integer x = 4265
integer y = 28
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_01670
integer x = 3918
integer y = 28
end type











type dw_print from w_standard_print`dw_print within w_pdt_01670
string dataobject = "d_pdt_01670_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_01670
integer x = 73
integer y = 184
integer width = 4146
integer height = 260
string dataobject = "d_pdt_01670_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, syymm, sNull
int     ireturn

setnull(sNull)

IF this.GetColumnName() = "fr_itnbr"	THEN
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
ELSEIF this.GetColumnName() = 'fitcls' then
	sItnbr = this.GetText()
   this.accepttext()	
	sispec = this.getitemstring(1, 'ittyp')
	
	if sitnbr = '' or isnull(sitnbr) then 
		this.setitem(1, "fclsnm", sNull)	
		return
	end if	
	
	ireturn = f_get_name2('품목분류', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fitcls", sitnbr)	
	this.setitem(1, "fclsnm", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	
	if syymm = "" or isnull(syymm) then	return 

  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
ELSEIF getcolumnname() = 'saupj' then
	f_child_saupj(dw_ip, 'fr_team', gettext())
	f_child_saupj(dw_ip, 'to_team', gettext())

END IF

end event

event dw_ip::rbuttondown;string sittyp
str_itnct lstr_sitnct

this.accepttext()
if this.GetColumnName() = 'fitcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"fclsnm", lstr_sitnct.s_titnm)
elseif this.GetColumnName() = 'fr_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_gubun = '1'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if	


end event

type dw_list from w_standard_print`dw_list within w_pdt_01670
integer x = 91
integer y = 476
integer width = 4503
integer height = 1824
string dataobject = "d_pdt_01670_1"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_01670
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 472
integer width = 4530
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

