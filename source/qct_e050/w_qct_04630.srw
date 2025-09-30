$PBExportHeader$w_qct_04630.srw
$PBExportComments$**접수형태별원인별 A/S현황(그래프)
forward
global type w_qct_04630 from w_standard_dw_graph
end type
type dw_1 from u_key_enter within w_qct_04630
end type
end forward

global type w_qct_04630 from w_standard_dw_graph
string title = "접수형태별 원인별 A/S현황"
dw_1 dw_1
end type
global w_qct_04630 w_qct_04630

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, rcvlog, sText

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
rcvlog = trim(dw_ip.object.rcvlog[1])
 
if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if isnull(rcvlog) or rcvlog = '' then
   rcvlog = "%"
	sText = '전체'
else
	sText = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(rcvlog) ', 1)"))
end if

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@ - ") + String(edate,"@@@@.@@.@@") 
dw_list.object.txt_rcvlog.text = sText

if dw_list.Retrieve(gs_sabu, sdate, edate, rcvlog) <= 0 then
	f_message_chk(50,'[LOT별 A/S 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_qct_04630.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_qct_04630.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.ReSet()
dw_1.InsertRow(0)
end event

type p_exit from w_standard_dw_graph`p_exit within w_qct_04630
end type

type p_print from w_standard_dw_graph`p_print within w_qct_04630
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_04630
end type

event p_retrieve::clicked;call super::clicked;string gubun

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if

gubun = trim(dw_1.object.gubun[1])

if gubun <> "2" then
   pb_color.Enabled =False
   pb_graph.Enabled =False
   pb_space.Enabled =False
   pb_title.Enabled =False
end if	
end event

type st_window from w_standard_dw_graph`st_window within w_qct_04630
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_04630
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_04630
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_04630
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_04630
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_04630
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_04630
integer x = 987
integer y = 56
integer width = 2089
integer height = 148
string dataobject = "d_qct_04630_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String s_cod

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

event dw_ip::itemerror;call super::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_04630
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_04630
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_04630
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_04630
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_04630
integer x = 37
integer width = 4576
integer height = 2080
string dataobject = "d_qct_04620_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_04630
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_04630
end type

type dw_1 from u_key_enter within w_qct_04630
integer y = 60
integer width = 1010
integer height = 168
integer taborder = 5
boolean bringtotop = true
string dataobject = "d_qct_04630_00"
boolean border = false
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_list.SetReDraw(False)
if gubun = "1" then //자료
	dw_list.DataObject = "d_qct_04620_02"
elseif gubun = "2" then	//그래프
	dw_list.DataObject = "d_qct_04630_02"
end if	

dw_list.SetTransObject(SQLCA)
dw_list.ReSet()
dw_list.SetReDraw(True)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

return
end event

