$PBExportHeader$w_qct_06010.srw
$PBExportComments$계측기 점검 기준표
forward
global type w_qct_06010 from w_standard_print
end type
end forward

global type w_qct_06010 from w_standard_print
string title = "계측기/주유 점검 기준표"
end type
global w_qct_06010 w_qct_06010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string mchno1, mchno2, sfilter, buncd, buncd1

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sfilter = trim(dw_ip.object.sfilter[1])
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

dw_list.dataobject = "d_qct_06010_02"
dw_print.dataobject = "d_qct_06010_02"
if sfilter = '%' then 
	dw_list.SetFilter("")
elseif sfilter = '1' then 
	dw_list.SetFilter("mchmst_insp_inspday = '1'")
elseif  sfilter = '2' then
	dw_list.SetFilter("mchmst_insp_inspday = '2'")
else  
	dw_list.dataobject = "d_qct_06010_03" 
	dw_print.dataobject = "d_qct_06010_03" 
end if

dw_list.settransobject(sqlca)	
dw_print.settransobject(sqlca)	

dw_list.filter()

//if dw_list.Retrieve(gs_sabu, buncd, buncd1) <= 0 then
//		f_message_chk(50,"[계측기/주유 점검 기준표]")
//		dw_ip.Setfocus()
//		return -1
//end if

IF dw_print.Retrieve(gs_sabu, buncd, buncd1) <= 0 then
	f_message_chk(50,"[계측기/주유 점검 기준표]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06010.create
call super::create
end on

on w_qct_06010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06010
end type

type p_exit from w_standard_print`p_exit within w_qct_06010
end type

type p_print from w_standard_print`p_print within w_qct_06010
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06010
end type







type st_10 from w_standard_print`st_10 within w_qct_06010
end type



type dw_print from w_standard_print`dw_print within w_qct_06010
string dataobject = "d_qct_06010_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06010
integer y = 0
integer width = 2213
integer height = 244
string dataobject = "d_qct_06010_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;//String  s_cod, s_nam1, s_nam2, ls_buncd
//integer i_rtn
//
//s_cod = Trim(this.GetText())
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
//                setitem(1 , "buncd", '')
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
//      		setitem(1 , "buncd1", '')
//		return 2 
//	end if
//end if

end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
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

type dw_list from w_standard_print`dw_list within w_qct_06010
integer x = 0
integer y = 260
string dataobject = "d_qct_06010_02"
end type

