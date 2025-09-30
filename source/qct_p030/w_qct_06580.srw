$PBExportHeader$w_qct_06580.srw
$PBExportComments$** 부품품목분류별(부품에 대한 제품) A/S 현황
forward
global type w_qct_06580 from w_standard_print
end type
end forward

global type w_qct_06580 from w_standard_print
string title = "부품 품목분류별 A/S 현황"
end type
global w_qct_06580 w_qct_06580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, itcls, titnm, sym, eym, ym1, ym2, sittyp

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])
sittyp = Trim(dw_ip.object.ittyp[1])
itcls = Trim(dw_ip.object.itcls[1])
titnm = Trim(dw_ip.object.titnm[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(itcls) or itcls = "")  then 
	f_message_chk(30, "[품목분류]")
	dw_ip.SetColumn("itcls")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(titnm) or titnm = "")  then 
	f_message_chk(30, "[품목분류명]")
	dw_ip.SetColumn("itcls")
	dw_ip.Setfocus()
	return -1
end if

eym = Mid(f_today(),1,6)
sym = f_aftermonth(eym, -5)

ym1 = f_aftermonth(ym, -4)
ym2 = ym

//dw_list.object.txt_itcls.text = dw_ip.object.itcls[1] + " " + dw_ip.object.titnm[1]
//dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 품목분류별 A/S 현황")
//
//if dw_list.Retrieve(gs_sabu, ym, sittyp, itcls, sym, eym, ym1, ym2, titnm) <= 0 then
//	f_message_chk(50,'[품목분류별 A/S 현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ym, sittyp, itcls, sym, eym, ym1, ym2, titnm) <= 0 then
	f_message_chk(50,'[품목분류별 A/S 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_itcls.text = dw_ip.object.itcls[1] + " " + dw_ip.object.titnm[1]
dw_print.object.txt_title.text = String(ym,"@@@@년 @@월 품목분류별 A/S 현황")
dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06580.create
call super::create
end on

on w_qct_06580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06580
end type

type p_exit from w_standard_print`p_exit within w_qct_06580
end type

type p_print from w_standard_print`p_print within w_qct_06580
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06580
end type







type st_10 from w_standard_print`st_10 within w_qct_06580
end type



type dw_print from w_standard_print`dw_print within w_qct_06580
string dataobject = "d_qct_06580_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06580
integer x = 46
integer y = 0
integer width = 1915
integer height = 188
string dataobject = "d_qct_06580_01"
end type

event dw_ip::itemchanged;string scod, snam, scod1

scod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(scod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "itcls" then
	if IsNull(scod) or scod = "" then
		f_message_chk(50, "[품목분류]")
	   this.object.titnm[1] = ""
		return 1
	end if	
	
	scod1 = this.getitemstring(1, "ittyp")
	
	select titnm into :snam from itnct
	 where ittyp = :scod1 and itcls = :scod;
	 
	if sqlca.sqlcode <> 0 then
		this.object.titnm[1] = ""
	else
		this.object.titnm[1] = snam
	end if	
end if


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "itcls" then
	gs_gubun = this.getitemstring(1, "ittyp") 
	open(w_itnct_popup)
	this.object.itcls[1] = gs_code
	this.object.titnm[1] = gs_codename
	return
end if	
end event

type dw_list from w_standard_print`dw_list within w_qct_06580
string dataobject = "d_qct_06580_02"
end type

