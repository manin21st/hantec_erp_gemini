$PBExportHeader$wp_pip3160_mailconf.srw
$PBExportComments$** 급여/상여 명세서(메일환경설정)
forward
global type wp_pip3160_mailconf from window
end type
type uo_1 from u_tabpg_settings within wp_pip3160_mailconf
end type
end forward

global type wp_pip3160_mailconf from window
integer width = 1435
integer height = 1104
boolean titlebar = true
string title = "메일환경설정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
uo_1 uo_1
end type
global wp_pip3160_mailconf wp_pip3160_mailconf

on wp_pip3160_mailconf.create
this.uo_1=create uo_1
this.Control[]={this.uo_1}
end on

on wp_pip3160_mailconf.destroy
destroy(this.uo_1)
end on

type uo_1 from u_tabpg_settings within wp_pip3160_mailconf
integer x = 32
integer y = 20
integer taborder = 10
end type

on uo_1.destroy
call u_tabpg_settings::destroy
end on

