$PBExportHeader$w_qct_03005.srw
$PBExportComments$크레임 작지 승인 등록
forward
global type w_qct_03005 from w_inherite
end type
type dw_1 from u_key_enter within w_qct_03005
end type
type pb_2 from u_pb_cal within w_qct_03005
end type
type pb_1 from u_pb_cal within w_qct_03005
end type
type rr_1 from roundrectangle within w_qct_03005
end type
end forward

global type w_qct_03005 from w_inherite
string title = "크레임 작지 승인 등록"
dw_1 dw_1
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
end type
global w_qct_03005 w_qct_03005

on w_qct_03005.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_03005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_1.setitem(1,'edate',left(f_today(),8))
dw_1.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_03005
integer x = 87
integer y = 176
integer width = 4503
integer height = 2096
integer taborder = 30
string dataobject = "d_qct_03005"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::constructor;call super::constructor;Modify("ispec_t.text = '" + f_change_name('2') + "'" )
Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

type p_delrow from w_inherite`p_delrow within w_qct_03005
boolean visible = false
integer x = 4178
integer y = 3296
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_03005
boolean visible = false
integer x = 4005
integer y = 3296
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_03005
boolean visible = false
integer x = 3310
integer y = 3296
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_03005
boolean visible = false
integer x = 3831
integer y = 3296
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_03005
integer x = 4430
integer y = 4
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_qct_03005
integer x = 4256
integer y = 4
integer taborder = 50
end type

event p_can::clicked;call super::clicked;dw_insert.setredraw(false)

dw_insert.reset()
dw_insert.settransobject(sqlca)
dw_1.setfocus()

dw_insert.setredraw(true)
end event

type p_print from w_inherite`p_print within w_qct_03005
boolean visible = false
integer x = 3483
integer y = 3296
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_03005
integer x = 3909
integer y = 4
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string ls_sdate ,ls_edate ,snull

setnull(snull)

if dw_1.accepttext() <> 1 then 
	return
end if

ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
ls_edate = Trim(dw_1.getitemstring(1,'edate'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[공장접수일자  FROM]')
	dw_1.setitem(1,'sdate',snull)
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[공장접수일자  TO]')
	dw_1.setitem(1,'edate',snull)
	dw_1.setcolumn('edate')
	dw_1.setfocus()
	return
end if

setpointer(hourglass!)

if dw_insert.retrieve(gs_sabu , ls_sdate , ls_edate) < 1 then
	f_message_chk(300,'')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return
end if

setpointer(arrow!)











end event

type p_del from w_inherite`p_del within w_qct_03005
boolean visible = false
integer x = 4361
integer y = 3304
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_qct_03005
integer x = 4082
integer y = 4
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;long ll_check , ll_mrow  ,ll_getrow ,i
string  ls_cfdate , ls_cfyn , snull

setnull(snull)

ll_check = messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1)

if ll_check <> 1 then return

if dw_insert.accepttext() <> 1 then return

ll_mrow = dw_insert.rowcount()

for i = 1 to ll_mrow
	ls_cfdate  = Trim(dw_insert.getitemstring(i,'clamst_cfdate'))
	ls_cfyn    = Trim(dw_insert.getitemstring(i,'clamst_cfyn'))
	
	if ls_cfyn = "" or isnull(ls_cfyn) or ls_cfyn = 'N' then
		dw_insert.setitem(i,'clamst_cfdate', snull)
	else
		if ls_cfdate = "" or isnull(ls_cfdate) then
			dw_insert.setitem(i,'clamst_cfdate', left(f_today(),8))
		end if
	end if
next

if ll_mrow < 1 then
	messagebox('확인','저장할 데이타가 없습니다.')
	return
end if

if dw_insert.update() <> 1 then 
	rollback using sqlca;
	w_mdi_frame.sle_msg.text='저장에 실패하였습니다.'
end if

commit using sqlca;

w_mdi_frame.sle_msg.text='저장에 성공하였습니다.'

p_can.triggerevent(clicked!)



end event

type cb_exit from w_inherite`cb_exit within w_qct_03005
boolean visible = false
integer x = 2811
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qct_03005
boolean visible = false
integer x = 2126
integer y = 3292
end type

type cb_ins from w_inherite`cb_ins within w_qct_03005
boolean visible = false
integer x = 91
integer y = 3048
end type

type cb_del from w_inherite`cb_del within w_qct_03005
boolean visible = false
integer x = 718
integer y = 3088
end type

type cb_inq from w_inherite`cb_inq within w_qct_03005
boolean visible = false
integer x = 1778
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qct_03005
boolean visible = false
integer x = 1403
integer y = 3092
end type

type st_1 from w_inherite`st_1 within w_qct_03005
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_qct_03005
boolean visible = false
integer x = 2469
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qct_03005
boolean visible = false
integer x = 1970
integer y = 3120
end type

type dw_datetime from w_inherite`dw_datetime within w_qct_03005
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_qct_03005
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_qct_03005
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_03005
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_03005
boolean visible = false
end type

type dw_1 from u_key_enter within w_qct_03005
integer x = 64
integer y = 8
integer width = 1463
integer height = 136
integer taborder = 10
string dataobject = "d_qct_03005_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;string snull

setnull(snull)

Choose Case this.Getcolumnname()
	Case 'sdate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[공장접수일자  FROM]')
			this.SetItem(1, "sdate", sNull)
			return 1
		end if
	Case 'edate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[공장접수일자  TO]')
			this.SetItem(1, "edate", sNull)
			return 1
		end if
End Choose

end event

event itemerror;call super::itemerror;return 1
end event

type pb_2 from u_pb_cal within w_qct_03005
integer x = 1349
integer y = 40
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_03005
integer x = 887
integer y = 40
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'sdate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_03005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 168
integer width = 4535
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 55
end type

