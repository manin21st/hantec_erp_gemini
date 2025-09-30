$PBExportHeader$w_pdt_02135.srw
$PBExportComments$작업실적등록 - 할당조회
forward
global type w_pdt_02135 from w_inherite
end type
type dw_1 from datawindow within w_pdt_02135
end type
end forward

global type w_pdt_02135 from w_inherite
integer x = 283
integer y = 464
integer width = 3081
integer height = 1680
string title = "할당 조회"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
dw_1 dw_1
end type
global w_pdt_02135 w_pdt_02135

type variables
datawindow dwname, dwnm
decimal {3} dqty
end variables

on w_pdt_02135.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_pdt_02135.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dwnm = message.powerobjectparm

dw_1.insertrow(0)
dw_1.setitem(1, 'pordno', gs_code)
dQty = dwnm.getitemdecimal(dwnm.getrow(), "waqty")
dw_1.setitem(1, "silqty", dQty)


String sShpjpno, sDepot
sShpjpno = dwnm.getitemstring(dwnm.getrow(), "shpjpno")
sDepot   = dwnm.getitemstring(dwnm.getrow(), "gubun")
dw_insert.settransobject(sqlca)

if isnull(sShpjpno) then sshpjpno = '1'
dw_insert.retrieve(gs_sabu, gs_code, sShpjpno, sDepot)

f_window_center_response(this)


end event

type dw_insert from w_inherite`dw_insert within w_pdt_02135
integer x = 23
integer y = 152
integer width = 3026
integer height = 1288
integer taborder = 0
string dataobject = "d_pdt_02135_1"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;string sitnbr, sitdsc
long lrow
Decimal {3} dsAvqty

lrow = this.getrow()

if Lrow < 1 then return

dsAvqty = dw_insert.getitemdecimal(Lrow, "ipyeqty") 

this.accepttext()

if dw_insert.getitemdecimal(Lrow, "cnfqty") < &
	dw_insert.getitemdecimal(Lrow, "ipyeqty") 	 then
	dw_insert.setitem(Lrow, "ipyeqty", dsAvqty) 	
	Messagebox("예정수량", "사용가능수량 보다 예정수량이 큽니다", stopsign!)
	return 1
end if
end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rbuttondown;string colname
long   lrow

lrow = this.getrow()
colname = this.getcolumnname()

if colname = "shpfat_gucod" then
		 setnull(gs_code)
		 setnull(gs_codename)
		 open(w_reffpf33_popup)
		 this.setitem(lrow, "shpfat_gucod", gs_code)
		 this.triggerevent(itemchanged!)
end if

gs_code = ''
gs_codename = ''
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02135
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02135
end type

type p_search from w_inherite`p_search within w_pdt_02135
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_pdt_02135
end type

type p_exit from w_inherite`p_exit within w_pdt_02135
end type

type p_can from w_inherite`p_can within w_pdt_02135
end type

type p_print from w_inherite`p_print within w_pdt_02135
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_pdt_02135
end type

type p_del from w_inherite`p_del within w_pdt_02135
end type

type p_mod from w_inherite`p_mod within w_pdt_02135
end type

type cb_exit from w_inherite`cb_exit within w_pdt_02135
integer x = 2683
integer y = 1460
integer width = 361
integer taborder = 20
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02135
integer x = 1019
integer y = 2252
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02135
integer x = 832
integer y = 2452
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_02135
integer x = 2254
integer y = 2452
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02135
integer x = 270
integer y = 2452
end type

type cb_print from w_inherite`cb_print within w_pdt_02135
integer x = 1253
integer y = 2452
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_02135
integer y = 2000
end type

type cb_can from w_inherite`cb_can within w_pdt_02135
integer x = 1381
integer y = 2252
boolean cancel = true
end type

event cb_can::clicked;call super::clicked;//rollback;
//
//close(parent)
end event

type cb_search from w_inherite`cb_search within w_pdt_02135
integer x = 1687
integer y = 2452
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pdt_02135
integer x = 1989
integer y = 2000
end type

type sle_msg from w_inherite`sle_msg within w_pdt_02135
integer y = 2000
integer width = 1609
end type

type gb_10 from w_inherite`gb_10 within w_pdt_02135
integer y = 1948
integer width = 2734
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02135
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02135
end type

type dw_1 from datawindow within w_pdt_02135
integer y = 24
integer width = 2555
integer height = 112
boolean bringtotop = true
string dataobject = "d_pdt_02135"
boolean border = false
boolean livescroll = true
end type

