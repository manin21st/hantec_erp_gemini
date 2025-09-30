$PBExportHeader$w_sal_05776.srw
$PBExportComments$년도별 동분기 대비 판매성장 그래프
forward
global type w_sal_05776 from w_standard_dw_graph
end type
end forward

global type w_sal_05776 from w_standard_dw_graph
string title = "년도별 동분기 대비 판매성장 그래프"
end type
global w_sal_05776 w_sal_05776

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syear0, syear1, syear2, syear3, sMM, sMM1,sMM2,sMM3, sTeamCd, tx_name, sPrtGbn
Long   ix, nRow,iy
Double amt[4]

If dw_ip.AcceptText() <> 1 Then Return -1

syear0   = Trim(dw_ip.GetItemString(1,'syear'))
sMM   = Trim(dw_ip.GetItemString(1,'mm'))

sTeamCd   = Trim(dw_ip.GetItemString(1,'deptcode'))
If IsNull(sTeamCd) Then sTeamCd = ''

sPrtGbn   = Trim(dw_ip.GetItemString(1,'prtgbn'))

If	f_datechk(syear0+'0101') <> 1 then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

If	IsNull(sMM) or sMM = '' then
	f_Message_Chk(35, '분기]')
	dw_ip.setcolumn('mm')
	dw_ip.setfocus()
	Return -1
End if

syear1 = String(Long(syear0) - 1)
syear2 = String(Long(syear0) - 2)
syear3 = String(Long(syear0) - 3)

/* 분기별 월 */
Choose Case sMM
	Case '1'
		sMM1 = '01'; sMM2 = '02'; sMM3 = '03'
	Case '2'
		sMM1 = '04'; sMM2 = '05'; sMM3 = '06'
	Case '3'
		sMM1 = '07'; sMM2 = '08'; sMM3 = '09'
	Case '4'
		sMM1 = '10'; sMM2 = '11'; sMM3 = '12'
End Choose

dw_list.SetRedraw(False)
dw_list.Reset()

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_list.retrieve(gs_sabu, syear3, syear2, syear1,syear0, sMM1, sMM2, sMM3, sTeamCd+'%' ,ls_silgu) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

amt[] = { 0,0,0,0,0,0,0,0,0,0,0,0 }
For ix = 0 To ( dw_list.RowCount()/4 - 1 )
	For iy = 1 To 4
		amt[iy] += dw_list.GetItemNumber(ix*4+iy,'amt')
	Next
Next

/* 합계 */
dw_list.Modify("sum1.expression = '" + string(amt[1]) + "'")
dw_list.Modify("sum2.expression = '" + string(amt[2]) + "'")
dw_list.Modify("sum3.expression = '" + string(amt[3]) + "'")
dw_list.Modify("sum4.expression = '" + string(amt[4]) + "'")

If sPrtgbn = '2' Then
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")
End If

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05776.create
call super::create
end on

on w_sal_05776.destroy
call super::destroy
end on

event open;call super::open;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
dw_ip.setitem(1,'syear',left(f_today(),4))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05776
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05776
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05776
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05776
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05776
integer x = 1947
integer y = 2372
integer height = 72
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05776
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05776
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05776
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05776
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05776
integer x = 9
integer y = 0
integer width = 3909
integer height = 156
string dataobject = "d_sal_057761"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;
Choose Case GetColumnName()
	Case "prtgbn"
		dw_list.SetRedraw(False)
		if this.GetText() = '1' then
			dw_list.DataObject = "d_sal_05776"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = '2' then
			dw_list.DataObject = "d_sal_05776a"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = '0' then
			dw_list.DataObject = "d_sal_05776b"
			dw_list.Settransobject(sqlca)
		end if
		dw_list.SetRedraw(True)
End Choose
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05776
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05776
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05776
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05776
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05776
integer y = 212
integer width = 4553
integer height = 2100
string dataobject = "d_sal_05776"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05776
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05776
integer y = 200
integer width = 4585
integer height = 2132
end type

