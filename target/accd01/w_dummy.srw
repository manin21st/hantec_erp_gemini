$PBExportHeader$w_dummy.srw
forward
global type w_dummy from window
end type
end forward

global type w_dummy from window
int Width=1024, Height=768
string title = "Dummy Window"
end type
global w_dummy w_dummy

on w_dummy.create
call super::create
end on

on w_dummy.destroy
call super::destroy
end on
