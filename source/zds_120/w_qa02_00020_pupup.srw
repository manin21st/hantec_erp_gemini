$PBExportHeader$w_qa02_00020_pupup.srw
$PBExportComments$** 부적합통보서 리스트 팝업
forward
global type w_qa02_00020_pupup from w_inherite
end type
type rr_1 from roundrectangle within w_qa02_00020_pupup
end type
type dw_1 from datawindow within w_qa02_00020_pupup
end type
type p_1 from picture within w_qa02_00020_pupup
end type
end forward

global type w_qa02_00020_pupup from w_inherite
integer width = 3621
integer height = 1788
string title = "부적합 통보서 발행"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
rr_1 rr_1
dw_1 dw_1
p_1 p_1
end type
global w_qa02_00020_pupup w_qa02_00020_pupup

on w_qa02_00020_pupup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.p_1
end on

on w_qa02_00020_pupup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.p_1)
end on

event open;call super::open;f_window_center(This)

dw_insert.settransobject(sqlca)

dw_1.InsertRow(0)

dw_1.Object.sdate[1] = f_afterday(f_today() , -30)
dw_1.Object.edate[1] = f_today()

p_inq.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_qa02_00020_pupup
integer x = 41
integer y = 284
integer width = 3506
integer height = 1288
integer taborder = 20
string dataobject = "d_qa02_00020_popup_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::doubleclicked;call super::doubleclicked;String ls_gubun ,ls_code
SetNull(gs_gubun)
SetNull(gs_code)

gs_gubun = Trim(dw_insert.Object.iogbn[row])
gs_code  = Trim(dw_insert.Object.iojpno[row])

Close(parent)
//CloseWithReturn(parent, ls_gubun + space(100) +ls_code)
end event

event dw_insert::clicked;call super::clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_qa02_00020_pupup
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa02_00020_pupup
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qa02_00020_pupup
boolean visible = false
integer x = 2674
integer y = 40
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qa02_00020_pupup
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qa02_00020_pupup
integer x = 3392
integer y = 36
end type

type p_can from w_inherite`p_can within w_qa02_00020_pupup
boolean visible = false
integer x = 3218
integer y = 36
end type

type p_print from w_inherite`p_print within w_qa02_00020_pupup
boolean visible = false
integer x = 3045
integer y = 36
end type

event p_print::clicked;call super::clicked;//if dw_1.accepttext() = -1 then return
//
//gs_code  	 = dw_1.getitemstring(1, "sdate")
//gs_codename  = dw_1.getitemstring(1, "edate")
//
//if isnull(gs_code) or trim(gs_code) = '' then
//	gs_code = '10000101'
//end if
//
//if isnull(gs_codename) or trim(gs_codename) = '' then
//	gs_codename = '99991231'
//end if
//
//open(w_qct_01075_1)
//
//Setnull(gs_code)
//Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_qa02_00020_pupup
integer x = 3045
integer y = 36
end type

event p_inq::clicked;call super::clicked;string ssdate, sedate, sstatus, snull

if dw_1.accepttext() = -1 then return

ssdate  = trim(dw_1.getitemstring(1, "sdate"))
sedate  = trim(dw_1.getitemstring(1, "edate"))
sstatus = Trim(dw_1.getitemstring(1, "status"))

if isnull(ssdate) or trim(ssdate) = '' then
	ssdate = '10000101'
end if

if isnull(sedate) or trim(sedate) = '' then
	ssdate = '99991231'
end if

dw_insert.setredraw(false)

dw_insert.setfilter(snull)
dw_insert.filter()

if dw_insert.retrieve(gs_sabu, ssdate, sedate) > 0 then
	if sstatus <> '전체' then
		dw_insert.setfilter("submit_yn = '"+ sstatus +"'")
		dw_insert.filter()
	end if
else
   f_message_chk(50, '[부적합 통보서 발행]')
end if

dw_insert.setredraw(true)
end event

type p_del from w_inherite`p_del within w_qa02_00020_pupup
boolean visible = false
integer x = 2235
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_qa02_00020_pupup
boolean visible = false
integer x = 2062
integer y = 2420
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_qa02_00020_pupup
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00020_pupup
boolean visible = false
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qa02_00020_pupup
boolean visible = false
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qa02_00020_pupup
boolean visible = false
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qa02_00020_pupup
boolean visible = false
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qa02_00020_pupup
boolean visible = false
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qa02_00020_pupup
end type

type cb_can from w_inherite`cb_can within w_qa02_00020_pupup
end type

type cb_search from w_inherite`cb_search within w_qa02_00020_pupup
end type







type gb_button1 from w_inherite`gb_button1 within w_qa02_00020_pupup
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00020_pupup
end type

type rr_1 from roundrectangle within w_qa02_00020_pupup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 276
integer width = 3547
integer height = 1312
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_qa02_00020_pupup
integer x = 9
integer y = 24
integer width = 2025
integer height = 244
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa02_00020_popup_1"
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

type p_1 from picture within w_qa02_00020_pupup
integer x = 3218
integer y = 36
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\선택_up.gif"
boolean focusrectangle = false
end type

event clicked;Long ll_row

ll_row = dw_insert.Getrow()
SetNull(gs_gubun)
SetNull(gs_code)

gs_gubun = Trim(dw_insert.Object.iogbn[ll_row])
gs_code  = Trim(dw_insert.Object.iojpno[ll_row])

Close(parent)

end event

