$PBExportHeader$w_graph_spacing.srw
$PBExportComments$Graph 간격 조절
forward
global type w_graph_spacing from Window
end type
type em_spacing from editmask within w_graph_spacing
end type
type cb_cancel from commandbutton within w_graph_spacing
end type
type cb_ok from commandbutton within w_graph_spacing
end type
end forward

global type w_graph_spacing from Window
int X=1079
int Y=368
int Width=1006
int Height=452
boolean TitleBar=true
string Title="간격 설정"
long BackColor=79741120
boolean ControlMenu=true
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
em_spacing em_spacing
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_graph_spacing w_graph_spacing

type variables
object io_passed
graph igr_parm
datawindow idw_parm
int ii_original_spacing
end variables

event open;///////////////////////////////////////////////////////////////////////////////////////////////////////
// open script for w_graph_spacing
///////////////////////////////////////////////////////////////////////////////////////////////////////
f_window_center(this)

graphicobject lgro_hold

lgro_hold = Message.PowerObjectParm

If lgro_hold.TypeOf() = Graph! Then
	io_passed = Graph!
	igr_parm = Message.PowerObjectParm
	em_spacing.text = string(igr_parm.spacing)
	ii_original_spacing = igr_parm.spacing
Elseif lgro_hold.TypeOf() = Datawindow! Then
	io_passed = Datawindow!
	idw_parm = Message.PowerObjectParm
	em_spacing.text = idw_parm.Object.gr_1.spacing
	ii_original_spacing = Integer(em_spacing.text)
End If
end event

on w_graph_spacing.create
this.em_spacing=create em_spacing
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.em_spacing,&
this.cb_cancel,&
this.cb_ok}
end on

on w_graph_spacing.destroy
destroy(this.em_spacing)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type em_spacing from editmask within w_graph_spacing
event ue_enchange pbm_enchange
int X=261
int Y=76
int Width=457
int Height=100
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
string Mask="#####"
boolean Spin=true
double Increment=10
string MinMax="0	100~~"
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event ue_enchange;///////////////////////////////////////////////////////////////////////////////////////////////////////
// ue_enchange script for em_spacing
///////////////////////////////////////////////////////////////////////////////////////////////////////
If io_passed = Graph! Then
	igr_parm.spacing = integer (em_spacing.text)
Elseif io_passed = Datawindow! Then
    
	idw_parm.Object.gr_1.spacing = integer (em_spacing.text)
End If

end event

type cb_cancel from commandbutton within w_graph_spacing
int X=512
int Y=236
int Width=366
int Height=96
int TabOrder=30
string Text="취소(&C)"
boolean Cancel=true
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;///////////////////////////////////////////////////////////////////////////////////////////////////////
// clicked script for cb_cancel
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Reset the spacing since the user hit the Cancel button.
If io_passed = Graph! Then
	igr_parm.spacing = ii_original_spacing
Elseif io_passed = Datawindow! Then
	idw_parm.Object.gr_1.spacing= string(ii_original_spacing)
End If

Close (parent)
end event

type cb_ok from commandbutton within w_graph_spacing
int X=119
int Y=236
int Width=366
int Height=96
int TabOrder=20
string Text="확인(&O)"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;///////////////////////////////////////////////////////////////////////////////////////////////////////
// close script for cb_ok
///////////////////////////////////////////////////////////////////////////////////////////////////////

Close (parent) 
end event

