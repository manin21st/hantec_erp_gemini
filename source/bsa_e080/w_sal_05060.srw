$PBExportHeader$w_sal_05060.srw
$PBExportComments$연말 종합평가 기준등록
forward
global type w_sal_05060 from w_inherite
end type
type gb_3 from groupbox within w_sal_05060
end type
type gb_2 from groupbox within w_sal_05060
end type
type gb_1 from groupbox within w_sal_05060
end type
type dw_key from u_key_enter within w_sal_05060
end type
type st_2 from statictext within w_sal_05060
end type
type st_unit from statictext within w_sal_05060
end type
end forward

global type w_sal_05060 from w_inherite
int Width=3653
int Height=2380
boolean TitleBar=true
string Title="연말 종합평가 기준등록"
event ue_open pbm_custom01
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_key dw_key
st_2 st_2
st_unit st_unit
end type
global w_sal_05060 w_sal_05060

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
is_year = dw_key.GetItemString(nRow,'syear')
is_gu   = dw_key.GetItemString(nRow,'gu')

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

on w_sal_05060.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_key=create dw_key
this.st_2=create st_2
this.st_unit=create st_unit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_key
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_unit
end on

on w_sal_05060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_key)
destroy(this.st_2)
destroy(this.st_unit)
end on

event open;call super::open;string syear

dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert.SetRowFocusIndicator(Hand!)

cb_can.Post PostEvent(Clicked!)

ib_any_typing =  FAlse
end event

type dw_insert from w_inherite`dw_insert within w_sal_05060
int X=119
int Y=468
int Width=2322
int Height=1312
int TabOrder=10
string DataObject="d_sal_05060"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event dw_insert::itemchanged;ib_any_typing =True
end event

event dw_insert::itemerror;Return 1
end event

type cb_exit from w_inherite`cb_exit within w_sal_05060
int X=2066
int Y=1872
end type

type cb_mod from w_inherite`cb_mod within w_sal_05060
int X=1010
int Y=1872
int TabOrder=50
end type

event cb_mod::clicked;call super::clicked;Long ix,nCnt
dec jumsu

If dw_insert.AcceptText() <> 1 Then Return

If IsNull(is_year) Or IsNull(is_gu) Then
   f_message_chk(1400,'')
	dw_key.SetFocus()
	dw_key.SetColumn('gu')
	Return -1
End If

/* 삭제 */
nCnt = dw_insert.RowCount()
If nCnt <= 0 Then Return

For ix = ncnt to 1 Step -1
   If IsNull(dw_insert.GetItemNumber(ix,'par_value')) Then dw_insert.DeleteRow(ix)
Next

For ix = 1 To dw_insert.RowCount()
	jumsu = dw_insert.GetItemNumber(ix,'par_jumsu')

   If IsNull(jumsu) Then
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

type cb_ins from w_inherite`cb_ins within w_sal_05060
int X=174
int Y=1872
int TabOrder=30
string Text="추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Long  row

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
dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(row, 0,Primary!, New!)
dw_insert.SetFocus()
dw_insert.SetRow(row)
dw_insert.ScrollToRow(row)
dw_insert.SetColumn('par_value')

end event

type cb_del from w_inherite`cb_del within w_sal_05060
int X=1362
int Y=1872
int TabOrder=60
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

type cb_inq from w_inherite`cb_inq within w_sal_05060
int X=526
int Y=1872
end type

event cb_inq::clicked;call super::clicked;If wf_key_check() = -1 Then Return

SetPointer(HourGlass!)
If dw_insert.Retrieve(gs_sabu,is_year,is_gu) <= 0 Then
	sle_msg.Text = '조회된 건수가 없습니다.!!'
	Return
End If

Choose Case is_gu
	Case '1'
		dw_insert.SetSort('par_value D')
		dw_insert.Sort()
		sle_msg.text = '매출실적이 조회되었습니다'
	Case '2'
		dw_insert.SetSort('par_value D')
		dw_insert.Sort()
		sle_msg.text = '목표달성율이 조회되었습니다'
	Case '3'
		dw_insert.SetSort('par_value ')
		dw_insert.Sort()
		sle_msg.text = '성장율이 조회되었습니다'
End Choose
end event

type cb_print from w_inherite`cb_print within w_sal_05060
int X=1774
int Y=2344
int TabOrder=100
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_05060
int X=1714
int Y=1872
int TabOrder=70
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

type cb_search from w_inherite`cb_search within w_sal_05060
int X=2496
int Y=2344
int TabOrder=110
boolean Visible=false
end type

type gb_3 from groupbox within w_sal_05060
int X=960
int Y=1800
int Width=1481
int Height=236
int TabOrder=90
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

type gb_2 from groupbox within w_sal_05060
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

type gb_1 from groupbox within w_sal_05060
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

type dw_key from u_key_enter within w_sal_05060
int X=174
int Y=196
int Width=1001
int Height=200
int TabOrder=20
boolean BringToTop=true
string DataObject="d_sal_05060_key"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event itemchanged;Choose Case GetColumnName()
	Case 'syear'
		cb_inq.TriggerEvent(Clicked!)
	Case 'gu'
	  Choose Case GetText()
		 Case '1'
			st_unit.Text = '원'
			dw_insert.SetFormat('par_value','#,##0원 이상')
		 Case '2'
			st_unit.Text = '％'
			dw_insert.SetFormat('par_value','#,##0.00％ 이상')
		 Case '3'
			st_unit.Text = '순위'
			dw_insert.SetFormat('par_value','#,##0위 이상')
  	  End Choose
		cb_inq.TriggerEvent(Clicked!)
End Choose
end event

event itemerror;return 1
end event

type st_2 from statictext within w_sal_05060
int X=1815
int Y=320
int Width=247
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="단위 :"
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

type st_unit from statictext within w_sal_05060
int X=2057
int Y=320
int Width=279
int Height=76
boolean Enabled=false
boolean BringToTop=true
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

