$PBExportHeader$w_pdt_07500.srw
$PBExportComments$생산일보
forward
global type w_pdt_07500 from w_standard_print
end type
type cb_1 from commandbutton within w_pdt_07500
end type
type rr_1 from roundrectangle within w_pdt_07500
end type
end forward

global type w_pdt_07500 from w_standard_print
string title = "생산일보"
cb_1 cb_1
rr_1 rr_1
end type
global w_pdt_07500 w_pdt_07500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sdate, sittyp, sitcls, ssitnbr, seitnbr, spdtgu, spdtname, soption 
decimal dArgm

if dw_ip.accepttext() = -1 then return -1

sdate 	= TRIM(dw_ip.getitemstring(1, "sdate"))

if (IsNull(sdate) or sdate = "")  then 
	f_message_chk(30,'[실적일자]')
	dw_ip.SetColumn("sdate")
	dw_ip.Setfocus()
	return -1
end if

spdtgu	= dw_ip.getitemstring(1, "pdtgu")
sittyp	= dw_ip.getitemstring(1, "ittyp")
sitcls	= dw_ip.getitemstring(1, "itcls")
ssitnbr	= dw_ip.getitemstring(1, "itnbr1")
seitnbr	= dw_ip.getitemstring(1, "itnbr2")
soption	= dw_ip.getitemstring(1, "option")


SELECT RFNA1 
  INTO :sPdtname      
  FROM REFFPF 
 WHERE RFCOD = '03' AND 
       RFGUB = :sPdtgu ;


if isnull(sittyp)  	or trim(sittyp)  	= '' then sittyp = '%';
if isnull(spdtgu)  	or trim(spdtgu)  	= '' then spdtgu = '%';
if isnull(sitcls)  	or trim(sitcls)  	= '' then sitcls = '%';
if isnull(ssitnbr) 	or trim(ssitnbr) 	= '' then ssitnbr = '.';
if isnull(seitnbr) 	or trim(seitnbr) 	= '' then seitnbr = 'ZZZZZZZZZZZZZZZ';
if isnull(spdtname)	or trim(spdtname)	= '' then spdtname = '전체'

if sOption = '2' then
	dArgm = 0
Else
	dArgm = -100000
End if

if dw_print.retrieve(gs_sabu, sdate, sittyp, sitcls, ssitnbr, seitnbr, spdtgu, spdtname, dArgm) < 1 then
	f_message_chk(50,'')
	dw_ip.Setcolumn('sdate')
	dw_ip.Setfocus()
	Return -1	
end if
   
	dw_print.sharedata(dw_list)
RETURN 1
end function

on w_pdt_07500.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_07500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", f_today())
end event

type p_preview from w_standard_print`p_preview within w_pdt_07500
end type

type p_exit from w_standard_print`p_exit within w_pdt_07500
end type

type p_print from w_standard_print`p_print within w_pdt_07500
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_07500
end type







type st_10 from w_standard_print`st_10 within w_pdt_07500
end type



type dw_print from w_standard_print`dw_print within w_pdt_07500
string dataobject = "d_pdt_07500_0_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_07500
integer x = 14
integer y = 168
integer width = 4375
integer height = 252
string dataobject = "d_pdt_07500_a"
end type

event dw_ip::itemchanged;string  snull, sdate, sData, sittyp, sitem, sname, sspec
integer ireturn
long lrow

lrow = this.getrow()

setnull(snull)

this.accepttext()

IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[실적일자]')
		this.setitem(1, "sdate", f_today())
		return 1
	END IF
Elseif this.GetColumnName() = "pdtgu"	THEN
	sDate = trim(this.GetText())
	
	Setnull(sData)
	select rfna1
	  into :sData 
	  From reffpf where rfcod = '03' and rfgub = :sdate;
	if isnull(sData) or trim(sData) = '' then
      f_message_chk(33, '[생산팀]')
		this.setitem(1, "pdtgu", sData)
		return 1		
	end if
Elseif this.GetColumnName() = "itcls"	THEN
	sDate 	= trim(this.GetText())
	sIttyp	= this.getitemstring(1, "ittyp")
	Setnull(sData)
	
	select titnm into :sData 
	  From itnct 
	 where ittyp = :sittyp and itcls = :sDate;

	if sqlca.sqlcode <> 0 then
      f_message_chk(33, '[품목분류]')
		this.setitem(1, "itcls", sNull)
		return 1		
	end if	
Elseif this.GetColumnName() = "itnbr1"	THEN
	sitem = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr1", sitem)	
	this.setitem(lrow, "itdsc1", sname)	
	this.setitem(lrow, "ispec1", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "itdsc1"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr1", sitem)	
	this.setitem(lrow, "itdsc1", sname)	
	this.setitem(lrow, "ispec1", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "ispec1"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr1", sitem)	
	this.setitem(lrow, "itdsc1", sname)	
	this.setitem(lrow, "ispec1", sspec)
	RETURN ireturn	
Elseif this.GetColumnName() = "itnbr2"	THEN
	sitem = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr2", sitem)	
	this.setitem(lrow, "itdsc2", sname)	
	this.setitem(lrow, "ispec2", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "itdsc2"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr2", sitem)	
	this.setitem(lrow, "itdsc2", sname)	
	this.setitem(lrow, "ispec2", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "ispec2"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr2", sitem)	
	this.setitem(lrow, "itdsc2", sname)	
	this.setitem(lrow, "ispec2", sspec)
	RETURN ireturn		
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = ''
string	sName

str_itnct lstr_sitnct


if this.GetColumnName() = 'itcls' then
   this.accepttext()
	
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
// 품번
ELSEIF this.GetColumnName() = 'itnbr1'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"itnbr1",gs_code)
	SetItem(1,"itdsc1",gs_codename)
	SetItem(1,"ispec1",gs_gubun)
	
	this.TriggerEvent("itemchanged")
// 품번
ELSEIF this.GetColumnName() = 'itnbr2'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"itnbr2",gs_code)
	SetItem(1,"itdsc2",gs_codename)
	SetItem(1,"ispec2",gs_gubun)
	
	this.TriggerEvent("itemchanged")	
end if
end event

type dw_list from w_standard_print`dw_list within w_pdt_07500
integer x = 82
integer y = 460
integer width = 4485
integer height = 1832
string dataobject = "d_pdt_07500_0"
boolean border = false
end type

type cb_1 from commandbutton within w_pdt_07500
integer x = 41
integer y = 36
integer width = 626
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "집계공정코드관리"
end type

event clicked;open(w_pdt_07600)


end event

type rr_1 from roundrectangle within w_pdt_07500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 444
integer width = 4599
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

