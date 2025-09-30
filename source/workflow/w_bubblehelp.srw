$PBExportHeader$w_bubblehelp.srw
forward
global type w_bubblehelp from Window
end type
type st_help from statictext within w_bubblehelp
end type
end forward

type os_size from structure
	long		l_cx
	long		l_cy
end type

global type w_bubblehelp from Window
int X=823
int Y=360
int Width=2135
int Height=1188
boolean Visible=false
boolean Enabled=false
long BackColor=15793151
boolean Border=false
WindowType WindowType=popup!
st_help st_help
end type
global w_bubblehelp w_bubblehelp

type prototypes
// Get text size
Function ulong GetDC(ulong hWnd) Library "USER32.DLL"
Function long ReleaseDC(ulong hWnd, ulong hdcr) Library "USER32.DLL"
Function boolean GetTextExtentPoint32A(ulong hdcr, string lpString, long nCount, ref os_size size) Library "GDI32.DLL" alias for "GetTextExtentPoint32A;Ansi"
Function ulong SelectObject(ulong hdc, ulong hWnd) Library "GDI32.DLL"

end prototypes

type variables

end variables

event open;// Copyright 1998 by Cary Hakes (chakes@texas.net)
// See nvo_bubblehelp.Constructor! for details

end event

on w_bubblehelp.create
this.st_help=create st_help
this.Control[]={this.st_help}
end on

on w_bubblehelp.destroy
destroy(this.st_help)
end on

type st_help from statictext within w_bubblehelp
int Width=2039
int Height=1080
boolean Enabled=false
boolean Border=true
boolean FocusRectangle=false
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

