$PBExportHeader$w_qct_06060.srw
$PBExportComments$계측기 일상점검 기록표
forward
global type w_qct_06060 from w_standard_print
end type
end forward

global type w_qct_06060 from w_standard_print
string title = "계측기 점검 기록표"
end type
global w_qct_06060 w_qct_06060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, mchno1, mchno2, buncd, buncd1, gubun
Long i, j, k

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = trim(dw_ip.object.ym[1])
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])
gubun  = trim(dw_ip.object.gubun[1])

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

//if (IsNull(ym) or ym = "") then 
//	f_message_chk(1400,"[기준년월]")
//	dw_ip.SetColumn("ym")
//	dw_ip.Setfocus()
//	return -1
//end if	
//
if gubun = '1' then     // 일상점검 
	dw_list.dataobject = 'd_qct_06060_02'
	dw_print.dataobject = 'd_qct_06060_02'
elseif gubun = '2' then // 정기점검 
	dw_list.dataobject = 'd_qct_06060_03'
	dw_print.dataobject = 'd_qct_06060_03'
end if

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
	
////dw_list.object.datawindow.print.preview = "no"
////dw_list.object.txt_ym.text = String(ym,"@@@@년 @@월")
//if dw_list.Retrieve(gs_sabu, buncd, buncd1 ) <= 0 then
//	f_message_chk(50,"[계측기 점검 기록표]")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, buncd, buncd1 ) <= 0 then
	f_message_chk(50,"[계측기 점검 기록표]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

if gubun = '1' then
	SetPointer(HourGlass!)
	dw_list.setredraw(false)
	mchno1 = dw_list.object.mchno[1]
	j = 0
	for i = 1 to dw_list.RowCount()
		 if IsNull(Trim(dw_list.object.mchno[i])) or Trim(dw_list.object.mchno[i]) = "" then
			 continue 
		 else	
			 mchno2 = dw_list.object.mchno[i]	
		 end if	 
		 if mchno1 = mchno2 then 
			 j++
		 else 	
			 mchno1 = mchno2
			 for k = 1 to 20 - j
				  dw_list.InsertRow(i)
			 next	
			 j = 0
		 end if	 
	next	
	
	for k = 1 to 20 - j
		 dw_list.InsertRow(0)
	next	
	dw_list.setredraw(true)
	
	setpointer(Arrow!)

end if
	
return 1

end function

on w_qct_06060.create
call super::create
end on

on w_qct_06060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;sle_msg.Text = "조회버튼을 CLICK한 다음 출력버튼이 활성화 될 때까지 기다리세요!" 
end event

type p_preview from w_standard_print`p_preview within w_qct_06060
end type

type p_exit from w_standard_print`p_exit within w_qct_06060
end type

type p_print from w_standard_print`p_print within w_qct_06060
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06060
end type







type st_10 from w_standard_print`st_10 within w_qct_06060
end type



type dw_print from w_standard_print`dw_print within w_qct_06060
string dataobject = "d_qct_06060_03"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06060
integer y = 0
integer width = 2139
integer height = 252
string dataobject = "d_qct_06060_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam, ls_buncd

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35,"[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if	
	
end if

return


end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "buncd" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	
elseif this.GetColumnName() = "buncd1" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd1[1] = gs_code
		
end if	
end event

type dw_list from w_standard_print`dw_list within w_qct_06060
string dataobject = "d_qct_06060_03"
end type

