$PBExportHeader$w_sal_05950.srw
$PBExportComments$영업팀/관할구역/담당자별 분기 영업실적 현황
forward
global type w_sal_05950 from w_standard_print
end type
type dw_rate from datawindow within w_sal_05950
end type
type rr_1 from roundrectangle within w_sal_05950
end type
end forward

global type w_sal_05950 from w_standard_print
string title = "분기 영업실적 현황"
dw_rate dw_rate
rr_1 rr_1
end type
global w_sal_05950 w_sal_05950

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear,sgu, sTeamcd
string   ar_year1,ar_year2,ar_mm1,ar_mm2,ar_mm3
Long     ix,iy,nRow,iord,rCnt,row
dec      ord1,ord2,dals_rate,sugum_rate,sungj_rate,jumsu
Double   dDamboAmt, dExDamAmt
Double   dSaleJumsu, dSungjJumsu, dSugumJumsu, dHoijunJumsu, dDamboJumsu, dTotalJumsu

String   sBaseGu

If dw_ip.accepttext() <> 1 Then Return 0

ar_year1 = trim(dw_ip.getitemstring(1, 'syear'))
ar_year2 = String(Long(ar_year1)-1)
sgu    = trim(dw_ip.getitemstring(1, 'gu'))

/* 1:영업팀, 2:관할구역 */
sBaseGu    = Trim(dw_ip.getitemstring(1, 'base_gu'))

IF	IsNull(ar_year1) or ar_year1 = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

IF	IsNull(sgu) or sgu = '' then
	f_message_chk(1400,'[분기]')
	dw_ip.setcolumn('gu')
	dw_ip.setfocus()
	Return -1
END IF

Choose Case sgu
	Case '1'
		ar_mm1 = '01' ; ar_mm2 = '02' ; ar_mm3 = '03'
	Case '2'
		ar_mm1 = '04' ; ar_mm2 = '05' ; ar_mm3 = '06'
	Case '3'
		ar_mm1 = '07' ; ar_mm2 = '08' ; ar_mm3 = '09'
	Case '4'
		ar_mm1 = '10' ; ar_mm2 = '11' ; ar_mm3 = '12'
End Choose

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

nRow = dw_print.retrieve(gs_sabu, ar_year1, ar_year2, ar_mm1, ar_mm2, ar_mm3, sgu,ls_silgu)
If nRow < 1	Then
	f_message_chk(50,"")
	dw_ip.setcolumn('gu')
	dw_ip.setfocus()
	Return -1
else
	dw_print.sharedata(dw_list)
End If

/* 목표달성율(내수) */
If dw_rate.Retrieve(gs_sabu,ar_year1,'1',sBaseGu) > 0 Then
	dw_rate.SetSort('par_value d')
	dw_rate.Sort()
	
	For ix = 1 To nRow
		
		sTeamCd = dw_print.GetItemString(ix,'steamcd')
		If Left(sTeamCd,1) = '2' Then Continue

		dals_rate = dw_print.GetItemNumber(ix,'rate2')
	
		row = dw_rate.Find("par_value < " + string(dals_rate*100),1,dw_rate.RowCount())	
		If row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If

		dw_print.SetItem(ix,'sales_jumsu',jumsu)
	Next
End If

/* 목표달성율(해외) */
If dw_rate.Retrieve(gs_sabu,ar_year1,'5',sBaseGu) > 0 Then
	dw_rate.SetSort('par_value d')
	dw_rate.Sort()
	
	For ix = 1 To nRow
		
		sTeamCd = dw_print.GetItemString(ix,'steamcd')
		If Left(sTeamCd,1) = '1' Then Continue

		dals_rate = dw_print.GetItemNumber(ix,'rate2')
	
		row = dw_rate.Find("par_value < " + string(dals_rate*100),1,dw_rate.RowCount())	
		If row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If

		dw_print.SetItem(ix,'sales_jumsu',jumsu)
	Next
End If

/* 성장율  */
If dw_rate.Retrieve(gs_sabu,ar_year1,'2',sBaseGu) > 0 Then
	dw_rate.SetSort('par_value d')
	dw_rate.Sort()
	
	For ix = 1 To nRow
		sungj_rate = dw_print.GetItemNumber(ix,'rate3')
		row = dw_rate.Find("par_value < " + string(sungj_rate*100),1,dw_rate.RowCount())	
		If row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If

		dw_print.SetItem(ix,'sungj_jumsu',jumsu)
	Next
End If

/* 수금율  */
If dw_rate.Retrieve(gs_sabu,ar_year1,'3',sBaseGu) > 0 Then
	dw_rate.SetSort('par_value d')
	dw_rate.Sort()
	
	For ix = 1 To nRow
		sugum_rate = dw_print.GetItemNumber(ix,'rate4')
		row = dw_rate.Find("par_value < " + string(sugum_rate*100),1,dw_rate.RowCount())
		If row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If

		dw_print.SetItem(ix,'sugum_jumsu',jumsu)
	Next
End If

/* 분기회전일 */
If dw_rate.Retrieve(gs_sabu,ar_year1,'4',sBaseGu) > 0 Then
	dw_rate.SetSort('par_value d')
	dw_rate.Sort()
	
	For ix = 1 To nRow
		sugum_rate = dw_print.GetItemNumber(ix,'hoijun')
		row = dw_rate.Find("par_value < " + string(sugum_rate),1,dw_rate.RowCount())
		If row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If

		dw_print.SetItem(ix,'hoijun_jumsu',jumsu)
	Next
End If

/* 담보대비 초과율 설정 */
For ix = 1 To nRow
	dDamboAmt = dw_print.GetItemNumber(ix,'dambo_amt')
	dExDamAmt = dw_print.GetItemNumber(ix,'exdam_amt')
	If IsNull(dDamboAmt) or dDamBoAmt = 0 Then
		dw_print.SetItem(ix,'rate5',0)
	Else
		dw_print.SetItem(ix,'rate5', dExDamAmt / dDamBoAmt)
	End If
Next

/* 담보대비수금율 */
If dw_rate.Retrieve(gs_sabu,ar_year1,'6',sBaseGu) > 0 Then
	dw_rate.SetSort('par_value d')
	dw_rate.Sort()
	
	For ix = 1 To nRow
		sugum_rate = dw_print.GetItemNumber(ix,'rate5')
		row = dw_rate.Find("par_value < " + string(sugum_rate*100),1,dw_rate.RowCount())
		If row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If

		dw_print.SetItem(ix,'dambo_jumsu',jumsu)
	Next
End If

/* 총점수 설정 */
For ix = 1 To nRow
	dSaleJumsu   = dw_print.GetItemNumber(ix,'sales_jumsu')
	dSungjJumsu  = dw_print.GetItemNumber(ix,'sungj_jumsu')
	dSugumJumsu  = dw_print.GetItemNumber(ix,'sugum_jumsu')
	dHoijunJumsu = dw_print.GetItemNumber(ix,'hoijun_jumsu')
	dDamboJumsu  = dw_print.GetItemNumber(ix,'dambo_jumsu')
	dTotalJumsu = dSaleJumsu + dSungjJumsu + dSugumJumsu + dHoijunJumsu + dDamboJumsu

	dw_print.SetItem(ix,'total_jumsu', dTotalJumsu)
Next

Return 1


end function

on w_sal_05950.create
int iCurrent
call super::create
this.dw_rate=create dw_rate
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rate
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_05950.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rate)
destroy(this.rr_1)
end on

event open;call super::open;dw_rate.SetTransObject(sqlca)  /* 기준 점수 */
 
dw_ip.SetItem(1,'syear',Left(f_today(),4))

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_05950
end type

type p_exit from w_standard_print`p_exit within w_sal_05950
end type

type p_print from w_standard_print`p_print within w_sal_05950
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05950
end type







type st_10 from w_standard_print`st_10 within w_sal_05950
end type



type dw_print from w_standard_print`dw_print within w_sal_05950
string dataobject = "d_sal_059501_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05950
integer x = 37
integer y = 24
integer width = 3712
integer height = 176
string dataobject = "d_sal_05950_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;Choose Case GetColumnName()
	/* 자료구분 */
	Case 'base_gu'
		dw_list.SetRedraw(False)
		IF GetText() = '1' THEN													/* 영업팀 */
			dw_list.DataObject = 'd_sal_059501'
			dw_print.DataObject = 'd_sal_059501_p'
		ELSEIF GETTEXT() = '2' THEN   										/* 관할구역 */
			dw_list.DataObject = 'd_sal_05950'
			dw_print.DataObject = 'd_sal_05950_p'
		ELSE                                                        /* 영업담당자 */
			dw_list.DataObject = 'd_sal_05950_10'
			dw_print.DataObject = 'd_sal_05950_10_p'
		END IF
		dw_print.SetTransObject(SQLCA)
		dw_list.SetTransObject(SQLCA)
		dw_list.SetRedraw(True)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_05950
integer x = 55
integer y = 224
integer width = 4521
integer height = 2088
string dataobject = "d_sal_059501"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type dw_rate from datawindow within w_sal_05950
boolean visible = false
integer x = 722
integer y = 2356
integer width = 1522
integer height = 360
boolean bringtotop = true
string dataobject = "d_sal_05960"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sal_05950
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 216
integer width = 4549
integer height = 2112
integer cornerheight = 40
integer cornerwidth = 55
end type

