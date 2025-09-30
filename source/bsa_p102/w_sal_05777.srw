$PBExportHeader$w_sal_05777.srw
$PBExportComments$전분기 대비 영업팀별 판매성장 추이 그래프
forward
global type w_sal_05777 from w_standard_dw_graph
end type
end forward

global type w_sal_05777 from w_standard_dw_graph
string title = "전분기 대비 판매성장 추이 그래프"
end type
global w_sal_05777 w_sal_05777

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syear, sMM, syymm1,syymm2,syymm3,syymm4,syymm5,syymm6,sTeamCd,sPrtGbn,tx_name
Long   ix, nRow,iy
Double amt[6]

If dw_ip.AcceptText() <> 1 Then Return -1

syear = Trim(dw_ip.GetItemString(1,'syear'))
sMM   = Trim(dw_ip.GetItemString(1,'mm'))

sTeamCd   = Trim(dw_ip.GetItemString(1,'deptcode'))
If IsNull(sTeamCd) Then sTeamCd = ''

sPrtGbn   = Trim(dw_ip.GetItemString(1,'prtgbn'))

If	f_datechk(syear+'0101') <> 1 then
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

If sPrtgbn = '2' Then
	If	IsNull(sTeamCd) or sTeamCd = '' then
		f_Message_Chk(1400, '[영업팀]')
		dw_ip.setcolumn('deptcode')
		dw_ip.setfocus()
		Return -1
	End if
End If


/* 분기별 월 */
Choose Case sMM
	Case '1'
		sYYmm6 = sYear+'03'
	Case '2'
		sYYmm6 = sYear+'06'
	Case '3'
		sYYmm6 = sYear+'09'
	Case '4'
		sYYmm6 = sYear+'12'
End Choose

select to_char(add_months(to_date(:sYYmm6,'yyyymm'), -1),'yyyymm'),
		 to_char(add_months(to_date(:sYYmm6,'yyyymm'), -2),'yyyymm'),
		 to_char(add_months(to_date(:sYYmm6,'yyyymm'), -3),'yyyymm'),
		 to_char(add_months(to_date(:sYYmm6,'yyyymm'), -4),'yyyymm'),
		 to_char(add_months(to_date(:sYYmm6,'yyyymm'), -5),'yyyymm')
  into :sYYmm5, :sYYmm4, :sYYmm3,:sYYmm2,  :sYYmm1
  from dual;

dw_list.SetRedraw(False)
dw_list.Reset()

string ls_silgu

SELECT DATANAME
INTO :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND
      SERIAL = '8' AND
      LINENO = '40' ;

If dw_list.retrieve(gs_sabu, syymm1,syymm2,syymm3,syymm4,syymm5,syymm6, sTeamCd,ls_silgu ) <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
End if

amt[] = { 0,0,0,0,0,0}
For ix = 1 To dw_list.RowCount()
	amt[1] += dw_list.GetItemNumber(ix,'amt1')
	amt[2] += dw_list.GetItemNumber(ix,'amt2')
	amt[3] += dw_list.GetItemNumber(ix,'amt3')
	amt[4] += dw_list.GetItemNumber(ix,'amt4')
	amt[5] += dw_list.GetItemNumber(ix,'amt5')
	amt[6] += dw_list.GetItemNumber(ix,'amt6')
Next

nRow = dw_list.InsertRow(0)
dw_list.SetItem(nRow, 'title','합 계')
dw_list.SetItem(nRow, 'amt1',amt[1])
dw_list.SetItem(nRow, 'amt2',amt[2])
dw_list.SetItem(nRow, 'amt3',amt[3])
dw_list.SetItem(nRow, 'amt4',amt[4])
dw_list.SetItem(nRow, 'amt5',amt[5])
dw_list.SetItem(nRow, 'amt6',amt[6])


If sPrtgbn = '2' Then
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")
End If

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05777.create
call super::create
end on

on w_sal_05777.destroy
call super::destroy
end on

event open;call super::open;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
dw_ip.setitem(1,'syear',left(f_today(),4))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05777
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05777
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05777
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05777
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05777
integer x = 1947
integer y = 2372
integer height = 72
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05777
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05777
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05777
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05777
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05777
integer x = 32
integer y = 28
integer width = 3794
integer height = 140
string dataobject = "d_sal_05777_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;
Choose Case GetColumnName()
	Case "prtgbn"
		dw_list.SetRedraw(False)
		if this.GetText() = '1' then
			dw_list.DataObject = "d_sal_05777"
			dw_list.Settransobject(sqlca)
		elseif this.GetText() = '2' then
			dw_list.DataObject = "d_sal_057771"
			dw_list.Settransobject(sqlca)
		end if
		dw_list.SetRedraw(True)
End Choose
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05777
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05777
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05777
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05777
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05777
integer y = 212
integer width = 4553
integer height = 2096
string dataobject = "d_sal_05777"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05777
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05777
integer y = 200
integer width = 4585
integer height = 2128
end type

