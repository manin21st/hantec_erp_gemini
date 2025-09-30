$PBExportHeader$w_sal_04011.srw
$PBExportComments$이자정산 지급보류 등록
forward
global type w_sal_04011 from w_inherite
end type
type gb_5 from groupbox within w_sal_04011
end type
type gb_2 from groupbox within w_sal_04011
end type
type gb_4 from groupbox within w_sal_04011
end type
type dw_jogun from u_key_enter within w_sal_04011
end type
type dw_insert1 from u_key_enter within w_sal_04011
end type
type gb_1 from groupbox within w_sal_04011
end type
end forward

global type w_sal_04011 from w_inherite
boolean TitleBar=true
string Title="이자정산 지급보류 등록"
long BackColor=80859087
gb_5 gb_5
gb_2 gb_2
gb_4 gb_4
dw_jogun dw_jogun
dw_insert1 dw_insert1
gb_1 gb_1
end type
global w_sal_04011 w_sal_04011

on w_sal_04011.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_2=create gb_2
this.gb_4=create gb_4
this.dw_jogun=create dw_jogun
this.dw_insert1=create dw_insert1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_4
this.Control[iCurrent+4]=this.dw_jogun
this.Control[iCurrent+5]=this.dw_insert1
this.Control[iCurrent+6]=this.gb_1
end on

on w_sal_04011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.dw_jogun)
destroy(this.dw_insert1)
destroy(this.gb_1)
end on

event open;call super::open;dw_Insert1.Settransobject(sqlca)
dw_Insert.Settransobject(sqlca)
dw_Jogun.Settransobject(sqlca)
dw_Jogun.InsertRow(0)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_jogun.SetItem(1, 'sarea', sarea)
	dw_jogun.Modify("sarea.protect=1")
	dw_jogun.Modify("sarea.background.color = 80859087")
End If

cb_can.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sal_04011
int X=160
int Y=328
int Width=3305
int Height=1512
int TabOrder=10
string DataObject="d_sal_04010_02"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
end type

event dw_insert::itemfocuschanged;if this.GetColumnName() = "jihold_cause" then
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
else
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
end if
end event

event dw_insert::itemerror;return 1
end event

type cb_exit from w_inherite`cb_exit within w_sal_04011
int X=3086
int Y=1936
int Width=402
int TabOrder=150
end type

type cb_mod from w_inherite`cb_mod within w_sal_04011
int X=2213
int Y=1936
int Width=402
int TabOrder=90
end type

event cb_mod::clicked;call super::clicked;Long ix

If dw_insert.AcceptText() <> 1 Then Return

For ix = 1 To dw_insert.Rowcount()
	dw_insert.SetItem(ix, 'ija_amt', dw_insert.GetItemNumber(ix, 'amt1'))
	dw_insert.SetItem(ix, 'ija_jamt', dw_insert.GetItemNumber(ix, 'amt2'))
Next

if dw_Insert.Update() = -1 then  
   f_message_Chk(32,'[지급보류 등록]')
	Rollback;
	return
end if

Commit;	
ib_any_typing = False

f_message_Chk(202,'[지급보류 대리점]')
end event

type cb_ins from w_inherite`cb_ins within w_sal_04011
int X=187
int Y=2348
int Width=535
int Height=136
int TabOrder=80
boolean Visible=false
boolean Enabled=false
string Text="집계처리(&I)"
end type

event cb_ins::clicked;call super::clicked;//String  sYM
//Integer cnt
//
//dw_Insert1.AcceptText()
//sYM = dw_Insert1.GetItemString(1, 'ym')
//if sYM = '' or isNull(sYM) then
//	f_message_chk(30, '[집계년월]')
//	dw_Insert1.SetColumn('ym')
//	dw_Insert1.SetFocus()
//	return
//end if
//// 해당년월로 집계되어 있는지 Check
//Select Count(*) Into :cnt 
//From   sugumijasum
//Where  sabu = :gs_sabu and ija_yymm = :sYM;
//
//beep (1)
//if cnt > 0 then
//	if MessageBox('확인', '해당년월의 수금이자분이 이미 집계되어 있습니다.' + '~r~r' + &
//	                      '기존 집계자료를 삭제하고 다시 집계하겠습니까?', + &
//							    question!,yesno!, 2) = 2 then
//	   return
//   end if
//end if
//
//SetPointer(hourGlass!)
//sle_msg.Text = '거래처별 수금이자집계 생성중............'
//// 수금이자 정산 월합계 테이블 삭제
//Delete From sugumijasum
//Where  sabu = :gs_sabu and ija_yymm = :sYM;
//
//if SQLCA.Sqlcode < 0 then
//   messagebox("확인", "수금이자 정산 월합계 테이블 삭제 실패!")
//	Rollback;
//	return
//end if
//
//Commit;			
//
//// 해당집계년월의 거래처별 수금이자집계 생성
//Insert Into sugumijasum
//       Select sabu, substr(ipgum_date,1,6), cvcod, sum(NVL(ija_amt,0)), 'N', ''
//       From   sugumija
//       Where  sabu = :gs_sabu and substr(ipgum_date,1,6) = :sYM
//       Group By sabu, substr(ipgum_date,1,6), cvcod;
//
//if SQLCA.Sqlcode < 0 then
//   messagebox("확인", "수금이자집계 생성 실패!")
//	Rollback;
//	return
//end if
//
//Commit;
//SetPointer(Arrow!)
//sle_msg.Text = ''
//MessageBox('확인', '수금이자집계 생성 완료' + '~r~r' + &
//                   '조회버턴을 Click하여 지급보류 등록을 하세요')
//
//dw_Jogun.SetItem(1, 'sarea', '00')
//cb_inq.SetFocus()
end event

type cb_del from w_inherite`cb_del within w_sal_04011
int X=1230
int Y=2388
int TabOrder=100
boolean Visible=false
boolean Enabled=false
end type

type cb_inq from w_inherite`cb_inq within w_sal_04011
int X=155
int Y=1936
int Width=402
int TabOrder=110
end type

event cb_inq::clicked;call super::clicked;String sYM, sSarea
Long   ix

if dw_Insert1.AcceptText() = -1 then return
sYM = dw_Insert1.GetItemString(1, 'ym')

if dw_Jogun.AcceptText() = -1 then return
sSarea = dw_Jogun.GetItemString(1, 'sarea')
if sSarea = '00' or sSarea = '' or isNull(sSarea) then
	sSarea = '%'
end if

if dw_Insert.Retrieve(gs_sabu, sYM, sSarea) = 0 then
	MessageBox('확인', '해당 년월의 수금이자정산 월집계 Data가 없습니다.')
	return
end if

For ix = 1 To dw_insert.Rowcount()
	dw_insert.SetItem(ix, 'amt1', dw_insert.GetItemNumber(ix, 'ija_amt'))
	dw_insert.SetItem(ix, 'amt2', dw_insert.GetItemNumber(ix, 'ija_jamt'))
Next

dw_Insert.SetFocus()
end event

type cb_print from w_inherite`cb_print within w_sal_04011
int X=1952
int Y=2388
int TabOrder=120
boolean Visible=false
boolean Enabled=false
end type

type cb_can from w_inherite`cb_can within w_sal_04011
int X=2651
int Y=1936
int Width=402
int TabOrder=130
end type

event cb_can::clicked;call super::clicked;dw_Insert1.Reset()
dw_Insert.Reset()

dw_Insert1.InsertRow(0)
dw_Insert1.SetFocus()

sle_msg.Text = '집계 및 조회,등록할 년월을 입력하세요'
ib_any_typing = false
end event

type cb_search from w_inherite`cb_search within w_sal_04011
int X=2674
int Y=2388
int TabOrder=140
boolean Visible=false
boolean Enabled=false
end type

type gb_5 from groupbox within w_sal_04011
int X=114
int Y=1884
int Width=485
int Height=184
int TabOrder=60
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

type gb_2 from groupbox within w_sal_04011
int X=119
int Y=268
int Width=3397
int Height=1600
int TabOrder=40
BorderStyle BorderStyle=StyleRaised!
long TextColor=128
long BackColor=79741120
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_4 from groupbox within w_sal_04011
int X=2176
int Y=1884
int Width=1344
int Height=184
int TabOrder=70
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

type dw_jogun from u_key_enter within w_sal_04011
int X=896
int Y=120
int Width=1221
int Height=96
int TabOrder=30
boolean BringToTop=true
string DataObject="d_sal_04010_01"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

type dw_insert1 from u_key_enter within w_sal_04011
int X=187
int Y=128
int Width=699
int Height=100
int TabOrder=20
boolean BringToTop=true
string DataObject="d_sal_04011"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event itemchanged;String sNull, sCol_Name, sYM, sGubun, sCvcod, sCvName

sCol_Name = This.GetColumnName()

SetNull(sNull)

Choose Case sCol_Name
	Case "ym"
      sYM = this.GetText()	+ '01'	
      if f_DateChk(Trim(sYM)) = -1 then
   	   f_Message_Chk(35, '[집계년월]')
	      this.SetItem(1, "ym", sNull)
   	   return 1
      end if
end Choose
end event

event itemerror;return 1
end event

event ue_pressenter;cb_ins.SetFocus()
end event

type gb_1 from groupbox within w_sal_04011
int X=119
int Y=40
int Width=3397
int Height=224
int TabOrder=50
BorderStyle BorderStyle=StyleRaised!
long TextColor=16711680
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

