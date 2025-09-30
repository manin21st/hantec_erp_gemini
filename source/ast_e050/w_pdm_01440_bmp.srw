$PBExportHeader$w_pdm_01440_bmp.srw
$PBExportComments$** 표준공정관리(공정도관리)
forward
global type w_pdm_01440_bmp from Window
end type
type st_zoom from statictext within w_pdm_01440_bmp
end type
type ddlb_zoom from dropdownlistbox within w_pdm_01440_bmp
end type
type dw_bmp from datawindow within w_pdm_01440_bmp
end type
type cb_exit from commandbutton within w_pdm_01440_bmp
end type
type cb_save from commandbutton within w_pdm_01440_bmp
end type
type dw_insert from datawindow within w_pdm_01440_bmp
end type
type gb_1 from groupbox within w_pdm_01440_bmp
end type
type gb_2 from groupbox within w_pdm_01440_bmp
end type
type gb_3 from groupbox within w_pdm_01440_bmp
end type
end forward

type str_offer_rex from structure
	string		offno
	string		rcdat
	double		offamt
	double		foramt
	double		wonamt
	boolean		flag
end type

global type w_pdm_01440_bmp from Window
int X=37
int Y=72
int Width=3301
int Height=2320
boolean TitleBar=true
string Title="공정도면"
long BackColor=79741120
boolean ControlMenu=true
WindowType WindowType=response!
st_zoom st_zoom
ddlb_zoom ddlb_zoom
dw_bmp dw_bmp
cb_exit cb_exit
cb_save cb_save
dw_insert dw_insert
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pdm_01440_bmp w_pdm_01440_bmp

type variables

end variables

on w_pdm_01440_bmp.create
this.st_zoom=create st_zoom
this.ddlb_zoom=create ddlb_zoom
this.dw_bmp=create dw_bmp
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.dw_insert=create dw_insert
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.st_zoom,&
this.ddlb_zoom,&
this.dw_bmp,&
this.cb_exit,&
this.cb_save,&
this.dw_insert,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_pdm_01440_bmp.destroy
destroy(this.st_zoom)
destroy(this.ddlb_zoom)
destroy(this.dw_bmp)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.dw_insert)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;f_window_center(this)

dw_insert.SetTransObject(SQLCA)
dw_bmp.SetTransObject(SQLCA)

dw_insert.insertrow(0)
dw_insert.setitem(1, 'path', gs_code)

dw_bmp.Retrieve(gs_code)
dw_bmp.object.datawindow.print.preview="yes"


end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
   	dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type st_zoom from statictext within w_pdm_01440_bmp
int X=1865
int Y=64
int Width=247
int Height=84
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="ZOOM"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type ddlb_zoom from dropdownlistbox within w_pdm_01440_bmp
int X=2121
int Y=64
int Width=265
int Height=296
int TabOrder=60
string Text="100"
BorderStyle BorderStyle=StyleLowered!
boolean Sorted=false
boolean VScrollBar=true
boolean AllowEdit=true
int Limit=3
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
string Item[]={"30",&
"50",&
"75",&
"100",&
"120",&
"150",&
"200"}
end type

event modified;string ls_zoom, ls_return

ls_zoom = trim(ddlb_zoom.text)

triggerevent(selectionchanged!)

choose case ls_zoom
	case '30'
		ls_zoom = '30'
	case '50'
		ls_zoom = '50'		
	case '75'
		ls_zoom = '75'
	case '100'
		ls_zoom = '100'
	case '120'
		ls_zoom = '120'
	case '150'
		ls_zoom = '150'
	case '200'
		ls_zoom = '200'
	case '250'
		ls_zoom = '250'
	case '300'
		ls_zoom = '300'
	case '350'
		ls_zoom = '350'
	case '400'
		ls_zoom = '400'
	case else
		if isnumber(ddlb_zoom.text) then
			ls_zoom = ddlb_zoom.text
		else
			messagebox("ZOOM 확인", "배율 범위를 확인하세요.!", information!, OK!)
			return
		end if
end choose

dw_bmp.modify("Datawindow.print.preview.zoom = '"+ls_zoom+"'")
end event

type dw_bmp from datawindow within w_pdm_01440_bmp
int X=32
int Y=192
int Width=3200
int Height=2016
int TabOrder=50
string DataObject="d_pdm_01280"
boolean TitleBar=true
BorderStyle BorderStyle=StyleLowered!
boolean MaxBox=true
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type cb_exit from commandbutton within w_pdm_01440_bmp
int X=2857
int Y=52
int Width=329
int Height=100
int TabOrder=40
string Text="취소(&C)"
boolean Cancel=true
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;setnull(gs_code)
close(parent)
end event

type cb_save from commandbutton within w_pdm_01440_bmp
int X=2510
int Y=52
int Width=329
int Height=100
int TabOrder=30
string Text="확인(&O)"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;dw_insert.AcceptText() 

gs_code = dw_insert.GetItemString(1, 'path')

close(parent)



end event

type dw_insert from datawindow within w_pdm_01440_bmp
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
int X=114
int Y=72
int Width=1632
int Height=96
int TabOrder=10
string DataObject="d_pdm_01440_path"
boolean Border=false
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rowfocuschanged;//THIS.SetRowFocusIndicator(HAND!)
//
//string spath
//
//IF THIS.rowcount() < 1 then return 
//
//spath = this.getitemstring(currentrow, 'path')
//
//dw_bmp.Retrieve(spath)
//dw_bmp.object.datawindow.print.preview="yes"
end event

event rbuttondown;integer fh, ret

blob Emp_pic
string txtname, named
string defext = "BMP"
string Filter = "bitmap Files (*.bmp), *.bmp"

IF this.GetColumnName() = 'path' then
	ret = GetFileOpenName("Open Bitmap", txtname, named, defext, filter)
	
	IF ret = 1 THEN
      dw_bmp.Retrieve(txtname)
      dw_bmp.object.datawindow.print.preview="yes"
      this.setitem(this.getrow(), 'path', txtname)
	END IF
	
END IF
end event

event itemchanged;string spath

IF this.GetColumnName() = 'path' then
   spath = this.gettext()

	dw_bmp.Retrieve(spath)
	dw_bmp.object.datawindow.print.preview="yes"
END IF
end event

event itemerror;return 1
end event

event buttonclicking;//integer fh, ret
//
//blob Emp_pic
//string txtname, named
//string defext = "BMP"
//string Filter = "bitmap Files (*.bmp), *.bmp"
//
//ret = GetFileOpenName("Open Bitmap", txtname, named, defext, filter)
//
//IF ret = 1 THEN
//	dw_bmp.Retrieve(txtname)
//	dw_bmp.object.datawindow.print.preview="yes"
//	this.setitem(this.getrow(), 'path', txtname)
//END IF
//	
//
end event

type gb_1 from groupbox within w_pdm_01440_bmp
int X=1778
int Width=677
int Height=188
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_2 from groupbox within w_pdm_01440_bmp
int X=37
int Width=1733
int Height=188
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_3 from groupbox within w_pdm_01440_bmp
int X=2464
int Width=773
int Height=188
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

