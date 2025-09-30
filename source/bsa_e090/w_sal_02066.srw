$PBExportHeader$w_sal_02066.srw
$PBExportComments$이벤트 보류 거래처 등록
forward
global type w_sal_02066 from w_inherite
end type
type dw_detail from datawindow within w_sal_02066
end type
type cbx_1 from checkbox within w_sal_02066
end type
type dw_update from datawindow within w_sal_02066
end type
type rr_1 from roundrectangle within w_sal_02066
end type
end forward

global type w_sal_02066 from w_inherite
string title = "이벤트  보류 거래처 등록"
dw_detail dw_detail
cbx_1 cbx_1
dw_update dw_update
rr_1 rr_1
end type
global w_sal_02066 w_sal_02066

type variables

end variables

on w_sal_02066.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.cbx_1=create cbx_1
this.dw_update=create dw_update
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.dw_update
this.Control[iCurrent+4]=this.rr_1
end on

on w_sal_02066.destroy
call super::destroy
destroy(this.dw_detail)
destroy(this.cbx_1)
destroy(this.dw_update)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_update.settransobject(sqlca)

p_can.PostEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sal_02066
integer y = 16
integer width = 1577
integer height = 344
integer taborder = 30
string dataobject = "d_sal_020661"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String sEventNo
Long   nCnt

Choose Case GetColumnName()
	/* 등록번호 */
	Case 'event_no'
		sEventNo = Trim(GetText())
		If IsNull(sEventNo) or sEventNo = '' Then Return
		
//		select count(*) into :ncnt 
//		  from seventh
//		 where sabu = :gs_sabu and
//		       event_no = :sEventNo;
		
//		cb_inq.PostEvent(Clicked!)
End Choose
end event

event dw_insert::rbuttondown;String sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case 'event_no'
		Open(w_sal_02065_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"event_no",gs_code)
		p_inq.TriggerEvent(Clicked!)
END Choose

ib_any_typing = False
end event

type p_delrow from w_inherite`p_delrow within w_sal_02066
boolean visible = false
integer x = 2519
integer y = 1284
end type

type p_addrow from w_inherite`p_addrow within w_sal_02066
boolean visible = false
integer x = 2345
integer y = 1284
end type

type p_search from w_inherite`p_search within w_sal_02066
boolean visible = false
integer x = 1650
integer y = 1284
end type

type p_ins from w_inherite`p_ins within w_sal_02066
boolean visible = false
integer x = 2171
integer y = 1284
end type

type p_exit from w_inherite`p_exit within w_sal_02066
end type

type p_can from w_inherite`p_can within w_sal_02066
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
dw_insert.InsertRow(0)

dw_detail.Reset()

dw_insert.Modify('event_no.protect = 0')
dw_insert.Modify('sarea.protect = 0')
		
dw_insert.SetFocus()
dw_insert.setColumn('event_no')


end event

type p_print from w_inherite`p_print within w_sal_02066
boolean visible = false
integer x = 1824
integer y = 1284
end type

type p_inq from w_inherite`p_inq within w_sal_02066
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String sEventNo, sArea

If dw_insert.AcceptText() <> 1 Then Return

sArea = dw_insert.GetItemString(1,'sarea')
If IsNull(sArea) then sArea = ''

sEventNo = dw_insert.GetItemString(1,'event_no')
IF sEventNo ="" OR IsNull(sEventNo) THEN
	f_message_chk(30,'[이벤트번호]')
	dw_insert.SetColumn("event_no")
	dw_insert.SetFocus()
	Return 
END IF

dw_insert.SetRedraw(False)
If dw_insert.Retrieve(gs_sabu, sEventNo) <= 0 Then
	f_message_chk(50,'')
	p_can.TriggerEvent(Clicked!)
	dw_insert.SetRedraw(True)
	Return
End If

dw_detail.Retrieve(gs_sabu, sEventNo, sArea+'%')

dw_insert.SetItem(1,'sarea', sArea)

dw_insert.Modify('event_no.protect = 1')
dw_insert.Modify('sarea.protect = 1')

ib_any_typing = False
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sal_02066
boolean visible = false
integer x = 2866
integer y = 1284
end type

type p_mod from w_inherite`p_mod within w_sal_02066
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String sEventNo, sArea
Long    nCnt, ix, nRow

If dw_detail.AcceptText() <> 1 Then Return

sEventNo = dw_insert.GetItemString(1,'event_no')
IF sEventNo ="" OR IsNull(sEventNo) THEN
	f_message_chk(30,'[이벤트번호]')
	dw_insert.SetColumn("event_no")
	dw_insert.SetFocus()
	Return 
END IF

sArea = dw_insert.GetItemString(1,'sarea')
If IsNull(sArea) then sArea = ''

/* 헤더에 존재하는가 확인 */
select count(*) into :ncnt 
  from seventh
 where sabu = :gs_sabu and
		 event_no = :sEventNo;
		 
If nCnt <= 0 Then
	MessageBox('확 인','관련 이벤트정보가 없습니다')
	p_can.TriggerEvent(Clicked!)
	Return
End If

SetPointer(HourGlass!)

/* 기존자료 삭제 */
dw_update.Retrieve(gs_sabu, sEventNo, sarea+'%')
dw_update.RowsMove(1, dw_update.Rowcount(),Primary! , dw_update, 1, Delete!)

For ix = 1 To dw_detail.RowCount()
	If dw_detail.GetItemString(ix,'reject_yn') = 'N' Then Continue
	
	nRow = dw_update.InsertRow(0)
	dw_update.SetItem(nRow,'sabu', gs_sabu)
	dw_update.SetItem(nRow,'event_no', sEventNo)
	dw_update.SetItem(nRow,'cvcod', dw_detail.GetItemString(ix,'cvcod'))
	dw_update.SetItem(nRow,'reject_yn', 'Y')
Next

If dw_update.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

commit;

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.!!'

ib_any_typing = False

end event

type cb_exit from w_inherite`cb_exit within w_sal_02066
boolean visible = false
integer x = 2958
integer y = 1060
integer taborder = 90
end type

type cb_mod from w_inherite`cb_mod within w_sal_02066
boolean visible = false
integer x = 2235
integer y = 1060
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_sal_02066
boolean visible = false
integer x = 384
integer y = 2408
integer width = 361
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02066
boolean visible = false
integer x = 1641
integer y = 2384
integer taborder = 70
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_02066
boolean visible = false
integer x = 1870
integer y = 1060
integer taborder = 10
end type

type cb_print from w_inherite`cb_print within w_sal_02066
boolean visible = false
integer x = 50
integer y = 2444
end type

type st_1 from w_inherite`st_1 within w_sal_02066
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02066
boolean visible = false
integer x = 2597
integer y = 1060
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sal_02066
boolean visible = false
integer x = 567
integer y = 2436
integer width = 462
boolean enabled = false
string text = "전체삭제(&W)"
end type



type sle_msg from w_inherite`sle_msg within w_sal_02066
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02066
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02066
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02066
end type

type dw_detail from datawindow within w_sal_02066
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_1"
integer x = 133
integer y = 412
integer width = 4370
integer height = 1872
string dataobject = "d_sal_02066"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

type cbx_1 from checkbox within w_sal_02066
integer x = 1696
integer y = 280
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
borderstyle borderstyle = stylelowered!
end type

event clicked;String sReject
Long   ix

If This.Checked = True Then
	sReject = 'Y'
Else
	sReject = 'N'
End If

For ix = 1 To dw_detail.RowCount()
	dw_detail.SetItem(ix,'reject_yn', sReject)
Next
end event

type dw_update from datawindow within w_sal_02066
boolean visible = false
integer x = 539
integer y = 964
integer width = 969
integer height = 360
integer taborder = 30
string dataobject = "d_sal_020662"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sal_02066
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 384
integer width = 4448
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

