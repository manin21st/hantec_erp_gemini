$PBExportHeader$w_pdt_02451.srw
$PBExportComments$금형/치공구 제작의뢰 popup
forward
global type w_pdt_02451 from w_inherite_popup
end type
type dw_2 from datawindow within w_pdt_02451
end type
end forward

global type w_pdt_02451 from w_inherite_popup
integer x = 123
integer y = 432
integer width = 3383
integer height = 1792
string title = "제작의뢰 조회"
dw_2 dw_2
end type
global w_pdt_02451 w_pdt_02451

on w_pdt_02451.create
int iCurrent
call super::create
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
end on

on w_pdt_02451.destroy
call super::destroy
destroy(this.dw_2)
end on

event open;call super::open;dw_2.insertrow(0)
dw_2.setitem(1, "sfrom", f_afterday(f_today(), -30))
dw_2.setitem(1, "sto", f_today())

If gs_gubun = '치공구' then
	dw_2.setitem(1, "mjgbn", 'J')
ELSEIF gs_gubun = '금형' then
	dw_2.setitem(1, "mjgbn", 'M')
END IF

If gs_code = '사내' then
	dw_2.setitem(1, "makgub", '1')
elseIf gs_code = '사외' then
	dw_2.setitem(1, "makgub", '2')
elseIf gs_code = '구매' then
	dw_2.setitem(1, "makgub", '3')
END IF

end event

type dw_1 from w_inherite_popup`dw_1 within w_pdt_02451
integer x = 18
integer y = 204
integer width = 3314
integer height = 1352
string dataobject = "d_pdt_02451_2"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;call super::doubleclicked;if row > 0 then
	gs_code = dw_1.getitemstring(row, "kestno")
	close(parent)
end if
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdt_02451
boolean visible = false
integer x = 727
integer y = 1996
integer taborder = 30
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_02451
integer x = 2405
integer y = 1576
integer taborder = 40
end type

event cb_1::clicked;call super::clicked;if dw_1.getrow() > 0 then
	gs_code = dw_1.getitemstring(dw_1.getrow(), "kestno")
	close(parent)
end if
end event

type cb_return from w_inherite_popup`cb_return within w_pdt_02451
integer x = 3035
integer y = 1576
integer taborder = 60
end type

event cb_return::clicked;call super::clicked;setnull(gs_code)
setnull(gs_codename)
close(parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_pdt_02451
integer x = 2720
integer y = 1576
integer taborder = 50
end type

event cb_inq::clicked;string stdat, eddat, kestgub, makgub, mjgbn, sConf

if dw_2.accepttext() = -1 then return 

stdat 	= dw_2.getitemstring(1, "sfrom")
eddat   	= dw_2.getitemstring(1, "sto")
kestgub 	= dw_2.getitemstring(1, "kestgub")
makgub 	= dw_2.getitemstring(1, "makgub")
mjgbn		= dw_2.getitemstring(1, "mjgbn")
sConf    = dw_2.getitemstring(1, "conf")

if isnull(stdat) or stdat ='' then stdat = '10000101'
if isnull(eddat) or eddat ='' then eddat = '99991231'

dw_1.retrieve(gs_sabu, stdat, eddat, kestgub, makgub, mjgbn, sConf)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type sle_1 from w_inherite_popup`sle_1 within w_pdt_02451
boolean visible = false
integer x = 544
integer y = 1996
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_02451
end type

type dw_2 from datawindow within w_pdt_02451
integer y = 12
integer width = 3333
integer height = 180
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_02451_1"
boolean border = false
boolean livescroll = true
end type

