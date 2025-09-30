$PBExportHeader$w_sal_06770.srw
$PBExportComments$===> 년도별 매출추이분석
forward
global type w_sal_06770 from w_standard_dw_graph
end type
end forward

global type w_sal_06770 from w_standard_dw_graph
end type
global w_sal_06770 w_sal_06770

type variables
string a_yyyy, a_fmyyyy
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
dw_ip.AcceptText()

a_yyyy   = trim(dw_ip.GetItemString(1,'a_yy'))
a_fmyyyy = string(integer(a_yyyy) - 9,'0000')

//기준년도 CHECK
if	(a_yyyy = '') or isNull(a_yyyy) or integer(a_yyyy) <= 1990 then           
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('a_yy')
	dw_ip.setfocus()
	Return -1 
end if

string ls_silgu 

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_list.Retrieve(gs_sabu, a_yyyy,a_fmyyyy,ls_silgu) <= 0 then
   f_message_chk(50,'[년도별 매출추이 분석]')
   dw_ip.setcolumn('a_yy')
   return -1
end if

return 1
end function

on w_sal_06770.create
call super::create
end on

on w_sal_06770.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_sal_06770
end type

type p_print from w_standard_dw_graph`p_print within w_sal_06770
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_06770
end type

type st_window from w_standard_dw_graph`st_window within w_sal_06770
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_06770
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_06770
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_06770
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_06770
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_06770
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_06770
integer x = 27
integer y = 24
integer width = 576
integer height = 136
string dataobject = "d_sal_06770"
end type

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_06770
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_06770
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_06770
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_06770
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_06770
integer y = 208
integer height = 2096
string dataobject = "d_sal_06770_01"
boolean border = false
boolean hsplitscroll = true
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_06770
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_06770
integer y = 196
integer height = 2128
end type

