$PBExportHeader$w_qct_06020.srw
$PBExportComments$계측기 정기점검 계획서
forward
global type w_qct_06020 from w_standard_print
end type
end forward

global type w_qct_06020 from w_standard_print
string title = "계측기 정기 점검 계획서(년간)"
end type
global w_qct_06020 w_qct_06020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String yyyy  , s_mchno , e_mchno, buncd, buncd1
Long   i, j

if dw_ip.accepttext() = -1 then return -1

yyyy    = Trim(dw_ip.object.yyyy[1])
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

if IsNull(yyyy) or yyyy = "" then
	f_message_chk(30,"[기준년도]")
	dw_ip.SetColumn('yyyy')
	dw_ip.Setfocus()
	return -1
end if

//dw_list.object.txt_title.text = String(yyyy,"@@@@년 계측기 정기 점검 계획서")
//
//if dw_list.Retrieve(gs_sabu,  yyyy, buncd, buncd1 ) <= 0 then
//	dw_list.setredraw(true)
//	f_message_chk(50,"[정기 점검 계획서(년간)]")
//	return -1
//end if	

IF dw_print.Retrieve(gs_sabu,  yyyy, buncd, buncd1 ) <= 0 then
	f_message_chk(50,"[정기 점검 계획서(년간)]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_title.text = String(yyyy,"@@@@년 계측기 정기 점검 계획서")
dw_print.ShareData(dw_list)

return 1

end function

on w_qct_06020.create
call super::create
end on

on w_qct_06020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1, 'yyyy', left(is_today, 4))
end event

type p_preview from w_standard_print`p_preview within w_qct_06020
end type

type p_exit from w_standard_print`p_exit within w_qct_06020
end type

type p_print from w_standard_print`p_print within w_qct_06020
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06020
end type







type st_10 from w_standard_print`st_10 within w_qct_06020
end type



type dw_print from w_standard_print`dw_print within w_qct_06020
string dataobject = "d_qct_06020_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06020
integer x = 46
integer y = 0
integer width = 1234
integer height = 248
string dataobject = "d_qct_06020_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;//String  s_cod, ls_buncd
//
////s_cod = Trim(this.GetText())
////
////if this.GetColumnName() = "yyyy" then 
////	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod + '0101') = -1 then
////		f_message_chk(35,"[기준년도]")
////		this.object.yyyy[1] = ""
////		return 1
////	end if	
////end if
////
//   s_cod = trim(this.gettext())
//	
//if this.GetColumnName() = "buncd" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//   FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//      setitem(1 , "buncd", '')
//		return 2 
//	end if
//
//elseif this.GetColumnName() = "buncd1" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//	FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//      setitem(1 , "buncd1", '')
//		return 2 
//	end if
//end if
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

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

type dw_list from w_standard_print`dw_list within w_qct_06020
integer x = 0
integer y = 284
string dataobject = "d_qct_06020_02"
end type

