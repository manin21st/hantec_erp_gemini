$PBExportHeader$w_pdt_03620.srw
$PBExportComments$**설비가동율현황
forward
global type w_pdt_03620 from w_standard_dw_graph
end type
type dw_1 from datawindow within w_pdt_03620
end type
end forward

global type w_pdt_03620 from w_standard_dw_graph
string title = "설비 가동율 현황"
dw_1 dw_1
end type
global w_pdt_03620 w_pdt_03620

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve1 ()
end prototypes

public function integer wf_retrieve ();string  gubun
integer i_rtn

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

gubun = Trim(dw_1.object.gubun[1])

if gubun = "1" then
	i_rtn = wf_retrieve1()
else
	i_rtn = wf_retrieve2()
end if

return i_rtn
end function

public function integer wf_retrieve2 ();string yyyy, gubun

if dw_ip.accepttext() = -1 then return -1


yyyy = Trim(dw_ip.object.yyyy[1])
if (IsNull(yyyy) or yyyy = "")  then 
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
end if

//gubun = Trim(dw_ip.object.gubun[1])
//if gubun = "1" then //설비별
//   dw_list.DataObject = "d_pdt_03750_02"
//else                //생산팀별
//   dw_list.DataObject = "d_pdt_03750_12"	
//end if	
//
//dw_list.SetTransObject(SQLCA)	
//
dw_list.object.txt_title.text = String(yyyy,"@@@@년 기종별 설비 가동율 현황")

if dw_list.Retrieve(gs_sabu, yyyy) <= 0 then
	f_message_chk(50,'[기종별 설비 가동율 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public function integer wf_retrieve1 ();string ym

if dw_ip.accepttext() = -1 then return -1

ym = Trim(dw_ip.object.ym[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 기종별 설비 가동율 현황")
dw_list.object.gr_1.title = String(ym,"@@@@년 @@월 기종별 가동율 현황")
dw_list.object.gr_2.title = String(ym,"@@@@년 @@월 기종별 효율 현황")

if dw_list.Retrieve(gs_sabu, ym) <= 0 then
	f_message_chk(50,'[설비 가동율 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_pdt_03620.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_pdt_03620.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)
end event

type p_exit from w_standard_dw_graph`p_exit within w_pdt_03620
integer x = 4370
integer y = 40
end type

type p_print from w_standard_dw_graph`p_print within w_pdt_03620
integer x = 4197
integer y = 40
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_pdt_03620
integer x = 4023
integer y = 40
end type

type st_window from w_standard_dw_graph`st_window within w_pdt_03620
integer x = 3296
integer y = 1956
end type

type st_popup from w_standard_dw_graph`st_popup within w_pdt_03620
integer x = 2592
integer y = 2068
end type

type pb_title from w_standard_dw_graph`pb_title within w_pdt_03620
integer x = 649
integer y = 1124
end type

type pb_space from w_standard_dw_graph`pb_space within w_pdt_03620
integer x = 471
integer y = 1124
end type

type pb_color from w_standard_dw_graph`pb_color within w_pdt_03620
integer x = 293
integer y = 1124
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_pdt_03620
integer x = 114
integer y = 1124
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_pdt_03620
integer x = 1143
integer y = 92
integer width = 1595
integer height = 108
integer taborder = 20
string dataobject = "d_pdt_03620_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "yyyy" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '0101') = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.ym[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_pdt_03620
integer x = 1317
integer y = 1956
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_pdt_03620
integer x = 3790
integer y = 1956
end type

type st_10 from w_standard_dw_graph`st_10 within w_pdt_03620
integer x = 960
integer y = 1956
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_pdt_03620
end type

type dw_list from w_standard_dw_graph`dw_list within w_pdt_03620
integer x = 37
integer width = 4567
integer height = 2080
string dataobject = "d_pdt_03620_02"
boolean border = false
end type

event dw_list::doubleclicked;RETURN 1
end event

event dw_list::ue_rbuttonup;RETURN 1
end event

event dw_list::rbuttondown;RETURN 1
end event

type gb_10 from w_standard_dw_graph`gb_10 within w_pdt_03620
integer x = 942
integer y = 1904
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_pdt_03620
end type

type dw_1 from datawindow within w_pdt_03620
integer x = 73
integer y = 24
integer width = 1042
integer height = 184
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_03620_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //설비가동율 현황
   dw_ip.DataObject = "d_pdt_03620_01"
	dw_list.DataObject = "d_pdt_03620_02"
elseif gubun = "2" then	//기종별 설비가동율 현황
   dw_ip.DataObject = "d_pdt_03750_01"
	dw_list.DataObject = "d_pdt_03750_02"
end if	

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_list.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetReDraw(True)
dw_list.SetReDraw(True)

pb_color.Enabled =False
pb_graph.Enabled =False
pb_space.Enabled =False
pb_title.Enabled =False

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

end event

