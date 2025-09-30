$PBExportHeader$w_kcda01_step2a.srw
forward
global type w_kcda01_step2a from w_inherite
end type
end forward

global type w_kcda01_step2a from w_inherite
int Width=1024, Height=768
string title = "Inheritance Test"
end type
global w_kcda01_step2a w_kcda01_step2a

on w_kcda01_step2a.create
call super::create
end on

on w_kcda01_step2a.destroy
call super::destroy
end on
