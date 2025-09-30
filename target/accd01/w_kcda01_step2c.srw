$PBExportHeader$w_kcda01_step2c.srw
forward
global type w_kcda01_step2c from w_inherite
end type
type p_mod from w_inherite`p_mod within w_kcda01_step2c
end type
end forward

global type w_kcda01_step2c from w_inherite
int Width=1024, Height=768
string title = "Inherited Control Test (p_mod)"
p_mod p_mod
end type
global w_kcda01_step2c w_kcda01_step2c

on w_kcda01_step2c.create
call super::create
this.p_mod=create p_mod
end on

on w_kcda01_step2c.destroy
call super::destroy
destroy(this.p_mod)
end on

type p_mod from w_inherite`p_mod within w_kcda01_step2c
    visible = false
    x = 2727
    y = 1500
end type
