$PBExportHeader$w_qct_06080.srw
$PBExportComments$계측기 점검/수리현황
forward
global type w_qct_06080 from w_standard_print
end type
end forward

global type w_qct_06080 from w_standard_print
string title = "계측기 점검/수리 현황"
end type
global w_qct_06080 w_qct_06080

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  ls_sdate, ls_edate, ls_rslcod, ls_gubun 

if  dw_ip.AcceptText() = -1 then return -1

ls_sdate  = trim(dw_ip.GetItemString(1,'sdate'))   
ls_edate  = trim(dw_ip.GetItemString(1,'edate'))  
ls_rslcod = dw_ip.Getitemstring(1,'rslcod')
ls_gubun  = dw_ip.Getitemstring(1,'gubun')

IF ls_sdate = ""  OR IsNull(ls_sdate) THEN  ls_sdate = '10000101'
if ls_edate = ""  or IsNull(ls_edate) then  ls_edate = '99991231'	

if ls_gubun = '4' then 
   dw_list.dataobject = 'd_qct_06080_05'   // 수리 
   dw_print.dataobject = 'd_qct_06080_05'   // 수리 
//elseif ls_gubun = '3' then 
//  dw_list.dataobject = "d_qct_06080_04"    // 주유점검 
else
  dw_list.dataobject = "d_qct_06080_02"   // 정기 점검 현황 
  dw_print.dataobject = "d_qct_06080_02"   // 정기 점검 현황 
end if
dw_list.settransobject(sqlca) 
dw_print.settransobject(sqlca) 

dw_list.object.sdate_t.text = string(ls_sdate , '@@@@.@@.@@' ) 
dw_list.object.edate_t.text = string(ls_edate , '@@@@.@@.@@' ) 

//if ls_gubun = '4' then 
//	IF dw_list.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_rslcod ) < 1 THEN
//		f_message_chk(50,'')
//		dw_ip.Setfocus()
//		return -1
//	end if
//else
//	IF dw_list.Retrieve(gs_sabu, ls_sdate, ls_edate) < 1 THEN
//		f_message_chk(50,'')
//		dw_ip.Setfocus()
//		return -1
//	end if
//end if

if ls_gubun = '4' then 
	IF dw_print.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_rslcod ) < 1 THEN
		f_message_chk(50,"[계측기 점검/수리 현황]")
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
		dw_print.insertrow(0)
	//	Return -1
	END IF
else
	IF dw_print.Retrieve(gs_sabu, ls_sdate, ls_edate) < 1 THEN
		f_message_chk(50,"[계측기 점검/수리 현황]")
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
		dw_print.insertrow(0)
	//	Return -1
	END IF
end if

dw_print.ShareData(dw_list)

return 1

end function

on w_qct_06080.create
call super::create
end on

on w_qct_06080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06080
end type

type p_exit from w_standard_print`p_exit within w_qct_06080
end type

type p_print from w_standard_print`p_print within w_qct_06080
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06080
end type







type st_10 from w_standard_print`st_10 within w_qct_06080
end type



type dw_print from w_standard_print`dw_print within w_qct_06080
string dataobject = "d_qct_06080_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06080
integer x = 50
integer y = 0
integer width = 1216
integer height = 248
string dataobject = "d_qct_06080_01"
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

type dw_list from w_standard_print`dw_list within w_qct_06080
string dataobject = "d_qct_06080_02"
end type

