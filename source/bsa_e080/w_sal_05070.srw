$PBExportHeader$w_sal_05070.srw
$PBExportComments$연말 종합평가 처리
forward
global type w_sal_05070 from w_inherite
end type
type gb_3 from groupbox within w_sal_05070
end type
type gb_2 from groupbox within w_sal_05070
end type
type gb_1 from groupbox within w_sal_05070
end type
type dw_key from u_key_enter within w_sal_05070
end type
type dw_list from datawindow within w_sal_05070
end type
type dw_rate from datawindow within w_sal_05070
end type
type dw_maechul from datawindow within w_sal_05070
end type
end forward

global type w_sal_05070 from w_inherite
int Height=2396
boolean TitleBar=true
string Title="연말 종합평가 처리"
long BackColor=80859087
event ue_open pbm_custom01
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_key dw_key
dw_list dw_list
dw_rate dw_rate
dw_maechul dw_maechul
end type
global w_sal_05070 w_sal_05070

type variables
string is_year

end variables

forward prototypes
public function integer wf_key_protect (boolean gb)
public function integer wf_key_check ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_key_protect (boolean gb);//Choose Case gb
//	Case True
//		dw_key.Modify('base_year.protect = 1')
//      dw_key.Modify("base_year.background.color = '"+String(Rgb(192,192,192))+"'") // gray
//		dw_key.Modify('sisang_gu.protect = 1')
//      dw_key.Modify("sisang_gu.background.color = '"+String(Rgb(192,192,192))+"'") // gray
//	Case False
//		dw_key.Modify('base_year.protect = 0')
//      dw_key.Modify("base_year.background.color = '"+String(Rgb(190,225,184))+"'")	 // mint
//		dw_key.Modify('sisang_gu.protect = 0')
//      dw_key.Modify("sisang_gu.background.color = '"+String(Rgb(190,225,184))+"'")	 // mint
//End Choose
//
Return 1
end function

public function integer wf_key_check ();int    nRow

dw_key.AcceptText()
nRow = dw_key.GetRow()
If nrow <= 0 Then Return -1

SetNull(is_year)
is_year = dw_key.GetItemString(nRow,'syear')

If IsNull(is_year) Or is_year = '' Then
   f_message_chk(1400,'[기준년도]')
	dw_key.SetFocus()
	dw_key.SetColumn('syear')
	Return -1
End If

Return 1
end function

public function integer wf_retrieve ();string	syear1,syear2
int      ix,iy,nRow,iord,rcnt,row, jumsu
dec      ord1,ord2
dec      maechul,dals_rate,sungi_rank

//////////////////////////////////////////////////////////////////
If dw_key.accepttext() <> 1 Then Return -1

syear1  = is_year

IF	IsNull(syear1) or syear1 = '' then
	f_message_chk(1400,'[기준년도]')
	dw_key.setcolumn('syear')
	dw_key.setfocus()
	Return -1
END IF

syear2 = String(long(syear1) -1 )

dw_list.SetRedraw(False)

/* 평가 데이타 조회 */
nRow = dw_list.retrieve(gs_sabu, syear1, syear2)
If nRow < 1	Then
	f_message_chk(50,"")
	dw_key.setcolumn('syear')
	dw_key.setfocus()
	dw_list.SetRedraw(True)
	Return -1
End if


/* 매출실적 */
Rcnt = dw_rate.Retrieve(gs_sabu, syear1,'1') /* 평가기준점수 */
For ix = 1 To nRow
	maechul = dw_list.GetItemNumber(ix,'maechul')
   row = dw_rate.Find("par_value <= " + string(maechul),1,Rcnt)	
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'sales_jumsu',jumsu)
Next

/* 목표달성율 */
Rcnt = dw_rate.Retrieve(gs_sabu, syear1,'2') /* 평가기준점수 */
For ix = 1 To nRow
	dals_rate = dw_list.GetItemNumber(ix,'dals_rate')
	
	dals_rate = Truncate(dals_rate * 100,0)
	/* 달성율이 100%이상이면 초과 1%당 1점씩 가산 */
	If dals_rate > 100 Then 
		row = dw_rate.Find("par_value <= " + string(100),1,Rcnt)	
		If Rcnt > 0 and row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
			If IsNull(jumsu ) Then jumsu = 0
			
			jumsu = jumsu + ( dals_rate - 100 )
		Else
			jumsu = 0
		End If
	Else
		row = dw_rate.Find("par_value <= " + string(dals_rate),1,Rcnt)	
		If Rcnt > 0 and row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If
	End If
	
	dw_list.SetItem(ix,'dals_jumsu',jumsu)
Next

/* 성장순위에 대한 순위 산정 */
For ix = 1 To ( nRow - 1 )
	For iy = ix + 1 To nRow
       ord1 = dw_list.GetItemNumber(ix,'sungj_rate')
       ord2 = dw_list.GetItemNumber(iy,'sungj_rate')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(iy,'sungj_rank')
				iord += 1
				dw_list.SetItem(iy,'sungj_rank',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(ix,'sungj_rank')
				iord += 1
				dw_list.SetItem(ix,'sungj_rank',iord)
		End Choose
	Next
Next


Rcnt = dw_rate.Retrieve(gs_sabu, syear1,'3') /* 평가기준점수 */
dw_rate.SetSort('par_value')
dw_rate.Sort()

For ix = nRow To 1 Step -1
	sungi_rank = dw_list.GetItemNumber(ix,'sungj_rank')
	
	/* 성장율순위가 20위미만이면 제외 */
	If sungi_rank > 20 Then 
		dw_list.DeleteRow(ix)
		continue
	End If
	
   row = dw_rate.Find("par_value >= " + string(sungi_rank),1,Rcnt)	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'sungj_jumsu',jumsu)	
Next

/* 종합순위 산정 */
dw_list.SetSort('tot_jumsu d, maechul d, sungj_rate d')
dw_list.Sort()

For ix = 1 To dw_list.RowCount()
	dw_list.SetItem(ix,'total_rank',ix)
Next

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05070.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_key=create dw_key
this.dw_list=create dw_list
this.dw_rate=create dw_rate
this.dw_maechul=create dw_maechul
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_key
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.dw_rate
this.Control[iCurrent+7]=this.dw_maechul
end on

on w_sal_05070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_key)
destroy(this.dw_list)
destroy(this.dw_rate)
destroy(this.dw_maechul)
end on

event open;call super::open;string syear

dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_rate.SetTransObject(sqlca)
dw_maechul.SetTransObject(sqlca)

cb_can.Post PostEvent(Clicked!)

ib_any_typing =  FAlse

end event

type dw_insert from w_inherite`dw_insert within w_sal_05070
int X=105
int Y=248
int Width=3360
int Height=1536
int TabOrder=10
string DataObject="d_sal_05070"
boolean TitleBar=true
string Title="거래처 평가 시상 내역"
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

type cb_exit from w_inherite`cb_exit within w_sal_05070
int X=3099
int Y=1872
int TabOrder=90
end type

type cb_mod from w_inherite`cb_mod within w_sal_05070
int X=2395
int Y=1872
int TabOrder=60
end type

event cb_mod::clicked;call super::clicked;If wf_key_check() = -1 Then Return                // key check

/* 순위 재정렬 */
cb_search.TriggerEvent(Clicked!)

If dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_ins from w_inherite`cb_ins within w_sal_05070
int X=155
int Y=1872
int Width=498
int TabOrder=40
string Text="평가처리(&P)"
end type

event cb_ins::clicked;call super::clicked;Long rcnt,row,ix,nRow,total_rank
dec  maechul,rate

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

sle_msg.Text = '거래처 평가처리중...'

If wf_retrieve() = -1 Then Return                     // 평가처리

For ix = 1 To dw_list.RowCount()
	nRow = dw_insert.InsertRow(0)
	
	dw_insert.SetItem(nRow,'sabu',gs_sabu)
	dw_insert.SetItem(nRow,'base_year',is_year)
	dw_insert.SetItem(nRow,'sisang_gu','0')
	dw_insert.SetItem(nRow,'cvcod',dw_list.GetItemString(ix,'cvcod'))
	dw_insert.SetItem(nRow,'cvcodnm',dw_list.GetItemString(ix,'cvcodnm'))
	dw_insert.SetItem(nRow,'maechul',dw_list.GetItemNumber(ix,'maechul'))
	dw_insert.SetItem(nRow,'sales_jumsu',dw_list.GetItemNumber(ix,'sales_jumsu'))
	dw_insert.SetItem(nRow,'dals_jumsu',dw_list.GetItemNumber(ix,'dals_jumsu'))
	dw_insert.SetItem(nRow,'sungj_jumsu',dw_list.GetItemNumber(ix,'sungj_jumsu'))
	dw_insert.SetItem(nRow,'total_rank',dw_list.GetItemNumber(ix,'total_rank'))
Next

If dw_insert.RowCount() > 0 Then
   wf_key_protect(true)
   sle_msg.Text = '거래처 평가처리 완료'
Else
   sle_msg.Text = '처리된 건수가 없습니다.!!'
End If

end event

type cb_del from w_inherite`cb_del within w_sal_05070
int X=1024
int Y=1872
int TabOrder=70
end type

event cb_del::clicked;call super::clicked;int    row,rank,rcnt

rcnt = dw_insert.RowCount()

If rcnt > 0 Then
   IF MessageBox("삭 제","거래처 평가내역 전체가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.RowsMove(1,rcnt,Primary!,dw_insert,1,Delete!)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"자료를 삭제하였습니다!!"	
	   Else
		   Rollback ;
	   End If		
	End If	
//   dw_insert.Retrieve(gs_sabu,is_year)
End If

end event

type cb_inq from w_inherite`cb_inq within w_sal_05070
int X=672
int Y=1872
int TabOrder=50
end type

event cb_inq::clicked;call super::clicked;String sCvcod
Long   ix, nRow
Double dMaechul

If wf_key_check() = -1 Then Return                // key check

dw_insert.SetRedraw(False)
If dw_insert.Retrieve(gs_sabu,is_year) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
Else
	dw_maechul.Retrieve(gs_sabu, is_year)

	For ix = 1 To dw_insert.RowCount()	
		sCvcod = dw_insert.GetItemString(ix,'cvcod')
		
		nRow = dw_maechul.Find("cvcod = '"+scvcod+"'" ,1,dw_maechul.Rowcount())
		If nRow > 0 Then
			dMaechul = dw_maechul.GetItemNumber(nRow,'maechul_amt')
			If IsNull(dMaechul) Then dMaechul = 0
		Else
			dMaechul = 0
		End If
		
		dw_insert.SetItem(ix,'maechul', dMaechul)
	Next
End If

dw_insert.SetRedraw(True)
end event

type cb_print from w_inherite`cb_print within w_sal_05070
int X=1774
int Y=2344
int TabOrder=120
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_05070
int X=2747
int Y=1872
int TabOrder=80
end type

event cb_can::clicked;call super::clicked;int row

dw_list.Reset()

dw_key.Reset()
row = dw_key.InsertRow(0)
dw_key.SetItem(row,'syear',Left(f_today(),4))

wf_key_protect(false)

dw_key.SetFocus()
dw_key.SetRow(row)
dw_key.SetColumn('syear')

dw_insert.Reset()

SetNull(is_year)

cb_search.Enabled = False
ib_any_typing = false

end event

type cb_search from w_inherite`cb_search within w_sal_05070
int X=1376
int Y=1872
int Width=457
int TabOrder=130
string Text="순위정렬(&W)"
end type

event cb_search::clicked;call super::clicked;Long ix

/* 종합순위 산정 */
dw_insert.SetRedraw(False)
dw_insert.SetSort('tot_jumsu d, maechul d, sungj_rate d')
dw_insert.Sort()

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix,'total_rank',ix)
Next

dw_insert.SetSort('total_rank')
dw_insert.Sort()

dw_insert.SetRedraw(True)
end event

type gb_3 from groupbox within w_sal_05070
int X=2354
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

type gb_2 from groupbox within w_sal_05070
int X=110
int Y=1800
int Width=1769
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

type gb_1 from groupbox within w_sal_05070
int X=110
int Y=36
int Width=2533
int Height=188
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_key from u_key_enter within w_sal_05070
int X=142
int Y=92
int Width=672
int Height=104
int TabOrder=30
boolean BringToTop=true
string DataObject="d_sal_050702"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event itemchanged;Choose Case GetColumnName()
	Case 'base_year','sisang_gu'
		cb_inq.TriggerEvent(Clicked!)      // 조회
End Choose
end event

event itemerror;return 1
end event

type dw_list from datawindow within w_sal_05070
int X=1975
int Y=84
int Width=562
int Height=100
int TabOrder=20
boolean Visible=false
boolean BringToTop=true
string DataObject="d_sal_05940"
boolean TitleBar=true
string Title="평가 처리"
BorderStyle BorderStyle=StyleLowered!
boolean MinBox=true
boolean MaxBox=true
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_rate from datawindow within w_sal_05070
int X=1211
int Y=76
int Width=722
int Height=96
int TabOrder=100
boolean Visible=false
boolean BringToTop=true
string DataObject="d_sal_05060"
boolean TitleBar=true
string Title="시상율"
BorderStyle BorderStyle=StyleLowered!
boolean MinBox=true
boolean MaxBox=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_maechul from datawindow within w_sal_05070
int X=2679
int Y=88
int Width=663
int Height=104
int TabOrder=30
boolean Visible=false
boolean BringToTop=true
string DataObject="d_sal_050701"
boolean TitleBar=true
string Title="거래처별 매출액"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

