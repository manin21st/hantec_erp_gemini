$PBExportHeader$w_pdt_06561.srw
$PBExportComments$점검/수리/주유현황
forward
global type w_pdt_06561 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06561
end type
end forward

global type w_pdt_06561 from w_standard_print
string title = "정기점검 실시 결과 현황"
rr_1 rr_1
end type
global w_pdt_06561 w_pdt_06561

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  ls_sdate, ls_edate, ls_rslcod, ls_gubun ,ls_pgubun

if  dw_ip.AcceptText() = -1 then return -1

ls_sdate  = trim(dw_ip.GetItemString(1,'sdate'))   
ls_edate  = trim(dw_ip.GetItemString(1,'edate'))  
ls_rslcod = dw_ip.Getitemstring(1,'rslcod')
ls_gubun  = dw_ip.Getitemstring(1,'gubun')
ls_pgubun = dw_ip.getitemstring(1,'jgubun')

IF ls_sdate = ""  OR IsNull(ls_sdate) THEN  ls_sdate = '10000101'
if ls_edate = ""  or IsNull(ls_edate) then  ls_edate = '99991231'	

dw_print.setredraw(false)
if ls_gubun = '4' then 
	if ls_pgubun = '1' then
   	dw_list.dataobject =  'd_pdt_06561_05'   // 수리 
		dw_print.dataobject = 'd_pdt_06561_05_p'
	elseif ls_pgubun = '2' then
		dw_list.dataobject =  'd_pdt_06561_06'
		dw_print.dataobject = 'd_pdt_06561_06_p'
	else
		dw_list.dataobject =  'd_pdt_06561_07'
		dw_print.dataobject = 'd_pdt_06561_07_p'
	end if
elseif ls_gubun = '3' then 
  dw_list.dataobject =  "d_pdt_06561_04"    // 주유점검 
  dw_print.dataobject = 'd_pdt_06561_04_p'
else
  dw_list.dataobject =  "d_pdt_06561_02"  // 정기 점검 현황 
  dw_print.dataobject = 'd_pdt_06561_02_p'
end if
dw_print.settransobject(sqlca) 
dw_print.setredraw(true)

dw_print.object.sdate_t.text = string(ls_sdate , '@@@@.@@.@@' ) 
dw_print.object.edate_t.text = string(ls_edate , '@@@@.@@.@@' ) 

if ls_gubun = '4' then 
	IF dw_print.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_rslcod ) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		//return -1
		dw_list.insertrow(0)
	end if
else
	IF dw_print.Retrieve(gs_sabu, ls_sdate, ls_edate) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		//return -1
		dw_list.insertrow(0)
	end if
end if

dw_print.sharedata(dw_list)

return 1

end function

on w_pdt_06561.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06561.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.Setitem(1, "sdate", Left(gs_today,6) + '01')
dw_ip.Setitem(1, "edate", gs_today)

end event

type p_preview from w_standard_print`p_preview within w_pdt_06561
end type

type p_exit from w_standard_print`p_exit within w_pdt_06561
end type

type p_print from w_standard_print`p_print within w_pdt_06561
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06561
end type







type st_10 from w_standard_print`st_10 within w_pdt_06561
end type



type dw_print from w_standard_print`dw_print within w_pdt_06561
string dataobject = "d_pdt_06561_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06561
integer x = 50
integer y = 36
integer width = 1829
integer height = 344
string dataobject = "d_pdt_06561_01"
end type

event dw_ip::itemchanged;String  s_cod, s_nam , ls_mchnam , snull

setnull(snull)

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod ) = -1 then
		f_message_chk(35,"[기준일자 FROM]")
		this.object.sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[기준일자 TO]")
		this.object.edate[1] = ""
		return 1 
	end if
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_06561
integer x = 64
integer y = 396
integer width = 4539
integer height = 1844
string dataobject = "d_pdt_06561_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06561
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 388
integer width = 4571
integer height = 1876
integer cornerheight = 40
integer cornerwidth = 55
end type

