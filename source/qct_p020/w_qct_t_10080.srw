$PBExportHeader$w_qct_t_10080.srw
$PBExportComments$**월 업체별 불량현황
forward
global type w_qct_t_10080 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_t_10080
end type
end forward

global type w_qct_t_10080 from w_standard_print
string title = "월 업체별 불량현황(수입검사)"
rr_1 rr_1
end type
global w_qct_t_10080 w_qct_t_10080

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_frmdat, ls_fcvcod, ls_tcvcod

if dw_ip.AcceptText() = -1 then return -1

s_frmdat = trim(dw_ip.GetItemString(1,"s_frmdat"))
ls_fcvcod   = dw_ip.GetItemString(1,"fcvcod")
ls_tcvcod   = dw_ip.GetItemString(1,"tcvcod")

//디폴트 입력값
IF (IsNull(s_frmdat) OR s_frmdat = "") THEN 
	f_message_chk(35,"기준년월") 
	return -1
End If

IF (IsNull(ls_fcvcod) OR ls_fcvcod = "") THEN ls_fcvcod = "."
IF (IsNull(ls_tcvcod) OR ls_tcvcod = "") THEN ls_tcvcod = "ZZZZ"

//기간
//dw_print.Object.t_date.Text = Mid(s_frmdat,1,4) + "." + Mid(s_frmdat,5,2) + "." + &
//        Mid(s_frmdat,7,2) + "-" + Mid(s_todat,1,4) + "." + Mid(s_todat,5,2) + "." + &
//	     Mid(s_todat,7,2)

//조회
IF dw_print.Retrieve(gs_sabu, ls_fcvcod,ls_tcvcod, s_frmdat) < 1 THEN
	f_message_chk(50,"월 업체별 불량현황")
	dw_ip.SetColumn('s_frmdat')
	dw_ip.SetFocus()
	return -1
END IF

dw_print.ShareData(dw_list)

Return 1
end function

on w_qct_t_10080.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_t_10080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string  s_today, s_frmdate, s_todate, s_lastday, syymm

s_today = String(Today(), 'yyyymmdd')
syymm     = Mid(s_today,1,6)
dw_ip.SetItem(1, "s_frmdat", syymm)		

///* 생산팀 & 영업팀 & 관할구역 Filtering */
///* 생산팀 & 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child
//integer rtncode
//
////담당자1
//rtncode 	= dw_ip.GetChild('s_frmemp', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자1")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve('45',gs_saupj)
//
////담당자2
//rtncode 	= dw_ip.GetChild('s_toemp', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자2")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve('45',gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_qct_t_10080
end type

type p_exit from w_standard_print`p_exit within w_qct_t_10080
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_t_10080
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_t_10080
end type







type st_10 from w_standard_print`st_10 within w_qct_t_10080
end type



type dw_print from w_standard_print`dw_print within w_qct_t_10080
string dataobject = "d_qct_t_10080_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_t_10080
integer x = 18
integer y = 12
integer width = 1600
integer height = 140
string dataobject = "d_qct_t_10080_h"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String s_col

this.AcceptText()
s_col = this.GetColumnName()
if s_col = "s_frmdate" then
	if IsNull(trim(this.object.s_frmdate[1])) or trim(this.object.s_frmdate[1]) = "" then return 
	if f_datechk(trim(this.object.s_frmdate[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.s_frmdate[1]) + "]")
		this.object.s_frmdate[1] = ""
		return 1
	end if
elseif s_col = "s_todate" then
	if IsNull(trim(this.object.s_todate[1])) or trim(this.object.s_todate[1]) = "" then return 
	if f_datechk(trim(this.object.s_todate[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.s_todate[1]) + "]")
		this.object.s_todate[1] = ""
		return 1
	end if
end if
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'fcvcod'	THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"fcvcod",		gs_code)
//	SetItem(1,"fcvnm",  gs_codename)
ELSEIF this.GetColumnName() = 'tcvcod'	THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"tcvcod",	gs_code)
//	SetItem(1,"tcvnm",  gs_codename)
END IF
end event

type dw_list from w_standard_print`dw_list within w_qct_t_10080
integer x = 32
integer y = 204
integer width = 4562
integer height = 2108
string dataobject = "d_qct_t_10080_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_t_10080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 192
integer width = 4599
integer height = 2132
integer cornerheight = 40
integer cornerwidth = 55
end type

