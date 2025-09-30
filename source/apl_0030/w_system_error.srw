$PBExportHeader$w_system_error.srw
$PBExportComments$시스템 에러 표시
forward
global type w_system_error from Window
end type
type dw_error from datawindow within w_system_error
end type
type cb_print from commandbutton within w_system_error
end type
type cb_exit from commandbutton within w_system_error
end type
type cb_continue from commandbutton within w_system_error
end type
end forward

global type w_system_error from Window
int X=434
int Y=428
int Width=2528
int Height=1092
boolean TitleBar=true
string Title="System Error"
long BackColor=79741120
WindowType WindowType=response!
dw_error dw_error
cb_print cb_print
cb_exit cb_exit
cb_continue cb_continue
end type
global w_system_error w_system_error

on open;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.open
//
// Purpose:
// 			Displays system errors and allows the user to either continue
//				running the application, exit the application, or print the 
//				error message.  Called from the systemerror event in the
//				application object.
//
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

dw_error.insertrow (1)

dw_error.setitem (1,"errornum",string(error.number))
dw_error.setitem (1,"message" ,error.text)
dw_error.setitem (1,"where"   ,error.windowmenu)
dw_error.setitem (1,"object"  ,error.object)
dw_error.setitem (1,"event"   ,error.objectevent)
dw_error.setitem (1,"line"    ,string(error.line))



end on

on w_system_error.create
this.dw_error=create dw_error
this.cb_print=create cb_print
this.cb_exit=create cb_exit
this.cb_continue=create cb_continue
this.Control[]={this.dw_error,&
this.cb_print,&
this.cb_exit,&
this.cb_continue}
end on

on w_system_error.destroy
destroy(this.dw_error)
destroy(this.cb_print)
destroy(this.cb_exit)
destroy(this.cb_continue)
end on

type dw_error from datawindow within w_system_error
int X=59
int Y=40
int Width=2382
int Height=740
int TabOrder=10
boolean Enabled=false
string DataObject="d_system_error"
BorderStyle BorderStyle=StyleLowered!
end type

type cb_print from commandbutton within w_system_error
int X=1545
int Y=856
int Width=361
int Height=88
int TabOrder=40
string Text="&Print"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.cb_print.clicked!
//
// Purpose:
// 			Event cb_print.clicked - Print the current error message
//				and write the error message to the supplied file name.
//
// Log:
// 
//  DATE		NAME				REVISION
// ------	-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

string ls_line
int	li_prt

li_prt   = printopen("System Error")

// Print each string variable

print    (li_prt, "System error message - "+string(today())+" - "+string(now(), "HH:MM:SS"))
print    (li_prt, " ")

ls_line = "Error Number  : " + getitemstring(dw_error,1,1)
print    (li_prt, ls_line)

ls_line = "Error Message : " + getitemstring(dw_error,1,2)
print    (li_prt, ls_line)

ls_line = "Window/Menu   : " + getitemstring(dw_error,1,3)
print    (li_prt, ls_line)

ls_line = "Object        : " + getitemstring(dw_error,1,4)
print    (li_prt, ls_line)

ls_line = "Event         : " + getitemstring(dw_error,1,5)
print    (li_prt, ls_line)

ls_line = "Line Number   : " + getitemstring(dw_error,1,6)
print    (li_prt, ls_line)

printclose(li_prt)
return
end on

type cb_exit from commandbutton within w_system_error
int X=439
int Y=856
int Width=640
int Height=88
int TabOrder=30
string Text="Exit The Program"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.cb_exit
//
// Purpose:
// 			Ends the application session
//
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

halt close
end on

type cb_continue from commandbutton within w_system_error
int X=1115
int Y=856
int Width=361
int Height=88
int TabOrder=20
string Text="&Continue"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.cb_continue
//
// Purpose:
// 			Closes w_system_error
//
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

close(parent)
end on

