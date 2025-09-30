$PBExportHeader$w_qct_04015.srw
$PBExportComments$A/S 작지의뢰 승인 등록
forward
global type w_qct_04015 from w_inherite
end type
type dw_1 from u_key_enter within w_qct_04015
end type
type rr_1 from roundrectangle within w_qct_04015
end type
end forward

global type w_qct_04015 from w_inherite
string title = "샘플 작지 의뢰 승인"
dw_1 dw_1
rr_1 rr_1
end type
global w_qct_04015 w_qct_04015

on w_qct_04015.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_qct_04015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_1.setitem(1,'edate',left(f_today(),8))
dw_1.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_04015
integer x = 123
integer y = 200
integer width = 4439
integer height = 2076
integer taborder = 30
string dataobject = "d_qct_04015"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::constructor;call super::constructor;//Modify("ispec_t.text = '" + f_change_name('2') + "'" )
//Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end event

type p_delrow from w_inherite`p_delrow within w_qct_04015
boolean visible = false
integer x = 4055
integer y = 3260
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_04015
boolean visible = false
integer x = 3881
integer y = 3260
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_04015
boolean visible = false
integer x = 3186
integer y = 3260
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_04015
boolean visible = false
integer x = 3707
integer y = 3260
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_04015
integer x = 4402
integer taborder = 60
boolean originalsize = true
end type

type p_can from w_inherite`p_can within w_qct_04015
integer x = 4229
integer taborder = 50
boolean originalsize = true
end type

event p_can::clicked;call super::clicked;dw_insert.setredraw(false)

dw_insert.reset()
dw_insert.settransobject(sqlca)
dw_1.setfocus()

dw_insert.setredraw(true)
end event

type p_print from w_inherite`p_print within w_qct_04015
boolean visible = false
integer x = 3360
integer y = 3260
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_04015
integer x = 3877
integer taborder = 20
boolean originalsize = true
end type

event p_inq::clicked;call super::clicked;string ls_sdate ,ls_edate ,snull

setnull(snull)

if dw_1.accepttext() <> 1 then 
	return
end if

ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
ls_edate = Trim(dw_1.getitemstring(1,'edate'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[의뢰기간 FROM]')
	dw_1.setitem(1,'sdate',snull)
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[의뢰기간 TO]')
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

type p_del from w_inherite`p_del within w_qct_04015
boolean visible = false
integer x = 4402
integer y = 3260
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_qct_04015
integer x = 4055
integer taborder = 40
boolean originalsize = true
end type

event p_mod::clicked;call super::clicked;long ll_check , ll_mrow  ,ll_getrow ,i
string  ls_cfdate , ls_cfyn , snull

setnull(snull)

ll_check = messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1)

if ll_check <> 1 then return

if dw_insert.accepttext() <> 1 then return

ll_mrow = dw_insert.rowcount()

for i = 1 to ll_mrow
	ls_cfdate  = Trim(dw_insert.getitemstring(i,'asmetr_cfdate'))
	ls_cfyn    = Trim(dw_insert.getitemstring(i,'asmetr_cfyn'))
	
	if ls_cfyn = "" or isnull(ls_cfyn) OR ls_cfyn = "N" then
		dw_insert.setitem(i,'asmetr_cfdate', snull)
	else
		if ls_cfdate = "" or isnull(ls_cfdate) then
			dw_insert.setitem(i,'asmetr_cfdate', left(f_today(),8))
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

commit ;

w_mdi_frame.sle_msg.text='저장에 성공하였습니다.'

p_can.triggerevent(clicked!)



end event

type cb_exit from w_inherite`cb_exit within w_qct_04015
integer x = 2798
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qct_04015
integer x = 2112
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_qct_04015
integer x = 251
integer y = 3060
end type

type cb_del from w_inherite`cb_del within w_qct_04015
integer x = 878
integer y = 3100
end type

type cb_inq from w_inherite`cb_inq within w_qct_04015
integer x = 1765
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qct_04015
integer x = 1563
integer y = 3104
end type

type st_1 from w_inherite`st_1 within w_qct_04015
end type

type cb_can from w_inherite`cb_can within w_qct_04015
integer x = 2455
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qct_04015
integer x = 2130
integer y = 3132
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_04015
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_04015
end type

type dw_1 from u_key_enter within w_qct_04015
integer x = 105
integer y = 32
integer width = 1335
integer height = 156
integer taborder = 10
string dataobject = "d_qct_04015_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;string snull

setnull(snull)

Choose Case this.Getcolumnname()
	Case 'sdate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[의뢰기간 FROM]')
			this.SetItem(1, "sdate", sNull)
			return 1
		end if
	Case 'edate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[의뢰기간 TO]')
			this.SetItem(1, "edate", sNull)
			return 1
		end if
End Choose

end event

event itemerror;call super::itemerror;return 1
end event

type rr_1 from roundrectangle within w_qct_04015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 188
integer width = 4466
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

