$PBExportHeader$w_sal_02300_popup.srw
$PBExportComments$등급/결제조건 할인율 등록(품목별)
forward
global type w_sal_02300_popup from w_inherite_popup
end type
type cb_2 from commandbutton within w_sal_02300_popup
end type
type dw_update from datawindow within w_sal_02300_popup
end type
type p_end from uo_picture within w_sal_02300_popup
end type
type rr_1 from roundrectangle within w_sal_02300_popup
end type
end forward

global type w_sal_02300_popup from w_inherite_popup
integer x = 14
integer y = 176
integer width = 2907
integer height = 2056
string title = "월 출하율 기준 등록(등급/결제)"
cb_2 cb_2
dw_update dw_update
p_end p_end
rr_1 rr_1
end type
global w_sal_02300_popup w_sal_02300_popup

type variables
String sgubun, sittyp, sitcls,sgrade
end variables

on w_sal_02300_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.dw_update=create dw_update
this.p_end=create p_end
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.dw_update
this.Control[iCurrent+3]=this.p_end
this.Control[iCurrent+4]=this.rr_1
end on

on w_sal_02300_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.dw_update)
destroy(this.p_end)
destroy(this.rr_1)
end on

event open;call super::open;sGrade = Message.StringParm	/* 등급 */

sGubun = gs_code					/* 구분 */
sIttyp = gs_codename				/* 품목구분 */
sItcls = gs_gubun					/* 품목분류 */

sle_1.Text = sItcls

SELECT TITNM INTO :sle_2.Text
  FROM ITNCT
 WHERE ITTYP = :sIttyp AND
       ITCLS = :sItcls;

dw_update.SetTransObject(sqlca)

cb_inq.TriggerEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_02300_popup
boolean visible = false
integer x = 37
integer y = 1176
end type

type p_exit from w_inherite_popup`p_exit within w_sal_02300_popup
integer x = 2533
integer y = 12
end type

event p_exit::clicked;call super::clicked;dw_1.Reset()
dw_update.Reset()
end event

type p_inq from w_inherite_popup`p_inq within w_sal_02300_popup
integer x = 2354
integer y = 12
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;If dw_1.Retrieve( sgubun, sGrade, sittyp, sitcls) <= 0 Then
	f_message_chk(300,'')
	Return
End If
end event

type p_choose from w_inherite_popup`p_choose within w_sal_02300_popup
integer x = 2171
integer y = 12
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::ue_lbuttondown;this.PictureName = "C:\erpman\image\저장_dn.gif "
end event

event p_choose::ue_lbuttonup;this.PictureName = "C:\erpman\image\저장_up.gif "
end event

event p_choose::clicked;call super::clicked;Long ix, nRow
Dec  dDcRate

/* 기존자료 삭제 */
DELETE VNDDC_ITEM
 WHERE DCGUB = :sGubun AND
       DCCOD = :sGrade AND
		 ITNBR IN ( SELECT ITNBR FROM ITEMAS
		             WHERE ITTYP = :sIttyp AND
						       ITCLS = :sItcls );
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

dw_update.Reset()
For ix = 1 To dw_1.RowCount()
	dDcRate = dw_1.GetItemNumber(ix, 'dc_rate')
	If IsNull(dDcRate) Then Continue
	
	nRow = dw_update.InsertRow(0)
	dw_update.SetItem(nRow, 'dcgub', sGubun)
	dw_update.SetItem(nRow, 'dccod', sGrade)
	dw_update.SetItem(nRow, 'itnbr', dw_1.GetItemString(ix, 'itnbr'))
	dw_update.SetItem(nRow, 'dc_rate', dw_1.GetItemNumber(ix, 'dc_rate'))
Next

If dw_update.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

COMMIT;

f_message_chk(202,'')
end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_02300_popup
integer x = 23
integer y = 200
integer width = 2848
integer height = 1724
string dataobject = "d_sal_02300_popup"
end type

event dw_1::rowfocuschanged;return
end event

event dw_1::ue_pressenter;return
end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_02300_popup
integer x = 686
integer y = 2180
integer width = 1179
integer taborder = 0
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_sal_02300_popup
boolean visible = false
integer x = 887
integer taborder = 10
string text = "저장(&S)"
end type

event cb_1::clicked;call super::clicked;Long ix, nRow
Dec  dDcRate

/* 기존자료 삭제 */
DELETE VNDDC_ITEM
 WHERE DCGUB = :sGubun AND
       DCCOD = :sGrade AND
		 ITNBR IN ( SELECT ITNBR FROM ITEMAS
		             WHERE ITTYP = :sIttyp AND
						       ITCLS = :sItcls );
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

dw_update.Reset()
For ix = 1 To dw_1.RowCount()
	dDcRate = dw_1.GetItemNumber(ix, 'dc_rate')
	If IsNull(dDcRate) Then Continue
	
	nRow = dw_update.InsertRow(0)
	dw_update.SetItem(nRow, 'dcgub', sGubun)
	dw_update.SetItem(nRow, 'dccod', sGrade)
	dw_update.SetItem(nRow, 'itnbr', dw_1.GetItemString(ix, 'itnbr'))
	dw_update.SetItem(nRow, 'dc_rate', dw_1.GetItemNumber(ix, 'dc_rate'))
Next

If dw_update.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

COMMIT;

f_message_chk(202,'')
end event

type cb_return from w_inherite_popup`cb_return within w_sal_02300_popup
boolean visible = false
integer taborder = 30
boolean cancel = false
end type

event cb_return::clicked;call super::clicked;dw_1.Reset()
dw_update.Reset()
end event

type cb_inq from w_inherite_popup`cb_inq within w_sal_02300_popup
boolean visible = false
integer taborder = 20
boolean default = false
end type

event cb_inq::clicked;call super::clicked;If dw_1.Retrieve( sgubun, sGrade, sittyp, sitcls) <= 0 Then
	f_message_chk(300,'')
	Return
End If
end event

type sle_1 from w_inherite_popup`sle_1 within w_sal_02300_popup
integer x = 302
integer y = 2180
integer width = 338
integer taborder = 0
long backcolor = 65535
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_sal_02300_popup
integer x = 466
integer y = 2332
string text = "분류명"
end type

type cb_2 from commandbutton within w_sal_02300_popup
boolean visible = false
integer x = 1938
integer y = 2008
integer width = 293
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;Close(Parent)
end event

type dw_update from datawindow within w_sal_02300_popup
boolean visible = false
integer x = 123
integer y = 1056
integer width = 494
integer height = 572
integer taborder = 50
string dataobject = "d_sal_02300_popup1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_end from uo_picture within w_sal_02300_popup
integer x = 2711
integer y = 12
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = "C:\ERPMAN\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = "C:\ERPMAN\image\닫기_up.gif"
end event

event clicked;call super::clicked;Close(parent)
end event

type rr_1 from roundrectangle within w_sal_02300_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 184
integer width = 2889
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 55
end type

