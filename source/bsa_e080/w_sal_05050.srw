$PBExportHeader$w_sal_05050.srw
$PBExportComments$거래처 분기 시상금 지급기준 등록
forward
global type w_sal_05050 from w_inherite
end type
type gb_3 from groupbox within w_sal_05050
end type
type gb_2 from groupbox within w_sal_05050
end type
type gb_1 from groupbox within w_sal_05050
end type
type dw_key from u_key_enter within w_sal_05050
end type
type st_2 from statictext within w_sal_05050
end type
type gb_4 from groupbox within w_sal_05050
end type
type st_3 from statictext within w_sal_05050
end type
type st_4 from statictext within w_sal_05050
end type
type st_5 from statictext within w_sal_05050
end type
type st_6 from statictext within w_sal_05050
end type
end forward

global type w_sal_05050 from w_inherite
int Height=2396
boolean TitleBar=true
string Title="거래처 분기 시상금 지급기준 등록"
event ue_open pbm_custom01
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_key dw_key
st_2 st_2
gb_4 gb_4
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
end type
global w_sal_05050 w_sal_05050

type variables
string is_year,     is_gu

end variables

forward prototypes
public function integer wf_key_check ()
end prototypes

public function integer wf_key_check ();int    nRow

dw_key.AcceptText()
nRow = dw_key.GetRow()
If nrow <= 0 Then Return -1

SetNull(is_year)
SetNull(is_gu)
is_year = dw_key.GetItemString(nRow,'base_year')
is_gu   = dw_key.GetItemString(nRow,'sisang_gu')

If IsNull(is_year) Or is_year = '' Then
   f_message_chk(1400,'[기준년도]')
	dw_key.SetFocus()
	dw_key.SetColumn('base_year')
	Return -1
End If

If IsNull(is_gu) Then
   f_message_chk(1400,'[분기구분]')
	dw_key.SetFocus()
	dw_key.SetColumn('sisang_gu')
	Return -1
End If

Return 1
end function

on w_sal_05050.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_key=create dw_key
this.st_2=create st_2
this.gb_4=create gb_4
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_key
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.gb_4
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.st_6
end on

on w_sal_05050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_key)
destroy(this.st_2)
destroy(this.gb_4)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
end on

event open;call super::open;string syear

dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert.SetRowFocusIndicator(Hand!)


cb_can.Post PostEvent(Clicked!)

ib_any_typing =  FAlse
end event

type dw_insert from w_inherite`dw_insert within w_sal_05050
int X=119
int Y=468
int Width=2322
int Height=1312
int TabOrder=10
string DataObject="d_sal_05050"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event dw_insert::itemerror;Return 1
end event

type cb_exit from w_inherite`cb_exit within w_sal_05050
int X=2066
int Y=1872
int TabOrder=90
end type

type cb_mod from w_inherite`cb_mod within w_sal_05050
int X=1010
int Y=1872
int TabOrder=60
end type

event cb_mod::clicked;call super::clicked;Long ix,nCnt

If dw_insert.AcceptText() <> 1 Then Return

If IsNull(is_year) Or IsNull(is_gu) Then
   f_message_chk(1400,'')
	dw_key.SetFocus()
	dw_key.SetColumn('base_year')
	Return -1
End If

/* 적용율이 입력안되면 삭제 */
nCnt = dw_insert.RowCount()
For ix = nCnt to 1 Step -1
	If IsNull(dw_insert.GetItemNumber(ix,'sisang_rate')) Then		dw_insert.DeleteRow(ix)		
Next

dw_insert.SetSort('sisang_rate d')
dw_insert.Sort()

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix,'bungi_rank',ix)
Next

If dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_ins from w_inherite`cb_ins within w_sal_05050
int X=174
int Y=1872
int TabOrder=40
string Text="추가(&I)"
end type

event cb_ins::clicked;call super::clicked;int  row,nMax,ix,itemp

If IsNull(is_year) Or IsNull(is_gu) Then
   f_message_chk(1400,'')
	dw_key.SetFocus()
	dw_key.SetColumn('base_year')
	Return -1
End If

// 최대 rank 구함
nMax = 0
For ix = 1 To dw_insert.RowCount()
    itemp = dw_insert.GetItemNumber(ix,'bungi_rank')
    nMax = Max(nMax,itemp)
Next
nMax += 1

row = dw_insert.InsertRow(0)
dw_insert.SetItem(row,'sabu',gs_sabu)
dw_insert.SetItem(row,'base_year',is_year)
dw_insert.SetItem(row,'sisang_gu',is_gu)
dw_insert.SetItem(row,'bungi_rank',nMax)
dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(row, 0,Primary!, New!)

dw_insert.SetFocus()
dw_insert.ScrollToRow(row)
dw_insert.SetRow(row)
dw_insert.SetColumn('bungi_rank')

end event

type cb_del from w_inherite`cb_del within w_sal_05050
int X=1362
int Y=1872
int TabOrder=70
end type

event cb_del::clicked;call super::clicked;int    row,rank

If dw_insert.RowCount() > 0 Then
	row   = dw_insert.GetRow()
	rank = dw_insert.GetItemNumber(row,'bungi_rank')
   IF MessageBox("삭 제",string(rank) +"순위가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.DeleteRow(row)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
	   Else
		   Rollback ;
			Return
	   End If		
	End If	
   cb_inq.PostEvent(Clicked!)
End If

sle_msg.text =	"자료를 삭제하였습니다!!"	
end event

type cb_inq from w_inherite`cb_inq within w_sal_05050
int X=526
int Y=1872
int TabOrder=50
end type

event cb_inq::clicked;call super::clicked;If wf_key_check() = -1 Then Return

If dw_insert.Retrieve(gs_sabu,is_year,is_gu) > 0 Then	
   sle_msg.Text = is_year+'년도 ' + is_gu + '/4 분기 조회되었습니다.'
Else
	sle_msg.Text = '조회된 건수가 없습니다.!!'
End If



end event

type cb_print from w_inherite`cb_print within w_sal_05050
int X=1774
int Y=2344
int TabOrder=110
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_05050
int X=1714
int Y=1872
int TabOrder=80
end type

event cb_can::clicked;call super::clicked;int row

dw_key.Reset()
row = dw_key.InsertRow(0)
dw_key.SetItem(row,'base_year',Left(f_today(),4))

dw_key.SetFocus()
dw_key.SetRow(row)
dw_key.SetColumn('sisang_gu')

dw_insert.Reset()

SetNull(is_year)
SetNull(is_gu)

ib_any_typing = false

sle_msg.Text = ''
end event

type cb_search from w_inherite`cb_search within w_sal_05050
int X=2496
int Y=2344
int TabOrder=120
boolean Visible=false
end type

type gb_3 from groupbox within w_sal_05050
int X=960
int Y=1800
int Width=1481
int Height=236
int TabOrder=100
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

type gb_2 from groupbox within w_sal_05050
int X=119
int Y=1800
int Width=823
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

type gb_1 from groupbox within w_sal_05050
int X=119
int Y=124
int Width=2322
int Height=316
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

type dw_key from u_key_enter within w_sal_05050
int X=293
int Y=196
int Width=855
int Height=200
int TabOrder=30
boolean BringToTop=true
string DataObject="d_sal_05040_key"
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

type st_2 from statictext within w_sal_05050
int X=1957
int Y=320
int Width=384
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="단위 : %"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_4 from groupbox within w_sal_05050
int X=430
int Y=2356
int Width=1275
int Height=1312
int TabOrder=20
boolean Visible=false
boolean Enabled=false
string Text="[등록 방법]"
BorderStyle BorderStyle=StyleLowered!
long TextColor=128
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_3 from statictext within w_sal_05050
int X=457
int Y=2452
int Width=1234
int Height=76
boolean Visible=false
boolean Enabled=false
boolean BringToTop=true
string Text="분기순위 - 거래처의 분기별 매출액 순위"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_4 from statictext within w_sal_05050
int X=457
int Y=2556
int Width=1207
int Height=76
boolean Visible=false
boolean Enabled=false
boolean BringToTop=true
string Text="시상적용율 - 각 순위별 적용율"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_5 from statictext within w_sal_05050
int X=1275
int Y=2556
int Width=416
int Height=76
boolean Visible=false
boolean Enabled=false
boolean BringToTop=true
string Text="(단위: %) "
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_6 from statictext within w_sal_05050
int X=773
int Y=2632
int Width=823
int Height=76
boolean Visible=false
boolean Enabled=false
boolean BringToTop=true
string Text="- 1%일 경우 1.0으로 등록"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

