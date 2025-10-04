$PBExportHeader$w_pdt_03640.srw
$PBExportComments$** 종합효율현황
forward
global type w_pdt_03640 from w_standard_dw_graph
end type
end forward

global type w_pdt_03640 from w_standard_dw_graph
string title = "종합효율현황"
end type
global w_pdt_03640 w_pdt_03640

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string yyyy, gubun  

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

yyyy = Trim(dw_ip.object.yyyy[1])
gubun = Trim(dw_ip.object.gubun[1])  

if (IsNull(yyyy) or yyyy = "")  then 
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
end if

if gubun = '1' then 
	dw_list.DataObject = "d_pdt_03640_04"
elseif gubun = '2' then 
	dw_list.DataObject = "d_pdt_03640_07"
else
	dw_list.DataObject = "d_pdt_03640_10"
end if
dw_list.SetTransObject(SQLCA)

if dw_list.Retrieve(gs_sabu, yyyy, '.') <= 0 then
	f_message_chk(50,'[종합 효율 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_pdt_03640.create
call super::create
end on

on w_pdt_03640.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_pdt_03640
integer x = 4375
end type

type p_print from w_standard_dw_graph`p_print within w_pdt_03640
integer x = 4192
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_pdt_03640
integer x = 4000
integer y = 32
end type

type st_window from w_standard_dw_graph`st_window within w_pdt_03640
integer x = 3360
integer y = 1952
end type

type st_popup from w_standard_dw_graph`st_popup within w_pdt_03640
end type

type pb_title from w_standard_dw_graph`pb_title within w_pdt_03640
integer x = 2830
integer y = 28
end type

type pb_space from w_standard_dw_graph`pb_space within w_pdt_03640
integer x = 3013
integer y = 40
end type

type pb_color from w_standard_dw_graph`pb_color within w_pdt_03640
integer x = 2629
integer y = 36
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_pdt_03640
integer x = 2400
integer y = 36
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_pdt_03640
integer x = 32
integer y = 4
integer width = 2185
integer height = 260
string dataobject = "d_pdt_03640_01"
end type

type sle_msg from w_standard_dw_graph`sle_msg within w_pdt_03640
integer x = 1381
integer y = 1952
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_pdt_03640
integer x = 3854
integer y = 1952
integer width = 745
end type

type st_10 from w_standard_dw_graph`st_10 within w_pdt_03640
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_pdt_03640
integer x = 3675
integer y = 32
end type

type dw_list from w_standard_dw_graph`dw_list within w_pdt_03640
integer y = 280
integer height = 2036
string dataobject = "d_pdt_03640_04"
boolean border = false
end type

event dw_list::doubleclicked;//

end event

type gb_10 from w_standard_dw_graph`gb_10 within w_pdt_03640
integer x = 1006
integer y = 1900
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_pdt_03640
integer y = 264
integer height = 2068
end type

