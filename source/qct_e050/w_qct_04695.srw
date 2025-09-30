$PBExportHeader$w_qct_04695.srw
$PBExportComments$** A/S처리 유/무상 현황
forward
global type w_qct_04695 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_04695
end type
end forward

global type w_qct_04695 from w_standard_print
string title = "A/S처리 유/무상 현황"
rr_1 rr_1
end type
global w_qct_04695 w_qct_04695

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gubun, sdate, edate

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

gubun = trim(dw_ip.object.gubun[1])
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
//if gubun = "%" then
//	dw_list.object.txt_gubun.text = "전체"
//elseif gubun = "1" then
//	dw_list.object.txt_gubun.text = "유상"
//elseif gubun = "2" then
//	dw_list.object.txt_gubun.text = "무상"
//end if	

//dw_list.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")
//if dw_list.Retrieve(gs_sabu, gubun, sdate, edate) <= 0 then
//	f_message_chk(50,'[A/S처리 유/무상 현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, gubun, sdate, edate) <= 0 then
	f_message_chk(50,'[A/S처리 유/무상 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_04695.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_04695.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_04695
end type

type p_exit from w_standard_print`p_exit within w_qct_04695
end type

type p_print from w_standard_print`p_print within w_qct_04695
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04695
end type







type st_10 from w_standard_print`st_10 within w_qct_04695
end type



type dw_print from w_standard_print`dw_print within w_qct_04695
string dataobject = "d_qct_04695_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04695
integer x = 91
integer y = 60
integer width = 2313
integer height = 160
string dataobject = "d_qct_04695_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod
s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if

end event

type dw_list from w_standard_print`dw_list within w_qct_04695
integer x = 114
integer y = 240
integer width = 4393
integer height = 2048
string dataobject = "d_qct_04695_02"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_qct_04695
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 101
integer y = 232
integer width = 4439
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

