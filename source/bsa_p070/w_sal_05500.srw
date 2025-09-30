$PBExportHeader$w_sal_05500.srw
$PBExportComments$ ===> 일일 영업 실적 현황
forward
global type w_sal_05500 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05500
end type
type pb_1 from u_pb_cal within w_sal_05500
end type
type rr_2 from roundrectangle within w_sal_05500
end type
end forward

global type w_sal_05500 from w_standard_print
integer width = 4677
integer height = 2556
string title = "일일 영업 실적 현황"
rr_1 rr_1
pb_1 pb_1
rr_2 rr_2
end type
global w_sal_05500 w_sal_05500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sIlja, syy, sym, sdd, st_dd, sRate, symd1, symd2 , sSteamcd, sTempCd, sSteamNm
Long   cnt, t_cnt, ix, nRow
String sRtn
Double  dAmt[10]

If dw_ip.AcceptText() <> 1 Then Return -1

sIlja = Trim(dw_ip.GetItemString(1,'symd'))

If	(sIlja='') or isNull(sIlja) then
	f_Message_Chk(35, '[기준일자]')
	dw_ip.setcolumn('symd')
	dw_ip.setfocus()
	Return -1
End If

syy = Left(sIlja,4)
sym = Left(sIlja,6)

Select Count(*) Into :cnt From p4_calendar
Where substr(cldate,1,6) = :sym and cldate <= :sIlja and salehdaygu = 'N';
If IsNull(cnt) Then
	cnt = 0
End If

sdd = String(cnt)

Select Count(*) Into :t_cnt From p4_calendar
Where substr(cldate,1,6) = :sym and salehdaygu = 'N';
If isnull(t_cnt) Then
	t_cnt = 0
End If

st_dd = string(t_cnt)

If t_cnt = 0 Then
	sRate = '0'
Else
	sRate = String(cnt / t_cnt * 100,'#0.0')
End If

symd1 = Left(sIlja,4) + '년 ' + Mid(sIlja,5,2) + '월 ' + Right(sIlja,2) + '일'
symd2 = ' [' + sdd + '일 경과(' + sRate + '%)]'

//dw_list.object.r_date.Text = symd1 + symd2

dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

If dw_list.Retrieve(gs_sabu, syy, sym, sIlja, sdd, sym+'01',ls_silgu) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('symd')
	dw_ip.setfocus()
	dw_list.SetRedraw(True)
	return -1
End if

/* 영업팀별 합계 계산 */
nRow = dw_list.RowCount()
sSteamCd = dw_list.GetItemString(nRow,'steamcd')
damt = { 0,0,0,0,0,0,0,0,0 ,0}

ix = dw_list.InsertRow(0)
Do While True
  If nRow >= 1 Then
	  sTempCd = dw_list.GetItemString(nRow,'steamcd')
	Else
		sTempCd =''
	End If
	
	If sSteamCd <>  sTempCd Then
		select steamnm into : sSteamNm from steam where steamcd = :sSteamCd;
		
		dw_list.SetItem(ix,'sareanm',sSteamNm)
		dw_list.SetItem(ix,'amt1',dAmt[1])
		dw_list.SetItem(ix,'amt2',dAmt[2])
		dw_list.SetItem(ix,'amt3',dAmt[3])
		dw_list.SetItem(ix,'amt4',dAmt[4])
		dw_list.SetItem(ix,'amt5',dAmt[5])
		dw_list.SetItem(ix,'amt6',dAmt[6])
		dw_list.SetItem(ix,'amt7',dAmt[7])
		dw_list.SetItem(ix,'amt8',dAmt[8])
		dw_list.SetItem(ix,'amt9',dAmt[9])
		dw_list.SetItem(ix,'amt10',dAmt[10])
		
		If nRow > 1 Then
			sSteamcd = sTempCd
			damt = { 0,0,0,0,0,0,0,0,0,0 }
			ix = dw_list.InsertRow(nRow + 1)
		Else
			Exit
		End If
	End If

	dAmt[1] += dw_list.GetItemNumber(nRow,'amt1')
	dAmt[2] += dw_list.GetItemNumber(nRow,'amt2')
	dAmt[3] += dw_list.GetItemNumber(nRow,'amt3')
	dAmt[4] += dw_list.GetItemNumber(nRow,'amt4')
	dAmt[5] += dw_list.GetItemNumber(nRow,'amt5')
	dAmt[6] += dw_list.GetItemNumber(nRow,'amt6')
	dAmt[7] += dw_list.GetItemNumber(nRow,'amt7')
	dAmt[8] += dw_list.GetItemNumber(nRow,'amt8')
	dAmt[9] += dw_list.GetItemNumber(nRow,'amt9')
	dAmt[10] += dw_list.GetItemNumber(nRow,'amt10')

	nRow -= 1
Loop

/* 영업팀은 굵은글씨체로 바꿈 */
For ix = 1 To dw_list.RowCount()
	If dw_list.GetItemString(ix,'sarea') = '' Or	IsNull(dw_list.GetItemString(ix,'sarea')) Then
		dw_list.Modify("sareanm_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt1_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt2_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt3_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt4_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt5_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt6_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt7_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt8_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt9_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("amt10_"+ string(ix) + ".Font.Weight='700'")
		
		dw_list.Modify("rate1_"+ string(ix) + ".Font.Weight='700'")
		dw_list.Modify("rate2_"+ string(ix) + ".Font.Weight='700'")
	End If
Next

dw_list.SetRedraw(True)

return 1

end function

on w_sal_05500.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.pb_1=create pb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_sal_05500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.pb_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1,'symd',left(f_today(),8))

end event

type p_preview from w_standard_print`p_preview within w_sal_05500
end type

type p_exit from w_standard_print`p_exit within w_sal_05500
end type

type p_print from w_standard_print`p_print within w_sal_05500
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05500
end type







type st_10 from w_standard_print`st_10 within w_sal_05500
end type



type dw_print from w_standard_print`dw_print within w_sal_05500
string dataobject = "d_sal_05500"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05500
integer x = 87
integer y = 40
integer height = 192
string dataobject = "d_sal_05500_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull

//dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	// 기준일자 유효성 Check
   Case "symd"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "symd", sNull)
			f_Message_Chk(35, '[기준일자]')
			return 1
		end if
end Choose
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_05500
integer x = 50
integer y = 280
integer width = 4553
integer height = 2032
string dataobject = "d_sal_05500"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 24
integer width = 3835
integer height = 224
integer cornerheight = 40
integer cornerwidth = 46
end type

type pb_1 from u_pb_cal within w_sal_05500
integer x = 786
integer y = 96
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('symd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'symd', gs_code)

end event

type rr_2 from roundrectangle within w_sal_05500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 272
integer width = 4571
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 46
end type

