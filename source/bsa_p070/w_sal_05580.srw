$PBExportHeader$w_sal_05580.srw
$PBExportComments$월 영업 실적 현황
forward
global type w_sal_05580 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05580
end type
type rr_3 from roundrectangle within w_sal_05580
end type
end forward

global type w_sal_05580 from w_standard_print
string title = "월 영업 실적 현황"
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_05580 w_sal_05580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sRtn, sYear, sYmd, sPdatef, sPdatet, sSteamcd, sTempCd, sSteamNm,ls_gubun
Double  dAmt[10]
Long    nRow, ix

If dw_ip.AcceptText() <> 1 Then Return -1

sYmd = Trim(dw_ip.GetItemString(1,'sdate'))
ls_gubun = Trim(dw_ip.Getitemstring(1,'gubun'))

If	sYmd = '' or IsNull(sYmd) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	Return -1
End If

sYear = Left(sYmd,4)
sPdatef = f_aftermonth(sYmd, -4)
sPdatet = f_aftermonth(sYmd, -1)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_print.Retrieve(gs_sabu, sYear, sYmd, sPdatef, sPdatet,ls_gubun,ls_silgu ) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	dw_print.InsertRow(0)
//	return -1
ELSE
	dw_print.sharedata(dw_list)
End if

/* 영업팀별 합계 계산 */
nRow = dw_print.RowCount()
sSteamCd = dw_print.GetItemString(nRow,'steamcd')
damt = { 0,0,0,0,0,0,0,0,0 ,0}

ix = dw_print.InsertRow(0)
Do While True
  If nRow >= 1 Then
	  sTempCd = dw_print.GetItemString(nRow,'steamcd')
	Else
		sTempCd =''
	End If
	
	If sSteamCd <>  sTempCd Then
		select steamnm into : sSteamNm from steam where steamcd = :sSteamCd;
		
		dw_print.SetItem(ix,'sareanm',sSteamNm)
		dw_print.SetItem(ix,'amt1',dAmt[1])
		dw_print.SetItem(ix,'amt2',dAmt[2])
		dw_print.SetItem(ix,'amt3',dAmt[3])
		dw_print.SetItem(ix,'amt4',dAmt[4])
		dw_print.SetItem(ix,'amt5',dAmt[5])
		dw_print.SetItem(ix,'amt6',dAmt[6])
		dw_print.SetItem(ix,'amt7',dAmt[7])
		dw_print.SetItem(ix,'amt8',dAmt[8])

		/* 진척율 */
		If dAmt[1] <> 0 Then	dw_print.SetItem(ix,'rate1',round(dAmt[2] / dAmt[1],3))
	   
		/* 달성율 */
		If dAmt[3] <> 0 Then	dw_print.SetItem(ix,'rate2',round(dAmt[4] / dAmt[3],3))
		
		/* 신장율 */
		If dAmt[6] <> 0 Then	dw_print.SetItem(ix,'rate3',round( ( dAmt[4] - dAmt[6] ) / dAmt[6],3))
		
		/* 수금율 */
		If dAmt[7] <> 0 Then	dw_print.SetItem(ix,'rate4',round(dAmt[8] / dAmt[7],3))
		 
		If nRow > 1 Then
			sSteamcd = sTempCd
			damt = { 0,0,0,0,0,0,0,0,0,0 }
			ix = dw_print.InsertRow(nRow + 1)
		Else
			Exit
		End If
	End If

	dAmt[1] += dw_print.GetItemNumber(nRow,'amt1')
	dAmt[2] += dw_print.GetItemNumber(nRow,'amt2')
	dAmt[3] += dw_print.GetItemNumber(nRow,'amt3')
	dAmt[4] += dw_print.GetItemNumber(nRow,'amt4')
	dAmt[5] += dw_print.GetItemNumber(nRow,'amt5')
	dAmt[6] += dw_print.GetItemNumber(nRow,'amt6')
	dAmt[7] += dw_print.GetItemNumber(nRow,'amt7')
	dAmt[8] += dw_print.GetItemNumber(nRow,'amt8')

	nRow -= 1
Loop

/* 영업팀은 굵은글씨체로 바꿈 */
//For ix = 1 To dw_print.RowCount()
//	If dw_print.GetItemString(ix,'sarea') = '' Or	IsNull(dw_print.GetItemString(ix,'sarea')) Then
//		dw_print.Modify("sareanm_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt1_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt2_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt3_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt4_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt5_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt6_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt7_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("amt8_"+ string(ix) + ".Font.Weight='700'")
//		
//		dw_print.Modify("rate1_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("rate2_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("rate3_"+ string(ix) + ".Font.Weight='700'")
//		dw_print.Modify("rate4_"+ string(ix) + ".Font.Weight='700'")
//	End If
//Next

if ls_gubun = '1' then
	dw_print.object.tx_unit.text= "수량단위 : 개"
else
	dw_print.object.tx_unit.text= "금액단위 : 천원"
end if

return 1

end function

on w_sal_05580.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
end on

on w_sal_05580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6))

end event

type p_preview from w_standard_print`p_preview within w_sal_05580
end type

type p_exit from w_standard_print`p_exit within w_sal_05580
end type

type p_print from w_standard_print`p_print within w_sal_05580
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05580
end type







type st_10 from w_standard_print`st_10 within w_sal_05580
end type



type dw_print from w_standard_print`dw_print within w_sal_05580
string dataobject = "d_sal_05580_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05580
integer x = 69
integer y = 76
integer width = 1847
integer height = 96
string dataobject = "d_sal_05580_01"
end type

event dw_ip::itemchanged;String sNull

SetNull(sNull)

Choose Case GetColumnName()
   Case "sdate"
		if f_DateChk(Trim(this.getText())+'01') = -1 then
			this.SetItem(1, "sdate", sNull)
			f_Message_Chk(35, '[기준년월]')
			return 1
		end if
End Choose
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_05580
integer x = 59
integer y = 336
integer width = 4526
integer height = 1928
string dataobject = "d_sal_05580"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 64
integer width = 1947
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_05580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 304
integer width = 4571
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

