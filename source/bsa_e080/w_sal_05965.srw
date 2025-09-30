$PBExportHeader$w_sal_05965.srw
$PBExportComments$영업팀/관할구역 분기평가 처리
forward
global type w_sal_05965 from w_inherite
end type
type gb_3 from groupbox within w_sal_05965
end type
type gb_2 from groupbox within w_sal_05965
end type
type dw_key from u_key_enter within w_sal_05965
end type
type dw_list from datawindow within w_sal_05965
end type
type dw_rate from datawindow within w_sal_05965
end type
end forward

global type w_sal_05965 from w_inherite
int Width=3648
boolean TitleBar=true
string Title="분기평가처리"
WindowState WindowState=normal!
event ue_open pbm_custom01
gb_3 gb_3
gb_2 gb_2
dw_key dw_key
dw_list dw_list
dw_rate dw_rate
end type
global w_sal_05965 w_sal_05965

type variables

end variables

forward prototypes
public function integer wf_key_check ()
public function integer wf_retrieve ()
public function integer wf_key_protect (string gb)
end prototypes

public function integer wf_key_check ();Long nRow
String sYear, sBun

If dw_key.AcceptText() <> 1 Then Return -1

sYear = dw_key.GetItemString(1,'syear')
sBun  = dw_key.GetItemString(1,'gu')

If IsNull(sYear) Or sYear = '' Then
   f_message_chk(1400,'[기준년도]')
	dw_key.SetFocus()
	dw_key.SetColumn('syear')
	Return -1
End If

If IsNull(sBun) Or sBun = '' Then
   f_message_chk(1400,'[분기]')
	dw_key.SetFocus()
	dw_key.SetColumn('gu')
	Return -1
End If

Return 1
end function

public function integer wf_retrieve ();string	syear,sgu, sTeamcd
string   ar_year1,ar_year2,ar_mm1,ar_mm2,ar_mm3
Long     ix,iy,nRow,iord,rCnt,row
dec      ord1,ord2,dals_rate,sugum_rate,sungj_rate,jumsu
Double   dDamboAmt, dExDamAmt
Double   dSaleJumsu, dSungjJumsu, dSugumJumsu, dHoijunJumsu, dDamboJumsu, dTotalJumsu

String   sBaseGu

If dw_key.accepttext() <> 1 Then Return 0

ar_year1 = trim(dw_key.getitemstring(1, 'syear'))
ar_year2 = String(Long(ar_year1)-1)
sgu    = trim(dw_key.getitemstring(1, 'gu'))

/* 1:영업팀, 2:관할구역,3:영업담당자  */
sBaseGu    = Trim(dw_key.getitemstring(1, 'base_gu'))

IF	IsNull(ar_year1) or ar_year1 = '' then
	f_message_chk(1400,'[기준년도]')
	dw_key.setcolumn('syear')
	dw_key.setfocus()
	Return -1
END IF

IF	IsNull(sgu) or sgu = '' then
	f_message_chk(1400,'[분기]')
	dw_key.setcolumn('gu')
	dw_key.setfocus()
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

dw_list.SetRedraw(False)

		nRow = dw_list.retrieve(gs_sabu, ar_year1, ar_year2, ar_mm1, ar_mm2, ar_mm3, sgu)
		If nRow < 1	Then
			f_message_chk(50,"")
			dw_key.setcolumn('gu')
			dw_key.setfocus()
			Return -1
		End If
		
		/* 목표달성율(내수) */
		If dw_rate.Retrieve(gs_sabu,ar_year1,'1',sBaseGu) > 0 Then
			dw_rate.SetSort('par_value d')
			dw_rate.Sort()
			
			For ix = 1 To nRow
				
				sTeamCd = dw_list.GetItemString(ix,'steamcd')
				If Left(sTeamCd,1) = '2' Then Continue
		
				dals_rate = dw_list.GetItemNumber(ix,'rate2')
			
				row = dw_rate.Find("par_value < " + string(dals_rate*100),1,dw_rate.RowCount())	
				If row > 0 Then
					jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
				Else
					jumsu = 0
				End If
		
				dw_list.SetItem(ix,'sales_jumsu',jumsu)
			Next
		End If
		
		/* 목표달성율(해외) */
		If dw_rate.Retrieve(gs_sabu,ar_year1,'5',sBaseGu) > 0 Then
			dw_rate.SetSort('par_value d')
			dw_rate.Sort()
			
			For ix = 1 To nRow
				
				sTeamCd = dw_list.GetItemString(ix,'steamcd')
				If Left(sTeamCd,1) = '1' Then Continue
		
				dals_rate = dw_list.GetItemNumber(ix,'rate2')
			
				row = dw_rate.Find("par_value < " + string(dals_rate*100),1,dw_rate.RowCount())	
				If row > 0 Then
					jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
				Else
					jumsu = 0
				End If
		
				dw_list.SetItem(ix,'sales_jumsu',jumsu)
			Next
		End If
		
		/* 성장율  */
		If dw_rate.Retrieve(gs_sabu,ar_year1,'2',sBaseGu) > 0 Then
			dw_rate.SetSort('par_value d')
			dw_rate.Sort()
			
			For ix = 1 To nRow
				sungj_rate = dw_list.GetItemNumber(ix,'rate3')
				row = dw_rate.Find("par_value < " + string(sungj_rate*100),1,dw_rate.RowCount())	
				If row > 0 Then
					jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
				Else
					jumsu = 0
				End If
		
				dw_list.SetItem(ix,'sungj_jumsu',jumsu)
			Next
		End If
		
		/* 수금율  */
		If dw_rate.Retrieve(gs_sabu,ar_year1,'3',sBaseGu) > 0 Then
			dw_rate.SetSort('par_value d')
			dw_rate.Sort()
			
			For ix = 1 To nRow
				sugum_rate = dw_list.GetItemNumber(ix,'rate4')
				row = dw_rate.Find("par_value < " + string(sugum_rate*100),1,dw_rate.RowCount())
				If row > 0 Then
					jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
				Else
					jumsu = 0
				End If
		
				dw_list.SetItem(ix,'sugum_jumsu',jumsu)
			Next
		End If
		
		/* 분기회전일 */
		If dw_rate.Retrieve(gs_sabu,ar_year1,'4',sBaseGu) > 0 Then
			dw_rate.SetSort('par_value d')
			dw_rate.Sort()
			
			For ix = 1 To nRow
				sugum_rate = dw_list.GetItemNumber(ix,'hoijun')
				row = dw_rate.Find("par_value < " + string(sugum_rate),1,dw_rate.RowCount())
				If row > 0 Then
					jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
				Else
					jumsu = 0
				End If
		
				dw_list.SetItem(ix,'hoijun_jumsu',jumsu)
			Next
		End If
		
		/* 담보대비 초과율 설정 */
		For ix = 1 To nRow
			dDamboAmt = dw_list.GetItemNumber(ix,'dambo_amt')
			dExDamAmt = dw_list.GetItemNumber(ix,'exdam_amt')
			If IsNull(dDamboAmt) or dDamBoAmt = 0 Then
				dw_list.SetItem(ix,'rate5',0)
			Else
				dw_list.SetItem(ix,'rate5', dExDamAmt / dDamBoAmt)
			End If
		Next
		
		/* 담보대비수금율 */
		If dw_rate.Retrieve(gs_sabu,ar_year1,'6',sBaseGu) > 0 Then
			dw_rate.SetSort('par_value d')
			dw_rate.Sort()
			
			For ix = 1 To nRow
				sugum_rate = dw_list.GetItemNumber(ix,'rate5')
				row = dw_rate.Find("par_value < " + string(sugum_rate*100),1,dw_rate.RowCount())
				If row > 0 Then
					jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
				Else
					jumsu = 0
				End If
		
				dw_list.SetItem(ix,'dambo_jumsu',jumsu)
			Next
		End If
		
		/* 총점수 설정 */
		For ix = 1 To nRow
			dSaleJumsu   = dw_list.GetItemNumber(ix,'sales_jumsu')
			dSungjJumsu  = dw_list.GetItemNumber(ix,'sungj_jumsu')
			dSugumJumsu  = dw_list.GetItemNumber(ix,'sugum_jumsu')
			dHoijunJumsu = dw_list.GetItemNumber(ix,'hoijun_jumsu')
			dDamboJumsu  = dw_list.GetItemNumber(ix,'dambo_jumsu')
			dTotalJumsu = dSaleJumsu + dSungjJumsu + dSugumJumsu + dHoijunJumsu + dDamboJumsu
		
			dw_list.SetItem(ix,'total_jumsu', dTotalJumsu)
		Next


dw_list.SetRedraw(True)

Return 1


end function

public function integer wf_key_protect (string gb);Choose Case gb
	Case '1'
		dw_key.Modify('syear.protect = 0')
      dw_key.Modify("syear.background.color = '"+String(Rgb(190,225,184))+"'")	 // mint
		dw_key.Modify('gu.protect = 0')
      dw_key.Modify("gu.background.color = '"+String(Rgb(190,225,184))+"'")	 // mint
	Case '2'
		dw_key.Modify('syear.protect = 1')
      dw_key.Modify("syear.background.color = '"+String(Rgb(192,192,192))+"'") // gray
		dw_key.Modify('gu.protect = 1')
      dw_key.Modify("gu.background.color = '"+String(Rgb(192,192,192))+"'") // gray
End Choose

Return 1
end function

on w_sal_05965.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_key=create dw_key
this.dw_list=create dw_list
this.dw_rate=create dw_rate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_key
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.dw_rate
end on

on w_sal_05965.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_key)
destroy(this.dw_list)
destroy(this.dw_rate)
end on

event open;call super::open;string syear

dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_rate.SetTransObject(sqlca)

dw_key.InsertRow(0)

ib_any_typing =  FAlse

dw_key.setitem(1,'syear',left(f_today(),4))
dw_key.setfocus()
dw_key.setcolumn('syear')

end event

type dw_insert from w_inherite`dw_insert within w_sal_05965
int X=123
int Y=424
int Width=3360
int Height=1364
int TabOrder=10
string DataObject="d_sal_059651"
boolean TitleBar=true
string Title="관할구역 분기평가 시상 내역"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean MaxBox=true
boolean HScrollBar=true
boolean VScrollBar=true
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;Long nRow
String sisang_no_gu, sisang_yn, sNull

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)
Choose Case GetColumnName()
	/* 업무협조점수 */
	Case 'assist_jumsu'
		cb_search.Enabled = True
	/* 시상제외사유 */
	Case 'sisang_no_gu'
		sisang_no_gu = Trim(GetText())
		If IsNull(sisang_no_gu) or sisang_no_gu = '' Then
			SetItem(nRow,'sisang_yn',sNull)
		Else
			SetItem(nRow,'sisang_yn','N')
		End If
		
		cb_search.Enabled = True
End Choose

ib_any_typing =True
end event

type cb_exit from w_inherite`cb_exit within w_sal_05965
int X=3104
int Y=1872
int TabOrder=90
end type

type cb_mod from w_inherite`cb_mod within w_sal_05965
int X=2400
int Y=1872
int TabOrder=60
end type

event cb_mod::clicked;call super::clicked;If dw_insert.RowCount() <= 0 Then Return

If wf_key_check() = -1 Then Return                // key check

If dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_ins from w_inherite`cb_ins within w_sal_05965
int X=169
int Y=1872
int Width=498
int TabOrder=40
string Text="평가처리(&P)"
end type

event cb_ins::clicked;call super::clicked;Long rcnt,row,ix,nRow,total_rank
String sYear, sBun, sBaseGu

If wf_key_check() = -1 Then Return                // key check

cb_inq.TriggerEvent(Clicked!)
rcnt = dw_insert.RowCount()
If rcnt > 0 Then
   IF MessageBox("평가처리","기존에 평가처리된 내역이 존재합니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN 
      RETURN
	Else
		dw_insert.RowsMove(1,rcnt,Primary!,dw_insert,1,Delete!)     // 전체 삭제
	End If
End If

SetPointer(HourGlass!)

sle_msg.Text = '분기 평가처리중...'

If wf_retrieve() = -1 Then Return

sYear = dw_key.GetItemString(1,'syear')
sBun  = dw_key.GetItemString(1,'gu')
sBaseGu = dw_key.GetItemString(1,'base_gu')

For ix = 1 To dw_list.RowCount()
	nRow = dw_insert.InsertRow(0)
	
	dw_insert.SetItem(nRow,'sabu',gs_sabu)
	dw_insert.SetItem(nRow,'base_year', sYear)
	dw_insert.SetItem(nRow,'base_gu', sBaseGu)
	dw_insert.SetItem(nRow,'sisang_gu', sBun)
	dw_insert.SetItem(nRow,'sarea',dw_list.GetItemString(ix,'sarea'))
	dw_insert.SetItem(nRow,'sareanm',dw_list.GetItemString(ix,'sareanm'))

	dw_insert.SetItem(nRow,'sales_jumsu',dw_list.GetItemNumber(ix,'sales_jumsu'))
	dw_insert.SetItem(nRow,'sungj_jumsu',dw_list.GetItemNumber(ix,'sungj_jumsu'))
	dw_insert.SetItem(nRow,'sugum_jumsu',dw_list.GetItemNumber(ix,'sugum_jumsu'))
	dw_insert.SetItem(nRow,'hoijun_jumsu',dw_list.GetItemNumber(ix,'hoijun_jumsu'))
	dw_insert.SetItem(nRow,'total_jumsu',dw_list.GetItemNumber(ix,'total_jumsu'))
	dw_insert.setitem(nrow,'maechul_amt',dw_list.getitemnumber(ix,'q_mae_amt'))
	dw_insert.SetItem(nRow,'sisang_date',is_today)
Next

If dw_insert.RowCount() > 0 Then
   wf_key_protect('2')
   sle_msg.Text = '분기평가처리 완료'
Else
   sle_msg.Text = '처리된 건수가 없습니다.!!'
End If

end event

type cb_del from w_inherite`cb_del within w_sal_05965

int X=1038
int Y=1872
int TabOrder=70
end type

event cb_del::clicked;call super::clicked;int    row,rank,rcnt

rcnt = dw_insert.RowCount()

If rcnt > 0 Then
   IF MessageBox("삭 제","분기 평가내역 전체가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.RowsMove(1,rcnt,Primary!,dw_insert,1,Delete!)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"자료를 삭제하였습니다!!"	
	   Else
		   Rollback ;
	   End If		
	End If	
End If

end event

type cb_inq from w_inherite`cb_inq within w_sal_05965
int X=686
int Y=1872
int TabOrder=50
end type

event cb_inq::clicked;call super::clicked;String sYear, sBun

If wf_key_check() = -1 Then Return

sYear = dw_key.GetItemString(1,'syear')
sBun  = dw_key.GetItemString(1,'gu')

dw_insert.SetRedraw(False)
If dw_insert.Retrieve(gs_sabu, sYear, sBun) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
End If

wf_key_protect('2')
 
dw_insert.SetRedraw(True)
end event

type cb_print from w_inherite`cb_print within w_sal_05965
int X=1774
int Y=2344
int TabOrder=120
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_05965
int X=2752
int Y=1872
int TabOrder=80
end type

event cb_can::clicked;call super::clicked;dw_list.Reset()
dw_insert.Reset()

wf_key_protect('1')

dw_key.SetFocus()
dw_key.SetColumn('syear')

cb_search.Enabled = False
ib_any_typing = false

end event

type cb_search from w_inherite`cb_search within w_sal_05965
int X=1362
int Y=2360
int Width=457
int TabOrder=130
boolean Visible=false
boolean Enabled=false
string Text="순위정렬(&W)"
end type

type gb_3 from groupbox within w_sal_05965
int X=2359
int Y=1800
int Width=1120
int Height=236
int TabOrder=110
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_2 from groupbox within w_sal_05965
int X=123
int Y=1800
int Width=1307
int Height=236
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_key from u_key_enter within w_sal_05965
int X=110
int Y=72
int Width=3387
int Height=344
int TabOrder=30
boolean BringToTop=true
string DataObject="d_sal_05965_01"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event itemerror;return 1
end event

event itemchanged;Choose Case GetColumnName()
	/* 자료구분 */
	Case 'base_gu'
		dw_list.SetRedraw(False)
		dw_insert.SetRedraw(False)
		IF GetText() = '1' THEN													/* 영업팀 */
			dw_list.DataObject = 'd_sal_059501'
			dw_insert.DataObject = 'd_sal_059652'
		ELSEIF GETTEXT() = '2' THEN   										/* 관할구역 */
			dw_list.DataObject = 'd_sal_05950'
			dw_insert.DataObject = 'd_sal_059651'
		ELSE                                                        /*영업담당자*/
			dw_list.DataObject = 'd_sal_05950_10'
			dw_insert.DataObject = 'd_sal_059653'
		END IF
		dw_list.SetTransObject(SQLCA)
		dw_insert.SetTransObject(SQLCA)
		dw_list.SetRedraw(True)
		dw_insert.SetRedraw(True)
End Choose
end event

type dw_list from datawindow within w_sal_05965
int X=3461
int Y=172
int Width=1243
int Height=1712
int TabOrder=20
boolean Visible=false
boolean BringToTop=true
string DataObject="d_sal_05950"
boolean TitleBar=true
string Title="평가 처리"
BorderStyle BorderStyle=StyleLowered!
boolean MinBox=true
boolean MaxBox=true
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_rate from datawindow within w_sal_05965
int X=1984
int Y=292
int Width=722
int Height=96
int TabOrder=100
boolean Visible=false
boolean BringToTop=true
string DataObject="d_sal_05960"
boolean TitleBar=true
string Title="시상율"
BorderStyle BorderStyle=StyleLowered!
boolean MinBox=true
boolean MaxBox=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

