$PBExportHeader$w_graph_title.srw
$PBExportComments$Graph Title 명
forward
global type w_graph_title from Window
end type
type cb_cancel from commandbutton within w_graph_title
end type
type cb_ok from commandbutton within w_graph_title
end type
type sle_title from singlelineedit within w_graph_title
end type
end forward

global type w_graph_title from Window
int X=677
int Y=740
int Width=1490
int Height=416
boolean TitleBar=true
string Title="Graph Title 명"
long BackColor=79741120
boolean ControlMenu=true
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
cb_cancel cb_cancel
cb_ok cb_ok
sle_title sle_title
end type
global w_graph_title w_graph_title

type variables
object io_passed
graph igr_parm
datawindow idw_parm
string is_original_title
end variables

event open;// The calling window has passed the current graph object. Initialize 
// the Single Line Edit so the user can modify it.
// the  graph object 'igr_parm' is declared as an instance variable.
f_window_center(this)

graphicobject lgro_hold

lgro_hold = message.powerobjectparm
If lgro_hold.TypeOf() = Graph! Then
	io_passed = Graph!
	igr_parm = message.powerobjectparm
	sle_title.text = igr_parm.title
	sle_title.SelectText (1,999)
	
	// Remember the original title, in case they cancel
	is_original_title = igr_parm.title
Elseif lgro_hold.TypeOf() = Datawindow! Then
	io_passed = Datawindow!
	idw_parm = message.powerobjectparm
	sle_title.text = idw_parm.Object.gr_1.title
	sle_title.SelectText (1,999)

	// Remember original title, in case they cancel
	is_original_title = sle_title.text
End If

end event

on w_graph_title.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_title=create sle_title
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.sle_title}
end on

on w_graph_title.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_title)
end on

type cb_cancel from commandbutton within w_graph_title
int X=992
int Y=204
int Width=366
int Height=96
int TabOrder=20
string Text="취소(&C)"
boolean Cancel=true
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;// Reset the graph title to the original title, since the user
// has hit cancel.

If io_passed = Graph! Then
	igr_parm.title = is_original_title
Elseif io_passed = Datawindow! Then
	// Set the graph title in the datawindow to the modified text.
	idw_parm.Object.gr_1.title = is_original_title
End If

Close (parent)
end event

type cb_ok from commandbutton within w_graph_title
int X=608
int Y=204
int Width=366
int Height=96
int TabOrder=30
string Text="확인(&O)"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

on clicked;Close (parent) 
end on

type sle_title from singlelineedit within w_graph_title
int X=105
int Y=60
int Width=1253
int Height=88
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
long TextColor=41943040
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;If io_passed = Graph! Then
	igr_parm.title = this.text
Elseif io_passed = Datawindow! Then
	// Set the graph title in the datawindow to the modified text.
	idw_parm.Object.gr_1.title = this.text
End If
end event

