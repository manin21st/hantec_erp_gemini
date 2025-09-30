$PBExportHeader$w_sal_05681.srw
$PBExportComments$월별 전년대비 생산금액 대 판매금액 현황
forward
global type w_sal_05681 from w_standard_dw_graph
end type
end forward

global type w_sal_05681 from w_standard_dw_graph
string title = "월별 전년대비 생산금액 대 판매금액 현황"
end type
global w_sal_05681 w_sal_05681

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String	syear, spyear

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear  = dw_ip.GetItemString(1,'syear')

IF	IsNull(syear) or syear = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

dw_list.SetRedraw(False)

spyear = String(Long(syear) -1)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_list.retrieve(gs_sabu, spyear, syear,ls_silgu) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

dw_list.SetRedraw(True)

Return 0

end function

on w_sal_05681.create
call super::create
end on

on w_sal_05681.destroy
call super::destroy
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syear',syymm)


end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05681
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05681
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05681
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05681
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05681
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05681
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05681
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05681
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05681
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05681
integer x = 32
integer y = 40
integer height = 132
string dataobject = "d_sal_05880_02"
end type

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05681
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05681
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05681
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05681
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05681
integer y = 212
integer height = 2096
string dataobject = "d_sal_05681"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05681
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05681
integer y = 200
integer height = 2128
end type

