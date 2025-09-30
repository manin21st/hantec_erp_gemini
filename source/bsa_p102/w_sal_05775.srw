$PBExportHeader$w_sal_05775.srw
$PBExportComments$년도별 영업팀별 분기 판매실적 그래프
forward
global type w_sal_05775 from w_standard_dw_graph
end type
end forward

global type w_sal_05775 from w_standard_dw_graph
string title = "년도별 영업팀별 분기 판매실적 그래프"
end type
global w_sal_05775 w_sal_05775

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syear0, syear1, syear2, sbigo 
Long   ix, nRow,iy
Double amt[12]

If dw_ip.AcceptText() <> 1 Then Return -1

syear0   = Trim(dw_ip.GetItemString(1,'syear'))
sbigo   = Trim(dw_ip.GetItemString(1,'bigo'))

If	f_datechk(syear0+'0101') <> 1 then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

syear1 = String(Long(syear0) - 1)
syear2 = String(Long(syear0) - 2)

/* 비교년도가 없을경우 전년도 */
If IsNull(sBigo) or sBigo = '' Then	sBigo = syear1

dw_list.SetRedraw(False)
dw_list.Reset()

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_list.retrieve(gs_sabu, syear2, syear1,syear0,sbigo,ls_silgu) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

amt[] = { 0,0,0,0,0,0,0,0,0,0,0,0 }
For ix = 0 To (dw_list.Rowcount()/12 - 1 )
	For iy = 1 To 12
		amt[iy] += dw_list.GetItemNumber(ix*12+iy,'amt')
	Next
Next

For ix = 1 To 12
	nRow = dw_list.InsertRow(0)
	dw_list.SetItem(nRow,'steamnm','전 체')
	dw_list.SetItem(nRow,'title',dw_list.GetItemString(ix,'title'))
	dw_list.SetItem(nRow,'amt',amt[ix])
Next

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05775.create
call super::create
end on

on w_sal_05775.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1,'syear',left(f_today(),4))

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05775
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05775
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05775
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05775
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05775
integer x = 1947
integer y = 2372
integer height = 72
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05775
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05775
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05775
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05775
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05775
integer x = 18
integer y = 20
integer width = 3259
integer height = 148
string dataobject = "d_sal_057751"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;Choose Case GetColumnName()
	Case "gubun"
		dw_list.SetRedraw(False)
		if this.GetText() = '1' then
			dw_list.DataObject = "d_sal_05775"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = '2' then
			dw_list.DataObject = "d_sal_05775_01"
			dw_list.Settransobject(sqlca)
		end if
		dw_list.SetRedraw(True)
End Choose
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05775
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05775
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05775
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05775
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05775
integer width = 4549
string dataobject = "d_sal_05775"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05775
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05775
integer width = 4581
end type

