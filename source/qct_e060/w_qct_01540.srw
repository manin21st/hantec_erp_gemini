$PBExportHeader$w_qct_01540.srw
$PBExportComments$** 부품이상발생통보서현황
forward
global type w_qct_01540 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_01540
end type
end forward

global type w_qct_01540 from w_standard_print
string title = "부품 이상발생통보서 현황"
rr_1 rr_1
end type
global w_qct_01540 w_qct_01540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, itnbr1, itnbr2, ls_gubun, ls_outgubun

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_gubun = dw_ip.getitemstring( 1, "gubun" )
ls_outgubun = dw_ip.getitemstring( 1, "outgubun" )
	
if ls_gubun = '1' and ls_outgubun = '1' then    // 품번-원인별 
	dw_print.dataobject = 'd_qct_01540_6_p'
	dw_list.dataobject = 'd_qct_01540_6'
elseif  ls_gubun = '1' and ls_outgubun = '2' then  // 품번-생산팀별 
	dw_print.dataobject = 'd_qct_01540_7_p'
	dw_list.dataobject = 'd_qct_01540_7'	
elseif  ls_gubun = '2' and ls_outgubun = '1' then  //거래처-원인별 
	dw_list.dataobject = 'd_qct_01540_8' 
	dw_print.dataobject = 'd_qct_01540_8_p' 	
elseif  ls_gubun = '2' and ls_outgubun = '2' then                                            //거래처 - 생산팀별 
	dw_list.dataobject = 'd_qct_01540_9'
	dw_print.dataobject = 'd_qct_01540_9_p'	
end if
	
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

if dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,'[부품이상발생 통보서 현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_01540.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_01540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_qct_01540
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_qct_01540
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_qct_01540
integer x = 4256
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01540
integer x = 3909
end type







type st_10 from w_standard_print`st_10 within w_qct_01540
end type



type dw_print from w_standard_print`dw_print within w_qct_01540
integer x = 3717
string dataobject = "d_qct_01540_6_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01540
integer x = 18
integer y = 0
integer width = 3205
integer height = 252
string dataobject = "d_qct_01540_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2, s_call
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "gubun" then 
	this.object.itnbr1[1] = ''
	this.object.itdsc1[1] = ''
	this.object.itnbr2[1] = ''
	this.object.itdsc2[1] = ''
elseif this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "itnbr1" then 
	if getitemstring(1, "gubun") = '1' then
		s_call = '품번'
	else
		s_call = 'V0'				
	end if
	i_rtn = f_get_name2(s_call,"N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "itnbr2" then 
	if getitemstring(1, "gubun") = '1' then
		s_call = '품번'
	else
		s_call = 'V0'		
	end if	
	i_rtn = f_get_name2(s_call,"N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keyF2!) THEN
	if this.GetColumnName() = "itnbr1" then
	   open(w_itemas_popup2)
	   this.object.itnbr1[1] = gs_code
	   this.object.itdsc1[1] = gs_codename
   elseif this.GetColumnName() = "itnbr2" then
	   open(w_itemas_popup2)
	   this.object.itnbr2[1] = gs_code
	   this.object.itdsc2[1] = gs_codename
   end if	
	return
END IF
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getitemstring(1, "gubun") = '1' then
	gs_gubun = '3' 
	if this.GetColumnName() = "itnbr1" then
		open(w_itemas_popup)
		if gs_code = '' or isnull(gs_code) then return 
		this.object.itnbr1[1] = gs_code
		this.object.itdsc1[1] = gs_codename
	elseif this.GetColumnName() = "itnbr2" then
		open(w_itemas_popup)
		if gs_code = '' or isnull(gs_code) then return 
		this.object.itnbr2[1] = gs_code
		this.object.itdsc2[1] = gs_codename
	end if
else
	gs_gubun = '1' 
	if this.GetColumnName() = "itnbr1" then
		open(w_vndmst_popup)
		if gs_code = '' or isnull(gs_code) then return 
		this.object.itnbr1[1] = gs_code
		this.object.itdsc1[1] = gs_codename
	elseif this.GetColumnName() = "itnbr2" then
		open(w_vndmst_popup)
		if gs_code = '' or isnull(gs_code) then return 
		this.object.itnbr2[1] = gs_code
		this.object.itdsc2[1] = gs_codename
	end if	
end if

end event

type dw_list from w_standard_print`dw_list within w_qct_01540
integer y = 272
integer width = 4553
integer height = 2012
string dataobject = "d_qct_01540_6"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_01540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 256
integer width = 4585
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

