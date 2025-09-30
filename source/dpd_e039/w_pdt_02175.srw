$PBExportHeader$w_pdt_02175.srw
$PBExportComments$** 지원이력현황
forward
global type w_pdt_02175 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_02175
end type
type pb_2 from u_pb_cal within w_pdt_02175
end type
type rr_1 from roundrectangle within w_pdt_02175
end type
end forward

global type w_pdt_02175 from w_standard_print
string title = "지원인력현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_02175 w_pdt_02175

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ymd1, ymd2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ymd1 = trim(dw_ip.object.ymd1[1])
ymd2 = trim(dw_ip.object.ymd2[1])

if (IsNull(ymd1) or ymd1 = "")  then ymd1 = "11110101"
if (IsNull(ymd2) or ymd2 = "")  then ymd2 = "99991231"

if dw_print.Retrieve(gs_sabu, ymd1, ymd2) <= 0 then
	f_message_chk(50,'[지원이력현황]')
	dw_ip.Setfocus()
	return -1
end if
   
	dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_02175.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_02175.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.object.ymd1[1] = f_today()
dw_ip.object.ymd2[1] = f_today()

end event

type p_preview from w_standard_print`p_preview within w_pdt_02175
end type

type p_exit from w_standard_print`p_exit within w_pdt_02175
end type

type p_print from w_standard_print`p_print within w_pdt_02175
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02175
end type







type st_10 from w_standard_print`st_10 within w_pdt_02175
end type



type dw_print from w_standard_print`dw_print within w_pdt_02175
string dataobject = "d_pdt_02175_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02175
integer x = 73
integer y = 28
integer width = 1317
integer height = 140
string dataobject = "d_pdt_02175_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ymd1" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.ymd1[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "ymd2" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.ymd2[1] = ""
		return 1
	end if
end if


end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02175
integer x = 82
integer y = 200
integer width = 4517
integer height = 2096
boolean bringtotop = true
string dataobject = "d_pdt_02175_02"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_pdt_02175
integer x = 699
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('ymd1')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'ymd1', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02175
integer x = 1147
integer y = 52
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('ymd2')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'ymd2', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02175
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 192
integer width = 4539
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

