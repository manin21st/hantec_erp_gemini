$PBExportHeader$w_sal_05970.srw
$PBExportComments$거래처 관리등급기준 등록
forward
global type w_sal_05970 from w_inherite
end type
type gb_5 from groupbox within w_sal_05970
end type
type gb_4 from groupbox within w_sal_05970
end type
type gb_3 from groupbox within w_sal_05970
end type
type gb_2 from groupbox within w_sal_05970
end type
type gb_1 from groupbox within w_sal_05970
end type
type dw_key from u_key_enter within w_sal_05970
end type
type dw_list from datawindow within w_sal_05970
end type
type dw_ip from datawindow within w_sal_05970
end type
type st_2 from statictext within w_sal_05970
end type
type st_3 from statictext within w_sal_05970
end type
type st_4 from statictext within w_sal_05970
end type
type st_5 from statictext within w_sal_05970
end type
type st_6 from statictext within w_sal_05970
end type
type st_7 from statictext within w_sal_05970
end type
end forward

global type w_sal_05970 from w_inherite
int Height=2396
boolean TitleBar=true
string Title="거래처 관리등급기준 등록"
WindowState WindowState=normal!
event ue_open pbm_custom01
gb_5 gb_5
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_key dw_key
dw_list dw_list
dw_ip dw_ip
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
end type
global w_sal_05970 w_sal_05970

type variables


end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String	syear, sPyear
Long     nRow

If dw_ip.accepttext() <> 1 Then Return 0

syear  = trim(dw_ip.getitemstring(1, 'syear'))

IF	IsNull(syear) or syear = '' Then
	f_message_chk(1400,'[기준년월]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

SetPointer(HourGlass!)

sPyear = f_aftermonth(syear,-12)

nRow = dw_list.retrieve(gs_sabu, sPyear, sYear, '%', '%')
If nRow < 1	Then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	return -1
End if

Double dAmt, jumsu
Long   rCnt, ix, row
String sGrade

/* 판매금액 */
rCnt = dw_insert.Retrieve(gs_sabu, '1') /* 평가기준점수 */
dw_insert.SetSort('par_value D')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'maechul')
   row = dw_insert.Find("par_value < " + string(dAmt),1,Rcnt)
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_insert.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'jumsu1',jumsu)
Next

/* 총회전일 */
rCnt = dw_insert.Retrieve(gs_sabu, '2') /* 평가기준점수 */
dw_insert.SetSort('par_value')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'hoijunil')
   row = dw_insert.Find("par_value > " + string(dAmt),1,Rcnt)
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_insert.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'jumsu2',jumsu)
Next

/* 성장율 */
rCnt = dw_insert.Retrieve(gs_sabu, '3') /* 평가기준점수 */
dw_insert.SetSort('par_value D')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'sungj_rate')
   row = dw_insert.Find("par_value < " + string(dAmt*100),1,Rcnt)
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_insert.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'jumsu3',jumsu)
Next

/* 총점수 */
rCnt = dw_insert.Retrieve(gs_sabu, '4') /* 평가기준점수 */
dw_insert.SetSort('par_value D')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'total_jumsu')
   row = dw_insert.Find("par_value < " + string(dAmt),1,Rcnt)
	
	If dw_list.GetItemString(ix,'outgu') = '3' Then
		sGrade = 'E'
	Else
		If Rcnt > 0 and row > 0 Then
			sGrade = dw_insert.GetItemString(row,'par_grade')
		Else
			sGrade = ''
		End If
	End If
	dw_list.SetItem(ix,'mlevel',sGrade)
Next

Return 1
end function

on w_sal_05970.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_key=create dw_key
this.dw_list=create dw_list
this.dw_ip=create dw_ip
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.dw_key
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.dw_ip
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.st_7
end on

on w_sal_05970.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_key)
destroy(this.dw_list)
destroy(this.dw_ip)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
end on

event open;call super::open;String syear

dw_list.SetTransObject(sqlca)

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

dw_insert.SetTransObject(sqlca)
dw_insert.SetRowFocusIndicator(Hand!)

cb_can.Post PostEvent(Clicked!)

ib_any_typing =  FAlse
end event

type dw_insert from w_inherite`dw_insert within w_sal_05970
int X=119
int Y=396
int Width=2025
int Height=1384
int TabOrder=10
string DataObject="d_sal_05970"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event dw_insert::ue_pressenter;Choose Case This.GetColumnName()
  Case 'par_jumsu','par_grade'
	 If this.GetRow() = This.RowCount() Then cb_ins.TriggerEvent(Clicked!)
  Case Else
    Send(Handle(this),256,9,0)
    Return 1
End Choose
end event

type cb_exit from w_inherite`cb_exit within w_sal_05970
int X=2011
int Y=1872
int Width=315
int TabOrder=100
end type

type cb_mod from w_inherite`cb_mod within w_sal_05970
int X=1024
int Y=1872
int Width=315
int TabOrder=70
end type

event cb_mod::clicked;call super::clicked;int    ix,nRow,nCnt
dec    value,jumsu
string sgu,grade

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sgu   = dw_key.GetItemString(1,'gu')

If IsNull(sgu) Then
   f_message_chk(1400,'[평가구분]')
	dw_key.SetFocus()
	dw_key.SetColumn('gu')
	Return -1
End If

/* 평가기준에 맞춰 sort */
Choose Case sgu
  Case '1','3','4'
	dw_insert.SetSort('par_value D')
  Case '2'
	dw_insert.SetSort('par_value A')
End Choose
dw_insert.Sort()


nCnt = dw_insert.RowCount()
For ix = nCnt  To 1 Step -1
  value = dw_insert.GetItemNumber(ix,'par_value')
  jumsu = dw_insert.GetItemNumber(ix,'par_jumsu')
  grade = dw_insert.GetItemString(ix,'par_grade')
  If ( IsNull(value) ) and ( IsNull(jumsu) ) and &
     ( Isnull(grade) or grade = '' ) Then 
	  dw_insert.DeleteRow(ix)
	  Continue
  End If
  
  If IsNull(value) Then dw_insert.SetItem(ix,'par_value',0)

  If sgu <> '4' and IsNull(jumsu) Then dw_insert.SetItem(ix,'par_jumsu',0)
  
  If sgu = '4' and IsNull(grade) Then dw_insert.SetItem(ix,'par_grade','')
Next

For ix = 1 to dw_insert.Rowcount()
	dw_insert.SetItem(ix,'par_seq',ix)
Next

If dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
End if

ib_any_typing = False
end event

type cb_ins from w_inherite`cb_ins within w_sal_05970
int X=114
int Y=1872
int Width=315
int TabOrder=50
string Text="추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Long   nRow,nMax,ix
string sgu
dec    value,jumsu

sgu   = dw_key.GetItemString(1,'gu')

If IsNull(sgu) Then
   f_message_chk(1400,'[평가구분]')
	dw_key.SetFocus()
	dw_key.SetColumn('gu')
	Return
End If

nMax = 0
For ix = 1 To dw_insert.RowCount()
  nMax = Max(nMax,dw_insert.GetItemNumber(ix,'par_seq'))
Next
nMax += 1

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow,'sabu',gs_sabu)
dw_insert.SetItem(nRow,'par_gu',sgu)
dw_insert.SetItem(nRow,'par_seq',nMax)

dw_insert.SetItemStatus(nRow, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(nRow, 0,Primary!, New!)

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('par_value')

end event

type cb_del from w_inherite`cb_del within w_sal_05970
int X=1353
int Y=1872
int Width=315
int TabOrder=80
end type

event cb_del::clicked;call super::clicked;int    row,rank

If dw_insert.RowCount() > 0 Then
	row   = dw_insert.GetRow()

   IF MessageBox("삭 제",string(row) +"번째 row가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

	If dw_insert.DeleteRow(row)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"자료를 삭제하였습니다!!"
		   cb_inq.PostEvent(Clicked!)
	   Else
		   Rollback ;
	   End If		
	End If	
  
End If

end event

type cb_inq from w_inherite`cb_inq within w_sal_05970
int X=448
int Y=1872
int Width=315
int TabOrder=60
end type

event cb_inq::clicked;call super::clicked;int    nRow
string sgu

If dw_key.AcceptText() <> 1 Then Return -1

nRow = dw_key.RowCount()
If nRow <= 0 Then Return -1

sgu   = dw_key.GetItemString(nRow,'gu')

If IsNull(sgu) Then
   f_message_chk(1400,'[평가구분]')
	dw_key.SetFocus()
	dw_key.SetColumn('gu')
	Return -1
End If

dw_insert.SetRedraw(False)
If dw_insert.Retrieve(gs_sabu,sgu) <= 0 Then	
  sle_msg.Text = '조회된 건수가 없습니다.!!'
  dw_insert.SetRedraw(True)
  Return
End If

/* 평가기준에 맞춰 sort */
Choose Case sgu
  Case '1','3','4'
	dw_insert.SetSort('par_value D')
  Case '2'
	dw_insert.SetSort('par_value A')
End Choose

dw_insert.Sort()
dw_insert.SetRedraw(True)
end event

type cb_print from w_inherite`cb_print within w_sal_05970
int X=1774
int Y=2344
int TabOrder=120
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_05970
int X=1682
int Y=1872
int Width=315
int TabOrder=90
end type

event cb_can::clicked;call super::clicked;int row

dw_key.Reset()
row = dw_key.InsertRow(0)

dw_key.SetFocus()
dw_key.SetRow(row)
dw_key.SetColumn('gu')

dw_insert.Reset()

ib_any_typing = false

end event

type cb_search from w_inherite`cb_search within w_sal_05970
int X=3077
int Y=204
int Width=329
int TabOrder=130
string Text="적용(&W)"
int TextSize=-9
end type

event cb_search::clicked;call super::clicked;String sCvcod, sGrade
Long   ix

If ib_any_typing = True Then
	IF MessageBox("확 인","기준값에 변경된 자료가 있습니다." +"~n~n" +&
								 "계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
Else
	IF MessageBox("거래처 관리등급 설정", "거래처의 관리등급을 설정하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
End if

sle_msg.Text = '거래처 관리등급 설정중...'
dw_insert.SetRedraw(False)
If wf_retrieve() <> 1 Then 
	dw_insert.SetRedraw(True)
	Return
End If

SetPointer(HourGlass!)
For ix = 1 To dw_list.RowCount()
	sCvcod = dw_list.GetItemString(ix,'cvcod')
	sGrade = dw_list.GetItemString(ix,'mlevel')
	
	If IsNull(sCvcod ) or sCvcod = '' Then Continue
	
	update vndmst
	   set mlevel = :sGrade
	 where salescod = :scvcod;
	If sqlca.sqlcode <> 0 Then
		rollback;
		f_rollback()
		dw_insert.SetRedraw(True)
		cb_can.TriggerEvent(Clicked!)
		Exit
	End If
Next

commit;

dw_insert.SetRedraw(True)

cb_can.TriggerEvent(Clicked!)

sle_msg.Text = '거래처 관리등급 설정완료'
end event

type gb_5 from groupbox within w_sal_05970
int X=2167
int Y=376
int Width=1275
int Height=1404
int TabOrder=140
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_4 from groupbox within w_sal_05970
int X=2167
int Y=124
int Width=1275
int Height=240
int TabOrder=20
string Text="[거래처 관리등급 적용]"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_3 from groupbox within w_sal_05970
int X=1001
int Y=1800
int Width=1358
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

type gb_2 from groupbox within w_sal_05970
int X=91
int Y=1800
int Width=709
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

type gb_1 from groupbox within w_sal_05970
int X=119
int Y=124
int Width=2030
int Height=240
string Text="[평가기준 등록]"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_key from u_key_enter within w_sal_05970
int X=151
int Y=196
int Width=923
int Height=128
int TabOrder=30
boolean BringToTop=true
string DataObject="d_sal_05970_key"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event itemchanged;Choose Case GetColumnName()
	Case 'syear'
		cb_inq.TriggerEvent(Clicked!)      // 조회
	Case 'gu'
      Choose Case Trim(GetText())
        Case '1'
			 dw_insert.SetFormat('par_value','#,##0원 이상')
        Case '2'
			 dw_insert.SetFormat('par_value','#,##0일 이하')
        Case '3'
			 dw_insert.SetFormat('par_value','#,##0.00％ 이상')
        Case '4'
	       dw_insert.SetFormat('par_value','#,##0점 이상')
      End Choose
		cb_inq.TriggerEvent(Clicked!)      // 조회
End Choose
end event

event itemerror;return 1
end event

type dw_list from datawindow within w_sal_05970
int X=585
int Y=2316
int Width=1097
int Height=120
int TabOrder=40
boolean Visible=false
boolean BringToTop=true
string DataObject="d_sal_05870"
boolean TitleBar=true
string Title="거래처별 관리등급 현황"
BorderStyle BorderStyle=StyleLowered!
boolean MinBox=true
boolean MaxBox=true
boolean LiveScroll=true
end type

type dw_ip from datawindow within w_sal_05970
int X=2213
int Y=208
int Width=782
int Height=124
int TabOrder=140
boolean BringToTop=true
string DataObject="d_sal_05970_key1"
boolean Border=false
boolean LiveScroll=true
end type

type st_2 from statictext within w_sal_05970
int X=2240
int Y=484
int Width=320
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="* 적용범위"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_3 from statictext within w_sal_05970
int X=2240
int Y=568
int Width=1083
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text=" - 1. 대리점 및 취급점만 관리등급이"
boolean FocusRectangle=false
long BackColor=80859087
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_4 from statictext within w_sal_05970
int X=2240
int Y=636
int Width=1083
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="      적용됩니다.   "
boolean FocusRectangle=false
long BackColor=80859087
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_5 from statictext within w_sal_05970
int X=2240
int Y=740
int Width=1166
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text=" - 2. 단, 직판점은 'E'등급으로 설정됩니다."
boolean FocusRectangle=false
long BackColor=80859087
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_6 from statictext within w_sal_05970
int X=2240
int Y=852
int Width=1189
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text=" - 3. 기준년월에 대한 실적거래처의 실적으로"
boolean FocusRectangle=false
long BackColor=80859087
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_7 from statictext within w_sal_05970
int X=2240
int Y=924
int Width=1189
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="      관리등급으로 부여합니다."
boolean FocusRectangle=false
long BackColor=80859087
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

