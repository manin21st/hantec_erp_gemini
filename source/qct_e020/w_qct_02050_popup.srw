$PBExportHeader$w_qct_02050_popup.srw
$PBExportComments$** 제안 실시 결과 등록(미실시 사유등록)
forward
global type w_qct_02050_popup from window
end type
type dw_list from datawindow within w_qct_02050_popup
end type
type cb_exit from commandbutton within w_qct_02050_popup
end type
type cb_save from commandbutton within w_qct_02050_popup
end type
type gb_3 from groupbox within w_qct_02050_popup
end type
type str_offer_rex from structure within w_qct_02050_popup
end type
end forward

type str_offer_rex from structure
	string		offno
	string		rcdat
	double		offamt
	double		foramt
	double		wonamt
	boolean		flag
end type

global type w_qct_02050_popup from window
integer x = 1664
integer y = 524
integer width = 1847
integer height = 604
boolean titlebar = true
string title = "미실시 사유 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
dw_list dw_list
cb_exit cb_exit
cb_save cb_save
gb_3 gb_3
end type
global w_qct_02050_popup w_qct_02050_popup

type variables
string ls_jpno
end variables

on w_qct_02050_popup.create
this.dw_list=create dw_list
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.gb_3=create gb_3
this.Control[]={this.dw_list,&
this.cb_exit,&
this.cb_save,&
this.gb_3}
end on

on w_qct_02050_popup.destroy
destroy(this.dw_list)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.gb_3)
end on

event open;f_window_center(this)

dw_list.SetTransObject(SQLCA)

ls_jpno = gs_code 
IF dw_list.Retrieve(gs_sabu, ls_jpno)  < 1 then 
	dw_list.insertrow(0)
	dw_list.setitem(1, 'sabu', gs_sabu)
	dw_list.setitem(1, 'prop_jpno', ls_jpno)
END IF


end event

type dw_list from datawindow within w_qct_02050_popup
integer x = 32
integer y = 40
integer width = 1787
integer height = 272
integer taborder = 30
string dataobject = "d_qct_02050_03"
boolean border = false
end type

type cb_exit from commandbutton within w_qct_02050_popup
integer x = 1417
integer y = 352
integer width = 329
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

event clicked;//gs_code = 'N'
close(parent)
end event

type cb_save from commandbutton within w_qct_02050_popup
integer x = 1070
integer y = 352
integer width = 329
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;if dw_list.update() = 1 then
   COMMIT;
//	gs_code = 'Y'
	close(parent)
else
	ROLLBACK;
   f_rollback()
end if



end event

type gb_3 from groupbox within w_qct_02050_popup
integer x = 1010
integer y = 296
integer width = 786
integer height = 188
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

