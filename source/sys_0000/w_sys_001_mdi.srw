$PBExportHeader$w_sys_001_mdi.srw
$PBExportComments$Security 包府 (MDI  MAIN)
forward
global type w_sys_001_mdi from Window
end type
type mdi_1 from mdiclient within w_sys_001_mdi
end type
end forward

global type w_sys_001_mdi from Window
int X=0
int Y=0
int Width=3657
int Height=2400
boolean TitleBar=true
string Title="Security包府"
string MenuName="m_sys_001_mdi"
long BackColor=16777215
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
WindowType WindowType=mdihelp!
mdi_1 mdi_1
end type
global w_sys_001_mdi w_sys_001_mdi

type variables
Long il_dragsource, il_dragparent, il_droptarget
end variables

on w_sys_001_mdi.create
if this.MenuName = "m_sys_001_mdi" then this.MenuID = create m_sys_001_mdi
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_sys_001_mdi.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

type mdi_1 from mdiclient within w_sys_001_mdi
long BackColor=15793151
end type

