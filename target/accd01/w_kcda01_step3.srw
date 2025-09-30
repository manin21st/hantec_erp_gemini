$PBExportHeader$w_kcda01_step3.srw
forward
global type w_kcda01_step3 from w_inherite
end type
type p_mod from w_inherite`p_mod within w_kcda01_step3
end type
end forward

global type w_kcda01_step3 from w_inherite
int Width=1024, Height=768
string title = "Inheritance Final Test (p_mod)"
end type
global w_kcda01_step3 w_kcda01_step3

on w_kcda01_step3.create
call super::create
end on

on w_kcda01_step3.destroy
call super::destroy
end on

type p_mod from w_inherite`p_mod within w_kcda01_step3
    x = 2727
    y = 1500
end type
