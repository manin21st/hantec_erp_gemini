$PBExportHeader$w_qct_01075.srw
$PBExportComments$원자재 이상발생 통보서 관리
forward
global type w_qct_01075 from w_inherite
end type
type dw_detail from datawindow within w_qct_01075
end type
type pb_1 from u_pb_cal within w_qct_01075
end type
type pb_2 from u_pb_cal within w_qct_01075
end type
type rr_1 from roundrectangle within w_qct_01075
end type
end forward

global type w_qct_01075 from w_inherite
integer width = 4640
string title = "원자재 이상발생 내역 관리"
dw_detail dw_detail
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_01075 w_qct_01075

on w_qct_01075.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_01075.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_insert.settransobject(sqlca)
dw_detail.settransobject(sqlca)

String stoday
stoday = f_today()

dw_detail.insertrow(0)
dw_detail.setitem(1, "sdate", stoday)
dw_detail.setitem(1, "edate", stoday)

/* User별 사업장 Setting */
f_mod_saupj(dw_detail,"porgu")




end event

type dw_insert from w_inherite`dw_insert within w_qct_01075
integer x = 32
integer y = 240
integer width = 4567
integer height = 2016
integer taborder = 20
string dataobject = "d_qct_01075_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::doubleclicked;if row > 0 then
	gs_code = this.getitemstring(row, "imhist_iojpno")
	open(w_qct_01076)
end if
setnull(gs_code)
end event

event dw_insert::clicked;call super::clicked;
if dw_insert.Rowcount() = 0 then return

if row < 1 then return

dw_insert.SelectRow(0, false)
dw_insert.SelectRow(row, true)

end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type p_delrow from w_inherite`p_delrow within w_qct_01075
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qct_01075
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qct_01075
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qct_01075
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qct_01075
end type

type p_can from w_inherite`p_can within w_qct_01075
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
dw_detail.setfocus()
end event

type p_print from w_inherite`p_print within w_qct_01075
integer x = 4096
end type

event p_print::clicked;call super::clicked;if dw_detail.accepttext() = -1 then return

gs_code  	 = dw_detail.getitemstring(1, "sdate")
gs_codename  = dw_detail.getitemstring(1, "edate")

if isnull(gs_code) or trim(gs_code) = '' then
	gs_code = '10000101'
end if

if isnull(gs_codename) or trim(gs_codename) = '' then
	gs_codename = '99991231'
end if

open(w_qct_01075_1)

Setnull(gs_code)
Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_qct_01075
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string ssdate, sedate, sstatus, snull,ls_porgu

if dw_detail.accepttext() = -1 then return

ls_porgu = trim(dw_detail.getitemstring(1, "porgu"))
IF isnull(ls_porgu) or trim(ls_porgu) = "" 	THEN
	f_message_chk(30,'[사업장]') 
	dw_detail.setcolumn("porgu")
	dw_detail.setfocus()
	RETURN
END IF

ssdate  = trim(dw_detail.getitemstring(1, "sdate"))
sedate  = trim(dw_detail.getitemstring(1, "edate"))
sstatus = dw_detail.getitemstring(1, "status")

if isnull(ssdate) or trim(ssdate) = '' then
	ssdate = '10000101'
end if

if isnull(sedate) or trim(sedate) = '' then
	ssdate = '99991231'
end if

dw_insert.setredraw(false)
dw_insert.setfilter(snull)
dw_insert.filter()
if dw_insert.retrieve(ls_porgu,gs_sabu, ssdate, sedate) > 0 then
	if sstatus <> '전체' then
		dw_insert.setfilter("ststxt = '"+ sstatus +"'")
		dw_insert.filter()
	end if
else
   f_message_chk(50, '[이상발생 내역]')
end if

dw_insert.setredraw(true)
end event

type p_del from w_inherite`p_del within w_qct_01075
boolean visible = false
integer x = 2235
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_qct_01075
boolean visible = false
integer x = 2062
integer y = 2420
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_qct_01075
end type

type cb_mod from w_inherite`cb_mod within w_qct_01075
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qct_01075
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qct_01075
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qct_01075
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qct_01075
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qct_01075
end type

type cb_can from w_inherite`cb_can within w_qct_01075
end type

type cb_search from w_inherite`cb_search within w_qct_01075
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_01075
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_01075
end type

type dw_detail from datawindow within w_qct_01075
integer x = 37
integer y = 24
integer width = 2926
integer height = 196
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_01075_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull, sdata 
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'sdate' then
	sdata = this.gettext()
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[시작일자]');
		this.setitem(1, "sdate", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'edate' then
	sdata = this.gettext()	
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[종료일자]');
		this.setitem(1, "edate", snull)
		return 1		
	end if
	if this.getitemstring(1, "sdate") > sdata then
		
		
	end if
	
end if
end event

event itemerror;return 1
end event

type pb_1 from u_pb_cal within w_qct_01075
integer x = 1911
integer y = 40
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_detail.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01075
integer x = 2405
integer y = 40
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_detail.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_01075
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 228
integer width = 4585
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

