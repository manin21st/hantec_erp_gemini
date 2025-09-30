$PBExportHeader$w_qct_06590.srw
$PBExportComments$** 주요제품(시리즈) A/S 현황
forward
global type w_qct_06590 from w_standard_print
end type
end forward

global type w_qct_06590 from w_standard_print
string title = "주요제품(시리즈) A/S 현황"
end type
global w_qct_06590 w_qct_06590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ymd1, ymd2, ittyp, itcls, titnm

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ymd1  = Trim(dw_ip.object.ymd1[1])
ymd2  = Trim(dw_ip.object.ymd2[1])
ittyp = Trim(dw_ip.object.ittyp[1])
itcls = Trim(dw_ip.object.itcls[1])
titnm = Trim(dw_ip.object.titnm[1])

if (IsNull(ymd1) or ymd1 = "")  then 
	f_message_chk(30, "[기준일자1]")
	dw_ip.SetColumn("ymd1")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(ymd2) or ymd2 = "")  then 
	f_message_chk(30, "[기준일자2]")
	dw_ip.SetColumn("ymd2")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(itcls) or itcls = "")  then 
	f_message_chk(30, "[시리즈]")
	dw_ip.SetColumn("itcls")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(titnm) or titnm = "")  then 
	f_message_chk(30, "[시리즈명]")
	dw_ip.SetColumn("itcls")
	dw_ip.Setfocus()
	return -1
end if

//dw_list.object.txt_title.text = dw_ip.object.titnm[1] +  " 주요제품 A/S 현황"
//
//if dw_list.Retrieve(gs_sabu, ymd1, ymd2, ittyp, itcls) <= 0 then
//	f_message_chk(50,'[주요제품(시리즈) A/S 현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ymd1, ymd2, ittyp, itcls) <= 0 then
	f_message_chk(50,'[주요제품(시리즈) A/S 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_title.text = dw_ip.object.titnm[1] +  " 주요제품 A/S 현황"
dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06590.create
call super::create
end on

on w_qct_06590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06590
end type

type p_exit from w_standard_print`p_exit within w_qct_06590
end type

type p_print from w_standard_print`p_print within w_qct_06590
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06590
end type







type st_10 from w_standard_print`st_10 within w_qct_06590
end type



type dw_print from w_standard_print`dw_print within w_qct_06590
string dataobject = "d_qct_06590_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06590
integer x = 23
integer y = 0
integer width = 1783
integer height = 268
string dataobject = "d_qct_06590_01"
end type

event dw_ip::itemchanged;string s_cod, s_ittyp, s_itcls, s_titnm

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ymd1" then
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[기준일자]")
		this.object.ymd1[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "ymd2" then
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[기준일자]")
		this.object.ymd2[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "itcls" then
	if IsNull(s_cod) or s_cod = "" then
		f_message_chk(30, "[시리즈]")
		this.object.itcls[1] = ""
	   this.object.titnm[1] = ""
		return 1
	end if	
	
	s_itcls = s_cod
	
	select ittyp, titnm into :s_ittyp, :s_titnm from itnct
	 where ittyp = '1' and itcls = :s_itcls;
	 
	if sqlca.sqlcode <> 0 then
		select ittyp, titnm into :s_ittyp, :s_titnm from itnct
	    where ittyp = '6' and itcls = :s_itcls;
		 
		if sqlca.sqlcode <> 0 then
	      f_message_chk(50, "[시리즈]")
		   this.object.itcls[1] = ""
	      this.object.titnm[1] = ""
			this.object.ittyp[1] = ""
		   return 1
	   end if
	end if	
	this.object.titnm[1] = s_titnm
	this.object.ittyp[1] = s_ittyp
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;gs_gubun = '1'  //완성품
SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "itcls" then
	open(w_itnct_m_popup2)
	this.object.itcls[1] = gs_code
	this.object.titnm[1] = gs_codename
	triggerevent(itemchanged!)
end if	
end event

type dw_list from w_standard_print`dw_list within w_qct_06590
string dataobject = "d_qct_06590_02"
end type

