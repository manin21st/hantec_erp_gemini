$PBExportHeader$w_graph_pie_explode.srw
$PBExportComments$Pie Graph Size 조절
forward
global type w_graph_pie_explode from Window
end type
type em_explode from editmask within w_graph_pie_explode
end type
type cb_cancel from commandbutton within w_graph_pie_explode
end type
type cb_ok from commandbutton within w_graph_pie_explode
end type
end forward

global type w_graph_pie_explode from Window
int X=105
int Y=216
int Width=873
int Height=436
boolean TitleBar=true
string Title="Select Spacing Percent"
long BackColor=79741120
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
em_explode em_explode
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_graph_pie_explode w_graph_pie_explode

type variables
object io_passed
graph igr_parm
datawindow idw_parm
int ii_original_explode
int ii_series
int ii_datapoint
end variables

event open;graphicobject lgro_hold
grobjecttype lgrot_clickedtype
str_graphobjectatpoint lstr_graph
string ls_category, is_objnm

f_window_center(this)
  
lstr_graph = Message.PowerObjectParm
lgro_hold = lstr_graph.graphicobject
ii_series = lstr_graph.series
ii_datapoint = lstr_graph.datapoint
is_objnm = lstr_graph.objnm

If lgro_hold.TypeOf() = Graph! Then
	io_passed = Graph!
	igr_parm = lgro_hold
	igr_parm.GetDataPieExplode(ii_series,ii_datapoint,ii_original_explode)
	ls_category = igr_parm.categoryname(ii_datapoint)
Elseif lgro_hold.TypeOf() = Datawindow! Then
	io_passed = Datawindow!
	idw_parm = lstr_graph.graphicobject
	idw_parm.GetDataPieExplode(is_objnm,ii_series,ii_datapoint,ii_original_explode)
	ls_category = idw_parm.categoryname(is_objnm,ii_datapoint)
End If

If ii_original_explode = 0 Then
	em_explode.text = "50"
	em_explode.triggerevent("ue_enchange")
Else
	em_explode.text = string(ii_original_explode)
End If

//set window name to category
this.title = "~"" + ls_category + "~""
end event

on w_graph_pie_explode.create
this.em_explode=create em_explode
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.em_explode,&
this.cb_cancel,&
this.cb_ok}
end on

on w_graph_pie_explode.destroy
destroy(this.em_explode)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type em_explode from editmask within w_graph_pie_explode
event ue_enchange pbm_enchange
int X=210
int Y=64
int Width=457
int Height=100
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
string Mask="####0"
boolean Spin=true
double Increment=10
string MinMax="0~~100"
long TextColor=41943040
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on ue_enchange;If io_passed = Graph! Then
      igr_parm.SetDataPieExplode(ii_series,ii_datapoint,integer(em_explode.text))
Elseif io_passed = Datawindow! Then
      idw_parm.SetDataPieExplode("gr_1",ii_series,ii_datapoint,integer(em_explode.text))
End If

end on

type cb_cancel from commandbutton within w_graph_pie_explode
int X=443
int Y=212
int Width=343
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

on clicked;If io_passed = Graph! Then
      igr_parm.SetDataPieExplode(ii_series,ii_datapoint,ii_original_explode)
Elseif io_passed = Datawindow! Then
      idw_parm.SetDataPieExplode("gr_1",ii_series,ii_datapoint,ii_original_explode)
End If

Close (parent)
end on

type cb_ok from commandbutton within w_graph_pie_explode
int X=78
int Y=212
int Width=343
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

on clicked;
Close (parent) 
end on

