$PBExportHeader$w_qct_t_10070.srw
$PBExportComments$**제품별 불량 현황 집계
forward
global type w_qct_t_10070 from w_standard_print
end type
type dw_1 from datawindow within w_qct_t_10070
end type
type pb_1 from u_pb_cal within w_qct_t_10070
end type
type pb_2 from u_pb_cal within w_qct_t_10070
end type
type rr_1 from roundrectangle within w_qct_t_10070
end type
end forward

global type w_qct_t_10070 from w_standard_print
string title = "제품별 불량 현황 집계"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_t_10070 w_qct_t_10070

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_frmdat, s_todat, s_frmemp, s_toemp, sJnpcrt1, sJnpcrt2, ls_fcvcod, ls_tcvcod

if dw_ip.AcceptText() = -1 then return -1

s_frmdat = trim(dw_ip.GetItemString(1,"s_frmdat"))
s_todat  = trim(dw_ip.GetItemString(1,"s_todat"))
s_frmemp  = dw_ip.GetItemString(1,"s_frmemp")
s_toemp   = dw_ip.GetItemString(1,"s_toemp")
ls_fcvcod   = dw_ip.GetItemString(1,"fcvcod")
ls_tcvcod   = dw_ip.GetItemString(1,"tcvcod")

//디폴트 입력값
IF (IsNull(s_frmdat) OR s_frmdat = "") THEN s_frmdat = "10000101"
IF (IsNull(s_todat) OR s_todat = "") THEN s_todat = "99991231"
IF (IsNull(ls_fcvcod) OR ls_fcvcod = "") THEN ls_fcvcod = "."
IF (IsNull(ls_tcvcod) OR ls_tcvcod = "") THEN ls_tcvcod = "ZZZZ"

IF IsNull(s_frmemp) THEN  
	s_frmemp = "."
END IF

IF IsNull(s_toemp) THEN
	s_toemp  = "ZZZZZZ"
END IF

// 상태구분에 따라 데이타윈도우 선택
sJnpcrt1 = '007'
sJnpcrt2 = '025'

//기간
dw_print.Object.t_date.Text = Mid(s_frmdat,1,4) + "." + Mid(s_frmdat,5,2) + "." + &
        Mid(s_frmdat,7,2) + "-" + Mid(s_todat,1,4) + "." + Mid(s_todat,5,2) + "." + &
	     Mid(s_todat,7,2)

//조회
IF dw_print.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp,ls_fcvcod,ls_tcvcod) < 1 THEN
	f_message_chk(50,"일일 품목별 입고현황")
	dw_ip.SetColumn('s_frmdat')
	dw_ip.SetFocus()
	return -1
Else
	dw_1.Retrieve(gs_sabu, s_frmdat, s_todat, s_frmemp, s_toemp,ls_fcvcod,ls_tcvcod)
END IF

dw_print.ShareData(dw_list)

Return 1
end function

on w_qct_t_10070.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_t_10070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

string  s_today, s_frmdate, s_todate, s_lastday, syymm

s_today = String(Today(), 'yyyymmdd')
s_frmdate = Mid(s_today,1,6) + "01"

syymm     = Mid(s_today,1,6)

  SELECT Max(substr(cldate, 7, 2))
    INTO :s_lastday  
	 FROM p4_calendar
   where cldate like :syymm||'%';

s_todate  = Mid(s_today,1,6) + s_lastday

dw_ip.SetItem(1, "s_frmdat", s_frmdate)		
dw_ip.SetItem(1, "s_todat", s_todate)

end event

type p_preview from w_standard_print`p_preview within w_qct_t_10070
end type

type p_exit from w_standard_print`p_exit within w_qct_t_10070
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_t_10070
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_t_10070
end type







type st_10 from w_standard_print`st_10 within w_qct_t_10070
end type



type dw_print from w_standard_print`dw_print within w_qct_t_10070
string dataobject = "d_qct_t_10070_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_t_10070
integer x = 18
integer y = 12
integer width = 2112
integer height = 228
string dataobject = "d_qct_t_10070_h"
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

type dw_list from w_standard_print`dw_list within w_qct_t_10070
integer x = 32
integer y = 292
integer width = 4562
integer height = 1536
string dataobject = "d_qct_t_10070_d"
boolean hscrollbar = false
boolean border = false
end type

type dw_1 from datawindow within w_qct_t_10070
integer x = 32
integer y = 1856
integer width = 4562
integer height = 440
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "월별 총입고 현황"
string dataobject = "d_qct_t_10070_d_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_qct_t_10070
integer x = 667
integer y = 36
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_frmdat')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_frmdat', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_t_10070
integer x = 1088
integer y = 36
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('s_todat')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 's_todat', gs_code)
end event

type rr_1 from roundrectangle within w_qct_t_10070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 280
integer width = 4599
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

