$PBExportHeader$w_pdt_02455.srw
$PBExportComments$금형/치공구 제작의뢰 승인 처리
forward
global type w_pdt_02455 from w_inherite
end type
type dw_1 from u_key_enter within w_pdt_02455
end type
type rb_1 from radiobutton within w_pdt_02455
end type
type rb_2 from radiobutton within w_pdt_02455
end type
type gb_1 from groupbox within w_pdt_02455
end type
type gb_2 from groupbox within w_pdt_02455
end type
type gb_3 from groupbox within w_pdt_02455
end type
type st_2 from statictext within w_pdt_02455
end type
end forward

global type w_pdt_02455 from w_inherite
int Height=2404
boolean TitleBar=true
string Title="금형/치공구 제작의뢰 승인 처리"
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
st_2 st_2
end type
global w_pdt_02455 w_pdt_02455

on w_pdt_02455.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.st_2
end on

on w_pdt_02455.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.st_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_insert.insertrow(0)
dw_insert.setitem(1, 'sdate',left(f_today(),6) + '01' )
dw_insert.setitem(1, 'edate',left(f_today(),8))
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02455
int X=1189
int Y=80
int Width=2295
int Height=132
int TabOrder=10
string DataObject="d_pdt_02455"
end type

event dw_insert::itemchanged;call super::itemchanged;string ls_sdate , ls_edate ,  snull , ls_text

setnull(snull)

if rb_1.checked = true then
	ls_text = '승인일자'
else
	ls_text = '의뢰일자'
end if

IF this.GetColumnName() = 'sdate' THEN
	ls_sdate = Trim(this.Gettext())
	IF ls_sdate ="" OR IsNull(ls_sdate) THEN RETURN		
	
	IF f_datechk(ls_sdate) = -1 THEN
		f_message_chk(35,'[' + ls_text +'FROM ]')
		this.SetItem(1,"sdate",snull)
		Return 1
	END IF
ELSEIF this.GetColumnName() = 'edate' THEN
	ls_edate = Trim(this.Gettext())
	IF ls_edate ="" OR IsNull(ls_edate) THEN return
	
	IF f_datechk(ls_edate) = -1 THEN
		f_message_chk(35,'[' + ls_text + 'TO ]')
		this.SetItem(1,"edate",snull)
		Return 1
	END IF
END IF

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::editchanged;return 
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02455
int X=3223
int Y=1936
int TabOrder=100
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02455
int X=2528
int Y=1936
int TabOrder=40
end type

event cb_mod::clicked;call super::clicked;long ll_check , ll_mrow  

if dw_1.accepttext() <> 1 then return

ll_mrow = dw_1.rowcount()

if ll_mrow < 1 then
	messagebox('확인','저장할 데이타가 없습니다.')
	return
end if

ll_check = messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1)

if ll_check <> 1 then return

if dw_1.update() <> 1 then 
	rollback using sqlca;
	sle_msg.text='저장에 실패하였습니다.'
end if

commit using sqlca;

sle_msg.text='저장에 성공하였습니다.'

cb_inq.triggerevent(clicked!)

end event

type cb_ins from w_inherite`cb_ins within w_pdt_02455
int Y=2272
int TabOrder=30
boolean Visible=false
end type

type cb_del from w_inherite`cb_del within w_pdt_02455
int X=1221
int Y=2260
int TabOrder=50
boolean Visible=false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02455
int X=87
int Y=1936
int TabOrder=60
end type

event cb_inq::clicked;call super::clicked;string ls_sdate , ls_edate , ls_gubun , ls_text 

if dw_insert.accepttext() <> 1 then return

ls_sdate = Trim(dw_insert.getitemstring(1,'sdate'))
ls_edate = Trim(dw_insert.getitemstring(1,'edate'))
ls_gubun = Trim(dw_insert.getitemstring(1,'gubun'))

if rb_1.checked = true then
	ls_text = '승인'
else
	ls_text = '의뢰'
end if

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[' +ls_text +'일자 FROM]')
	dw_insert.setcolumn('sdate')
	dw_insert.setfocus()
	return 
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[' +ls_text +'일자 TO]')
	dw_insert.setcolumn('edate')
	dw_insert.setfocus()
	return 
end if

if dw_1.retrieve(gs_sabu, ls_sdate, ls_edate, ls_gubun ) < 1 then
	f_message_chk(300,'')
	dw_insert.setcolumn('sdate')
	dw_insert.setfocus()
	return 
end if

end event

type cb_print from w_inherite`cb_print within w_pdt_02455
int X=1929
int Y=2284
int TabOrder=70
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_pdt_02455
int X=2875
int Y=1936
int TabOrder=80
end type

event cb_can::clicked;call super::clicked;dw_1.setredraw(false)
dw_1.reset()
dw_1.setredraw(true)
end event

type cb_search from w_inherite`cb_search within w_pdt_02455
int X=2569
int Y=2300
int TabOrder=90
boolean Visible=false
end type

type dw_1 from u_key_enter within w_pdt_02455
int X=55
int Y=236
int Width=3525
int Height=1652
int TabOrder=20
string DataObject="d_pdt_02455_02"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
end type

event itemchanged;Choose Case this.getcolumnname()
	Case 'kumest_conf_yn'
		if this.gettext() = 'Y' then
			this.setitem(row,'kumest_conf_date', f_today() )
		else
			this.setitem(row,'kumest_conf_date','')
		end if
End Choose

end event

type rb_1 from radiobutton within w_pdt_02455
int X=846
int Y=84
int Width=251
int Height=76
boolean BringToTop=true
string Text="승인"
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

event clicked;dw_insert.object.sdate_t.text = '승인일자'

dw_1.setredraw(false)
dw_1.dataobject = 'd_pdt_02455_01'
dw_1.settransobject(sqlca)
dw_1.setredraw(true)
end event

type rb_2 from radiobutton within w_pdt_02455
int X=517
int Y=84
int Width=320
int Height=76
boolean BringToTop=true
string Text="미승인"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long TextColor=8388608
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;dw_insert.object.sdate_t.text = '의뢰일자'

dw_1.setredraw(false)
dw_1.dataobject = 'd_pdt_02455_02'
dw_1.settransobject(sqlca)
dw_1.setredraw(true)
end event

type gb_1 from groupbox within w_pdt_02455
int X=55
int Width=3525
int Height=220
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_2 from groupbox within w_pdt_02455
int X=55
int Y=1888
int Width=393
int Height=180
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

type gb_3 from groupbox within w_pdt_02455
int X=2496
int Y=1888
int Width=1088
int Height=180
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

type st_2 from statictext within w_pdt_02455
int X=119
int Y=96
int Width=370
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="승인구분 :"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=128
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

