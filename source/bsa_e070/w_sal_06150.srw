$PBExportHeader$w_sal_06150.srw
$PBExportComments$수출 면장 회수 등록
forward
global type w_sal_06150 from w_inherite
end type
type dw_1 from datawindow within w_sal_06150
end type
type pb_1 from u_pb_cal within w_sal_06150
end type
type pb_2 from u_pb_cal within w_sal_06150
end type
type gb_3 from groupbox within w_sal_06150
end type
type gb_2 from groupbox within w_sal_06150
end type
type rr_1 from roundrectangle within w_sal_06150
end type
end forward

global type w_sal_06150 from w_inherite
string title = "수출 면장 회수 등록"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
gb_3 gb_3
gb_2 gb_2
rr_1 rr_1
end type
global w_sal_06150 w_sal_06150

on w_sal_06150.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.gb_3=create gb_3
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_sal_06150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.rr_1)
end on

event w_sal_06150::open;call super::open;dw_1.settransobject(sqlca)
dw_1.insertrow(0)

dw_1.setitem(1,'sdate',left(f_today(),6) + '01')
dw_1.setitem(1,'edate',left(f_today(),8))

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_1.SetItem(1, 'sarea', sarea)
	dw_1.Modify("sarea.protect=1")
	//dw_1.Modify("sarea.background.color = 80859087")
End If

dw_insert.settransobject(sqlca)
end event

type dw_insert from w_inherite`dw_insert within w_sal_06150
integer x = 96
integer y = 232
integer width = 4448
integer height = 2052
integer taborder = 10
string dataobject = "d_sal_06150_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;string snull

setnull(snull)

Choose Case this.getcolumnname()
	Case 'rtnyn'
		
		if this.getText() = 'Y' then
		   this.setitem(row ,'export_rtndat',left(f_today(),8))
		else
			this.setitem(row ,'export_rtndat',snull)
		end if
		
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sal_06150
boolean visible = false
integer x = 2999
integer y = 2776
end type

type p_addrow from w_inherite`p_addrow within w_sal_06150
boolean visible = false
integer x = 2825
integer y = 2776
end type

type p_search from w_inherite`p_search within w_sal_06150
boolean visible = false
integer x = 2130
integer y = 2776
end type

type p_ins from w_inherite`p_ins within w_sal_06150
boolean visible = false
integer x = 2651
integer y = 2776
end type

type p_exit from w_inherite`p_exit within w_sal_06150
end type

type p_can from w_inherite`p_can within w_sal_06150
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
end event

type p_print from w_inherite`p_print within w_sal_06150
boolean visible = false
integer x = 2304
integer y = 2776
end type

type p_inq from w_inherite`p_inq within w_sal_06150
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string ls_sdate , ls_edate, sarea

if dw_1.accepttext() <> 1 then return 

ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
ls_edate = Trim(dw_1.getitemstring(1,'edate'))
sarea	   = Trim(dw_1.getitemstring(1,'sarea'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[수출일자 FROM]')
   dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return 1
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[수출일자 TO]')
   dw_1.setcolumn('edate')
	dw_1.setfocus()
	return 1
end if

If IsNull(sArea) Then sArea = ''

setpointer(hourglass!)

if dw_insert.retrieve(gs_sabu, ls_sdate, ls_edate, sArea+'%') < 1 then
	f_message_chk(300,'')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return 1
end if

setpointer(arrow!)

end event

type p_del from w_inherite`p_del within w_sal_06150
boolean visible = false
integer x = 3346
integer y = 2776
end type

type p_mod from w_inherite`p_mod within w_sal_06150
integer x = 4096
end type

event p_mod::clicked;call super::clicked;long ll_check , ll_mrow 

ll_check = messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1)

if ll_check <> 1 then return

ll_mrow = dw_insert.rowcount()

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

DW_INSERT.RESET()


end event

type cb_exit from w_inherite`cb_exit within w_sal_06150
integer x = 3195
integer y = 2660
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_sal_06150
integer x = 2510
integer y = 2660
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;//long ll_check , ll_mrow 
//
//ll_check = messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1)
//
//if ll_check <> 1 then return
//
//ll_mrow = dw_insert.rowcount()
//
//if ll_mrow < 1 then
//	messagebox('확인','저장할 데이타가 없습니다.')
//	return
//end if
//
//if dw_insert.update() <> 1 then 
//	rollback using sqlca;
//	sle_msg.text='저장에 실패하였습니다.'
//end if
//
//commit using sqlca;
//
//sle_msg.text='저장에 성공하였습니다.'
//
//DW_INSERT.RESET()
//
//
end event

type cb_ins from w_inherite`cb_ins within w_sal_06150
integer x = 987
integer y = 2576
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_sal_06150
integer x = 1061
integer y = 2552
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sal_06150
integer x = 101
integer y = 2660
integer taborder = 80
end type

event cb_inq::clicked;call super::clicked;//string ls_sdate , ls_edate, sarea
//
//if dw_1.accepttext() <> 1 then return 
//
//ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
//ls_edate = Trim(dw_1.getitemstring(1,'edate'))
//sarea	   = Trim(dw_1.getitemstring(1,'sarea'))
//
//if ls_sdate = "" or isnull(ls_sdate) then
//	f_message_chk(30,'[수출일자 FROM]')
//   dw_1.setcolumn('sdate')
//	dw_1.setfocus()
//	return 1
//end if
//
//if ls_edate = "" or isnull(ls_edate) then
//	f_message_chk(30,'[수출일자 TO]')
//   dw_1.setcolumn('edate')
//	dw_1.setfocus()
//	return 1
//end if
//
//If IsNull(sArea) Then sArea = ''
//
//setpointer(hourglass!)
//
//if dw_insert.retrieve(gs_sabu, ls_sdate, ls_edate, sArea+'%') < 1 then
//	f_message_chk(300,'')
//	dw_1.setcolumn('sdate')
//	dw_1.setfocus()
//	return 1
//end if
//
//setpointer(arrow!)
//
end event

type cb_print from w_inherite`cb_print within w_sal_06150
integer x = 1897
integer y = 2580
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_sal_06150
end type

type cb_can from w_inherite`cb_can within w_sal_06150
integer x = 2853
integer y = 2660
integer taborder = 100
end type

event cb_can::clicked;call super::clicked;//dw_insert.reset()
end event

type cb_search from w_inherite`cb_search within w_sal_06150
integer x = 2368
integer y = 2548
integer taborder = 110
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06150
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06150
end type

type dw_1 from datawindow within w_sal_06150
integer x = 78
integer y = 56
integer width = 2441
integer height = 168
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_06150"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull

setnull(snull)

Choose Case this.getcolumnname()
	Case 'sdate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[수출일자 FROM]')
			this.SetItem(1, "sdate", sNull)
			return 1
		end if
	Case 'edate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[수출일자 TO]')
			this.SetItem(1, "edate", sNull)
			return 1
		end if
End Choose
end event

event itemerror;RETURN 1
end event

type pb_1 from u_pb_cal within w_sal_06150
integer x = 773
integer y = 104
integer width = 82
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06150
integer x = 1234
integer y = 104
integer width = 78
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'edate', gs_code)

end event

type gb_3 from groupbox within w_sal_06150
boolean visible = false
integer x = 2487
integer y = 2616
integer width = 1065
integer height = 168
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_sal_06150
boolean visible = false
integer x = 82
integer y = 2616
integer width = 375
integer height = 168
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_sal_06150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 224
integer width = 4480
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

