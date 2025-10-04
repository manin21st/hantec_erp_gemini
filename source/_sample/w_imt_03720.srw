$PBExportHeader$w_imt_03720.srw
$PBExportComments$납기 미준수 현황
forward
global type w_imt_03720 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_03720
end type
type pb_2 from u_pb_cal within w_imt_03720
end type
type rr_2 from roundrectangle within w_imt_03720
end type
end forward

global type w_imt_03720 from w_standard_print
string title = "납기 미준수 현황"
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_imt_03720 w_imt_03720

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_fitnbr, s_titnbr, s_fcvcod, s_tcvcod, sdate, edate, s_saupj, sittyp, sgubun
integer delay

if dw_ip.AcceptText() = -1 then return -1

sgubun   = dw_ip.GetItemString(1, "gubun")
sittyp   = trim(dw_ip.GetItemString(1, "ittyp"))
s_fitnbr = trim(dw_ip.GetItemString(1, "sitnbr"))
s_titnbr = trim(dw_ip.GetItemString(1, "eitnbr"))
s_fcvcod = trim(dw_ip.GetItemString(1, "scvcod"))
s_tcvcod = trim(dw_ip.GetItemString(1, "ecvcod"))
s_saupj  = trim(dw_ip.GetItemString(1, "saupj" ))
sdate    = trim(dw_ip.GetItemString(1, "sdate" ))
edate    = trim(dw_ip.GetItemString(1, "edate" )) 
delay    = dw_ip.GetItemnumber(1, "delay" ) 

IF s_saupj = "" OR IsNull(s_saupj) THEN 
	f_message_chk(30,'[사업장]')
	dw_ip.Setcolumn('saupj')
	dw_ip.SetFocus()
	return -1
END IF

if sdate = "" or IsNull(sdate) then	sdate = '10000101'
if edate = "" or IsNull(edate) then	edate = '99991231'
if IsNull(delay) then delay = 0
IF s_fitnbr = "" OR IsNull(s_fitnbr) THEN s_fitnbr = '.'
IF s_titnbr = "" OR IsNull(s_titnbr) THEN	s_titnbr = 'zzzzzzzzzzzzzzz'
IF s_fcvcod = "" OR IsNull(s_fcvcod) THEN s_fcvcod = '.'
IF s_tcvcod = "" OR IsNull(s_tcvcod) THEN s_tcvcod = 'zzzzzz'
IF sittyp   = "" OR IsNull(sittyp) THEN sittyp = '%'

if sgubun = '1' then //자재별
	dw_list.dataobject = 'd_imt_03720_02'
	dw_print.dataobject = 'd_imt_03720_02_p'
else
	dw_list.dataobject = 'd_imt_03720_03'
	dw_print.dataobject = 'd_imt_03720_03_p'
end if	
dw_print.settransobject(sqlca)		

//dw_list.object.sdate_t.text = string( sdate, "@@@@.@@.@@" )
//dw_list.object.edate_t.text = string( edate, "@@@@.@@.@@" )

IF dw_print.Retrieve(gs_sabu, s_saupj, s_fitnbr, s_titnbr, s_fcvcod, s_tcvcod, sdate, edate, &
                    delay, sittyp ) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('sitnbr')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1

end function

on w_imt_03720.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_2
end on

on w_imt_03720.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

event open;call super::open;/* 부가 사업장 */
f_mod_saupj(dw_ip,'saupj')
end event

type p_preview from w_standard_print`p_preview within w_imt_03720
end type

type p_exit from w_standard_print`p_exit within w_imt_03720
end type

type p_print from w_standard_print`p_print within w_imt_03720
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03720
end type







type st_10 from w_standard_print`st_10 within w_imt_03720
end type



type dw_print from w_standard_print`dw_print within w_imt_03720
integer x = 4238
integer y = 156
string dataobject = "d_imt_03720_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03720
integer x = 27
integer y = 24
integer width = 3854
integer height = 228
string dataobject = "d_imt_03720_01"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;string  snull, svndcod, svndnm, svndnm2, sdate 
int     ireturn 
setnull(snull)

IF this.GetColumnName() = "scvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "scvcod", svndcod)	
	this.setitem(1, "scvnam", svndnm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ecvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "ecvcod", svndcod)	
	this.setitem(1, "ecvnam", svndnm)	
	RETURN ireturn
//ELSEIF this.GetColumnName() = "sitnbr"	THEN
//	svndcod = trim(this.GetText())
//	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
//	this.setitem(1, "sitnbr", svndcod)	
//	this.setitem(1, "sitdsc", svndnm)	
//	RETURN ireturn	
//ELSEIF this.GetColumnName() = "eitnbr"	THEN
//	svndcod = trim(this.GetText())
//	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
//	this.setitem(1, "eitnbr", svndcod)	
//	this.setitem(1, "eitdsc", svndnm)	
//	RETURN ireturn		
ELSEIF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[발주일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[발주일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
end if
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'scvcod' then
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"scvcod",gs_code)
	this.SetItem(1,"scvnam",gs_codename)
elseif this.GetColumnName() = 'ecvcod' then
	gs_gubun = '1'
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"ecvcod",gs_code)
	this.SetItem(1,"ecvnam",gs_codename)
elseif this.GetColumnName() = 'sitnbr' then
	gs_gubun = '3'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"sitnbr",gs_code)
//	this.setitem(1,"sitdsc",gs_codename)
elseif this.GetColumnName() = 'eitnbr' then
	gs_gubun = '3'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"eitnbr",gs_code)
//	this.setitem(1,"eitdsc",gs_codename)
end if	



end event

type dw_list from w_standard_print`dw_list within w_imt_03720
integer x = 50
integer y = 268
integer width = 4553
integer height = 2048
string dataobject = "d_imt_03720_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_03720
integer x = 3296
integer y = 40
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_03720
integer x = 3744
integer y = 40
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_2 from roundrectangle within w_imt_03720
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 256
integer width = 4571
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

