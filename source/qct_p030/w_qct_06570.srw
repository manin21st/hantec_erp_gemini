$PBExportHeader$w_qct_06570.srw
$PBExportComments$** 월별 품질현황
forward
global type w_qct_06570 from w_standard_dw_graph
end type
end forward

global type w_qct_06570 from w_standard_dw_graph
string title = "월별 품질현황"
end type
global w_qct_06570 w_qct_06570

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

dw_list.object.txt_title.text = String(yyyy,"@@@@년 월별 품질현황(불합격율)")

if dw_list.Retrieve(gs_sabu, yyyy, gubun) <= 0 then
	f_message_chk(50,'[월별 품질현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_qct_06570.create
call super::create
end on

on w_qct_06570.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_qct_06570
end type

type p_print from w_standard_dw_graph`p_print within w_qct_06570
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_06570
end type

event p_retrieve::clicked;call super::clicked;pb_color.Enabled =False
pb_graph.Enabled =False
pb_space.Enabled =False
pb_title.Enabled =False

end event

type st_window from w_standard_dw_graph`st_window within w_qct_06570
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_06570
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_06570
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_06570
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_06570
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_06570
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_06570
integer x = 37
integer y = 0
integer width = 1394
integer height = 180
string dataobject = "d_qct_06570_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "yyyy" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '0101') = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.yyyy[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_06570
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_06570
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_06570
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_06570
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_06570
string dataobject = "d_qct_06570_02"
end type

event dw_list::doubleclicked;//
end event

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_06570
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_06570
end type

