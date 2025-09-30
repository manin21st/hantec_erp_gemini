$PBExportHeader$w_qct_05500.srw
$PBExportComments$교정 계측기 현황
forward
global type w_qct_05500 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_05500
end type
end forward

global type w_qct_05500 from w_standard_print
string title = "교정 계측기 현황"
rr_1 rr_1
end type
global w_qct_05500 w_qct_05500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	buncd, buncd1

//////////////////////////////////////////////////////////////////
if dw_ip.accepttext() = -1 then return -1

buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

//dw_list.object.txt_mchno.text = buncd + " - " + buncd1

if dw_list.Retrieve(gs_sabu, buncd, buncd1) <= 0 then
	f_message_chk(50,"[교정 계측기 현황]")
	dw_ip.Setfocus()
	return -1
end if

IF dw_print.Retrieve(gs_sabu, buncd, buncd1) <= 0 then
	f_message_chk(50,"[교정 계측기 현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
////////////////////////////////////////////////////////////////
//if dw_list.retrieve(gs_sabu,sfrno,stono,buncd) <= 0	then
//	f_message_chk(50,"[교정 계측기 현황]")
//	return -1
//end if
//Return 1
//
end function

on w_qct_05500.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_05500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;W_MDI_FRAME.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_qct_05500
end type

type p_exit from w_standard_print`p_exit within w_qct_05500
end type

type p_print from w_standard_print`p_print within w_qct_05500
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05500
end type







type st_10 from w_standard_print`st_10 within w_qct_05500
end type



type dw_print from w_standard_print`dw_print within w_qct_05500
string dataobject = "d_qct_05500_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05500
integer x = 73
integer y = 40
integer width = 2025
integer height = 152
string dataobject = "d_qct_05500_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

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

event dw_ip::itemchanged;call super::itemchanged;//string ls_buncd , s_cod
//
//s_cod = trim(this.gettext())
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
//		return 1
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
//		return 1
//	end if
//
//end if
//	
end event

type dw_list from w_standard_print`dw_list within w_qct_05500
integer x = 87
integer y = 200
integer width = 4489
integer height = 2108
string dataobject = "d_qct_05500"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_qct_05500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 196
integer width = 4512
integer height = 2124
integer cornerheight = 40
integer cornerwidth = 55
end type

