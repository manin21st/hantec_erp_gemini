$PBExportHeader$w_qct_03530.srw
$PBExportComments$** 원인별 크레임 현황
forward
global type w_qct_03530 from w_standard_dw_graph
end type
type pb_2 from u_pb_cal within w_qct_03530
end type
type pb_1 from u_pb_cal within w_qct_03530
end type
end forward

global type w_qct_03530 from w_standard_dw_graph
integer width = 4640
string title = "원인별 크레임 현황"
pb_2 pb_2
pb_1 pb_1
end type
global w_qct_03530 w_qct_03530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sdate, edate

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
if dw_list.Retrieve(gs_sabu, sdate, edate) <= 0 then
   f_message_chk(50,'[원인별 크레임 현황]')
   dw_ip.Setfocus()
//	dw_list.insertrow(0)
   return -1
end if
	
return 1
end function

on w_qct_03530.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
end on

on w_qct_03530.destroy
call super::destroy
destroy(this.pb_2)
destroy(this.pb_1)
end on

type p_exit from w_standard_dw_graph`p_exit within w_qct_03530
end type

type p_print from w_standard_dw_graph`p_print within w_qct_03530
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_03530
end type

event p_retrieve::clicked;call super::clicked;pb_color.Enabled =False
pb_graph.Enabled =False
pb_space.Enabled =False
pb_title.Enabled =False

end event

type st_window from w_standard_dw_graph`st_window within w_qct_03530
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_03530
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_03530
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_03530
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_03530
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_03530
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_03530
integer x = 0
integer y = 40
integer width = 1262
integer height = 144
string dataobject = "d_qct_03560_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_03530
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_03530
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_03530
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_03530
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_03530
string dataobject = "d_qct_03530_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_03530
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_03530
end type

type pb_2 from u_pb_cal within w_qct_03530
integer x = 1088
integer y = 60
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_03530
integer x = 635
integer y = 60
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

