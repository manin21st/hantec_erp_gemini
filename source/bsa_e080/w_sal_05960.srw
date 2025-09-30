$PBExportHeader$w_sal_05960.srw
$PBExportComments$영업팀/관할구역 분기평가기준 등록
forward
global type w_sal_05960 from w_inherite
end type
type gb_3 from groupbox within w_sal_05960
end type
type gb_2 from groupbox within w_sal_05960
end type
type gb_1 from groupbox within w_sal_05960
end type
type dw_key from u_key_enter within w_sal_05960
end type
type st_unit from statictext within w_sal_05960
end type
end forward

global type w_sal_05960 from w_inherite
int Height=2396
boolean TitleBar=true
string Title="관할구역 분기평가기준 등록"
WindowState WindowState=normal!
event ue_open pbm_custom01
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_key dw_key
st_unit st_unit
end type
global w_sal_05960 w_sal_05960

type variables
string is_year,     is_gu, is_base_gu

end variables

forward prototypes
public function integer wf_key_check ()
end prototypes

public function integer wf_key_check ();Long nRow

If dw_key.AcceptText() <> 1 Then Return -1
nRow = dw_key.GetRow()
If nrow <= 0 Then Return -1

SetNull(is_year)
SetNull(is_gu)
SetNull(is_base_gu)

is_year = dw_key.GetItemString(nRow,'syear')
is_gu   = dw_key.GetItemString(nRow,'gu')
is_base_gu   = dw_key.GetItemString(nRow,'base_gu')

If IsNull(is_year) Or is_year = '' Then
   f_message_chk(1400,'[기준년도]')
	dw_key.SetFocus()
	dw_key.SetColumn('syear')
	Return -1
End If

If IsNull(is_gu) Then
   f_message_chk(1400,'[평가구분]')
	dw_key.SetFocus()
	dw_key.SetColumn('gu')
	Return -1
End If

Return 1
end function

on w_sal_05960.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_key=create dw_key
this.st_unit=create st_unit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_key
this.Control[iCurrent+5]=this.st_unit
end on

on w_sal_05960.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_key)
destroy(this.st_unit)
end on

event open;call super::open;dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert.SetRowFocusIndicator(Hand!)

cb_can.Post PostEvent(Clicked!)

ib_any_typing =  FAlse
end event

type dw_insert from w_inherite`dw_insert within w_sal_05960
int X=110
int Y=640
int Width=2322
int Height=1140
int TabOrder=10
string DataObject="d_sal_05960"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event dw_insert::itemchanged;ib_any_typing =True
end event

type cb_exit from w_inherite`cb_exit within w_sal_05960
int X=2066
int Y=1872
int TabOrder=70
end type

type cb_mod from w_inherite`cb_mod within w_sal_05960
int X=1010
int Y=1872
int TabOrder=40
end type

event cb_mod::clicked;call super::clicked;Long ix, nCnt

If dw_insert.AcceptText() <> 1 Then Return

If IsNull(is_year) Or IsNull(is_gu) Then
   f_message_chk(1400,'')
	dw_key.SetFocus()
	dw_key.SetColumn('gu')
	Return -1
End If

nCnt = dw_insert.RowCount()
For ix = nCnt To 1 Step -1
   If IsNull(dw_insert.GetItemNumber(ix,'par_value')) Then dw_insert.DeleteRow(ix)
Next

For ix = 1 To dw_insert.RowCount()
   If IsNull(dw_insert.GetItemNumber(ix,'par_jumsu')) Then
      f_message_chk(1400,'[평가기준점수]')
	   dw_insert.SetFocus()
	   dw_insert.SetRow(ix)
	   dw_insert.SetColumn('par_jumsu')
   	Return -1
    End If
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

type cb_ins from w_inherite`cb_ins within w_sal_05960
int X=174
int Y=1872
int TabOrder=20
string Text="추가(&I)"
end type

event cb_ins::clicked;call super::clicked;int  row

If IsNull(is_year) Or IsNull(is_gu) Then
   f_message_chk(1400,'')
	dw_key.SetFocus()
	dw_key.SetColumn('syear')
	Return -1
End If

row = dw_insert.InsertRow(0)
dw_insert.SetItem(row,'sabu',gs_sabu)
dw_insert.SetItem(row,'base_year',is_year)
dw_insert.SetItem(row,'par_gu',is_gu)
dw_insert.SetItem(row,'base_gu',is_base_gu)

dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(row, 0,Primary!, New!)
dw_insert.SetFocus()
dw_insert.SetRow(row)
dw_insert.ScrollToRow(row)
dw_insert.SetColumn('par_value')

end event

type cb_del from w_inherite`cb_del within w_sal_05960
int X=1362
int Y=1872
int TabOrder=50
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
	   Else
		   Rollback ;
	   End If		
	End If	
   cb_inq.PostEvent(Clicked!)
End If

end event

type cb_inq from w_inherite`cb_inq within w_sal_05960
int X=526
int Y=1872
int TabOrder=30
end type

event cb_inq::clicked;call super::clicked;If wf_key_check() = -1 Then Return

If dw_insert.Retrieve(gs_sabu,is_year,is_gu, is_base_gu) > 0 Then

Else
	sle_msg.Text = '조회된 건수가 없습니다.!!'
End If



end event

type cb_print from w_inherite`cb_print within w_sal_05960
int X=1774
int Y=2344
int TabOrder=90
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_05960
int X=1714
int Y=1872
end type

event cb_can::clicked;call super::clicked;int row

dw_key.Reset()
row = dw_key.InsertRow(0)
dw_key.SetItem(row,'syear',Left(f_today(),4))

dw_key.SetFocus()
dw_key.SetRow(row)
dw_key.SetColumn('gu')

dw_insert.Reset()

SetNull(is_year)
SetNull(is_gu)

ib_any_typing = false

end event

type cb_search from w_inherite`cb_search within w_sal_05960
int X=2496
int Y=2344
int TabOrder=100
boolean Visible=false
end type

type gb_3 from groupbox within w_sal_05960
int X=951
int Y=1800
int Width=1481
int Height=236
int TabOrder=80
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

type gb_2 from groupbox within w_sal_05960
int X=110
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

type gb_1 from groupbox within w_sal_05960
int X=119
int Y=52
int Width=2322
int Height=544
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

type dw_key from u_key_enter within w_sal_05960
int X=174
int Y=108
int Width=1463
int Height=420
int TabOrder=10
boolean BringToTop=true
string DataObject="d_sal_05960_key"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event itemchanged;Choose Case GetColumnName()
	Case 'syear'
		cb_inq.TriggerEvent(Clicked!)
	Case 'gu'
	  Choose Case GetText()
		 Case '1','2','3','5','6'
			st_unit.Text = '단위 : ％'
			dw_insert.SetFormat('par_value','#,##0.00％ 이상')
		 Case '4'
			st_unit.Text = '단위 : 일'
			dw_insert.SetFormat('par_value','#,##0일 이상')
  	  End Choose
		cb_inq.TriggerEvent(Clicked!)
End Choose
end event

event itemerror;return 1
end event

type st_unit from statictext within w_sal_05960
int X=1806
int Y=420
int Width=366
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

