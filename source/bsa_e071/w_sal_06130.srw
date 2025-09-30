$PBExportHeader$w_sal_06130.srw
$PBExportComments$DA/DP 사용 완료 등록
forward
global type w_sal_06130 from w_inherite
end type
type dw_1 from datawindow within w_sal_06130
end type
type cbx_1 from checkbox within w_sal_06130
end type
type pb_1 from u_pb_cal within w_sal_06130
end type
type pb_2 from u_pb_cal within w_sal_06130
end type
type rr_1 from roundrectangle within w_sal_06130
end type
end forward

global type w_sal_06130 from w_inherite
string title = "DA/DP 사용 완료 등록"
dw_1 dw_1
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_06130 w_sal_06130

on w_sal_06130.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_sal_06130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)

dw_insert.SetTransObject(sqlca)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_1.SetItem(1, 'sarea', sarea)
	dw_1.Modify("sarea.protect=1")
	//dw_1.Modify("sarea.background.color = 80859087")
End If
end event

type dw_insert from w_inherite`dw_insert within w_sal_06130
integer x = 251
integer y = 268
integer width = 4023
integer height = 1996
string dataobject = "d_sal_06130"
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_sal_06130
boolean visible = false
integer x = 4055
integer y = 2792
end type

type p_addrow from w_inherite`p_addrow within w_sal_06130
boolean visible = false
integer x = 3881
integer y = 2792
end type

type p_search from w_inherite`p_search within w_sal_06130
boolean visible = false
integer x = 3186
integer y = 2792
end type

type p_ins from w_inherite`p_ins within w_sal_06130
boolean visible = false
integer x = 3707
integer y = 2792
end type

type p_exit from w_inherite`p_exit within w_sal_06130
end type

type p_can from w_inherite`p_can within w_sal_06130
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
end event

type p_print from w_inherite`p_print within w_sal_06130
boolean visible = false
integer x = 3360
integer y = 2792
end type

type p_inq from w_inherite`p_inq within w_sal_06130
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet, sArea

If dw_1.AcceptText() <> 1 Then Return

sDatef = Trim(dw_1.GetItemString(1,'sdatef'))
sDatet = Trim(dw_1.GetItemString(1,'sdatet'))
sArea  = Trim(dw_1.GetItemString(1,'sarea'))

If IsNull(sArea) Then sArea = ''

If dw_insert.Retrieve(gs_sabu, sDatef,sDatet, sArea+'%') <= 0 Then
	f_message_chk(50,'')
	dw_1.Setfocus()
End If

end event

type p_del from w_inherite`p_del within w_sal_06130
boolean visible = false
integer x = 4402
integer y = 2792
end type

type p_mod from w_inherite`p_mod within w_sal_06130
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Long ix

If dw_insert.RowCount() <= 0 Then Return

For ix = 1 To dw_insert.RowCount()
	If dw_insert.GetItemString(ix,'chk') = 'Y' Then
		dw_insert.SEtItem(ix, 'dapswon', dw_insert.GetItemNumber(ix,'dapsamt'))
	End If
Next

If dw_insert.Update() <> 1 then
	RollBack;
	Return
End If

Commit;

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_06130
boolean visible = false
integer x = 3182
integer y = 2760
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_sal_06130
boolean visible = false
integer x = 2469
integer y = 2760
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;//Long ix
//
//If dw_insert.RowCount() <= 0 Then Return
//
//For ix = 1 To dw_insert.RowCount()
//	If dw_insert.GetItemString(ix,'chk') = 'Y' Then
//		dw_insert.SEtItem(ix, 'dapswon', dw_insert.GetItemNumber(ix,'dapsamt'))
//	End If
//Next
//
//If dw_insert.Update() <> 1 then
//	RollBack;
//	Return
//End If
//
//Commit;
//
//cb_inq.TriggerEvent(Clicked!)
//
//sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_ins from w_inherite`cb_ins within w_sal_06130
boolean visible = false
integer x = 736
integer y = 2648
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_sal_06130
boolean visible = false
integer x = 1179
integer y = 2644
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_sal_06130
boolean visible = false
integer x = 197
integer taborder = 60
end type

event cb_inq::clicked;call super::clicked;//String sDatef, sDatet, sArea
//
//If dw_1.AcceptText() <> 1 Then Return
//
//sDatef = Trim(dw_1.GetItemString(1,'sdatef'))
//sDatet = Trim(dw_1.GetItemString(1,'sdatet'))
//sArea  = Trim(dw_1.GetItemString(1,'sarea'))
//
//If IsNull(sArea) Then sArea = ''
//
//If dw_insert.Retrieve(gs_sabu, sDatef,sDatet, sArea+'%') <= 0 Then
//	f_message_chk(50,'')
//	dw_1.Setfocus()
//End If
//
end event

type cb_print from w_inherite`cb_print within w_sal_06130
boolean visible = false
integer x = 1641
integer y = 2584
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_sal_06130
end type

type cb_can from w_inherite`cb_can within w_sal_06130
boolean visible = false
integer x = 2825
integer y = 2760
integer taborder = 80
end type

event cb_can::clicked;call super::clicked;//dw_insert.Reset()
end event

type cb_search from w_inherite`cb_search within w_sal_06130
boolean visible = false
integer x = 2290
integer y = 2536
integer taborder = 90
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06130
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06130
end type

type dw_1 from datawindow within w_sal_06130
event ue_enter pbm_dwnprocessenter
integer x = 242
integer y = 64
integer width = 2757
integer height = 180
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_061301"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

type cbx_1 from checkbox within w_sal_06130
integer x = 2592
integer y = 116
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;long ix
String sStatus

IF This.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF


For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix,'chk',sStatus)
Next

end event

type pb_1 from u_pb_cal within w_sal_06130
integer x = 1006
integer y = 108
integer width = 78
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06130
integer x = 1499
integer y = 108
integer width = 73
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 242
integer y = 260
integer width = 4050
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

