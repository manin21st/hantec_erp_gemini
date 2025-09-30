$PBExportHeader$w_qct_03620.srw
$PBExportComments$claim및 무상서비스 그래프
forward
global type w_qct_03620 from w_standard_dw_graph
end type
end forward

global type w_qct_03620 from w_standard_dw_graph
string title = "CLAIM및 무상서비스 graph"
end type
global w_qct_03620 w_qct_03620

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  ls_yyyy

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_yyyy = trim(dw_ip.object.yyyy[1])

if (IsNull(ls_yyyy) or ls_yyyy = "")  then ls_yyyy = left(is_today, 4)

if dw_list.Retrieve(gs_sabu, ls_yyyy) <= 0 then
   f_message_chk(50,'[claim 및 무상서비스 graph]')
   dw_ip.Setfocus()
   return -1
end if
	
return 1
end function

on w_qct_03620.create
call super::create
end on

on w_qct_03620.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_qct_03620
end type

type p_print from w_standard_dw_graph`p_print within w_qct_03620
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_03620
end type

type st_window from w_standard_dw_graph`st_window within w_qct_03620
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_03620
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_03620
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_03620
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_03620
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_03620
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_03620
integer y = 52
integer width = 1303
integer height = 152
string dataobject = "d_qct_03620_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.gettext())

if this.GetColumnName() = "yyyy" then
	if IsNull(s_cod) or s_cod = "" then
		f_message_chk( 30,"[조건 년도]")
		return 1
	END IF
END IF




end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_03620
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_03620
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_03620
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_03620
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_03620
integer x = 37
integer width = 4576
integer height = 2076
string dataobject = "d_qct_03620_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_03620
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_03620
end type

