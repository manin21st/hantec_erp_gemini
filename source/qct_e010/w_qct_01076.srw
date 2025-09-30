$PBExportHeader$w_qct_01076.srw
$PBExportComments$이상발생 조치 내역 및 통보내역등록
forward
global type w_qct_01076 from w_inherite
end type
type dw_1 from datawindow within w_qct_01076
end type
type dw_2 from datawindow within w_qct_01076
end type
type pb_1 from u_pb_cal within w_qct_01076
end type
type pb_2 from u_pb_cal within w_qct_01076
end type
type pb_3 from u_pb_cal within w_qct_01076
end type
type gb_3 from groupbox within w_qct_01076
end type
type gb_2 from groupbox within w_qct_01076
end type
type gb_1 from groupbox within w_qct_01076
end type
type gb_4 from groupbox within w_qct_01076
end type
end forward

global type w_qct_01076 from w_inherite
integer x = 5
integer y = 100
integer width = 3191
integer height = 2396
string title = "이상발생 통보 내역 및 조치내역"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
dw_1 dw_1
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
gb_4 gb_4
end type
global w_qct_01076 w_qct_01076

type variables

end variables

on w_qct_01076.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_4
end on

on w_qct_01076.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_4)
end on

event open;call super::open;String sitnbr, sitdsc, sispec , ls_jijil,ls_ispec, ls
Decimal  {3} dioreqty, diofaqty, diocdqty

/* 기본내역 */
Select a.itnbr, b.itdsc, b.ispec, a.ioreqty, a.iofaqty, a.iocdqty,b.jijil,b.ispec_code
  into :sitnbr, :sitdsc, :sispec, :dioreqty, :diofaqty, :diocdqty, :ls_jijil, :ls_ispec
  from imhist a, itemas b
 where a.sabu  = :gs_sabu and a.iojpno = :gs_code
   and a.itnbr = b.itnbr;


dw_1.insertrow(0)
dw_1.setitem(1, "iojpno", gs_code)
dw_1.setitem(1, "itnbr",  sitnbr)
dw_1.setitem(1, "itdsc",  sitdsc)
dw_1.setitem(1, "ispec",  sispec)
dw_1.setitem(1, "ioqty",  dioreqty)
dw_1.setitem(1, "buqty",  diofaqty)
dw_1.setitem(1, "joqty",  diocdqty)
dw_1.setitem(1, "jijil",  ls_jijil)
dw_1.setitem(1, "ispec_code",  ls_ispec)

/* 이상발생 조치내역 */
dw_insert.settransobject(sqlca)
dw_2.settransobject(sqlca)
if dw_insert.retrieve(gs_sabu, gs_code) < 1 then
	dw_insert.insertrow(0)
	dw_insert.setitem(1, "sabu", gs_sabu)
	dw_insert.setitem(1, "iojpno", gs_code)
end if

dw_insert.setfocus()

f_window_center(this)
end event

type dw_insert from w_inherite`dw_insert within w_qct_01076
integer x = 0
integer y = 536
integer width = 3077
integer height = 1656
string dataobject = "d_qct_01076_1"
boolean border = false
end type

event dw_insert::itemchanged;string snull, sdata 
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'baldat' then
	sdata = TRIM(this.gettext())
	if isnull(sdata) or trim(sdata) = '' then return
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[발신일자]');
		this.setitem(1, "baldat", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'jochydat' then
	sdata = TRIM(this.gettext())
	if isnull(sdata) or trim(sdata) = '' then return
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[조치요청일]');
		this.setitem(1, "jochydat", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'jochwdat' then
	sdata = TRIM(this.gettext())	
	if isnull(sdata) or trim(sdata) = '' then return		
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[조치완료일]');
		this.setitem(1, "jochwdat", snull)
		return 1		
	end if
	if trim(this.getitemstring(1, "jochydat")) > sdata then
		f_message_chk(34,'[조치요청일]');
		this.setitem(1, "jochwdat", snull)
		return 1					
	end if
end if


end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_qct_01076
boolean visible = false
integer x = 4517
integer y = 408
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qct_01076
integer x = 4517
integer y = 1008
integer width = 174
integer height = 148
end type

type p_search from w_inherite`p_search within w_qct_01076
boolean visible = false
integer x = 5179
integer y = 828
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qct_01076
integer x = 4517
integer y = 720
end type

type p_exit from w_inherite`p_exit within w_qct_01076
integer x = 2967
end type

type p_can from w_inherite`p_can within w_qct_01076
integer x = 4517
integer y = 860
end type

type p_print from w_inherite`p_print within w_qct_01076
boolean visible = false
integer x = 3209
integer y = 304
end type

event p_print::clicked;call super::clicked;cb_print.TriggerEvent(Clicked!)
end event

type p_inq from w_inherite`p_inq within w_qct_01076
boolean visible = false
integer x = 3397
integer y = 308
end type

event p_inq::clicked;call super::clicked;cb_inq.TriggerEvent(Clicked!)
end event

type p_del from w_inherite`p_del within w_qct_01076
integer x = 2793
end type

event p_del::clicked;call super::clicked;cb_del.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_qct_01076
integer x = 2619
end type

event p_mod::clicked;call super::clicked;cb_mod.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qct_01076
integer x = 2213
integer y = 2008
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_qct_01076
integer x = 87
integer y = 2008
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return

if    (isnull(dw_insert.getitemstring(1, "jochydat"))  and &
	not isnull(dw_insert.getitemstring(1, "jochwdat"))) then
	    Messagebox("조치일", "요청일 또는 완료일이 부정확합니다", stopsign!)
		 dw_insert.setcolumn("jochwdat")
		 dw_insert.setfocus()	
	return
end if

if    (isnull(dw_insert.getitemstring(1, "jochydat")) and &
	not isnull(dw_insert.getitemstring(1, "murmks")))   or &
  (not isnull(dw_insert.getitemstring(1, "jochydat")) and &
	    isnull(dw_insert.getitemstring(1, "murmks"))) Then 
	    Messagebox("조치요청일", "조치요청일 또는 문제점이 부정확 합니다", stopsign!)
		 dw_insert.setcolumn("jochydat")
		 dw_insert.setfocus()			 
	  	 return
end if

//if    (isnull(dw_insert.getitemstring(1, "jochwdat")) and &
//	not isnull(dw_insert.getitemstring(1, "datrmks")))   or &
//  (not isnull(dw_insert.getitemstring(1, "jochwdat")) and &
//	    isnull(dw_insert.getitemstring(1, "datrmks"))) Then 
//	    Messagebox("조치완료일", "조치완료일 또는 대책이 부정확 합니다", stopsign!)
//		 dw_insert.setcolumn("jochwdat")
//		 dw_insert.setfocus()
//	  	 return
//end if

if dw_insert.update() = 1 then
	commit;
	close(parent)
else
	rollback;
	f_rollback()
end if


end event

type cb_ins from w_inherite`cb_ins within w_qct_01076
integer x = 69
integer y = 2376
end type

type cb_del from w_inherite`cb_del within w_qct_01076
integer x = 434
integer y = 2008
integer taborder = 60
end type

event cb_del::clicked;call super::clicked;dw_insert.deleterow(1)

if dw_insert.update() = 1 then
	commit;
	close(parent)
else
	rollback;
	f_rollback()
end if

end event

type cb_inq from w_inherite`cb_inq within w_qct_01076
integer x = 2821
integer y = 2140
integer width = 475
integer taborder = 70
boolean enabled = false
end type

event cb_inq::clicked;call super::clicked;Long	 Lrow, Lnam, lcurr, llast
String siojpno, sCvnas
siojpno = dw_1.getitemstring(1, "iojpno")

If Messagebox("저장확인", "저장후 출력하시겠읍니까?", information!, yesno!) = 1 then
	if dw_insert.accepttext() = -1 then return
	
	if dw_insert.update() = 1 then
		commit;
	else
		rollback;
		f_rollback()
	end if
end if

IF dw_2.retrieve(gs_sabu, siojpno) = -1 THEN
	cb_print.Enabled =False
	SetPointer(Arrow!)
	Return
ELSE
		
	/* 한 건당 5건을 기준으로 출력물이 되어있음 */
	if mod(dw_2.rowcount(), 5) <> 0 then
		Lnam = 5 - (truncate(mod(dw_2.rowcount(), 5), 0))
		llast = dw_2.rowcount()
		for lrow = 1 to Lnam
			 lcurr = dw_2.insertrow(0)			
			 dw_2.object.data[lcurr] = dw_2.object.data[llast]
			 dw_2.setitem(lcurr, "hanmok", '')
			 dw_2.setitem(lcurr, "bulname", '')
			 dw_2.setitem(lcurr, "bulsan", '')
			 dw_2.setitem(lcurr, "silyoq", 0)
			 dw_2.setitem(lcurr, "bulqty", 0)
		Next
	end if
	
	/* 자사거래처명 출력 */
	SELECT CVNAS
	  INTO :sCvnas
	  FROM SYSCNFG, vndmst
	 WHERE SYSGU = 'C' and SERIAL = '4' and LINENO = '1'
	 	AND DATANAME = CVCOD;	
		 
	dw_2.object.last_text.text = sCvnas
	
	cb_print.Enabled =True
	dw_2.object.datawindow.print.preview="yes"
END IF
dw_2.scrolltorow(1)
SetPointer(Arrow!)

end event

type cb_print from w_inherite`cb_print within w_qct_01076
integer x = 2798
integer y = 2008
integer width = 475
integer taborder = 80
end type

event cb_print::clicked;call super::clicked;gi_page = 1
//dw_2.GetItemNumber(1,"last_page")
OpenWithParm(w_print_options, dw_2)
end event

type st_1 from w_inherite`st_1 within w_qct_01076
integer y = 2184
end type

type cb_can from w_inherite`cb_can within w_qct_01076
integer x = 421
integer y = 2392
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_qct_01076
integer x = 1458
integer y = 2412
integer taborder = 100
end type

type dw_datetime from w_inherite`dw_datetime within w_qct_01076
integer y = 2184
end type

type sle_msg from w_inherite`sle_msg within w_qct_01076
integer y = 2184
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_qct_01076
integer y = 2132
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_01076
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_01076
end type

type dw_1 from datawindow within w_qct_01076
integer width = 2610
integer height = 540
boolean bringtotop = true
string dataobject = "d_qct_01051_1"
boolean border = false
boolean livescroll = true
end type

type dw_2 from datawindow within w_qct_01076
boolean visible = false
integer x = 3022
integer y = 480
integer width = 727
integer height = 1444
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "원부자재 문제점 통보서"
string dataobject = "d_qct_01076_2"
boolean minbox = true
boolean maxbox = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_qct_01076
integer x = 722
integer y = 756
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('baldat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'baldat', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01076
integer x = 1509
integer y = 756
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('jochydat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'jochydat', gs_code)
end event

type pb_3 from u_pb_cal within w_qct_01076
integer x = 704
integer y = 1412
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('jochwdat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'jochwdat', gs_code)
end event

type gb_3 from groupbox within w_qct_01076
boolean visible = false
integer x = 9
integer y = 1964
integer width = 850
integer height = 168
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_qct_01076
boolean visible = false
integer x = 2130
integer y = 1964
integer width = 494
integer height = 168
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_qct_01076
boolean visible = false
integer x = 2743
integer y = 1968
integer width = 631
integer height = 360
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "원부자재 통보서"
end type

type gb_4 from groupbox within w_qct_01076
boolean visible = false
integer x = 3031
integer y = 244
integer width = 727
integer height = 224
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "원부자재 통보서"
end type

