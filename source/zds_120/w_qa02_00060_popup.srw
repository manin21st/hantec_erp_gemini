$PBExportHeader$w_qa02_00060_popup.srw
$PBExportComments$** 매입 클레임 처리
forward
global type w_qa02_00060_popup from w_inherite_popup
end type
type p_mod from uo_picture within w_qa02_00060_popup
end type
type p_1 from picture within w_qa02_00060_popup
end type
type st_2 from statictext within w_qa02_00060_popup
end type
type st_3 from statictext within w_qa02_00060_popup
end type
type st_itnbr from statictext within w_qa02_00060_popup
end type
type st_cvcod from statictext within w_qa02_00060_popup
end type
type st_4 from statictext within w_qa02_00060_popup
end type
type st_yymm from statictext within w_qa02_00060_popup
end type
type rr_1 from roundrectangle within w_qa02_00060_popup
end type
end forward

global type w_qa02_00060_popup from w_inherite_popup
integer x = 1257
integer y = 188
integer width = 3429
integer height = 1612
string title = "이상 발생 내역 조회 [ 가공비 단가 계산]"
event ue_postopen ( )
p_mod p_mod
p_1 p_1
st_2 st_2
st_3 st_3
st_itnbr st_itnbr
st_cvcod st_cvcod
st_4 st_4
st_yymm st_yymm
rr_1 rr_1
end type
global w_qa02_00060_popup w_qa02_00060_popup

type variables
str_mro	istmro
end variables

event ue_postopen;//string	sitdsc, scvnas
//
//if gs_codename2 = '1' then
//	st_4.text = '처리년월:'
//	st_yymm.text = string(gs_gubun,'@@@@.@@')
//	dw_1.dataobject = 'd_qa02_00060_popup1_t'
//else
//	st_4.text = '처리번호:'
//	st_yymm.text = string(gs_gubun,'@@@@@@-@@@')
//	dw_1.dataobject = 'd_qa02_00060_popup0_t'
//end if
//dw_1.settransobject(sqlca)
//
//select itdsc into :sitdsc from itemas where itnbr = :gs_code ;
//st_itnbr.text = gs_code + '     ' + sitdsc
//
//select cvnas into :scvnas from vndmst where cvcod = :gs_codename ;
//st_cvcod.text = gs_codename + '     ' + scvnas
//
//setpointer(hourglass!)
//dw_1.Retrieve(gs_saupj,gs_gubun,gs_code,gs_codename)
//
//setnull(gs_code)
end event

on w_qa02_00060_popup.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.p_1=create p_1
this.st_2=create st_2
this.st_3=create st_3
this.st_itnbr=create st_itnbr
this.st_cvcod=create st_cvcod
this.st_4=create st_4
this.st_yymm=create st_yymm
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_itnbr
this.Control[iCurrent+6]=this.st_cvcod
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_yymm
this.Control[iCurrent+9]=this.rr_1
end on

on w_qa02_00060_popup.destroy
call super::destroy
destroy(this.p_mod)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_itnbr)
destroy(this.st_cvcod)
destroy(this.st_4)
destroy(this.st_yymm)
destroy(this.rr_1)
end on

event open;call super::open;string	sitdsc, scvnas

if gs_codename2 = '1' then
	st_4.text = '처리년월:'
	st_yymm.text = string(gs_gubun,'@@@@.@@')
	dw_1.dataobject = 'd_qa02_00060_popup1_t'
else
	st_4.text = '처리번호:'
	st_yymm.text = string(gs_gubun,'@@@@@@-@@@')
	dw_1.dataobject = 'd_qa02_00060_popup0_t'
end if
dw_1.settransobject(sqlca)

select itdsc into :sitdsc from itemas where itnbr = :gs_code ;
st_itnbr.text = gs_code + '     ' + sitdsc

select cvnas into :scvnas from vndmst where cvcod = :gs_codename ;
st_cvcod.text = gs_codename + '     ' + scvnas

setpointer(hourglass!)
dw_1.Retrieve(gs_saupj,gs_gubun,gs_code,gs_codename)

setnull(gs_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qa02_00060_popup
integer x = 1696
integer y = 2192
end type

type p_exit from w_inherite_popup`p_exit within w_qa02_00060_popup
boolean visible = false
integer x = 2345
integer y = 1712
end type

event p_exit::clicked;call super::clicked;//SetNull(gs_code)
//SetNull(gs_codename)
//
//Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_qa02_00060_popup
integer x = 3090
integer y = 36
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
return 0
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
return 0
end event

event p_inq::clicked;call super::clicked;gs_code = string(dw_1.getitemnumber(1,'workprc'))
close(parent)
end event

type p_choose from w_inherite_popup`p_choose within w_qa02_00060_popup
boolean visible = false
integer x = 2574
integer y = 1716
end type

event p_choose::clicked;call super::clicked;//long 		ll_row
//string	smark=''
//
//FOR ll_row = 1 TO dw_1.rowcount()
//	smark = smark + dw_1.getitemstring(ll_row,'yn')
//NEXT
//
//gs_code = smark
//
//Close(Parent)
//
end event

type dw_1 from w_inherite_popup`dw_1 within w_qa02_00060_popup
integer x = 32
integer y = 268
integer width = 3333
integer height = 1196
integer taborder = 10
string dataobject = "d_qa02_00060_popup1_t"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code = string(dw_1.GetItemNumber(Row, "gugan"))
//
//Close(Parent)
//
end event

event dw_1::rowfocuschanged;//
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(currentrow,True)
//
//dw_1.ScrollToRow(currentrow)
end event

event type long dw_1::ue_pressenter();//
//cb_1.TriggerEvent(Clicked!)
return 0
end event

type sle_2 from w_inherite_popup`sle_2 within w_qa02_00060_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_qa02_00060_popup
boolean visible = false
integer x = 357
integer y = 1908
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_qa02_00060_popup
boolean visible = false
integer x = 677
integer y = 1908
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_qa02_00060_popup
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_qa02_00060_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_qa02_00060_popup
boolean visible = false
end type

type p_mod from uo_picture within w_qa02_00060_popup
boolean visible = false
integer x = 2798
integer y = 1728
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;long		lrow
string	scolid

dw_1.accepttext()
FOR lrow = 1 TO dw_1.rowcount()
	scolid = dw_1.getitemstring(lrow,'colid')
	if scolid = 'JIJIL' then istmro.jijil = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MHORIZON' then istmro.mhorizon = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MVERTICAL' then istmro.mvertical = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MHEIGHT' then istmro.mheight = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MWIDTH' then istmro.mwidth = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MHOLE' then istmro.mhole = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MCOLOR' then istmro.mcolor = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MOUTDIA' then istmro.moutdia = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MINDIA' then istmro.mindia = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MLENGTH' then istmro.mlength = dec(dw_1.getitemstring(lrow,'mvalue'))
	if scolid = 'MSIZE' then istmro.msize = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MUSAGE' then istmro.musage = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MAKER' then istmro.maker = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MTYPE' then istmro.mtype = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MOIL' then istmro.moil = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MJUMDO' then istmro.mjumdo = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MVENDOR' then istmro.mvendor = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MJUNGDO' then istmro.mjungdo = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MSERNO' then istmro.mserno = dw_1.getitemstring(lrow,'mvalue')
	if scolid = 'MYONGDO' then istmro.myongdo = dw_1.getitemstring(lrow,'mvalue')
NEXT

gs_code = 'OK'

Closewithreturn(Parent,istmro)
end event

type p_1 from picture within w_qa02_00060_popup
boolean visible = false
integer x = 2990
integer y = 1724
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\결재상신.gif"
boolean focusrectangle = false
end type

type st_2 from statictext within w_qa02_00060_popup
integer x = 50
integer y = 108
integer width = 329
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "소재품번:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_qa02_00060_popup
integer x = 55
integer y = 176
integer width = 329
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "공급업체:"
boolean focusrectangle = false
end type

type st_itnbr from statictext within w_qa02_00060_popup
integer x = 411
integer y = 108
integer width = 1426
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean focusrectangle = false
end type

type st_cvcod from statictext within w_qa02_00060_popup
integer x = 411
integer y = 176
integer width = 1426
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean focusrectangle = false
end type

type st_4 from statictext within w_qa02_00060_popup
integer x = 50
integer y = 40
integer width = 329
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "처리년월:"
boolean focusrectangle = false
end type

type st_yymm from statictext within w_qa02_00060_popup
integer x = 411
integer y = 40
integer width = 334
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qa02_00060_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 256
integer width = 3374
integer height = 1216
integer cornerheight = 40
integer cornerwidth = 55
end type

