$PBExportHeader$w_pdt_02890.srw
$PBExportComments$** 생산 진행 현황
forward
global type w_pdt_02890 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02890
end type
end forward

global type w_pdt_02890 from w_standard_print
string title = "생산 진행 현황"
rr_1 rr_1
end type
global w_pdt_02890 w_pdt_02890

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_frdate, s_todate, spdtgu, sitcls1, sitcls2, sittyp

dw_ip.AcceptText()

s_frdate = trim(dw_ip.GetItemString(1, "sdate"))
s_todate = trim(dw_ip.GetItemString(1, "edate"))
spdtgu   = trim(dw_ip.GetItemString(1, "pdtgu1"))
sittyp   = trim(dw_ip.GetItemString(1, "ittyp"))
sitcls1  = trim(dw_ip.GetItemString(1, "itnbr1"))
sitcls2  = trim(dw_ip.GetItemString(1, "itnbr2"))

IF s_frdate = "" OR IsNull(s_frdate) THEN 
	s_frdate = '10000101'
END IF
IF s_todate = "" OR IsNull(s_todate) THEN 
	s_todate = '99991231'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[지시일자]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

if isnull(spdtgu) or trim(spdtgu) = '' then
	f_message_chk(30,'[생산팀]')
	dw_ip.Setcolumn('pdtgu1')
	dw_ip.SetFocus()
	return -1
end if	

if isnull(sittyp) or trim(sittyp) = '' then
	f_message_chk(30,'[품목구분]')
	dw_ip.Setcolumn('ittyp')
	dw_ip.SetFocus()
	return -1
end if	

if sitcls1 > sitcls2 then 
	f_message_chk(34,'[품목분류]')
	dw_ip.Setcolumn('itnbr1')
	dw_ip.SetFocus()
	return -1
end if	

if IsNull(sitcls1) or sitcls1 = "" then sitcls1 = "."
if IsNull(sitcls2) or sitcls2 = "" then sitcls2 = "ZZZZZZZZZZZZZZZ"

IF dw_print.Retrieve(gs_sabu, s_frdate, s_todate, spdtgu, sittyp, sitcls1, sitcls2) < 1 then
	f_message_chk(50,'')
	dw_ip.Setcolumn('sdate')
	dw_ip.Setfocus()
	return -1
end if

Int	li_Return
li_Return = dw_print.sharedata(dw_list)

return 1

end function

on w_pdt_02890.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_02890.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, "sdate", left(f_today(), 6) + '01')
dw_ip.SetItem(1, "edate", f_today())

String scode

Select Min(rfgub) into :scode
  from reffpf
 where rfcod = '03' and rfgub <> '00';
dw_ip.setitem(1, "pdtgu1", sCode)

Select Min(rfgub) into :scode
  from reffpf
 where rfcod = '05' and rfgub <> '00';
dw_ip.setitem(1, "ittyp",  sCode)

dw_ip.SetColumn("sdate")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_02890
end type

type p_exit from w_standard_print`p_exit within w_pdt_02890
end type

type p_print from w_standard_print`p_print within w_pdt_02890
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02890
end type







type st_10 from w_standard_print`st_10 within w_pdt_02890
end type



type dw_print from w_standard_print`dw_print within w_pdt_02890
string dataobject = "d_pdt_02890_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02890
integer x = 73
integer y = 32
integer width = 2537
integer height = 180
string dataobject = "d_pdt_02890_a"
end type

event dw_ip::itemchanged;string  snull, sdate

setnull(snull)

IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[지시일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[지시일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = ''
string	sName

str_itnct lstr_sitnct


if this.GetColumnName() = 'itnbr1' then
   this.accepttext()
	
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itnbr1", lstr_sitnct.s_sumgub)

end if

if this.GetColumnName() = 'itnbr2' then
   this.accepttext()
	
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itnbr2", lstr_sitnct.s_sumgub)

end if
end event

event dw_ip::ue_key;if keydown(keyF1!) THEN
	this.TriggerEvent(rbuttondown!)
elseif keydown(keyF2!) THEN	
	if This.GetColumnName() = "itnbr1" then 
		open(w_itemas_popup2)
		this.object.itnbr1[1] = gs_code
   elseif This.GetColumnName() = "itnbr2" then 
		open(w_itemas_popup2)
		this.object.itnbr2[1] = gs_code
   end if
end if	
end event

type dw_list from w_standard_print`dw_list within w_pdt_02890
integer x = 91
integer y = 244
integer width = 4498
integer height = 2044
string dataobject = "d_pdt_02890_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_02890
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 240
integer width = 4530
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

