$PBExportHeader$w_sal_05610.srw
$PBExportComments$일일 수주미처리 적수 그래프
forward
global type w_sal_05610 from w_standard_dw_graph
end type
end forward

global type w_sal_05610 from w_standard_dw_graph
string title = "일일 수주미처리 적수 그래프"
end type
global w_sal_05610 w_sal_05610

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sCvgu, tx_name
Long   lDayCount


//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

sCvgu     = trim(dw_ip.getitemstring(1, 'sInOutGbn'))
If IsNull(sCvgu) or sCvgu = 'A' Then sCvgu = ''

lDayCount = dw_ip.getitemNumber(1, 'daycount')
If IsNull(lDaycount) Then lDayCount = 0

If dw_list.retrieve(gs_sabu, sCvgu+'%', lDayCount) < 1	Then
	f_message_chk(50,"")
	return -1
End if

// title 년월 설정

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sInOutGbn) ', 1)"))
If tx_name = '' Then tx_name = '전체'
dw_list.Object.txt_gubun.text = tx_name

dw_list.Object.txt_daycount.text = String(lDayCount)+'일 이상'

Return 1


end function

on w_sal_05610.create
call super::create
end on

on w_sal_05610.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_sal_05610
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05610
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05610
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05610
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05610
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05610
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05610
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05610
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05610
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05610
integer x = 41
integer width = 2697
integer height = 144
string dataobject = "d_sal_056103"
end type

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05610
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05610
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05610
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05610
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05610
integer y = 232
integer width = 4567
string dataobject = "d_sal_05610"
boolean border = false
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05610
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05610
integer y = 220
end type

