$PBExportHeader$w_sal_05770.srw
$PBExportComments$관할구역별 성장율 현황
forward
global type w_sal_05770 from w_standard_print
end type
end forward

global type w_sal_05770 from w_standard_print
string title = "관할구역별 성장율 현황"
end type
global w_sal_05770 w_sal_05770

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear4, syear3, syear2, syear1,syear0

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear0  = dw_ip.GetItemString(dw_ip.GetRow(),'syear')

IF	IsNull(syear0) or syear0 = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

syear1 = String(long(syear0) -1 )
syear2 = String(long(syear1) -1 )
syear3 = String(long(syear2) -1 )
syear4 = String(long(syear3) -1 )

dw_print.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_print.retrieve(gs_sabu, syear0, syear1,syear2,syear3,syear4,ls_silgu) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

dw_print.sharedata(dw_list)
dw_print.SetRedraw(True)

Return 1
end function

on w_sal_05770.create
call super::create
end on

on w_sal_05770.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syear',syymm)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_05770
end type

type p_exit from w_standard_print`p_exit within w_sal_05770
end type

type p_print from w_standard_print`p_print within w_sal_05770
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05770
end type







type st_10 from w_standard_print`st_10 within w_sal_05770
end type



type dw_print from w_standard_print`dw_print within w_sal_05770
string dataobject = "d_sal_05770_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05770
integer x = 27
integer y = 24
integer width = 3497
integer height = 216
string dataobject = "d_sal_05880_01"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_05770
integer x = 133
integer y = 268
integer width = 4462
integer height = 2056
string dataobject = "d_sal_05770"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

