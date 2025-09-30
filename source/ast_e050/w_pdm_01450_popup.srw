$PBExportHeader$w_pdm_01450_popup.srw
$PBExportComments$** 실적시간 & 수량 조회
forward
global type w_pdm_01450_popup from w_inherite
end type
type dw_1 from datawindow within w_pdm_01450_popup
end type
type cb_save from commandbutton within w_pdm_01450_popup
end type
type rr_1 from roundrectangle within w_pdm_01450_popup
end type
end forward

global type w_pdm_01450_popup from w_inherite
integer x = 169
integer y = 212
integer width = 3762
integer height = 1992
string title = "실적시간 & 수량 조회"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_1 dw_1
cb_save cb_save
rr_1 rr_1
end type
global w_pdm_01450_popup w_pdm_01450_popup

type variables


end variables

on w_pdm_01450_popup.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_save=create cb_save
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_save
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdm_01450_popup.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_save)
destroy(this.rr_1)
end on

event open;call super::open;f_window_center_response(this)

string fdate, tdate, sitdsc, sispec, sopsnm

fdate = left(gs_gubun, 8) 
tdate = mid(gs_gubun, 9, 8) 

SELECT ITDSC,   ISPEC  
  INTO :sitdsc, :sispec
  FROM ITEMAS  
 WHERE ITNBR = :gs_code   ;

SELECT OPDSC  
  INTO :sopsnm  
  FROM ROUTNG  
 WHERE ITNBR = :gs_code AND  OPSEQ = :gs_codename  ;

dw_1.insertrow(0)
dw_1.setitem(1, 'itnbr', gs_code)
dw_1.setitem(1, 'itdsc', sitdsc)
dw_1.setitem(1, 'ispec', sispec)
dw_1.setitem(1, "opseq", gs_codename)
dw_1.setitem(1, "opsnm", sopsnm)
dw_1.setitem(1, "fdate", fdate)
dw_1.setitem(1, "tdate", tdate)

dw_insert.SetTransObject(SQLCA)
dw_insert.retrieve(gs_sabu, fdate, tdate, gs_code, gs_codename)


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01450_popup
integer x = 59
integer y = 260
integer width = 3634
integer height = 1600
integer taborder = 0
string dataobject = "d_pdm_01450_popup"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01450_popup
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01450_popup
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdm_01450_popup
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdm_01450_popup
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdm_01450_popup
integer x = 3534
integer y = 20
end type

type p_can from w_inherite`p_can within w_pdm_01450_popup
integer y = 5000
end type

type p_print from w_inherite`p_print within w_pdm_01450_popup
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdm_01450_popup
integer y = 5000
end type

type p_del from w_inherite`p_del within w_pdm_01450_popup
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdm_01450_popup
integer y = 5000
end type

type cb_exit from w_inherite`cb_exit within w_pdm_01450_popup
integer x = 3049
integer y = 2028
integer width = 361
integer taborder = 20
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01450_popup
integer x = 1019
integer y = 2252
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01450_popup
boolean visible = false
integer x = 832
integer y = 2452
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdm_01450_popup
boolean visible = false
integer x = 2254
integer y = 2452
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01450_popup
boolean visible = false
integer x = 270
integer y = 2452
end type

type cb_print from w_inherite`cb_print within w_pdm_01450_popup
boolean visible = false
integer x = 1253
integer y = 2452
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdm_01450_popup
integer y = 2000
end type

type cb_can from w_inherite`cb_can within w_pdm_01450_popup
integer x = 1381
integer y = 2252
boolean cancel = true
end type

event cb_can::clicked;call super::clicked;//rollback;
//
//close(parent)
end event

type cb_search from w_inherite`cb_search within w_pdm_01450_popup
boolean visible = false
integer x = 1687
integer y = 2452
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01450_popup
integer x = 1989
integer y = 2000
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01450_popup
integer y = 2000
integer width = 1609
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01450_popup
integer y = 2040
integer width = 2734
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01450_popup
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01450_popup
end type

type dw_1 from datawindow within w_pdm_01450_popup
integer x = 41
integer y = 8
integer width = 2473
integer height = 220
boolean bringtotop = true
string dataobject = "d_pdm_01450_popup1"
boolean border = false
boolean livescroll = true
end type

type cb_save from commandbutton within w_pdm_01450_popup
boolean visible = false
integer x = 2651
integer y = 2012
integer width = 361
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "저장(&S)"
end type

type rr_1 from roundrectangle within w_pdm_01450_popup
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 240
integer width = 3685
integer height = 1632
integer cornerheight = 40
integer cornerwidth = 55
end type

