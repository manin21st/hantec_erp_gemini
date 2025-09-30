$PBExportHeader$w_pu01_00020_popup.srw
$PBExportComments$** 월 구매계획 추가
forward
global type w_pu01_00020_popup from window
end type
type p_1 from picture within w_pu01_00020_popup
end type
type dw_1 from datawindow within w_pu01_00020_popup
end type
type sle_1 from singlelineedit within w_pu01_00020_popup
end type
type rr_1 from roundrectangle within w_pu01_00020_popup
end type
end forward

global type w_pu01_00020_popup from window
integer width = 1925
integer height = 524
boolean titlebar = true
string title = "월 구매계획 추가 "
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
dw_1 dw_1
sle_1 sle_1
rr_1 rr_1
end type
global w_pu01_00020_popup w_pu01_00020_popup

on w_pu01_00020_popup.create
this.p_1=create p_1
this.dw_1=create dw_1
this.sle_1=create sle_1
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.dw_1,&
this.sle_1,&
this.rr_1}
end on

on w_pu01_00020_popup.destroy
destroy(this.p_1)
destroy(this.dw_1)
destroy(this.sle_1)
destroy(this.rr_1)
end on

event open;f_window_center(this)

dw_1.insertrow(0)
dw_1.setitem(1,'cvcod',gs_code)
dw_1.setitem(1,'cvnas',gs_codename)

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

//sle_1.setfocus()
end event

event key;Choose Case key
	Case KeyEnter!
		p_1.triggerevent(clicked!)
	Case KeyZ!
		p_1.triggerevent(clicked!)
End Choose
end event

type p_1 from picture within w_pu01_00020_popup
integer x = 1678
integer y = 40
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lcnt
string	scvcod, scvnas, sitnbr, sitdsc

if dw_1.accepttext() = -1 then return

scvcod = dw_1.getitemstring(1,'cvcod')
scvnas = dw_1.getitemstring(1,'cvnas')
sitnbr = dw_1.getitemstring(1,'itnbr')
sitdsc = dw_1.getitemstring(1,'itdsc')

if isnull(scvcod) or scvcod = '' then
	messagebox('확인','공급업체를 지정하세요')
	return
end if

if isnull(sitnbr) or sitnbr = '' then
	messagebox('확인','품번을 지정하세요')
	return
end if

select count(*) into :lcnt from danmst_leewon
 where cvcod = :scvcod and itnbr = :sitnbr ;
if lcnt = 0 then
	messagebox('확인','품목마스타-공급업체 정보와 맞지 않습니다.')
	return
end if

gs_gubun = 'OK'
gs_code = scvcod
gs_codename = sitnbr

close(parent)
end event

type dw_1 from datawindow within w_pu01_00020_popup
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 28
integer width = 1531
integer height = 320
integer taborder = 10
string dataobject = "d_pu01_00020_popup_0"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string 	snull, scode, sname, sittyp

setnull(snull)

IF this.GetColumnName() = "itnbr" THEN
	scode = this.GetText()
	
	select itdsc, ittyp into :sname, :sittyp from itemas
	 where itnbr = :scode and useyn = '0' ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','사용중인 품목이 아닙니다')
		this.setitem(1,"itnbr",snull)	
		this.setitem(1,"itdsc",snull)
		return 1
	else
//		if sittyp = '7' or sittyp = '8' or sittyp = '9' then
//			messagebox('확인','외주품목은 지정할 수 없습니다')
//			this.setitem(1,"itnbr",snull)	
//			this.setitem(1,"itdsc",snull)
//			return 1
//		end if
			
		this.setitem(1,"itdsc",sname)
	end if

ELSEIF this.GetColumnName() = "cvcod" THEN
	scode = this.GetText()
	
	select cvnas into :sname from vndmst
	 where cvcod = :scode and cvstatus = '0' ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','거래중인 업체가 아닙니다')
		this.setitem(1,"cvcod",snull)	
		this.setitem(1,"cvnas",snull)
		return 1
	else
		this.setitem(1,"cvnas",sname)
	end if

END IF	

end event

event itemerror;RETURN 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

IF this.GetColumnName() = "itnbr" THEN
	gs_gubun = this.getitemstring(1,'cvcod')
//	Open(w_dan_item_popup)
	Open(w_itemas_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return

	this.SetItem(1, "itnbr", gs_Code)
	this.triggerevent(itemchanged!)

ELSEIF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return

	this.SetItem(1, "cvcod", gs_Code)
	this.triggerevent(itemchanged!)
END IF	
end event

type sle_1 from singlelineedit within w_pu01_00020_popup
boolean visible = false
integer x = 183
integer y = 512
integer width = 1061
integer height = 144
integer taborder = 10
integer textsize = -20
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;long		lcnt
string	sjpno

sjpno = sle_1.text

select count(*) into :lcnt from poblkt_hist
 where prt_jpno = :sjpno ;

if lcnt = 0 then
	messagebox('확인','처리가능한 납입카드번호가 아닙니다.')
	sle_1.text = ''
	return
end if

gs_gubun = 'OK'
gs_code  = sjpno

close(parent)
end event

type rr_1 from roundrectangle within w_pu01_00020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 16
integer width = 1605
integer height = 368
integer cornerheight = 40
integer cornerwidth = 46
end type

