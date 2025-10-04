$PBExportHeader$w_imt_03730.srw
$PBExportComments$회계 계정별 매입 현황
forward
global type w_imt_03730 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_03730
end type
type pb_2 from u_pb_cal within w_imt_03730
end type
type rr_1 from roundrectangle within w_imt_03730
end type
end forward

global type w_imt_03730 from w_standard_print
string title = "회계 계정별 매입 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_03730 w_imt_03730

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_fitnbr, s_titnbr, s_ittyp , s_sitcls, s_eitcls, s_sdate, s_edate 

if dw_ip.AcceptText() = -1 then return -1

s_fitnbr = trim(dw_ip.GetItemString(1, "sitnbr"))
s_titnbr = trim(dw_ip.GetItemString(1, "eitnbr"))
s_sdate  = trim(dw_ip.GetItemString(1, "sdate" ))
s_edate  = trim(dw_ip.GetItemString(1, "edate" )) 
s_ittyp  = trim(dw_ip.GetitemString(1, "ittyp" ))
s_sitcls = trim(dw_ip.Getitemstring(1, "arg_itcls1"))
s_eitcls = trim (dw_ip.Getitemstring(1, "arg_itcls2"))

if s_sdate  = "" or IsNull(s_sdate)  then s_sdate  = '10000101'
if s_edate  = "" or IsNull(s_edate)  then s_edate  = '99991231'
IF s_fitnbr = "" OR IsNull(s_fitnbr) THEN	s_fitnbr = '.'
IF s_titnbr = "" OR IsNull(s_titnbr) THEN s_titnbr = 'zzzzzzzzzzzzzzz'
if s_ittyp  = "" or IsNull(s_ittyp ) then	s_ittyp  = '%'
IF s_sitcls = "" OR IsNull(s_sitcls) THEN s_sitcls = '.'
IF s_eitcls = "" OR IsNull(s_eitcls) THEN s_eitcls = 'zzzzzzzzz'

//dw_list.object.sdate_t.text = string( s_sdate, "@@@@.@@.@@" )
//dw_list.object.edate_t.text = string( s_edate, "@@@@.@@.@@" )
//
IF dw_print.Retrieve(gs_sabu, s_sdate, s_edate, s_ittyp, s_sitcls, s_eitcls, s_fitnbr, s_titnbr ) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('sitnbr')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1

end function

on w_imt_03730.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_imt_03730.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_imt_03730
end type

type p_exit from w_standard_print`p_exit within w_imt_03730
end type

type p_print from w_standard_print`p_print within w_imt_03730
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03730
end type







type st_10 from w_standard_print`st_10 within w_imt_03730
end type



type dw_print from w_standard_print`dw_print within w_imt_03730
string dataobject = "d_imt_03730_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03730
integer x = 37
integer y = 24
integer width = 2674
integer height = 216
string dataobject = "d_imt_03730_01"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;string  snull, svndcod, svndnm, svndnm2 
int     ireturn 
setnull(snull)

IF this.GetColumnName() = "sitnbr"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "sitnbr", svndcod)	
	this.setitem(1, "sitdsc", svndnm)	
	RETURN ireturn	
ELSEIF this.GetColumnName() = "eitnbr"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "eitnbr", svndcod)	
	this.setitem(1, "eitdsc", svndnm)	
	RETURN ireturn		
ELSEIF this.GetColumnName() = "sitdsc"	THEN
	svndnm = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "sitnbr", svndcod)	
	this.setitem(1, "sitdsc", svndnm)	
	RETURN ireturn		
ELSEIF this.GetColumnName() = "eitdsc"	THEN
	svndnm = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "eitnbr", svndcod)	
	this.setitem(1, "eitdsc", svndnm)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "sdate" then
	svndcod = trim(this.GetText())
	if isNull(svndcod) or svndcod = "" then return
   if f_datechk(svndcod) = -1 then
		f_message_chk(35, "[검사일자 FROM]")
		this.object.sdate[1] = "" 
		return 1
	end if
ELSEIF this.GetColumnName() = "edate" then
	svndcod = trim(this.GetText())
	if isNull(svndcod) or svndcod = "" then return
	if f_datechk(svndcod) = -1 then
		f_message_chk(35, "[검사일자 TO]" )
		this.object.edate[1] = ""
		return 1
	end if
end if


end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'sitnbr' then
	gs_gubun = '3'
   open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"sitnbr",gs_code)
	this.setitem(1,"sitdsc",gs_codename)
elseif this.GetColumnName() = 'eitnbr' then
	gs_gubun = '3'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"eitnbr",gs_code)
	this.setitem(1,"eitdsc",gs_codename)
elseif this.GetColumnName() = 'arg_itcls1' then
	gs_gubun = this.getitemstring(1, 'ittyp')

	open(w_itnct_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"arg_itcls1",gs_code)	
	this.SetItem(1,"ittyp",gs_gubun)	
elseif this.GetColumnName() = 'arg_itcls2' then
	gs_gubun = this.getitemstring(1, 'ittyp')
	open(w_itnct_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"arg_itcls2",gs_code)		
	this.SetItem(1,"ittyp",gs_gubun)	
end if	
	
end event

type dw_list from w_standard_print`dw_list within w_imt_03730
integer y = 268
integer width = 4544
integer height = 2052
string dataobject = "d_imt_03730_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_03730
integer x = 617
integer y = 32
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

type pb_2 from u_pb_cal within w_imt_03730
integer x = 1056
integer y = 32
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

type rr_1 from roundrectangle within w_imt_03730
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 264
integer width = 4562
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

