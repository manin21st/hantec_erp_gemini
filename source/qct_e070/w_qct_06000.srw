$PBExportHeader$w_qct_06000.srw
$PBExportComments$계측기 이력카드
forward
global type w_qct_06000 from w_standard_print
end type
end forward

global type w_qct_06000 from w_standard_print
string title = " 계측기 이력카드"
end type
global w_qct_06000 w_qct_06000

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string mchno1, mchno2, gubun, buncd, buncd1

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

//mchno1 = trim(dw_ip.object.mchno1[1])
//mchno2 = trim(dw_ip.object.mchno2[1])
gubun = trim(dw_ip.object.gubun[1])
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

dw_list.SetFilter("") //구분 => ALL
dw_list.Filter( )

if gubun = "2" then //구분 => 보유
   dw_list.SetFilter("IsNull(pedat) or pedat = ''")
	dw_list.Filter( )
elseif gubun = "3" then //구분 => 폐기
	dw_list.SetFilter("not (IsNull(pedat) or pedat = '')")
	dw_list.Filter( )
end if	

//if dw_list.Retrieve(gs_sabu, buncd, buncd1) <= 0 then
//	f_message_chk(50,"[계측기 이력 카드-[기본정보]]")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, buncd, buncd1) <= 0 then
	f_message_chk(50,"[계측기 이력 카드-[기본정보]]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06000.create
call super::create
end on

on w_qct_06000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06000
end type

type p_exit from w_standard_print`p_exit within w_qct_06000
end type

type p_print from w_standard_print`p_print within w_qct_06000
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06000
end type







type st_10 from w_standard_print`st_10 within w_qct_06000
end type



type dw_print from w_standard_print`dw_print within w_qct_06000
string dataobject = "d_qct_06000_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06000
integer x = 23
integer y = 0
integer width = 1883
integer height = 284
string dataobject = "d_qct_06000_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;//String  s_cod, s_nam1, ls_buncd
//
//s_cod = Trim(this.getText())
//
//if this.GetColumnName() = "buncd" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//        FROM mchmst
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
//  		setitem(1 , "buncd1", '')
//		return 2 
//	end if
//	
//end if
//
//
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

//if this.GetColumnName() = "mchno1" then
//	gs_gubun = 'ALL'
//	gs_code  = '계측기'
//	open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	
//	this.object.mchno1[1] = gs_code
//	this.object.mchnam1[1] = gs_codename
//elseif this.GetColumnName() = "mchno2" then
//	gs_gubun = 'ALL'
//	gs_code  = '계측기'
//   open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.object.mchno2[1] = gs_code
//	this.object.mchnam2[1] = gs_codename
//elseif this.GetColumnName() = "buncd" then
//	gs_gubun = 'Y'
//	open(w_mittyp_popup)
//	if isnull(gs_code) or gs_code = '' then return
//	this.object.buncd[1] = gs_code
//	this.object.bunnam[1] = gs_codename
//end if



end event

type dw_list from w_standard_print`dw_list within w_qct_06000
string dataobject = "d_qct_06000_02"
end type

