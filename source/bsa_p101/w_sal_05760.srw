$PBExportHeader$w_sal_05760.srw
$PBExportComments$제품별 성장율 현황
forward
global type w_sal_05760 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05760
end type
end forward

global type w_sal_05760 from w_standard_print
string title = "제품군별 성장율 현황"
rr_1 rr_1
end type
global w_sal_05760 w_sal_05760

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear4, syear3, syear2, syear1,syear0 ,ls_gubun

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear0  = dw_ip.GetItemString(dw_ip.GetRow(),'syear')
ls_gubun = trim(dw_ip.getitemstring(1,'gubun'))

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

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_print.retrieve(gs_sabu, syear0, syear1,syear2,syear3,syear4,ls_gubun,ls_silgu) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
else
	dw_print.sharedata(dw_list)
End if

if ls_gubun = '1' then
	dw_print.object.tx_1.text = '매출수량'
   dw_print.object.tx_2.text = '매출수량'
	dw_print.object.tx_3.text = '[수량별]'
else
	dw_print.object.tx_1.text = '매출액'
   dw_print.object.tx_2.text = '매출액'
	dw_print.object.tx_3.text = '[금액별]'
end if

Return 1
end function

on w_sal_05760.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05760.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syear',syymm)


end event

type p_preview from w_standard_print`p_preview within w_sal_05760
end type

type p_exit from w_standard_print`p_exit within w_sal_05760
end type

type p_print from w_standard_print`p_print within w_sal_05760
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05760
end type







type st_10 from w_standard_print`st_10 within w_sal_05760
end type



type dw_print from w_standard_print`dw_print within w_sal_05760
string dataobject = "d_sal_05760_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05760
integer x = 46
integer y = 36
integer width = 1399
integer height = 152
string dataobject = "d_sal_05880_01"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_05760
integer x = 59
integer y = 212
integer width = 4530
integer height = 2092
string dataobject = "d_sal_05760"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_05760
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 204
integer width = 4549
integer height = 2108
integer cornerheight = 40
integer cornerwidth = 55
end type

